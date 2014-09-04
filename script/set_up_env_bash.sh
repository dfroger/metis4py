#!/bin/bash

# Check the file is sourced.
if [ "${BASH_SOURCE[0]}" == "${0}" ]
then 
    echo "===================================================="
    echo "WARNING: Usage: source set_up_env_bash.sh"
    echo "===================================================="
    echo
fi

function pyrealpath ()
{
    python -c "import os; print os.path.realpath('$1')"
}

SCRIPT_DIR=$(pyrealpath $(dirname ${BASH_SOURCE[0]}))
ROOT_DIR=$(pyrealpath $SCRIPT_DIR/..)
INSTALL_DIR=$ROOT_DIR/install

PYTHON_MAJOR=$(python -c 'import sys; print sys.version_info.major')
PYTHON_MINOR=$(python -c 'import sys; print sys.version_info.minor')

LIB_DIR=$INSTALL_DIR/lib
BIN_DIR=$INSTALL_DIR/bin
PY_DIR=$INSTALL_DIR/lib/python$PYTHON_MAJOR.$PYTHON_MINOR/site-packages

export LD_LIBRARY_PATH=$LIB_DIR:$LD_LIBRARY_PATH
export PATH=$BIN_DIR:$PATH

export PYTHONPATH=$LIB_DIR:$PYTHONPATH
export PYTHONPATH=$PY_DIR:$PYTHONPATH
export PYTHONPATH=$ROOT_DIR:$PYTHONPATH # to import tool module

echo "LD_LIBRARY_PATH has been prepended with   : $LIB_DIR"
echo "PYTHONPATH has been prepended with        : $LIB_DIR"
echo "PYTHONPATH has been prepended with        : $PY_DIR"
echo "PYTHONPATH has been prepended with        : $ROOT_DIR"
