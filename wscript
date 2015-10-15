#!/usr/bin/env python
from os.path import join
from os.path import expanduser
import platform

from waflib.Configure import conf

top = '.'
out = 'build'

def options(opt):
    opt.load('compiler_cxx')

    opt.add_option('--metis-inc', action='store', default='',
        help='Directory containing metis.h header.')

    opt.add_option('--metis-lib', action='store', default='',
        help='Directory containing metis library.')

    opt.add_option('--numpy-inc', action='store', default='',
        help='Directory containing numpy header.')

    opt.add_option('--python-inc', action='store', default='',
        help='Directory containing python header.')

def configure(conf):
    conf.load('compiler_cxx')
    conf.load('python')
    conf.load('swig')

    conf.check_python_version((2,4,2))
    conf.check_python_headers()
    if conf.check_swig_version() < (1,2,27):
        conf.fatal('this swig version is too old')

    metis_inc = expanduser(conf.options.metis_inc)
    metis_lib = expanduser(conf.options.metis_lib)
    numpy_inc = expanduser(conf.options.numpy_inc)
    python_inc = expanduser(conf.options.python_inc)

    conf.env.prepend_value('INCLUDES', [metis_inc,numpy_inc,python_inc])
    conf.env.prepend_value('LIBPATH', [metis_lib])
    conf.env.prepend_value('RPATH', [metis_lib])
    conf.check(header_name='metis.h', features='c cprogram')
    conf.check_cc(lib='metis')

    conf.env.SWIG_IDX_T_DEFINES = ['-DIDX_T=int32_t', '-DPY_IDX_T=NPY_INT32']

def build(bld):

    bld(
        features = 'cxx cxxshlib pyext',
        source = 'metis4py.i',
        target = '_metis4py',
        swig_flags = ['-c++', '-python'] + bld.env.SWIG_IDX_T_DEFINES,
        includes = '.',
        use  = 'metis4py',
        cxxflags = ['-O3','-DNDEBUG'],
        lib = 'metis',
    )

    python_site_package = '${PREFIX}/lib/python%s/site-packages' \
        % bld.env['PYTHON_VERSION']
    bld.install_files(python_site_package, 'metis4py.py')
