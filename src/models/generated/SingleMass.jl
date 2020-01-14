#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct SingleMass <: Shaft
        H::Float64
        D::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of single mass shaft model. Typically represents the rotor mass.

# Arguments
- `H::Float64`: Rotor inertia constant in MWs/MVA, validation range: (0, nothing)
- `D::Float64`: Rotor natural damping in pu, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct SingleMass <: Shaft
    "Rotor inertia constant in MWs/MVA"
    H::Float64
    "Rotor natural damping in pu"
    D::Float64
    ext::Dict{String, Any}
    states::Vector{Symbol}
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function SingleMass(H, D, ext=Dict{String, Any}(), )
    SingleMass(H, D, ext, [:δ, :ω], 2, InfrastructureSystemsInternal(), )
end

function SingleMass(; H, D, ext=Dict{String, Any}(), )
    SingleMass(H, D, ext, )
end

# Constructor for demo purposes; non-functional.
function SingleMass(::Nothing)
    SingleMass(;
        H=0,
        D=0,
        ext=Dict{String, Any}(),
    )
end

"""Get SingleMass H."""
get_H(value::SingleMass) = value.H
"""Get SingleMass D."""
get_D(value::SingleMass) = value.D
"""Get SingleMass ext."""
get_ext(value::SingleMass) = value.ext
"""Get SingleMass states."""
get_states(value::SingleMass) = value.states
"""Get SingleMass n_states."""
get_n_states(value::SingleMass) = value.n_states
"""Get SingleMass internal."""
get_internal(value::SingleMass) = value.internal
