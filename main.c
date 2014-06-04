#include <stdio.h>

#include "metis.h"

int main() {
    idx_t *vwgt = NULL;
    idx_t *vsize = NULL;
    real_t *tpwgts = NULL; 
    idx_t *options = NULL;
    idx_t objval;

    idx_t nparts = 4;

    idx_t ne = 15;
    idx_t nn = 15;
    idx_t eptr[16] = {0,2,5,8,11,13,16,20,24,28,31,33,36,39,42,44};
    idx_t eind[44] = {1,5,0,2,6,1,3,7,2,4,8,3,9,0,6,10,1,5,7,11,2,
        6,8,12,3,7,9,13,4,8,14,5,11,6,10,12,7,11,13,8,12,14,9,13};

    // element_parts
    idx_t element_parts[15];
    idx_t node_parts[15];

    int err = METIS_PartMeshNodal(&ne, &nn, eptr, eind, vwgt, vsize,
            &nparts, tpwgts, options, &objval, element_parts, node_parts);

    return 0;
}
