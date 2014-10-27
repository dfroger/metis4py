import unittest

import numpy as np

import metis4py

class TestMetis4py(unittest.TestCase):

    def test_normal(self):
        nx, ny = 4,3
        x2d, y2d = np.meshgrid(range(nx),range(ny))
        x1d = x2d.flatten()
        y1d = y2d.flatten()
        trivtx1 = ((0,4,1),(1,5,2),(2,6,3),(4,8,5),(5,9,6),(6,10,7))
        trivtx2 = ((1,4,5),(2,5,6),(3,6,7),(5,8,9),(6,9,10),(7,10,11))
        trivtx = np.array(trivtx1 + trivtx2).flatten()
        triidx = np.arange(0, trivtx.size+1, 3)
        nparts = 3

        tripart,vtxpart = metis4py.part_mesh_nodal(triidx,trivtx,nparts)

        self.assertEqual(tripart.tolist(), [2, 1, 1, 2, 1, 0, 2, 1, 1, 1, 0, 0])
        self.assertEqual(vtxpart.tolist(), [2, 2, 1, 1, 2, 1, 1, 0, 2, 0, 0, 0])

if __name__ == '__main__':
    unittest.main()
