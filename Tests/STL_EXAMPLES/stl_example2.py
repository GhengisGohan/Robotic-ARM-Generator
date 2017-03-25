from stl import mesh
import math
import numpy

# Create 3 faces of a cube
data = numpy.zeros(6, dtype=mesh.Mesh.dtype)

print mesh.Mesh.dtype
# Top of the cube
# data['vectors'][0] = numpy.array([[0, 1, 1],
#                                   [1, 0, 1],
#                                   [0, 0, 1]])
# data['vectors'][1] = numpy.array([[1, 0, 1],
#                                   [0, 1, 1],
#                                   [1, 1, 1]])
# # Right face
# data['vectors'][2] = numpy.array([[1, 0, 0],
#                                   [1, 0, 1],
#                                   [1, 1, 0]])
# data['vectors'][3] = numpy.array([[1, 1, 1],
#                                   [1, 0, 1],
#                                   [1, 1, 0]])
# # Left face
# data['vectors'][4] = numpy.array([[0, 0, 0],
#                                   [1, 0, 0],
#                                   [1, 0, 1]])
# data['vectors'][5] = numpy.array([[0, 0, 0],
#                                   [0, 0, 1],
#                                   [1, 0, 1]])

# # Generate 4 different meshes so we can rotate them later
# meshes = mesh.Mesh(data)


# Define the 8 vertices of the cube
vertices = numpy.array([\
    [-1, -1, -1],
    [+1, -1, -1],
    [+1, +1, -1],
    [-1, +1, -1],
    [-1, -1, +1],
    [+1, -1, +1],
    [+1, +1, +1],
    [-1, +1, +1]])

# Define the 12 triangles composing the cube
faces = numpy.array([\
    [0,3,1],
    [1,3,2],
    [0,4,7],
    [0,7,3],
    [4,5,6],
    [4,6,7],
    [5,1,2],
    [5,2,6],
    [2,3,6],
    [3,7,6],
    [0,1,5],
    [0,5,4]])

# Create the mesh
meshes = mesh.Mesh(numpy.zeros(faces.shape[0], dtype=mesh.Mesh.dtype))
for i, f in enumerate(faces):
    for j in range(3):
        meshes.vectors[i][j] = vertices[f[j],:]

# Optionally render the rotated cube faces
from matplotlib import pyplot
from mpl_toolkits import mplot3d

# Create a new plot
figure = pyplot.figure()
axes = mplot3d.Axes3D(figure)

# Render the cube faces
axes.add_collection3d(mplot3d.art3d.Poly3DCollection(meshes.vectors))

# Auto scale to the mesh size
scale = meshes.points.flatten(-1)
axes.auto_scale_xyz(scale, scale, scale)

# Show the plot to the screen
pyplot.show()