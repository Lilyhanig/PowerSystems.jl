struct StaticLoad <: ElectricLoad
    name::String
    available::Bool
    bus::Bus
    model::String # [Z, I, P]
    maxrealpower::Float64 # [MW]
    maxreactivepower::Float64 # [MVAr]
    scalingfactor::TimeSeries.TimeArray
end

StaticLoad(; name = "init", status = true, bus = Bus(), model = "0", maxrealpower = 0, maxreactivepower=0, 
            scalingfactor=TimeArray(today(),ones(1))) = StaticLoad(name, status, bus, model, maxrealpower, maxreactivepower, scalingfactor)

struct InterruptibleLoad <: ElectricLoad
    name::String
    available::Bool
    bus::Bus
    model::String # [Z, I, P]
    maxrealpower::Float64 # [MW]
    maxreactivepower::Float64 # [MVAr]
    sheddingcost::Float64 # $/MWh
    scalingfactor::TimeSeries.TimeArray
end

InterruptibleLoad(; name = "init", status = true, bus = Bus(), model = "0", maxrealpower = 0, maxreactivepower=0, sheddingcost = 999, 
                scalingfactor = TimeArray(today(),ones(1))) = InterruptibleLoad(name, status, bus, model, maxrealpower, maxreactivepower, sheddingcost, scalingfactor)
