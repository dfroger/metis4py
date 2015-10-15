import unittest
import platform

import numpy as np

import metis4py

# See mesh here:
# https://github.com/dfroger/metis4py/blob/master/part_mesh_nodal.ipynb

class TestMetis4py(unittest.TestCase):

    def test_normal(self):

        triangles = np.array((
            (0,4,1),(1,5,2),(2,6,3),
            (4,8,5),(5,9,6),(6,10,7),
            (8,9,12),(9,10,13),(10,11,14),
            (1,4,5),(2,5,6),(3,6,7),
            (5,8,9),(6,9,10),(7,10,11),
            (9,12,13),(10,13,14),(11,14,15),
        ), dtype='int32')

        triangles_idx = np.array(
            [0,3,6,9,12,15,18,21,24,27,30,33,
             36,39,42,45,48,51,54,], dtype='int32')

        nparts = 3

        tripart,vtxpart = metis4py.part_mesh_nodal(triangles_idx,
                                                   triangles.flatten(),
                                                   nparts)

        for part in tripart:
            self.assertIn(part, range(nparts))

        for part in vtxpart:
            self.assertIn(part, range(nparts))

if __name__ == '__main__':
    unittest.main()
