@def title = "Manifold Tutorials"

{{startcolumns "text-to-code"}}
## The Rayleigh Quotient

For a symmetric matrix, i.e. $A∈\R^{n\times n}, A = A^\transp$, the Rayleigh quotient is defined as

\[
  f(x) = \frac{x^\transp A x}{\lVert x \rVert^2}.
\]

It can be used to compute an [eigenvector](https://en.wikipedia.org/wiki/Eigenvalues_and_eigenvectors)
to the largest eigenvalue of a matrix. Let $\lambda_1$ denote the largest eigenvalue. Then we have

\[
  \lambda_1 = \max_{x\in\R^n} f(x).
\]

Since optimization problems are usually phrased as minimization problems, we look at
\[
  \min_{x\in\R^n} -f(x).
\]
Still, Optimization on the whole Euclidean space has the problem, that the minimizer $x^*$, where this minimum is attained, is not unique.
This can easily be seen by observing that any $a\cdot x$, with a positive $a>0$ has the same function value, and also any such vector is of course also an eigenvector to $\lambda_1$.


A remedy is, to restrict the function $f$ to all unit vectors, or in other words the unit sphere
\[
  \mathbb S^{n-1} := \bigl\{x\in\R^n \big| \lVert x \rVert = 1 \bigr\}
\]
of dimension $n-1$. The code on the left now formulates the cost function and its gradient
on this Riemannian manifold in order to perform a Riemannian [Quasi Newton](https://en.wikipedia.org/wiki/Quasi-Newton_method) method.

\bootstrapbox{Note}{In <code class="plaintext">Manopt.jl</code> the example is written using the Riemannian gradient. In <code class="plaintext">Manopt</code> the Euclidean gradient, that is the gradient in the embedding of the sphere, is provided and internally converted via projection to the Riemannian one.}

{{newcolumn}}
  {{addtab "Manopt.jl" "_code/rayleigh.jl" "julia_src" "Julia"}}
  {{addtab "Manopt" "_code/rayleigh.m" "matlab_src" "Matlab"}}
  {{addtab "Pymanopt" "_code/rayleigh_pymanopt.py" "python_src" "Pymanopt"}}
  {{addtab "GeomStats" "_code/rayleigh_geomstats.py" "python_src" "Geomstats}}
  {{printtabs}}
{{endcolumns}}