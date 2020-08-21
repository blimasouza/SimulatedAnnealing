abstract type AbstractState end

function move!(state::T) where {T<:AbstractState}
end
function energy(state::T) where {T<:AbstractState}
    return 0
end
