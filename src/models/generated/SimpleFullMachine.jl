#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct SimpleFullMachine <: Machine
        R::Float64
        R_f::Float64
        R_1d::Float64
        R_1q::Float64
        L_d::Float64
        L_q::Float64
        L_ad::Float64
        L_aq::Float64
        L_f1d::Float64
        L_ff::Float64
        L_1d::Float64
        L_1q::Float64
        MVABase::Float64
        ext::Dict{String, Any}
        inv_d_fluxlink::Array{Float64,2}
        inv_q_fluxlink::Array{Float64,2}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameter of a full order flux stator-rotor model without zero sequence flux in the stator.
 The derivative of stator fluxes (ψd and ψq) is neglected. This is standard when
 transmission network dynamics is neglected. Only one q-axis damping circuit
 is considered. All per unit are in machine per unit.
 Refer to Chapter 3 of Power System Stability and Control by P. Kundur or Chapter 11 of Power System Dynamics: Stability and Control, by J. Machowski, J. Bialek and J. Bumby, for more details.
 Note that the models are somewhat different (but equivalent) due to the different Park Transformation used in both books.

# Arguments
- `R::Float64`: Resistance after EMF in machine per unit, validation range: (0, nothing)
- `R_f::Float64`: Field rotor winding resistance in per unit, validation range: (0, nothing)
- `R_1d::Float64`:  Damping rotor winding resistance on d-axis in per unit. This value is denoted as RD in Machowski., validation range: (0, nothing)
- `R_1q::Float64`: Damping rotor winding resistance on q-axis in per unit. This value is denoted as RQ in Machowski., validation range: (0, nothing)
- `L_d::Float64`: Inductance of fictitious damping that represent the effect of the three-phase stator winding in the d-axis of the rotor, in per unit. This value is denoted as L_ad + L_l in Kundur (and Ld in Machowski)., validation range: (0, nothing)
- `L_q::Float64`: Inductance of fictitious damping that represent the effect of the three-phase stator winding in the q-axis of the rotor, in per unit. This value is denoted as L_aq + L_l in Kundur., validation range: (0, nothing)
- `L_ad::Float64`: Mutual inductance between stator winding and rotor field (and damping) winding inductance on d-axis, in per unit, validation range: (0, nothing)
- `L_aq::Float64`: Mutual inductance between stator winding and rotor damping winding inductance on q-axis, in per unit, validation range: (0, nothing)
- `L_f1d::Float64`: Mutual inductance between rotor field winding and rotor damping winding inductance on d-axis, in per unit, validation range: (0, nothing)
- `L_ff::Float64`: Field rotor winding inductance, in per unit, validation range: (0, nothing)
- `L_1d::Float64`: Inductance of the d-axis rotor damping circuit, in per unit, validation range: (0, nothing)
- `L_1q::Float64`: Inductance of the q-axis rotor damping circuit, in per unit, validation range: (0, nothing)
- `MVABase::Float64`: Nominal Capacity in MVA, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `inv_d_fluxlink::Array{Float64,2}`: Equations 3.127, 3.130, 3.131 From Kundur
- `inv_q_fluxlink::Array{Float64,2}`: Equations 3.128, 3.132 From Kundur
- `states::Vector{Symbol}`
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct SimpleFullMachine <: Machine
    "Resistance after EMF in machine per unit"
    R::Float64
    "Field rotor winding resistance in per unit"
    R_f::Float64
    " Damping rotor winding resistance on d-axis in per unit. This value is denoted as RD in Machowski."
    R_1d::Float64
    "Damping rotor winding resistance on q-axis in per unit. This value is denoted as RQ in Machowski."
    R_1q::Float64
    "Inductance of fictitious damping that represent the effect of the three-phase stator winding in the d-axis of the rotor, in per unit. This value is denoted as L_ad + L_l in Kundur (and Ld in Machowski)."
    L_d::Float64
    "Inductance of fictitious damping that represent the effect of the three-phase stator winding in the q-axis of the rotor, in per unit. This value is denoted as L_aq + L_l in Kundur."
    L_q::Float64
    "Mutual inductance between stator winding and rotor field (and damping) winding inductance on d-axis, in per unit"
    L_ad::Float64
    "Mutual inductance between stator winding and rotor damping winding inductance on q-axis, in per unit"
    L_aq::Float64
    "Mutual inductance between rotor field winding and rotor damping winding inductance on d-axis, in per unit"
    L_f1d::Float64
    "Field rotor winding inductance, in per unit"
    L_ff::Float64
    "Inductance of the d-axis rotor damping circuit, in per unit"
    L_1d::Float64
    "Inductance of the q-axis rotor damping circuit, in per unit"
    L_1q::Float64
    "Nominal Capacity in MVA"
    MVABase::Float64
    ext::Dict{String, Any}
    "Equations 3.127, 3.130, 3.131 From Kundur"
    inv_d_fluxlink::Array{Float64,2}
    "Equations 3.128, 3.132 From Kundur"
    inv_q_fluxlink::Array{Float64,2}
    states::Vector{Symbol}
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function SimpleFullMachine(R, R_f, R_1d, R_1q, L_d, L_q, L_ad, L_aq, L_f1d, L_ff, L_1d, L_1q, MVABase, ext=Dict{String, Any}(), )
    SimpleFullMachine(R, R_f, R_1d, R_1q, L_d, L_q, L_ad, L_aq, L_f1d, L_ff, L_1d, L_1q, MVABase, ext, inv([[-L_d L_ad L_ad]; [-L_ad L_ff L_f1d]; [-L_ad L_f1d L_1d]]), inv([[-L_q L_aq]; [-L_aq L_1q]]), [:ψf, :ψ1d, :ψ1q], 3, InfrastructureSystemsInternal(), )
end

function SimpleFullMachine(; R, R_f, R_1d, R_1q, L_d, L_q, L_ad, L_aq, L_f1d, L_ff, L_1d, L_1q, MVABase, ext=Dict{String, Any}(), )
    SimpleFullMachine(R, R_f, R_1d, R_1q, L_d, L_q, L_ad, L_aq, L_f1d, L_ff, L_1d, L_1q, MVABase, ext, )
end

# Constructor for demo purposes; non-functional.
function SimpleFullMachine(::Nothing)
    SimpleFullMachine(;
        R=0,
        R_f=0,
        R_1d=0,
        R_1q=0,
        L_d=1.0,
        L_q=1.0,
        L_ad=2.0,
        L_aq=1.0,
        L_f1d=1.0,
        L_ff=2.0,
        L_1d=1.0,
        L_1q=2.0,
        MVABase=0,
        ext=Dict{String, Any}(),
    )
end

"""Get SimpleFullMachine R."""
get_R(value::SimpleFullMachine) = value.R
"""Get SimpleFullMachine R_f."""
get_R_f(value::SimpleFullMachine) = value.R_f
"""Get SimpleFullMachine R_1d."""
get_R_1d(value::SimpleFullMachine) = value.R_1d
"""Get SimpleFullMachine R_1q."""
get_R_1q(value::SimpleFullMachine) = value.R_1q
"""Get SimpleFullMachine L_d."""
get_L_d(value::SimpleFullMachine) = value.L_d
"""Get SimpleFullMachine L_q."""
get_L_q(value::SimpleFullMachine) = value.L_q
"""Get SimpleFullMachine L_ad."""
get_L_ad(value::SimpleFullMachine) = value.L_ad
"""Get SimpleFullMachine L_aq."""
get_L_aq(value::SimpleFullMachine) = value.L_aq
"""Get SimpleFullMachine L_f1d."""
get_L_f1d(value::SimpleFullMachine) = value.L_f1d
"""Get SimpleFullMachine L_ff."""
get_L_ff(value::SimpleFullMachine) = value.L_ff
"""Get SimpleFullMachine L_1d."""
get_L_1d(value::SimpleFullMachine) = value.L_1d
"""Get SimpleFullMachine L_1q."""
get_L_1q(value::SimpleFullMachine) = value.L_1q
"""Get SimpleFullMachine MVABase."""
get_MVABase(value::SimpleFullMachine) = value.MVABase
"""Get SimpleFullMachine ext."""
get_ext(value::SimpleFullMachine) = value.ext
"""Get SimpleFullMachine inv_d_fluxlink."""
get_inv_d_fluxlink(value::SimpleFullMachine) = value.inv_d_fluxlink
"""Get SimpleFullMachine inv_q_fluxlink."""
get_inv_q_fluxlink(value::SimpleFullMachine) = value.inv_q_fluxlink
"""Get SimpleFullMachine states."""
get_states(value::SimpleFullMachine) = value.states
"""Get SimpleFullMachine n_states."""
get_n_states(value::SimpleFullMachine) = value.n_states
"""Get SimpleFullMachine internal."""
get_internal(value::SimpleFullMachine) = value.internal
