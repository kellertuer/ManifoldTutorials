using Manopt, Manifolds, Random, LinearAlgebra
# Generate random problem data.
n = 1000
A = randn(n, n)
A = (A + A') / 2

# Create the problem structure.
M = Sphere(n - 1)

# Define the problem cost function and its Riemannian gradient.
F(X) = -X' * A * X
∇F(X) = -2 * (A * X - X * X' * A * X)

# Solve
x = random_point(M)
quasi_Newton(M, F, ∇F, x; debug=[:Iteration, " ", :Cost, "\n", 1, :Stop])
