Each repo relies on several concept:

- "thin environment", which is the Python environment that contains enough
  packages to run commands
- The "set env" script, which is used to configured a shell inside the thin environment
- The "tmux" script, which is used to create a `tmux` session with our standard
  setup for the repo (e.g., multiple windows on different repo and sub-repos)
- The Docker environment, which contains all the dependencies to do the actual
  development (e.g., run the tools, run the unit tests)

We rule several rules when we compose sub-repos (e.g., `helpers` inside
`sports_analytics`)
- TODO(gp): Explain this

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

- utils.sh


## 
- `build.sh`: builds the thin environment
- `requirements.txt`: the list of Python packages needed in the thin environment

- `go_helpers.sh`: a script to create our standard `tmux` set up
- `
tmux.helpers.sh

- `setenv.helpers.configure_env.sh`
- `setenv.helpers.sh`
- `tmux.helpers.sh`
- `tmux_kill_session.sh`

- `set_repo_vars.sh`
- `set_vars.sh`
- `utils.sh`

