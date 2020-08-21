module SimulatedAnnealing
export State, Parameters, move!, energy, optimize

import Distributions: Normal
import Printf: @printf

mutable struct State
    value::Number
    σ::Number
    State(value::Number) = new(value, 0.01)
    State(value::Number, σ::Number) = new(value, σ)
end

struct Parameters
    steps::Integer
    updates::Integer
    maxtemp::Float64
    mintemp::Float64
end

function move!(state)
    dist = Normal(0, state.σ)
    ϵ = rand(dist)
    state.value += ϵ
end

function energy(state::State)
    x = state.value
    return x^2 - 5x + 6
end

function cooling_schedule(params::Parameters)
    function temperature(step)
        return params.maxtemp * (
            (params.mintemp / params.maxtemp)^((step - 1) / params.steps)
        )
    end

    return temperature
end

function accept_move(ΔE, temperature)
    if ΔE <= 0
        return true
    elseif rand() < exp(-ΔE / temperature)
        return true
    else
        return false
    end
end

function update!(
    state::State,
    previous_state::State,
    previous_energy::Number,
    best_state::State,
    current_temp::Number,
)
    move!(state)
    current_energy = energy(state)
    ΔE = current_energy - previous_energy

    if accept_move(ΔE, current_temp)
        previous_state = deepcopy(state)
        previous_energy = current_energy
        if ΔE < 0 && current_energy < energy(best_state)
            best_state = deepcopy(state)
        end
    else
        state = deepcopy(previous_state)
    end

    return state, previous_state, previous_energy, best_state
end

function report(step, max_steps, temperature, energy)
    separator = (
            "| " * repeat("-", 10)
        * " | " * repeat("-", 11)
        * " | " * repeat("-", 10)
        * " |"
    )
    if step == 1
        println(separator)
        @printf(
            "| %10s | %11s | %10s |\n",  
            ["step", "temperature", "energy"]...
        )
        println(separator)
    end
    @printf(
        "| %10d | %11.0f | %10.2f |\n", 
        [step, temperature, energy]...
    )
    if step == max_steps
        println(separator)
    end
end

function optimize(state::State, params::Parameters)
    # define the cooling_schedule
    temperature = cooling_schedule(params)

    # initialize the best state
    best_state = deepcopy(state)

    # initialize the current temperature
    current_temp = params.maxtemp

    # keep track of the previous state
    previous_state = deepcopy(state)

    # initialize the energy
    previous_energy = energy(state)

    for step = 1:params.steps
        state, previous_state, previous_energy, best_state = update!(
            state, previous_state, previous_energy, best_state, current_temp
        )
        if step % Int(floor(params.steps / params.updates)) == 1 || step == params.steps
            report(step, params.steps, current_temp, previous_energy)
        end
        current_temp = temperature(step)
    end

    return best_state
end

end # module
