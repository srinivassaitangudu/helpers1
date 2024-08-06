#
# Configure the local (thin) client built with `${THIN_CLIENT_DIR}/build.sh`.
#
# NOTE: This file needs to be sourced and not executed. For this reason doesn't
# use bash and doesn't have +x permissions.
# 

SCRIPT_PATH="dev_scripts/thin_client/setenv.helpers.sh"
echo "##> $SCRIPT_PATH"

# We can't use $0 to find the path since we are sourcing this file.
GIT_ROOT_PATH=$(pwd)
SOURCE_PATH=$GIT_ROOT_PATH/dev_scripts/thin_client/utils.sh
echo "> source $SOURCE_PATH ..."
source $SOURCE_PATH

SOURCE_PATH=$GIT_ROOT_PATH/dev_scripts/thin_client/set_vars.sh
echo "> source $SOURCE_PATH ..."
source $SOURCE_PATH

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
        echo "> ${THIN_CLIENT_DIR}/build.sh"
        return -1
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
