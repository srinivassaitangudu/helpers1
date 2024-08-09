Each repo relies on several concept:

- "thin environment": a Python environment that contains enough packages to run
  commands and start the development system in Docker
- "set env" script: it is used to configured a shell inside the thin environment
- "tmux" script: it is used to create a `tmux` session with our standard setup
  for the repo (e.g., multiple windows on different repo and sub-repos)
- Docker environment: it contains all the libraries, packages, and dependencies
  for the actual development (e.g., run the tools, run the unit tests)

## Naming objects composed across repos
- We add a suffix representing the name of the repo any time we need to
  distinguish different objects
  - E.g., `dev_scripts_helpers` vs `dev_scripts_cmamp`
- We can't always use the `.` to separate the fields since `.` creates problems
  when importing Python files, and so we resort to using `_`

- On the one hand, we agree that the directory structure should help distinguish
  different objects
  - E.g., `//helpers/.../dev_scripts` vs `//cmamp/.../dev_scripts`
- On the other hand, with the previous approach is that the same name easily create
  confusion and can be a source of bugs, since one needs to always keep track
  of the including dir

# Files

- The files involved in the various functions
  ```bash
  > ls -l -1 dev_scripts/thin_client/
  build.sh
  go_helpers.sh
  requirements.txt
  set_repo_vars.sh
  set_vars.sh
  setenv.helpers.configure_env.sh
  setenv.helpers.sh
  tmux.helpers.sh
  tmux_kill_session.sh
  utils.sh
  ```

## General utils

- `utils.sh`: contain code shared across all the scripts
- `set_vars.sh`: create variables needed across all the scripts
- `set_repo_vars.helpers.sh`: contain the code specific of the repo

## Building the thin environment

- `build.sh`: build the thin environment
- `requirements.txt`: list of Python packages needed in the thin environment

## Configuring a shell

- `setenv.helpers.sh`: configure a shell to run the thin environment
- `setenv.helpers.configure_env.sh`
  - TODO(gp): Not sure if this is still needed

## Tmux session

- `go_helpers.sh`: check if the tmux exists and if not creates it
- `tmux.helpers.sh`: a script to create our standard `tmux` set up
  - TODO(gp): These two files should be merged
- `tmux_kill_session.sh`: kill the current tmux session
