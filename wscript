#!/usr/bin/env python
from os.path import join
from os.path import expanduser
import platform

from waflib.Configure import conf

top = '.'
out = 'build'

def remove_isysroot(flags):
    """
    >>> flags =  ['-stdlib=libc++', '-std=c++11',
    ...           '-isysroot', '/Developer/SDKs/MacOSX10.5.sdk',
    ...           '-isysroot', '/Developer/SDKs/MacOSX10.5.sdk']
    >>> remove_isysroot(flags)
    >>> print flags
    ['-stdlib=libstdc++', '-std=c++11' ]
    """
    name = '-isysroot'
    while name in flags:
        idx = flags.index(flag)
        flags.pop(idx)
        flags.pop(idx)

def options(opt):
    opt.load('compiler_cxx python')

    opt.add_option('--metis-inc', action='store', default='',
        help='Directory containing metis.h header.')

    opt.add_option('--metis-lib', action='store', default='',
        help='Directory containing metis library.')

    opt.add_option('--cflags', action='store', default="", help='Additional C flags')

    opt.add_option('--cxxflags', action='store', default="", help='Additional C++ flags')

    opt.add_option('--ldflags', action='store', default="", help='Additional linker flags')

    opt.add_option('--remove-isysroot', action='store_true', default=False,
        help='Remove -isysroot C/C++ flag that may come with python-config --cflags')

def configure(conf):
    conf.load('compiler_cxx python swig')

    conf.check_python_version((2,4,2))
    conf.check_python_headers()
    if conf.check_swig_version() < (1,2,27):
        conf.fatal('this swig version is too old')

    # Changing CFLAGS alters conf.load('swig')
    # See: https://github.com/waf-project/waf/issues/1663
    conf.env.append_value('CFLAGS', conf.options.cflags.split())
    conf.env.append_value('CXXFLAGS', conf.options.cxxflags.split())
    conf.env.append_value('LDFLAGS', conf.options.ldflags.split())

    metis_inc = expanduser(conf.options.metis_inc)
    metis_lib = expanduser(conf.options.metis_lib)
    import numpy
    numpy_inc = numpy.get_include()

    conf.env.prepend_value('INCLUDES', [metis_inc,numpy_inc])
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
