%module metis4py

%{
#define SWIG_FILE_WITH_INIT
#include "metis.h"
#include "stdio.h"
%}

%include "numpy.i"

%init %{
    import_array(); 
%}

%import "metis.h"

#if IDXTYPEWIDTH == 32
%numpy_typemaps(idx_t, NPY_INT, idx_t)
#else
%numpy_typemaps(idx_t, NPY_LONG, idx_t)
#endif

%apply (idx_t* IN_ARRAY1, idx_t DIM1) {(idx_t* element_idx, idx_t element_idx_size)}
%apply (idx_t* IN_ARRAY1, idx_t DIM1) {(idx_t* elements, idx_t elements_size)}

%apply (idx_t** ARGOUTVIEWM_ARRAY1, idx_t* DIM1) {(idx_t** element_parts, idx_t* element_parts_size)}
%apply (idx_t** ARGOUTVIEWM_ARRAY1, idx_t* DIM1) {(idx_t** node_parts, idx_t* node_parts_size)}

%exception part_mesh_nodal {
    try {
        $action
    } 
    catch (int e)
    {
        switch (e) {
            case METIS_ERROR_INPUT:
                PyErr_SetString(PyExc_RuntimeError,"Metis returned METIS_ERROR_INPUT.");
                return NULL;
                break;

            case METIS_ERROR_MEMORY:
                PyErr_SetString(PyExc_RuntimeError,"Metis returned METIS_ERROR_MEMORY.");
                return NULL;
                break;

            case METIS_ERROR:
                PyErr_SetString(PyExc_RuntimeError,"Metis returned METIS_ERROR.");
                return NULL;
                break;

            default:
                PyErr_SetString(PyExc_RuntimeError,"Metis returned unknow error.");
                return NULL;
                break;
        }
    }
}

%inline %{
void part_mesh_nodal(
    idx_t* element_idx, idx_t element_idx_size,         // IN_ARRAY1
    idx_t* elements, idx_t elements_size,               // IN_ARRAY1
    idx_t nparts,
    idx_t** element_parts, idx_t* element_parts_size ,  // ARGOUTVIEWM_ARRAY1
    idx_t** node_parts, idx_t* node_parts_size          // ARGOUTVIEWM_ARRAY1
    )
{
    // TODO: return ncuts

    idx_t *vwgt = NULL;
    idx_t *vsize = NULL;
    real_t *tpwgts = NULL; 
    idx_t *options = NULL;
    idx_t objval;

    // number of elements;
    idx_t ne = element_idx_size - 1;

    // number of nodes is the greatest element vertex index, plus one.
    idx_t nn = elements[0];
    idx_t ii;
    for (ii = 0 ; ii < elements_size ; ii++) {
        if (elements[ii] > nn) {
            nn = elements[ii];
        }
    }
    nn++; // counting from 0

    // element_parts
    *element_parts_size = ne;
    *element_parts = (idx_t*) malloc( (*element_parts_size)*sizeof(idx_t) );

    // node_parts
    *node_parts_size = nn;
    *node_parts = (idx_t*) malloc( (*node_parts_size)*sizeof(idx_t) );

    int err = METIS_PartMeshNodal(&ne, &nn, element_idx, elements, vwgt, vsize, 
            &nparts, tpwgts, options, &objval, *element_parts, *node_parts);

    if (err != METIS_OK) {
        throw err;
    }

}
%}
