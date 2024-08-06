import os
import subprocess

import helpers.hdbg as hdbg
import helpers.hsystem as hsystem

# Define strings with colors
RED = '\033[0;31m'
YELLOW = '\033[1;33m'
GREEN = '\033[0;32m'
# No color
NC = '\033[0m'


def warning(txt: str):
    print(YELLOW + ": " + txt + NC)


def error(txt: str):
    print(RED + ": " + txt + NC)
    raise RuntimeError("")


def get_git_root_dir() -> str:
    _, git_root_dir = hsystem.system_to_string("git rev-parse --show-toplevel")
    return git_root_dir


def get_home_dir() -> str:
    home_dir = os.environ['HOME']
    return home_dir


def get_thin_environment_dir() -> str:
    git_root_dir = get_git_root_dir()
    return f"{git_root_dir}/dev_scripts/thin_client"


def get_venv_dir(dir_prefix: str) -> str:
    home_dir = get_home_dir()
    return f"{home_dir}/src/venv/client_venv.{dir_prefix}"