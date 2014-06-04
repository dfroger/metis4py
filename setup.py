#!/usr/bin/env python
from distutils.core import setup, Extension
import os

metis_dir = '/local/froger/opt/metis/5.1.0/'
metis_inc = os.path.join(metis_dir,'include')
metis_lib = os.path.join(metis_dir,'lib')

metis4py = Extension(
        '_metis4py',
        sources = ['metis4py.i',],
        swig_opts=["-c++","-I"+metis_inc,"-I/usr/include"],
        libraries = ['metis'],
        library_dirs = [metis_lib],
        runtime_library_dirs = [metis_lib],
        include_dirs = [metis_inc],
        )

setup (name = 'metis4py',
       ext_modules = [metis4py,],
       py_modules = ['metis4py'],
       )

