#!/usr/bin/env python3
"""
Check whether a tmux session exists and, if not, create it.
"""

import argparse
import logging
import os
import sys

import helpers.hdbg as hdbg
import helpers.hparser as hparser
import helpers.hprint as hprint
import helpers.hsystem as hsystem

import thin_client_utils as tcu

_LOG = logging.getLogger(__name__)

SCRIPT_PATH = os.path.abspath(__file__)

# This is specific of this repo.
DIR_PREFIX = "helpers"


def _system(cmd: str) -> None:
    print(hprint.frame(cmd))
    hsystem.system(cmd, suppress_output=False)


def _main(parser: argparse.ArgumentParser) -> None:
    print(f"##> {SCRIPT_PATH}")
    args = parser.parse_args()
    hdbg.init_logger(verbosity=args.log_level, use_exec_path=True)
    #
    if args.create_global_link:
        _LOG.info("Creating the global link")
        hdbg.dassert_file_exists(SCRIPT_PATH)
        cmd = f"ln -sf {SCRIPT_PATH} ~/go_{DIR_PREFIX}.sh"
        _system(cmd)
        _LOG.info("Link created: exiting")
        sys.exit(0)
    #
    idx = int(args.index)
    tmux_name = f"{DIR_PREFIX}{idx}"
    _LOG.info("tmux_name=%s", tmux_name)
    #
    _LOG.debug("Checking if the tmux session '%s' already exists", tmux_name)
    _, tmux_session_str = hsystem.system_to_string("tmux list-sessions")
    _LOG.debug("tmux_session_str=%s", tmux_session_str)
    # TODO(gp): This is a bit brittle. Parse the output better or check if the
    # through a command.
    tmux_exists = tmux_name in tmux_session_str
    _LOG.debug("tmux_exists=%s", tmux_exists)
    if tmux_exists:
        # The tmux session exists.
        if args.force_restart:
            # Destroy the tmux session.
            _LOG.warning("The tmux session already exists: destroying it ...")
            current_tmux = tcu.get_tmux_session()
            _system(f"tmux kill-session -t {current_tmux}")
        else:
            _LOG.info("The tmux session already exists: attaching it ...")
            # Make sure we are outside a tmux session.
            tcu.dassert_not_inside_tmux()
            # Attach the existing tmux session.
            _system(f"tmux attach-session -t {tmux_name}")
            sys.exit(0)
    _LOG.info("The tmux session doesn't exist, creating it")
    # Make sure we are outside a tmux session.
    tcu.dassert_not_inside_tmux()
    # Try macOS setup.
    server_name = hsystem.get_server_name()
    os_name = hsystem.get_os_name()
    user_name = hsystem.get_user_name()
    if os_name == "Darwin":
        _LOG.info("Inferred MacOS setup")
        home_dir = tcu.get_home_dir()
    elif os_name == "Linux":
        _LOG.info("Inferred server setup")
        hdbg.dassert_in(server_name, ["dev1", "dev2", "dev3"])
        home_dir = f"/data/{user_name}"
    hdbg.dassert_ne(home_dir, "")
    _LOG.info("home_dir=%s", home_dir)
    git_root_dir = os.path.join(home_dir, "src", tmux_name)
    _LOG.info("git_root_dir=%s", git_root_dir)
    # Open the tmux session.
    setenv_path = os.path.join(git_root_dir, "dev_scripts/thin_client/setenv.helpers.sh")
    hdbg.dassert_file_exists(setenv_path)
    tmux_cmd = f"source {setenv_path}"
    hsystem.system(f"tmux new-session -d -s {tmux_name} -n '---{tmux_name}---'")
    hsystem.system(f"tmux send-keys 'white; cd {git_root_dir} && {tmux_cmd}' C-m C-m")
    windows = ["dbash", "regr", "jupyter"]
    for window in windows:
        hsystem.system(f"tmux new-window -n '{window}'")
        hsystem.system(
            f"tmux send-keys 'green; cd {git_root_dir} && {tmux_cmd}' C-m C-m")
    hsystem.system(f"tmux select-window -t {tmux_name}:0")
    hsystem.system(f"tmux -2 attach-session -t {tmux_name}")


def _parse() -> argparse.ArgumentParser:
    # Create the parser.
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    hparser.add_verbosity_arg(parser)
    parser.add_argument(
        '--do_not_confirm',
        action="store_true",
        help='Do not ask for user confirmation',
        required=False
    )
    parser.add_argument(
        '--index',
        type=int,
        help='Index of the client (e.g., 1, 2, 3)',
        required=False,
    )
    parser.add_argument(
        '--force_restart',
        action="store_true",
        help='Destroy the existing tmux session and start a new one',
        required=False,
    )
    parser.add_argument(
        '--create_global_link',
        action="store_true",
        help='Create the link go_*.sh to this script in the home dir and exit',
        required=False,
    )
    return parser


if __name__ == "__main__":
    # Parse the arguments.
    _main(_parse())
