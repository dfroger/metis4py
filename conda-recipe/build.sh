if [ "$(uname)" == "Darwin" ]
then
    export CC=clang
    export CXX=clang++

    unset CXXFLAGS
    unset CFLAGS
    unset LDFLAGS

    ./waf -v configure  \
        --metis-inc=$PREFIX/include/ \
        --metis-lib=$PREFIX/lib/ \
        --prefix=$PREFIX \
        --cflags='-mmacosx-version-min=10.7 -arch x86_64' \
        --cxxflags='-stdlib=libc++ -mmacosx-version-min=10.7 -arch x86_64' \
        --ldflags="-L$PREFIX/lib -stdlib=libc++ -mmacosx-version-min=10.7 -arch x86_64" \
        --remove-isysroot

else
    ./waf -v configure  \
        --metis-inc=$PREFIX/include/ \
        --metis-lib=$PREFIX/lib/ \
        --prefix=$PREFIX
fi

./waf -v build
./waf -v install
