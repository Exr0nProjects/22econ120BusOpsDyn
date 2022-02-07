using JuMP, GLPK

# Preparing an optimization model
m = Model(GLPK.Optimizer)

@variable(m, x1 >= 0)
@variable(m, x2)
@variable(m, x3 <= 0)
@variable(m, x4)

@objective(m, Min, 2*x1 - x2 + 3*x3)

@constraint(m, constraint1, x1 + x2 + x4 <= 2)
@constraint(m, constraint2, 3*x2 - x3 == 5)
@constraint(m, constraint3, x3 + x4 >= 3)

# Printing the prepared optimization model
print(m)

# Solving the optimization problem
JuMP.optimize!(m)

# Printing the optimal solutions obtained
println("Optimal Solutions:")
println("x1 = ", JuMP.value(x1))
println("x2 = ", JuMP.value(x2))
println("x3 = ", JuMP.value(x3))

# Printing the optimal dual variables
println("Dual Variables:")
println("dual1 = ", JuMP.shadow_price(constraint1))
println("dual2 = ", JuMP.shadow_price(constraint2))

