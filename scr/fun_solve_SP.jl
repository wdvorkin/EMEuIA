function solve_SP(wind_scenarios,wind_scenarios_subject)
    α = 1.5
    β = 0.3
    τ = 5
    set_s = collect(keys(wind_scenarios))
    sort!(set_s)

    SP = Model(solver=MosekSolver(MSK_IPAR_LOG=0))
    @variables SP begin
        p >= 0
        d >= 0
        -1000 <= r[set_s] <= 1000
        -1000 <= l[set_s] <= 1000
    end
    @objective(SP, Max, τ*d - 1/2*β*d^2 - 1/2*α*(p)^2
    + sum(wind_scenarios[s].π * (τ*l[s] - 1/2*β*l[s]^2) for s in set_s)
    + sum(wind_scenarios_subject[s].π * (- 1/2*α*r[s]^2) for s in set_s)
    )
    @constraintref PB[1:length(set_s)]
    for s in set_s
        PB[wind_scenarios[s].ord] = @constraint(SP, d - p - r[s] + l[s] - wind_scenarios[s].L == 0)
    end

    info("Solving model")
    status = solve(SP)
    objective = getobjectivevalue(SP)
    if status == :Optimal
        info("SP solved to optimality")
        info("Objective: $(objective)")
    else
        warn("SP not optimal, termination status $(status)")
    end
    return getvalue(p), getvalue(d), sum(getdual(PB[wind_scenarios[s].ord]) for s in set_s)
end
