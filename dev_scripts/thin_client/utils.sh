# Define strings with colors.
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
# No color.
NC='\033[0m'

INFO="${GREEN}INFO${NC}"
WARNING="${YELLOW}WARNING${NC}"
ERROR="${RED}ERROR${NC}"

echo -e -n $NC


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


exit_or_return() {
    ret_value=$1
    if [[ is_sourced ]]; then
        return -1
    else
        exit -1
    fi;
}


dassert_dir_exists() {
    # Check if a directory exists.
    local dir_path="$1"
    if [[ ! -d "$dir_path" ]]; then
        echo -e "${ERROR}: Directory '$dir_path' does not exist."
        exit_or_return -1
    fi
}


# TODO(gp): -> dassert_file_exists
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


dassert_is_git_root() {
    # Check if the current directory is the root of a Git repository.
    if [[ -d .git ]]; then
        echo -e "${ERROR}: Current dir '$(pwd)' is not the root of a Git repo."
        exit_or_return -1
    fi;
}


dassert_var_defined() {
    local var_name="$1"
    if [[ -n $var_name ]]; then
        echo -e "${ERROR}: Var '${var_name}' is not defined and non-empty."
        exit_or_return -1
    fi;
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
