function cooling_schedule(params::Parameters)
    function temperature(step)
        return params.maxtemp *
               ((params.mintemp / params.maxtemp)^((step - 1) / params.steps))
    end

    return temperature
end