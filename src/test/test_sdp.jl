using Base.Test
include("../Convex.jl")
using Convex

TOL = 1e-2

# SDP variables
y = Variable((2,2), Semidefinite())
p = minimize(y[1,1])
println(conic_problem(p))
solve!(p, SCS.SCSMathProgModel())
@test_approx_eq_eps p.optval 0 TOL

# SDP variables twice
y = Variable((2,2), Semidefinite())
p = minimize(y[1,1], y[2,1]==1)
println(conic_problem(p))
solve!(p, SCS.SCSMathProgModel())
@test_approx_eq_eps p.optval 1 TOL

# SDP variables twice
y = Variable((2,2), Semidefinite())
p = minimize(y[1,1], y[1,2]==1, y==y')
println(conic_problem(p))
solve!(p, SCS.SCSMathProgModel())
@test_approx_eq_eps p.optval 1 TOL

# SDP variables
y = Semidefinite(2)
p = minimize(sum(diag(y)), y[1,2]==1)
solve!(p, SCS.SCSMathProgModel())
@test_approx_eq_eps p.optval 2 TOL

# SDP constraints
x = Variable(Positive())
y = Variable((2,2))
p = minimize(x + y[1,1], isposdef(y), x>=1,y[2,1]==1)
solve!(p, SCS.SCSMathProgModel())
@test_approx_eq_eps p.optval 2 TOL

quit()
# nuclear norm XXX should work when hcat and vcat do
y = Variable((2,2), Semidefinite())
p = minimize(nuclear_norm(y), y[2,1]<=4, y[2,2]>=3)
solve!(p, SCS.SCSMathProgModel())

# trace
y = Variable((2,2), Semidefinite())
p = minimize(trace(y), y[2,1]<=4, y[2,2]>=3)
solve!(p, SCS.SCSMathProgModel())

# operator norm XXX should work when hcat and vcat do
y = Variable((2,2))
p = minimize(operator_norm(y), y[2,1]<=4, y[2,2]>=3, sum(y)>=12)
solve!(p, SCS.SCSMathProgModel())
