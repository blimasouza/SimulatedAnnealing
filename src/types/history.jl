struct Iteration
    State::AbstractState
    Energy::Float64
    BestEnergy::Float64
    Step::Integer
    Temperature::Float64
    Accepted::Bool
    EnergyImprove::Bool
end

function initialize_history(
    params::Parameters,
    state::AbstractState,
    current_energy::Number,
    best_energy::Number,
    temperature::Number,
)
    history = Vector{Iteration}(undef, params.steps + 1)
    _state = deepcopy(state)
    history[1] = Iteration(
        _state,
        current_energy,
        best_energy,
        0,
        temperature,
        true,
        true,
    )
    return history
end

function update_history!(
    history::Vector{Iteration},
    step::Integer,
    state::AbstractState,
    current_energy::Number,
    best_energy::Number,
    temperature::Number,
    accepted::Bool,
    energy_improve::Bool,
)
    _state = deepcopy(state)
    return history[step+1] = Iteration(
        _state,
        current_energy,
        best_energy,
        step,
        temperature,
        accepted,
        energy_improve,
    )
end