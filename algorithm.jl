using JuMP, Mosek, CSV

include("scr/fun_data.jl") # function to load data
include("scr/fun_producer_update.jl") # function to solve producer update
include("scr/fun_consumer_update.jl") # function to solve consumer update
# Data
δ = 1 # delta factor
γ = 1 # gamma factor
α = 1.5 # producer cost coefficient
β = 0.3 # consumer 2nd-ord cost coefficient
τ = 5 # consumer 1st-ord cost coefficient
(wind_scenarios,wind_scenarios_subject,set_s) = load_data(δ,γ)

𝛎 = 1000
𝛒 = 10e-5
𝛆 = 10e-5
𝚲 = zeros(𝛎,length(set_s))
𝐑 = zeros(length(set_s))
𝐋 = zeros(length(set_s))
res_s = zeros(length(set_s))
res = zeros(𝛎)

for ν in 1:𝛎-1
    (𝐏,𝐑)=solve_producer(wind_scenarios_subject,𝚲,ν)
    (𝐃,𝐋)=solve_consumer(wind_scenarios,𝚲,ν)
    for s in 1:length(set_s)
        𝚲[ν+1,s] = 𝚲[ν,s] - 𝛒 * (𝐏 + 𝐑[s] + wind_scenarios[set_s[s]].L - 𝐃 - 𝐋[s])
        res_s[s] = norm(𝐏 + 𝐑[s] + wind_scenarios[set_s[s]].L - 𝐃 - 𝐋[s])
    end
    res[ν] = norm(sum(res_s[s] for s in 1:length(set_s)))
    println("ν --- $(ν) ..... res --- $(round(res[ν],6))")
    if res[ν] <= 𝛆
        println("--------------------------------------------------")
        println("𝚲_DA --- $(round(sum(𝚲[ν,s] for s in 1:length(set_s)),3)) ..... 𝐏 --- $(round(𝐏,3)) .... 𝐃 --- $(round(𝐃,3))")
        break
    end
end
