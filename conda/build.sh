waf configure --metis-inc=$PREFIX/include/ \
              --metis-lib=$PREFIX/lib/ \
              --numpy-inc=$PREFIX/lib/python2.7/site-packages/numpy/core/include \
              --python-inc=$PREFIX/include/python2.7 \
              --prefix=$PREFIX
waf build
waf install
