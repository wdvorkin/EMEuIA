function solve_consumer(wind_scenarios,λ,ν)
    m_c = Model(solver=MosekSolver(MSK_IPAR_LOG=0))
    @variables m_c begin
        0 <= d <= 1000
        -1000 <= l[1:length(set_s)] <= 1000
    end
    @objective(m_c, Max, τ*d - 1/2*β*d^2 + sum(wind_scenarios[set_s[s]].π*(τ*l[s] - 1/2*β*l[s]^2) for s in 1:length(set_s))
    - sum(λ[ν,s] * (d+ l[s]) for s in 1:length(set_s))
    )
    solve(m_c)
    return getvalue(d), getvalue(l)
end
