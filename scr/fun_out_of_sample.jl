function solve_OFS(p_f,d_f,wind_scenarios,s)
    α = 1.5
    β = 0.3
    τ = 5
    set_s = collect(keys(wind_scenarios))
    sort!(set_s)

    OFS = Model(solver=MosekSolver(MSK_IPAR_LOG=0))
    @variables OFS begin
        #Primal varaibles
        p >= 0
        d >= 0
        -1000 <= r <= 1000
        -1000 <= l <= 1000
    end
    @objective(OFS, Max, τ*d - 1/2*β*d^2 - 1/2*α*(p)^2 + (τ*l - 1/2*β*l^2) + (- 1/2*α*r^2))
    @constraint(OFS, d - p - r + l - wind_scenarios[s].L == 0)
    @constraint(OFS, p == p_f)
    @constraint(OFS, d == d_f)

    info("Solving model")
    status = solve(OFS)
    objective = getobjectivevalue(OFS)
    if status == :Optimal
        info("OFS solved to optimality")
        info("Objective: $(objective)")
    else
        warn("OFS not optimal, termination status $(status)")
    end
    return objective
end
