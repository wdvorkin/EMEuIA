# E-Companion for "Electricity Market Equilibrium under Information Asymmetry"
by  V. Dvorkin, J. Kazempour and P. Pinson. All with the Technical University of Denmark.

The repository contains data and code for the distributed algorithm in Section 4.1 and its centralized optimization counterpart in (A.1). The optimization models have been implemented by using [JuMP](https://github.com/JuliaOpt/JuMP.jl) (v.0.18.2) in the [Julia](http://julialang.org/downloads/) programming language (v.0.6.4). The following packages are required:
- [JuMP](https://github.com/JuliaOpt/JuMP.jl)
- [Mosek.jl](https://github.com/JuliaOpt/Mosek.jl)
- [CSV.jl](https://github.com/JuliaData/CSV.jl)
- [DataFrames.jl](https://github.com/DataFrames.jl/stable/)
- [DataStructures.jl](https://github.com/JuliaCollections/DataStructures.jl)

Mosek is a commercial solver, though it provides a free license for academic use. You can easily switch the solver if Mosek license is not available.

To run the code, you should force the use of particular versions of these Julia packages with
```
julia> Pkg.pin("JuMP", v"0.18.2")
julia> Pkg.pin("Mosek", v"0.8.4")
julia> Pkg.pin("CSV", v"0.2.5")
julia> Pkg.pin("DataFrames", v"0.11.6")
julia> Pkg.pin("DataStructures", v"0.8.4")
```

*Running the code:*

To run the distributed algorithm in Section 4.1, use ``algorithm.jl``, whereas use ``centralized_opt.jl`` to run the centralized optimization in (A.1). The reference wind power distribution is contained in ``wind_scenarios.csv``
