A curve $γ: I → \mathcal M$ on a [Riemannian manifold](https://en.wikipedia.org/wiki/Riemannian_manifold) $\mathcal M$ is called a geodesic if the [ODE](https://en.wikipedia.org/wiki/Ordinary_differential_equation) $∇_{\dot γ(t)}\dot γ(t) = 0$ holds for $t∈I$, where $∇$ denotes the [Levi-Civita connection](https://en.wikipedia.org/wiki/Levi-Civita_connection).

First, a curve fulfilling this ODE also fulfills $⟨\dot γ(t), \dot γ(t) ⟩_{\dot γ(t)}$ is a constant value,
so we have an acceleration free curve on our manifold.

The solution of the ODE can be specified by

1. boundary conditions, for example $γ(0)=p$, $γ(1)=q$ for two points $p,q ∈ \mathcal M$, which yields the shortest curve (path) between $p$ and $q$. This is also called _shortest geodesic_.
2. initial conditions $γ(0)=p$, $\dot γ(0)=X$ for $p ∈ \mathcal M$ and $X ∈ T_p\mathcal M$ from the tangent space at $p$. This locally also yields a shortest curve between points, but not necessarily globally. It is still acceleration free

The example code now evaluates a geodesic for both cases at 101 points along the curve.
