# Define strings with colors.
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
INFO="${GREEN}INFO${NC}"
WARNING="${YELLOW}WARNING${NC}"
ERROR="${RED}ERROR${NC}"

# Function to check if a directory exists.
check_dir_exists() {
    local dir_path="$1"
    if [[ ! -d "$dir_path" ]]; then
        echo -e "${ERROR}: Directory '$dir_path' does not exist."
        exit -1
    fi
}

# Function to check if a filename exists.
check_file_exists() {
    local file_name="$1"
    if [[ ! -f "$file_name" ]]; then
        echo -e "${ERROR}: File '$file_name' does not exist."
        exit -1
    fi
}

remove_dups() {
    local vars="$1"
    # Remove duplicates.
    echo $vars | perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, scalar <>))'
}

# Print $PATH on different lines.
echo_on_different_lines() {
    local vars="$1"
    echo $vars | perl -e 'print join("\n", grep { not $seen{$_}++ } split(/:/, scalar <>))'
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
check_dir_exists $DEV_SCRIPT_DIR

THIN_CLIENT_DIR=${DEV_SCRIPT_DIR}/thin_client
echo "THIN_CLIENT_DIR=$THIN_CLIENT_DIR"
check_dir_exists $DEV_SCRIPT_DIR

# Resolve the dir containing the Git client.
# For now let's keep using the central version of /venv independenly of where
# the Git client is (e.g., `.../src` vs `.../src_vc`).
SRC_DIR="$HOME/src"
echo "SRC_DIR=$SRC_DIR"
check_dir_exists $SRC_DIR

VENV_DIR="$SRC_DIR/venv/client_venv.${DIR_PREFIX}"
echo "VENV_DIR=$VENV_DIR"
