#!/bin/bash
#
# Build a thin virtual environment to run workflows on the dev machine.
#

# TODO(gp): Use python 3.9 and keep this in sync with
# devops/docker_build/pyproject.toml

set -e

source $(dirname "$0")/utils.sh

echo $(remove_dups $PATH)

exit -1

echo "which python="$(which python 2>&1)
echo "python -v="$(python --version 2>&1)
echo "which python3="$(which python3)
echo "python3 -v="$(python3 --version)

# Check if AWS CLI V2 is already installed.
if command -v aws &>/dev/null; then
    AWS_VERSION=$(aws --version)
else
    echo "AWS CLI is not installed. Please install it and try again."
    exit 1
fi;
echo "# aws=${AWS_VERSION}"

# Create thin environment.
if [[ -d $VENV_DIR ]]; then
    echo -e "${WARNING}: Deleting old virtual environment in '$VENV_DIR'"
    rm -rf $VENV_DIR
fi;
echo -e "${INFO}: Creating virtual environment in '$VENV_DIR'"
python3 -m venv $VENV_DIR
source $VENV_DIR/bin/activate

# Install packages.
cp ${THIN_CLIENT_DIR}/requirements.txt ${THIN_CLIENT_DIR}/tmp.requirements.txt
if [[ $(uname) == "Darwin" ]]; then
    # On Mac there is an issue related to this package, so you might want to pin it
    # down.
    # pyyaml == 5.3.1
    echo "pyyaml == 5.3.1" >> ${THIN_CLIENT_DIR}/tmp.requirements.txt
fi;

# TODO(gp): Switch to poetry.
python3 -m pip install --upgrade pip
pip3 install -r ${THIN_CLIENT_DIR}/tmp.requirements.txt

# Print package versions.
INVOKE_VER=$(invoke --version)
echo "# invoke=${INVOKE_VER}"
POETRY_VER=$(poetry --version)
echo "# poetry=${POETRY_VER}"
DOCKER_COMPOSE_VER=$(docker-compose --version)
echo "# docker-compose=${DOCKER_COMPOSE_VER}"
DOCKER_VER=$(docker --version)
echo "# docker=${DOCKER_VER}"

# Handle MacOS specific packages.
if [[ $(uname) == "Darwin" ]]; then
    # Update brew.
    brew update
    BREW_VER=$(brew --version)
    echo "# brew version=$BREW_VER"

    # Install GitHub CLI.
    brew install gh
    GH_VER=$(gh --version)
    echo "# gh version=$GH_VER"

    # Install dive.
    # https://github.com/wagoodman/dive
    #brew install dive
    #echo "dive version="$(dive --version)
fi;

echo -e "${INFO}: Building thin client successful"
