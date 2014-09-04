import triangle
from pylab import *
from metis4py import part_mesh_nodal

A = {'vertices' : array([[0,0], [1,0], [1, 1], [0, 1]])}
B = triangle.triangulate(A, 'qa0.05')

x1d = B['vertices'][:,0]
y1d = B['vertices'][:,1]
triangles = B['triangles']
ntri = len(triangles)

ntri = len(B['triangles'])
triangles = B['triangles'].flatten()

triangle_idx = range(0,len(triangles)+1,3)

def print_nodes(itri):
    i0 = triangle_idx[itri]
    i1 = triangle_idx[itri+1]
    print triangles[i0:i1]
    print B['triangles'][itri]

print_nodes(itri=0)
print_nodes(itri=5)
print_nodes(itri=ntri-1)

nparts = 3
element_part,node_part = part_mesh_nodal(triangle_idx, triangles,nparts)

print element_part
print node_part
