#
# Configure the local (thin) client built with `${THIN_CLIENT_DIR}/build.sh`.
#
# NOTE: This file needs to be sourced and not executed. For this reason doesn't
# use bash and doesn't have +x permissions.
# 

# NOTE: We can't use $0 to find out in which file we are in, since this file is
# sourced and not executed.
SCRIPT_PATH="dev_scripts/thin_client/setenv.helpers.sh"
echo "##> $SCRIPT_PATH"

DIR_PREFIX="helpers"

# We can't use $0 to find the path since we are sourcing this file.
GIT_ROOT_PATH=$(pwd)
SOURCE_PATH=$GIT_ROOT_PATH/dev_scripts/thin_client/utils.sh
echo "> source $SOURCE_PATH ..."
source $SOURCE_PATH

# Set the derived vars common to all the scripts.
GIT_ROOT_DIR=$(pwd)
echo "GIT_ROOT_DIR=$GIT_ROOT_DIR"
dassert_is_git_root

REPO_NAME=$(basename $GIT_ROOT_DIR)
echo "REPO_NAME=$REPO_NAME"

DEV_SCRIPT_DIR="${GIT_ROOT_DIR}/dev_scripts"
echo "DEV_SCRIPT_DIR=$DEV_SCRIPT_DIR"
dassert_dir_exists $DEV_SCRIPT_DIR

THIN_CLIENT_DIR="${DEV_SCRIPT_DIR}/thin_client"
echo "THIN_CLIENT_DIR=$THIN_CLIENT_DIR"
dassert_dir_exists $DEV_SCRIPT_DIR

# Resolve the dir containing the Git client.
# For now let's keep using the central version of /venv independenly of where
# the Git client is (e.g., `.../src` vs `.../src_vc`).
SRC_DIR="$HOME/src"
echo "SRC_DIR=$SRC_DIR"
dassert_dir_exists $SRC_DIR

VENV_DIR="$SRC_DIR/venv/client_venv.${DIR_PREFIX}"
echo "VENV_DIR=$VENV_DIR"

dassert_is_sourced

print_vars

# Give permissions to read / write to user and group.
umask 002

# #############################################################################
# Virtual env
# #############################################################################

if [[ ! -d $VENV_DIR ]]; then
    echo -e "${WARNING}: Can't find VENV_DIR='$VENV_DIR': checking the container one"
    # The venv in the container is in a different spot. Check that.
    VENV_DIR="/venv/client_venv.${DIR_PREFIX}"
    if [[ ! -d $VENV_DIR ]]; then
        echo -e "${ERROR}: Can't find VENV_DIR='$VENV_DIR'. Create it with:"
        echo "> ${THIN_CLIENT_DIR}/build.py"
        return 1
    fi;
fi;

ACTIVATE_SCRIPT="$VENV_DIR/bin/activate"
echo "# Activate virtual env '$ACTIVATE_SCRIPT'"
check_file_exists $ACTIVATE_SCRIPT
source $ACTIVATE_SCRIPT

print_python_ver

# #############################################################################
# PATH
# #############################################################################

echo "# Set PATH"

export PATH=.:$PATH
export PATH=$GIT_ROOT_DIR:$PATH
# Add to the PATH all the first level directory under `dev_scripts`.
export PATH="$(find $DEV_SCRIPT_DIR -maxdepth 1 -type d -not -path "$(pwd)" | tr '\n' ':' | sed 's/:$//'):$PATH"

# Remove duplicates.
export PATH=$(remove_dups $PATH)

# Print.
echo "PATH="
echo_on_different_lines $PATH

# #############################################################################
# PYTHONPATH
# #############################################################################

echo "# Set PYTHONPATH"
export PYTHONPATH=$PWD:$PYTHONPATH

# Remove duplicates.
export PYTHONPATH=$(remove_dups $PYTHONPATH)

# Print.
echo "PYTHONPATH="
echo_on_different_lines $PYTHONPATH

# #############################################################################
# Configure environment
# #############################################################################

SCRIPT_PATH2="${THIN_CLIENT_DIR}/setenv.${DIR_PREFIX}.configure_env.sh"
check_file_exists $SCRIPT_PATH2
source $SCRIPT_PATH2

echo -e "${INFO}: ${SCRIPT_PATH} successful"
