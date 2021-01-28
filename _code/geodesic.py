from pymanopt.manifolds import Sphere

# The 'usual' sphere S^2, the set of points lying
# on the surface of a ball in 3D space:
manifold = Sphere(3)

p = [0.0, 0.0, 1.0]
q = [0.0, 1.0, 0.0]
X = [0.0, 3*pi/2, 0.0]