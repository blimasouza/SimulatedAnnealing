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
    state::AbstractState,
    previous_state::AbstractState,
    previous_energy::Number,
    best_state::AbstractState,
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


function optimize(state::AbstractState, params::Parameters)
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

