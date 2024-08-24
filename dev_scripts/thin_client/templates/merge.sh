#!/bin/bash -xe
# The repo that we are using as reference (can be `helpers` or a super-repo).
SRC_ROOT_DIR="/Users/saggese/src/sports_analytics1/helpers_root"
TEMPLATE_DIR="$SRC_ROOT_DIR/dev_scripts/thin_client/templates"
# The new repo that we are creating / syncing.
PREFIX="tutorials"
DST_ROOT_DIR="/Users/saggese/src/tutorials1"
DST_DIR="$DST_ROOT_DIR/dev_scripts_${PREFIX}/thin_client"
# Template vs helpers.
vimdiff ${TEMPLATE_DIR}/setenv.template.sh dev_scripts/thin_client/setenv.helpers.sh
vimdiff ${TEMPLATE_DIR}/tmux.template.py dev_scripts/thin_client/tmux.helpers.py
# Template vs dst dir.
vimdiff ${TEMPLATE_DIR}/setenv.template.sh ${DST_DIR}/setenv.${PREFIX}.sh
vimdiff ${TEMPLATE_DIR}/tmux.template.py ${DST_DIR}/tmux.${PREFIX}.py
