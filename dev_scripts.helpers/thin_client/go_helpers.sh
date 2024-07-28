#!/bin/bash -e
#
# Check whether a tmux session exists and, if not, creates it by calling the
# tmux script in the repo.
# 

# set -x

DIR_PREFIX="helpers"
echo "DIR_PREFIX=$DIR_PREFIX"

IDX=$1
if [[ -z $IDX ]]; then
    echo "ERROR: You need to specify a client, like 1, 2, 3..."
    exit -1
fi;

TMUX_NAME=${DIR_PREFIX}$IDX

#DIR_NAME="$HOME/src_vc/$DIR_PREFIX$IDX"
DIR_NAME="$HOME/src/${DIR_PREFIX}$IDX"
echo "DIR_NAME=$DIR_NAME"

# Check if the session already exists.
echo "Checking if the tmux session '$TMUX_NAME' already exists ..."
tmux list-clients

TMUX_EXISTS=1
tmux list-clients | grep $TMUX_NAME || TMUX_EXISTS=0

# Check the exit status.
if [[ $TMUX_EXISTS == 1 ]]; then
    # The session already exists: attach.
    echo "The tmux session already exists: attaching it ..."
    tmux attach $DIR_NAME
fi
echo "The tmux session doesn't exists, creating it"

# Create a new session.
if [[ ! -d $DIR_NAME ]]; then
    echo "Can't find dir $DIR_NAME"
    exit -1
fi;
FILE="dev_scripts.${DIR_PREFIX}/tmux.${DIR_PREFIX}.sh $IDX"
echo "> $DIR_NAME/$FILE"

cd $DIR_NAME
exec $FILE
