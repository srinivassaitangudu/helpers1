import os

import argparse
import logging
import os
import sys

import helpers.hdbg as hdbg
import helpers.hparser as hparser
import helpers.hprint as hprint
import helpers.hsystem as hsystem

_LOG = logging.getLogger(__name__)


# #############################################################################
# General
# #############################################################################


def get_git_root_dir() -> str:
    _, git_root_dir = hsystem.system_to_string("git rev-parse --show-toplevel")
    return git_root_dir


def get_home_dir() -> str:
    home_dir = os.environ['HOME']
    return home_dir


def get_thin_environment_dir() -> str:
    git_root_dir = get_git_root_dir()
    thin_environ_dir = f"{git_root_dir}/dev_scripts/thin_client"
    return thin_environ_dir


def get_venv_dir(dir_prefix: str) -> str:
    home_dir = get_home_dir()
    venv_dir = f"{home_dir}/src/venv/client_venv.{dir_prefix}"
    return venv_dir


def get_tmux_session() -> str:
    rc, tmux_session = hsystem.system_to_string("tmux display-message -p '#S'",
                                                abort_on_error=False)
    if rc != 0:
        tmux_session = ""
    return tmux_session


def inside_tmux() -> bool:
    return 'TMUX' in os.environ


def dassert_not_inside_tmux():
    hdbg.dassert(not inside_tmux())


def system(cmd: str) -> None:
    print(hprint.frame(cmd))
    hsystem.system(cmd, suppress_output=False)


# #############################################################################
# Tmux
# #############################################################################


def create_parser(docstring: str) -> argparse.ArgumentParser:
    # Create the parser.
    parser = argparse.ArgumentParser(
        description=docstring,
        formatter_class=argparse.RawDescriptionHelpFormatter
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


def create_tmux_session(parser: argparse.ArgumentParser,
                        script_path: str,
                        dir_prefix: str, setenv_path: str) -> \
        None:
    print(f"##> {script_path}")
    args = parser.parse_args()
    hdbg.init_logger(verbosity=args.log_level, use_exec_path=True)
    #
    if args.create_global_link:
        _LOG.info("Creating the global link")
        hdbg.dassert_file_exists(script_path)
        cmd = f"ln -sf {script_path} ~/go_{dir_prefix}.sh"
        system(cmd)
        _LOG.info("Link created: exiting")
        sys.exit(0)
    #
    hdbg.dassert_is_not(args.index, None, "Need to specify --index")
    idx = int(args.index)
    tmux_name = f"{dir_prefix}{idx}"
    _LOG.info("tmux_name=%s", tmux_name)
    #
    _LOG.debug("Checking if the tmux session '%s' already exists", tmux_name)
    _, tmux_session_str = hsystem.system_to_string("tmux list-sessions")
    _LOG.debug("tmux_session_str=\n%s", tmux_session_str)
    # E.g.,
    # cmamp1: 4 windows (created Sun Aug  4 09:54:53 2024) (attached)
    tmux_sessions = [l.split(":")[0] for l in tmux_session_str.splitlines()]
    tmux_exists = tmux_name in tmux_sessions
    _LOG.debug("tmux_exists=%s", tmux_exists)
    if tmux_exists:
        # The tmux session exists.
        if args.force_restart:
            # Destroy the tmux session.
            _LOG.warning("The tmux session already exists: destroying it ...")
            current_tmux = get_tmux_session()
            system(f"tmux kill-session -t {current_tmux}")
        else:
            _LOG.info("The tmux session already exists: attaching it ...")
            # Make sure we are outside a tmux session.
            dassert_not_inside_tmux()
            # Attach the existing tmux session.
            system(f"tmux attach-session -t {tmux_name}")
            sys.exit(0)
    _LOG.info("The tmux session doesn't exist, creating it")
    # Make sure we are outside a tmux session.
    dassert_not_inside_tmux()
    # Try macOS setup.
    server_name = hsystem.get_server_name()
    os_name = hsystem.get_os_name()
    user_name = hsystem.get_user_name()
    if os_name == "Darwin":
        _LOG.info("Inferred MacOS setup")
        home_dir = get_home_dir()
    elif os_name == "Linux":
        _LOG.info("Inferred server setup")
        hdbg.dassert_in(server_name, ["dev1", "dev2", "dev3"])
        home_dir = f"/data/{user_name}"
    hdbg.dassert_ne(home_dir, "")
    _LOG.info("home_dir=%s", home_dir)
    git_root_dir = os.path.join(home_dir, "src", tmux_name)
    _LOG.info("git_root_dir=%s", git_root_dir)
    # Open the tmux session.
    setenv_path = os.path.join(git_root_dir, setenv_path)
    hdbg.dassert_file_exists(setenv_path)
    tmux_cmd = f"source {setenv_path}"
    hsystem.system(f"tmux new-session -d -s {tmux_name} -n '---{tmux_name}---'")
    hsystem.system(
        f"tmux send-keys 'white; cd {git_root_dir} && {tmux_cmd}' C-m C-m")
    windows = ["dbash", "regr", "jupyter"]
    for window in windows:
        hsystem.system(f"tmux new-window -n '{window}'")
        hsystem.system(
            f"tmux send-keys 'green; cd {git_root_dir} && {tmux_cmd}' C-m C-m")
    hsystem.system(f"tmux select-window -t {tmux_name}:0")
    hsystem.system(f"tmux -2 attach-session -t {tmux_name}")