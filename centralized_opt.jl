using JuMP, Mosek, CSV

include("scr/fun_data.jl") # function to load data
include("scr/fun_solve_SP.jl") # function to solve sp problem
include("scr/fun_out_of_sample.jl") # function to compute out of sample social wellfare

# SOLVE FOR DIFFERENT DISTRIBUTIONS
δ_set = [0.25,0.5,0.75,1,2,3,5]
γ_set = [0.25,0.5,0.75,1,2,3,5]
δ_impacts = DataFrame(δ = Any[], μ = Any[], var = Any[], p = Any[], d = Any[], w = Any[], λ_DA = Any[])
γ_impacts = DataFrame(γ = Any[], μ = Any[], var = Any[], p = Any[], d = Any[], w = Any[], λ_DA = Any[])
# Tweak the mean of the true distribution
for i in 1:length(δ_set)
    (wind_scenarios, wind_scenarios_subject,set_s) = load_data(δ_set[i],1)
    (p,d,λ_DA)= solve_SP(wind_scenarios,wind_scenarios_subject)
    res = [
    round(δ_set[i],2),
    round(sum(wind_scenarios_subject[s].π*wind_scenarios_subject[s].L for s in set_s),2),
    round(sum(wind_scenarios_subject[s].π * wind_scenarios_subject[s].L^2 for s in set_s) - (sum(wind_scenarios_subject[s].π*wind_scenarios_subject[s].L for s in set_s))^2,2),
    round(p,2),round(d,2),round(d-p,2),round(λ_DA,2)]
    push!(δ_impacts,res)
end
# Tweak the variance of the true distribution
for i in 1:length(γ_set)
    (wind_scenarios, wind_scenarios_subject,set_s) = load_data(1,γ_set[i])
    (p,d,λ_DA)= solve_SP(wind_scenarios,wind_scenarios_subject)
    res = [
    round(γ_set[i],2),
    round(sum(wind_scenarios_subject[s].π*wind_scenarios_subject[s].L for s in set_s),2),
    round(sum(wind_scenarios_subject[s].π * wind_scenarios_subject[s].L^2 for s in set_s) - (sum(wind_scenarios_subject[s].π*wind_scenarios_subject[s].L for s in set_s))^2,2),
    round(p,2),round(d,2),round(d-p,2),round(λ_DA,2)]
    push!(γ_impacts,res)
end

println("Impacts of delta-factor")
println(δ_impacts)
println("Impacts of gamma-factor")
println(γ_impacts)

# # # Uncomment the lines below for out-of-sample analysis.
# # # Creat a folder "out_of_sample_results" in the root to save the results
# # OUT OF SAMPLE FOR DIFFERENT DISTRIBUTIONS
# for i in 1:length(δ_set)
#     SW_save = DataFrame(scenario = Any[], Relization = Any[], SW = Any[])
#     (wind_scenarios, wind_scenarios_subject,set_s) = load_data(δ_set[i],1)
#     (p,d,λ_DA)= solve_SP(wind_scenarios,wind_scenarios_subject)
#     for s in set_s
#         SW = solve_OFS(p,d,wind_scenarios,s)
#         res = [s, wind_scenarios[s].L, SW]
#         push!(SW_save,res)
#     end
#     CSV.write("out_of_sample_results/OFS_delta_$(δ_set[i])_gamma_1.csv", SW_save)
# end
# for i in 1:length(γ_set)
#     SW_save = DataFrame(scenario = Any[], Relization = Any[], SW = Any[])
#     (wind_scenarios, wind_scenarios_subject,set_s) = load_data(1,γ_set[i])
#     (p,d,λ_DA)= solve_SP(wind_scenarios,wind_scenarios_subject)
#     for s in set_s
#         SW = solve_OFS(p,d,wind_scenarios,s)
#         res = [s, wind_scenarios[s].L, SW]
#         push!(SW_save,res)
#     end
#     CSV.write("out_of_sample_results/OFS_delta_1_gamma_$(γ_set[i]).csv", SW_save)
# end
