#!/bin/bash
#
# Build a thin virtual environment to run workflows on the dev machine.
#

set -e

SCRIPT_PATH="dev_scripts.helpers/thin_client/build.sh"
echo "##> $SCRIPT_PATH"

source $(dirname "$0")/utils.sh

#dassert_is_executed

print_python_ver()

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

print_pip_package_ver

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

echo -e "${INFO}: ${SCRIPT_PATH} successful"
