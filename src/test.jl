module test

import SimulatedAnnealing
import Printf: @printf

state = SimulatedAnnealing.State(100, 1)
params = SimulatedAnnealing.Parameters(1000, 20, 100, 1)

result = SimulatedAnnealing.optimize(state, params)

@printf(
    "Best state: %.3f | Best energy: %.3f \n", 
    result.value,
    SimulatedAnnealing.energy(result)
)

end