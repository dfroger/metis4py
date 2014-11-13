./waf -v configure --metis-inc=$PREFIX/include/ \
                   --metis-lib=$PREFIX/lib/ \
                   --numpy-inc=$PREFIX/lib/python2.7/site-packages/numpy/core/include \
                   --python-inc=$PREFIX/include/python2.7 \
                   --prefix=$PREFIX
./waf -v build
./waf -v install
