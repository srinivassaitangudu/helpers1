#
# Configure the local (thin) client built with `${THIN_CLIENT_DIR}/build.sh`.
#
# NOTE: This file needs to be sourced and not executed. For this reason doesn't
# use bash and doesn't have +x permissions.
# 

DIR_PREFIX="helpers"
echo "DIR_PREFIX=$DIR_PREFIX"
PWD=$(pwd)
GIT_ROOT_DIR=$PWD
REPO_NAME={dirname $GIT_ROOT_DIR}
DEV_SCRIPT_DIR=${GIT_ROOT_DIR}/dev_scripts.${REPO_NAME}
THIN_CLIENT_DIR=${DEV_SCRIPT_DIR}/thin_client

# Give permissions to read / write to user and group.
umask 002

# #############################################################################
# Virtual env
# #############################################################################

# Resolve the dir containing the Git client.
# For now let's keep using the central version of /venv independenly of where
# the Git client is (e.g., `.../src` vs `.../src_vc`).
SRC_DIR="$HOME/src"
echo "SRC_DIR=$SRC_DIR"
if [[ ! -d $SRC_DIR ]]; then
    echo "ERROR: Dir SRC_DIR='$SRC_DIR' doesn't exist"
    exit -1
fi;

# This var needs to be in sync with `${THIN_CLIENT_DIR}/build.sh`.
VENV_DIR="$SRC_DIR/venv/client_venv.${DIR_PREFIX}"
if [[ ! -d $VENV_DIR ]]; then
    echo "Can't find VENV_DIR='$VENV_DIR': checking the container one"
    # The venv in the container is in a different spot. Check that.
    VENV_DIR="/venv/client_venv.${DIR_PREFIX}"
    if [[ ! -d $VENV_DIR ]]; then
        echo "ERROR: Can't find VENV_DIR='$VENV_DIR'. Create it with:"
        echo "> ${THIN_CLIENT_DIR}/build.sh"
        return -1
    fi;
fi;

ACTIVATE_SCRIPT="$VENV_DIR/bin/activate"
echo "# Activate virtual env '$ACTIVATE_SCRIPT'"
if [[ ! -f $ACTIVATE_SCRIPT ]]; then
    echo "ERROR: Can't find '$ACTIVATE_SCRIPT'"
    return -1
fi;
source $ACTIVATE_SCRIPT

echo "which python="$(which python 2>&1)
echo "python -v="$(python --version)

# #############################################################################
# PATH
# #############################################################################

echo "# Set PATH"

export PATH=.:$PATH
export PATH=$GIT_ROOT_DIR:$PATH

# Add to the PATH all the first level directory under `dev_scripts`.
export PATH="$(find $DEV_SCRIPT_DIR -maxdepth 1 -type d -not -path "$(pwd)" | tr '\n' ':' | sed 's/:$//'):$PATH"

# Remove duplicates.
export PATH=$(echo $PATH | perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, scalar <>))')

# Print.
echo "PATH="
echo $PATH | perl -e 'print join("\n", grep { not $seen{$_}++ } split(/:/, scalar <>))'

# #############################################################################
# PYTHONPATH
# #############################################################################

echo "# Set PYTHONPATH"
export PYTHONPATH=$PWD:$PYTHONPATH

# Remove duplicates.
export PYTHONPATH=$(echo $PYTHONPATH | perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, scalar <>))')

# Print on different lines.
echo "PYTHONPATH="
echo $PYTHONPATH | perl -e 'print join("\n", grep { not $seen{$_}++ } split(/:/, scalar <>))'

# #############################################################################
# Configure environment
# #############################################################################

source ${THIN_CLIENT_DIR}/setenv.${REPO_NAME}.configure_env.sh

echo "# setenv successful" 
