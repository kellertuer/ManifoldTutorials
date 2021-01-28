using Manifolds

M = Sphere(2)
p = [0.0, 0.0, 1.0]
q = [0.0, 1.0, 0.0]
X = [0.0, 3π/2, 0.0]

γ = shortest_geodesic(M,p,q)
pts = [γ(t) for t ∈ 0:0.1:1]

γ2 = geodesic(M, p, X)
pts2 = [γ2(t) for t ∈ 0:0.1:1]