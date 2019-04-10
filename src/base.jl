### Struct and different Power System constructors depending on the data provided ####

"""
    System

A power system defined by fields for buses, generators, loads, branches, and
overall system parameters.

# Constructor
```julia
System(buses, generators, loads, branches, storage, basepower; kwargs...)
System(buses, generators, loads, branches, basepower; kwargs...)
System(buses, generators, loads, basepower; kwargs...)
System(ps_dict; kwargs...)
System(file, ts_folder; kwargs...)
System(; kwargs...)
```

# Arguments

* `buses`::Vector{Bus} : an array of buses
* `generators`::Vector{Generator} : an array of generators of (possibly) different types
* `loads`::Vector{ElectricLoad} : an array of load specifications that includes timing of the loads
* `branches`::Union{Nothing, Vector{Branch}} : an array of branches; may be `nothing`
* `storage`::Union{Nothing, Vector{Storage}} : an array of storage devices; may be `nothing`
* `basepower`::Float64 : the base power of the system (DOCTODO: is this true? what are the units of base power?)
* `ps_dict`::Dict{String,Any} : the dictionary object containing System data
* `file`::String, `ts_folder`::String : the filename and foldername that contain the System data

# Keyword arguments

* `runchecks`::Bool : run available checks on input fields
DOCTODO: any other keyword arguments? genmap_file, REGEX_FILE

"""
struct System <: PowerSystemType
    # DOCTODO docs for System fields are currently not working, JJS 1/15/19
    buses::Vector{Bus}
    generators::GenClasses
    loads::Vector{<: ElectricLoad}
    branches::Union{Nothing, Vector{<: Branch}}
    storage::Union{Nothing, Vector{<: Storage}}
    basepower::Float64 # [MVA]
    time_periods::Int64

    function System(buses, generators, loads, branches, storage_devices, basepower,
                    time_periods; kwargs...)

        sys = new(buses, generators, loads, branches, storage_devices, basepower,
                  time_periods)

        # TODO Default validate to true once validation code is written.
        if get(kwargs, :validate, false) && !validate(sys)
            error("System is not valid")
        end

        return sys
    end
end

"""Primary System constructor. Funnel point for all other outer constructors."""
function System(buses::Vector{Bus},
                generators::Vector{<: Generator},
                loads::Vector{<: ElectricLoad},
                branches::Union{Nothing, Vector{<: Branch}},
                storage::Union{Nothing, Vector{<: Storage}},
                basepower::Float64; kwargs...)
    runchecks = in(:runchecks, keys(kwargs)) ? kwargs[:runchecks] : true
    if runchecks
        slackbuscheck(buses)
        buscheck(buses)
        if !isnothing(branches)
            calculatethermallimits!(branches, basepower)
            check_branches!(branches)
        end

        pvbuscheck(buses, generators)
        generators = checkramp(generators, minimumtimestep(loads))
    end

    time_periods = timeseriescheckload(loads)

    # This constructor receives an array of Generator structs. It separates them by category
    # in GenClasses.
    gen_classes = genclassifier(generators)
    if !isnothing(gen_classes.renewable)
        timeserieschecksources(gen_classes.renewable, time_periods)
    end

    if !isnothing(gen_classes.hydro)
        timeserieschecksources(gen_classes.hydro, time_periods)
    end

    return System(buses, gen_classes, loads, branches, storage, basepower, time_periods;
                       kwargs...)
end

"""Constructs System with Generators but no branches or storage."""
function System(buses::Vector{<: Bus},
                generators::Vector{<: Generator},
                loads::Vector{<: ElectricLoad},
                basepower::Float64; kwargs...)
    return System(buses, generators, loads, nothing, nothing, basepower; kwargs...)
end

"""Constructs System with Generators but no storage."""
function System(buses::Vector{Bus},
                generators::Vector{<: Generator},
                loads::Vector{<: ElectricLoad},
                branches::Vector{<: Branch},
                basepower::Float64; kwargs...)
    return System(buses, generators, loads, branches, nothing, basepower; kwargs...)
end

"""Constructs System with Generators but no branches."""
function System(buses::Vector{<: Bus},
                generators::Vector{<: Generator},
                loads::Vector{<: ElectricLoad},
                storage::Vector{<: Storage},
                basepower::Float64; kwargs...)
    return System(buses, generators, loads, nothing, storage, basepower; kwargs...)
end

"""Constructs System with default values."""
function System(; buses=[Bus()],
                generators=[ThermalDispatch(), RenewableFix()],
                loads=[PowerLoad()],
                branches=nothing,
                storage=nothing,
                basepower=100.0,
                kwargs...)
    return System(buses, generators, loads, branches, storage,  basepower; kwargs...)
end

"""Constructs System from a ps_dict."""
function System(ps_dict::Dict{String,Any}; kwargs...)
    buses, generators, storage, branches, loads, loadZones, shunts, services =
        ps_dict2ps_struct(ps_dict)

    return System(buses, generators, loads, branches, storage, ps_dict["baseMVA"];
                       kwargs...);
end

"""Constructs System from a file containing Matpower, PTI, or JSON data."""
function System(file::String, ts_folder::String; kwargs...)
    ps_dict = parsestandardfiles(file,ts_folder; kwargs...)
    buses, generators, storage, branches, loads, loadZones, shunts, services =
        ps_dict2ps_struct(ps_dict)

    return System(buses, generators, loads, branches, storage, ps_dict["baseMVA"];
                       kwargs...);
end

"""A System struct that stores all devices in arrays with concrete types.
This is a temporary implementation that will allow consumers of PowerSystems to test the
functionality before it is finalized.
"""
struct SystemConcrete <: PowerSystemType
    devices::Dict{DataType, Vector{<: Component}}
    basepower::Float64 # [MVA]
    time_periods::Int64
end

function SystemConcrete(sys::System)
    devices = Dict{DataType, Vector{<: Component}}()
    for subtype in get_subtypes(Device, PowerSystems)
        devices[subtype] = Vector{subtype}()
    end

    @debug "Created devices keys" keys(devices)

    for field in (:buses, :loads)
        objs = getfield(sys, field)
        for obj in objs
            push!(devices[typeof(obj)], obj)
        end
    end

    for field in (:thermal, :renewable, :hydro)
        generators = getfield(sys.generators, field)
        if !isnothing(generators)
            for gen in generators
                push!(devices[typeof(gen)], gen)
            end
        end
    end

    for field in (:branches, :storage)
        objs = getfield(sys, field)
        if !isnothing(objs)
            for obj in objs
                push!(devices[typeof(obj)], obj)
            end
        end
    end

    for (key, value) in devices
        @debug "Devices: $(string(key)): count=$(string(length(value)))"
    end

    return SystemConcrete(devices, sys.basepower, sys.time_periods)
end

"""Returns an array of devices from the System."""
function get_devices(
                     ::Type{T},
                     sys::SystemConcrete,
                    )::Vector{T} where {T <: Component}
    if isconcretetype(T)
        return sys.devices[T]
    elseif isabstracttype(T)
        # PERF:  This makes copies and could be optimized.
        devices = Vector{T}()
        for subtype in get_subtypes(T, PowerSystems)
            devices = vcat(devices, sys.devices[subtype])
        end

        return devices
    else
        error("Invalid type $T")
    end
end
