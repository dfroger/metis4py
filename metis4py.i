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

%apply (int* IN_ARRAY1, int DIM1) {(int* element_idx, int element_idx_size)}
%apply (int* IN_ARRAY1, int DIM1) {(int* elements, int elements_size)}

%apply (int** ARGOUTVIEWM_ARRAY1, int* DIM1) {(int** element_parts, int* element_parts_size)}
%apply (int** ARGOUTVIEWM_ARRAY1, int* DIM1) {(int** node_parts, int* node_parts_size)}

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
    int* element_idx, int element_idx_size,         // IN_ARRAY1
    int* elements, int elements_size,               // IN_ARRAY1
    int nparts,
    int** element_parts, int* element_parts_size ,  // ARGOUTVIEWM_ARRAY1
    int** node_parts, int* node_parts_size          // ARGOUTVIEWM_ARRAY1
    )
{
    // TODO: return ncuts

    int *vwgt = NULL;
    int *vsize = NULL;
    real_t *tpwgts = NULL; 
    int *options = NULL;
    int objval;

    // number of elements;
    int ne = element_idx_size - 1;

    // number of nodes is the greatest element vertex index, plus one.
    int nn = elements[0];
    int ii;
    for (ii = 0 ; ii < elements_size ; ii++) {
        if (elements[ii] > nn) {
            nn = elements[ii];
        }
    }
    nn++; // counting from 0

    // element_parts
    *element_parts_size = ne;
    *element_parts = (int*) malloc( (*element_parts_size)*sizeof(int) );

    // node_parts
    *node_parts_size = nn;
    *node_parts = (int*) malloc( (*node_parts_size)*sizeof(int) );

    int err = METIS_PartMeshNodal(&ne, &nn, element_idx, elements, vwgt, vsize, 
            &nparts, tpwgts, options, &objval, *element_parts, *node_parts);

    if (err != METIS_OK) {
        throw err;
    }

}
%}
