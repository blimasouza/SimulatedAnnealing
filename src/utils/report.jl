import Printf: @printf

function report(step, max_steps, temperature, energy, best_energy)
    separator = (
        "| " *
        repeat("-", 10) *
        " | " *
        repeat("-", 11) *
        " | " *
        repeat("-", 10) *
        " | " *
        repeat("-", 11) *
        " |"
    )
    if step == 1
        println(separator)
        @printf(
            "| %10s | %11s | %10s | %11s |\n",
            ["step", "temperature", "energy", "best energy"]...
        )
        println(separator)
    end
    @printf(
        "| %10d | %11.0f | %10.2f | %11.2f |\n",
        [step, temperature, energy, best_energy]...
    )
    if step == max_steps
        println(separator)
    end
end