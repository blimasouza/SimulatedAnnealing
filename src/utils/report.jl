import Printf: @printf


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