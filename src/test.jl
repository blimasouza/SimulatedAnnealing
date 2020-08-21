module test

import SimulatedAnnealing: AbstractState, move!, energy, Parameters, optimize
import Distributions: Normal
import Printf: @printf

# define a concrete state
mutable struct State <: AbstractState
    value::Number
    σ::Number
    State(value::Number) = new(value, 0.01)
    State(value::Number, σ::Number) = new(value, σ)
end

# define how we move
function move!(state::State)
    dist = Normal(0, state.σ)
    ϵ = rand(dist)
    state.value += ϵ
end

# define how we compute the energy
function energy(state::State)
    x = state.value
    return x^2 - 5x + 6
end

# setup the initial state
state = State(100, 1)

# setup the optimization params
params = Parameters(1000, 20, 100, 1)

# optimize
result = optimize(state, params)

@printf(
    "Best state: %.3f | Best energy: %.3f \n", 
    result.value,
    energy(result)
)

end