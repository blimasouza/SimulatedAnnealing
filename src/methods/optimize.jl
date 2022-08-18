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
    original_energy::Number,
    best_energy::Number,
    current_temp::Number,
    history::Vector{Iteration},
    step::Integer,
)
    # keep track of the original state
    original_state = deepcopy(state)

    # make a moviment     
    move!(state)

    # compute the new energy and the energy gap     
    new_energy = energy(state)
    ΔE = new_energy - original_energy

    energy_improve = false

    if accept_move(ΔE, current_temp)
        if ΔE < 0 && new_energy < best_energy
            best_state = deepcopy(state)
            best_energy = energy(best_state)
            energy_improve = true
        end
        update_history!(
            history,
            step,
            state,
            new_energy,
            best_energy,
            current_temp,
            true,
            energy_improve,
        )
        return state, new_energy, best_state, best_energy
    else
        update_history!(
            history,
            step,
            original_state,
            original_energy,
            best_energy,
            current_temp,
            false,
            energy_improve,
        )
        return original_state, original_energy, best_state, best_energy
    end
end

function optimize(state::AbstractState, params::Parameters)
    # define the cooling_schedule
    temperature = cooling_schedule(params)

    # initialize the best state
    best_state = deepcopy(state)
    best_energy = energy(best_state)

    # initialize the current temperature
    current_temp = params.maxtemp

    # initialize the energy
    current_energy = energy(state)

    # initialize history array
    history = initialize_history(
        params,
        state,
        current_energy,
        best_energy,
        current_temp,
    )

    for step in 1:params.steps
        state, current_energy, best_state, best_energy = update!(
            state,
            current_energy,
            best_energy,
            current_temp,
            history,
            step,
        )

        if step % Int(floor(params.steps / params.updates)) == 1 ||
           step == params.steps
            report(
                step,
                params.steps,
                current_temp,
                current_energy,
                best_energy,
            )
        end
        current_temp = temperature(step)
    end

    return best_state, history
end
