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
