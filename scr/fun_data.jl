using DataFrames, CSV
import DataStructures

type wind_scenario
   index::Any
   L::Float64
   π::Float64
   ord::Int
   function wind_scenario(index, L, π, ord)
      s = new()
      s.index  = index
      s.L = L
      s.π = π
      s.ord = ord
      return s
   end
end

function load_data(δ,γ)
    info("Reading Data")
    wind_scenarios_table = CSV.read("wind_scenarios.csv")

    wind_scenarios = Dict()
    for s in 1:nrow(wind_scenarios_table)
        index = wind_scenarios_table[s, :index]
        L = wind_scenarios_table[s, :L]
        π = wind_scenarios_table[s, :Pr]
        ord = wind_scenarios_table[s, :ord]
        add_scenario = wind_scenario(index, L, π, ord)
        wind_scenarios[add_scenario.index] = add_scenario
    end

    wind_scenarios=DataStructures.SortedDict(wind_scenarios)

    # Compute subjective probabilities
    set_s = collect(keys(wind_scenarios))
    π_CDF = zeros(nrow(wind_scenarios_table))
    π_CDF_sub = zeros(nrow(wind_scenarios_table))

    for s in 1:length(set_s)
        for j in 1:length(set_s)
            if j <= s
                π_CDF[s] = sum(wind_scenarios[set_s[j]].π for j in 1:j)
            end
        end
    end

    for s in 1:length(set_s)
        π_CDF_sub[s] = (δ * π_CDF[s]^γ) / (δ * π_CDF[s]^γ + (norm(1-π_CDF[s]))^γ) # norm is used to avoid DomainError()
    end

    π_pr = zeros(length(set_s))
    for s in 1:length(set_s)
        if s >=2
            π_pr[s] = π_CDF_sub[s] - π_CDF_sub[s-1]
        end
    end
    π_pr[1] = 1 - sum(π_pr[s] for s in 2:length(set_s))

    wind_scenarios_subject = Dict()
    for s in 1:nrow(wind_scenarios_table)
        index = wind_scenarios_table[s, :index]
        L = wind_scenarios_table[s, :L]
        π = π_pr[s]
        ord = wind_scenarios_table[s, :ord]
        add_scenario = wind_scenario(index, L, π, ord)
        wind_scenarios_subject[add_scenario.index] = add_scenario
    end

    set_s = collect(keys(wind_scenarios))
    sort!(set_s)

    info("Done preparing Data")
    return wind_scenarios, wind_scenarios_subject, set_s
end
