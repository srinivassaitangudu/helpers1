#!/bin/bash -e
#
# Create a standard tmux session for this repo.
#
# > dev_scripts.{repo_name}/tmux.{repo_name}.sh 1
# > dev_scripts.helpers/tmux.helpers.sh 1
#

echo "##> dev_scripts.helpers/tmux.helpers.sh"

#set -x

DIR_PREFIX="helpers"
echo "DIR_PREFIX=$DIR_PREFIX"

# #############################################################################
# Infer server and home dir.
# #############################################################################

SERVER_NAME=$(uname -n)
echo "SERVER_NAME=$SERVER_NAME"

# Try macOS setup.
DIR_NAME="/Users/$USER"
if [[ -d $DIR_NAME ]]; then
  echo "Inferred macOS setup"
  HOME_DIR=$DIR_NAME
else
  # Try AWS setup.
  DIR_NAME="/data/$USER"
  if [[ -d $DIR_NAME ]]; then
    echo "Inferred AWS setup"
    HOME_DIR=$DIR_NAME
  else
    if [[ $SERVER_NAME == "cf-spm-dev4" ]]; then
      HOME_DIR=$HOME
    elif [[ $SERVER_NAME == "cf-spm-dev8" ]]; then
      HOME_DIR=$HOME
    fi;
  fi;
fi;

if [[ -z $HOME_DIR ]]; then
    echo "ERROR: Can't infer where your home dir is located"
    exit -1
fi;
echo "HOME_DIR=$HOME_DIR"

# #############################################################################
# Parse command options.
# #############################################################################

IDX=$1
if [[ -z $IDX ]]; then
  echo "ERROR: You need to specify IDX={1,2,3}"
  exit -1
fi;

GIT_ROOT_DIR="${HOME_DIR}/src/${DIR_PREFIX}${IDX}"
echo "GIT_ROOT_DIR=$GIT_ROOT_DIR"

# #############################################################################
# Open the tmux session.
# #############################################################################

SETENV="dev_scripts.${DIR_PREFIX}/setenv.${DIR_PREFIX}.sh"

# No `clear` since we want to see issues, if any.
#CMD="source ${SETENV} && reset && clear"
CMD="source ${SETENV}"
TMUX_NAME="${DIR_PREFIX}${IDX}"

tmux new-session -d -s $TMUX_NAME -n "---${TMUX_NAME}---"

# The first one window seems a problem.
tmux send-keys "white; cd ${GIT_ROOT_DIR} && $CMD" C-m C-m
#
tmux new-window -n "dbash"
tmux send-keys "green; cd ${GIT_ROOT_DIR} && $CMD" C-m C-m
#
tmux new-window -n "regr"
tmux send-keys "yellow; cd ${GIT_ROOT_DIR} && $CMD" C-m C-m
#
tmux new-window -n "jupyter"
tmux send-keys "yellow; cd ${GIT_ROOT_DIR} && $CMD" C-m C-m

# Go to the first tab.
tmux select-window -t $TMUX_NAME:0
tmux -2 attach-session -t $TMUX_NAME
