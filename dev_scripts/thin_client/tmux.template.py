#!/usr/bin/env python3
"""
Check whether a tmux session exists and, if not, creates it.
"""

import argparse
import logging
import os
import sys

import helpers.hdbg as hdbg
import helpers.hparser as hparser
import helpers.hprint as hprint
import helpers.hsystem as hsystem

# We need to tweak `PYTHONPATH` directly since we are bootstrapping the system.
sys.path.append('helpers_root/dev_scripts/thin_client')
import thin_client_utils as tcu

_LOG = logging.getLogger(__name__)

SCRIPT_PATH = os.path.abspath(__file__)


if __name__ == "__main__":
    parser = tcu.create_parser(__doc__)
    #
    dir_prefix = "xyz"
    setenv_path = os.path.join("dev_scripts_xyz",
                               "thin_client", "setenv.xyz.sh")
    tcu.create_tmux_session(parser, SCRIPT_PATH, dir_prefix, setenv_path)