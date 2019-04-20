function solve_producer(wind_scenarios_subject,λ,ν)
    m_p = Model(solver=MosekSolver(MSK_IPAR_LOG=0))
    @variables m_p begin
        0 <= p <= 1000
        -1000 <= r[1:length(set_s)] <= 1000
    end
    @objective(m_p, Max, sum(λ[ν,s] * (p + r[s]) for s in 1:length(set_s)) - 1/2 * α * p^2 -
    sum(wind_scenarios_subject[set_s[s]].π*(1/2 * α * r[s]^2) for s in 1:length(set_s)))
    solve(m_p)
    return getvalue(p), getvalue(r)
end
