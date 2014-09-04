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

%numpy_typemaps(long              , NPY_LONG     , long)

%apply (long int* IN_ARRAY1, long int DIM1) {(long int* element_idx, long int element_idx_size)}
%apply (long int* IN_ARRAY1, long int DIM1) {(long int* elements, long int elements_size)}

%apply (long int** ARGOUTVIEWM_ARRAY1, long int* DIM1) {(long int** element_parts, long int* element_parts_size)}
%apply (long int** ARGOUTVIEWM_ARRAY1, long int* DIM1) {(long int** node_parts, long int* node_parts_size)}

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
    long int* element_idx, long int element_idx_size,         // IN_ARRAY1
    long int* elements, long int elements_size,               // IN_ARRAY1
    long int nparts,
    long int** element_parts, long int* element_parts_size ,  // ARGOUTVIEWM_ARRAY1
    long int** node_parts, long int* node_parts_size          // ARGOUTVIEWM_ARRAY1
    )
{
    // TODO: return ncuts

    long int *vwgt = NULL;
    long int *vsize = NULL;
    real_t *tpwgts = NULL; 
    long int *options = NULL;
    long int objval;

    // number of elements;
    long int ne = element_idx_size - 1;

    // number of nodes is the greatest element vertex index, plus one.
    long int nn = elements[0];
    long int ii;
    for (ii = 0 ; ii < elements_size ; ii++) {
        if (elements[ii] > nn) {
            nn = elements[ii];
        }
    }
    nn++; // counting from 0

    // element_parts
    *element_parts_size = ne;
    *element_parts = (long int*) malloc( (*element_parts_size)*sizeof(long int) );

    // node_parts
    *node_parts_size = nn;
    *node_parts = (long int*) malloc( (*node_parts_size)*sizeof(long int) );

    int err = METIS_PartMeshNodal(&ne, &nn, element_idx, elements, vwgt, vsize, 
            &nparts, tpwgts, options, &objval, *element_parts, *node_parts);

    if (err != METIS_OK) {
        throw err;
    }

}
%}
