#
# Configure the local (thin) client built with `thin_client.../build.py`.
#
# NOTE: This file needs to be sourced and not executed. For this reason doesn't
# use bash and doesn't have +x permissions.
# 

# NOTE: We can't use $0 to find out in which file we are in, since this file is
# sourced and not executed.
SCRIPT_PATH="dev_scripts_sports_analytics/thin_client/setenv.sports_analytics.sh"
echo "##> $SCRIPT_PATH"

DIR_TAG="xyz"

# We can reuse the thin environment of `helpers`.
VENV_TAG="xyz"

# Give permissions to read / write to user and group.
umask 002

# NOTE: we can't use $0 to find the path since we are sourcing this file.
GIT_ROOT_PATH=$(pwd)
echo "GIT_ROOT_DIR=$GIT_ROOT_DIR"

# Source `thin_client_utils.sh`.
SOURCE_PATH=$GIT_ROOT_PATH/dev_scripts/thin_client/thin_client_utils.sh
echo "> source $SOURCE_PATH ..."
source $SOURCE_PATH

activate_venv $VENV_TAG

# PATH
DEV_SCRIPT_DIR="${GIT_ROOT_DIR}/dev_scripts_${DIR_TAG}"
echo "DEV_SCRIPT_DIR=$DEV_SCRIPT_DIR"
dassert_dir_exists $DEV_SCRIPT_DIR

# Set basic vars.
set_path $DEV_SCRIPT_DIR

# Add more vars.
export PATH=.:$PATH
export PATH=$GIT_ROOT_DIR:$PATH
# Add to the PATH all the first level directory under `dev_scripts`.
export PATH="$(find $DEV_SCRIPT_DIR -maxdepth 1 -type d -not -path "$(pwd)" | tr '\n' ':' | sed 's/:$//'):$PATH"

# Remove duplicates.
export PATH=$(remove_dups $PATH)
# Print.
echo "PATH=$PATH"

# PYTHONPATH
set_pythonpath

# Add more vars.
export PYTHONPATH=$PWD:$PYTHONPATH
# Add helpers.
HELPERS_ROOT_DIR="$GIT_ROOT_DIR/helpers_root"
echo "HELPERS_ROOT_DIR=$HELPERS_ROOT_DIR"
dassert_dir_exists $HELPERS_ROOT_DIR
export PYTHONPATH=$HELPERS_ROOT_DIR:$PYTHONPATH

# Remove duplicates.
export PYTHONPATH=$(remove_dups $PYTHONPATH)
# Print.
echo "PYTHONPATH=$PYTHONPATH"

configure_specific_project

print_env_signature

echo -e "${INFO}: ${SCRIPT_PATH} successful"
