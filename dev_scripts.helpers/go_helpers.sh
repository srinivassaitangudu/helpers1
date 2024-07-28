#!/bin/bash -e

# set -x

DIR_PREFIX="helpers"

IDX=$1
if [[ -z $IDX ]]; then
    echo "ERROR: You need to specify a client, like 1, 2, 3..."
    exit -1
fi;

#DIR_NAME="$HOME/src_vc/$DIR_PREFIX$IDX"
DIR_NAME="$HOME/src/${DIR_PREFIX}$IDX"
echo "DIR_NAME=$DIR_NAME"

# Check if the session already exists.
tmux list-clients | grep $DIR_NAME

# Check the exit status.
if [ $? -eq 0 ]; then
    # The session already exists: attach.
    tmux attach $DIR_NAME
fi

# Create a new session.
if [[ ! -d $DIR_NAME ]]; then
    echo "Can't find dir $DIR_NAME"
    exit -1
fi;
FILE="dev_scripts.${DIR_PREFIX}/tmux_${DIR_PREFIX}.sh $IDX"
echo "> $DIR_NAME/$FILE"

cd $DIR_NAME
exec $FILE
