#!/bin/bash -e
#
# Check whether a tmux session exists and, if not, creates it by calling the
# tmux script in the repo.
# 
# Create a global link with:
# ```
# > cd $HOME/src/helpers1
# > ls -l $(pwd)/dev_scripts.helpers/thin_client/go_helpers.sh
# > ln -sf $(pwd)/dev_scripts.helpers/thin_client/go_helpers.sh ~/go_helpers.sh
# > ls -l ~/go_helpers.sh
# ```

# set -x

SCRIPT_PATH="dev_scripts.helpers/thin_client/go_helpers.sh"
echo "##> $SCRIPT_PATH"

# Note that we don't use `utils.sh` here since we don't know where the repo is.
DIR_PREFIX="helpers"
echo "DIR_PREFIX=$DIR_PREFIX"

IDX=$1
if [[ -z $IDX ]]; then
    echo "ERROR: You need to specify a client, like 1, 2, 3..."
    exit -1
fi;

TMUX_NAME=${DIR_PREFIX}${IDX}
echo "TMUX_NAME=$TMUX_NAME"
#GIT_ROOT_DIR="$HOME/src_vc/$DIR_PREFIX$IDX"
GIT_ROOT_DIR="$HOME/src/${DIR_PREFIX}$IDX"
echo "GIT_ROOT_DIR=$GIT_ROOT_DIR"
DEV_SCRIPT_DIR=${GIT_ROOT_DIR}/dev_scripts.${DIR_PREFIX}
echo "DEV_SCRIPT_DIR=$DEV_SCRIPT_DIR"
THIN_CLIENT_DIR=${DEV_SCRIPT_DIR}/thin_client
echo "THIN_CLIENT_DIR=$THIN_CLIENT_DIR"

# Check if the session already exists.
echo "# Checking if the tmux session '$TMUX_NAME' already exists ..."
tmux list-sessions

TMUX_EXISTS=1
tmux list-sessions | grep $TMUX_NAME || TMUX_EXISTS=0
if [[ $TMUX_EXISTS == 1 ]]; then
    # The session already exists: attach.
    echo "The tmux session already exists: attaching it ..."
    tmux attach-session -t $TMUX_NAME
fi

# Create a new session.
echo "The tmux session doesn't exists, creating it"
FILE="${THIN_CLIENT_DIR}/tmux.${DIR_PREFIX}.sh $IDX"
echo "Executing $GIT_ROOT_DIR/$FILE ..."
cd $GIT_ROOT_DIR
exec $FILE
