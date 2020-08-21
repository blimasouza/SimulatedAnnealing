module SimulatedAnnealing
export State, Parameters, optimize

# types
include("types/state.jl")
include("types/parameters.jl")

# reporting
include("utils/report.jl")

# cooling schedule
include("methods/cooling_schedule.jl")

# simulated annealing heuristics
include("methods/optimize.jl")

end # module
