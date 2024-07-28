# Define strings with colors.
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
INFO="${GREEN}INFO${NC}"
WARNING="${YELLOW}WARNING${NC}"
ERROR="${RED}ERROR${NC}"

echo -e $NC

is_sourced() {
    # Function to check if the script is being sourced.
    # If the script is being sourced, $0 will not be equal to ${BASH_SOURCE[0]}
    return [[ $0 != "${BASH_SOURCE}" ]]
}


dassert_is_sourced() {
    # Ensure that this is being sourced and not executed.
    if [[ ! is_sourced ]]; then
        # We are in a script.
        echo -e "${ERROR}: This needs to be sourced and not executed"
        exit -1
    fi;
}


dassert_is_executed() {
    # Ensure that this is being executed and not sourced.
    if [[ is_sourced ]]; then
        # This is being executed and not sourced.
        echo -e "${ERROR}: This needs to be executed and not sourced"
        return -1
    fi;
}

dassert_dir_exists() {
    # Check if a directory exists.
    local dir_path="$1"
    if [[ ! -d "$dir_path" ]]; then
        echo -e "${ERROR}: Directory '$dir_path' does not exist."
        if [[ is_sourced ]]; then
            return -1
        else
            exit -1
        fi;
    fi
}


check_file_exists() {
    # Check if a filename exists.
    local file_name="$1"
    if [[ ! -f "$file_name" ]]; then
        echo -e "${ERROR}: File '$file_name' does not exist."
        if [[ is_sourced ]]; then
            return -1
        else
            exit -1
        fi;
    fi
}

remove_dups() {
    # Remove duplicates.
    local vars="$1"
    echo $vars | perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, scalar <>))'
}

echo_on_different_lines() {
    # Print $PATH on different lines.
    local vars="$1"
    echo $vars | perl -e 'print join("\n", grep { not $seen{$_}++ } split(/:/, scalar <>))'
}


print_vars() {
    echo "TMUX_NAME=$TMUX_NAME"
    echo "GIT_ROOT_DIR=$GIT_ROOT_DIR"
    dassert_dir_exists $GIT_ROOT_NAME
    echo "DEV_SCRIPT_DIR=$DEV_SCRIPT_DIR"
    dassert_dir_exists $DEV_SCRIPT_DIR
    echo "THIN_CLIENT_DIR=$THIN_CLIENT_DIR"
    dassert_dir_exists $THIN_CLIENT_DIR
}


print_python_ver() {
    echo "which python="$(which python 2>&1)
    echo "python -v="$(python --version 2>&1)
    echo "which python3="$(which python3)
    echo "python3 -v="$(python3 --version)
}


print_pip_package_ver() {
    # Print package versions.
    INVOKE_VER=$(invoke --version)
    echo "# invoke=${INVOKE_VER}"
    POETRY_VER=$(poetry --version)
    echo "# poetry=${POETRY_VER}"
    DOCKER_COMPOSE_VER=$(docker-compose --version)
    echo "# docker-compose=${DOCKER_COMPOSE_VER}"
    DOCKER_VER=$(docker --version)
    echo "# docker=${DOCKER_VER}"
}
#
DIR_PREFIX="helpers"
echo "DIR_PREFIX=$DIR_PREFIX"

# Extract the vars.
GIT_ROOT_DIR=$(pwd)
echo "GIT_ROOT_DIR=$GIT_ROOT_DIR"

REPO_NAME=$(basename $GIT_ROOT_DIR)
echo "REPO_NAME=$REPO_NAME"

DEV_SCRIPT_DIR=${GIT_ROOT_DIR}/dev_scripts.${DIR_PREFIX}
echo "DEV_SCRIPT_DIR=$DEV_SCRIPT_DIR"
dassert_dir_exists $DEV_SCRIPT_DIR

THIN_CLIENT_DIR=${DEV_SCRIPT_DIR}/thin_client
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
