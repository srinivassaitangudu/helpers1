# How to create a super-repo including `helpers`

- Create the super-repo

- Add `helpers` as sub-repo
  ```bash
  > git submodule add <repository-url> <path>
  > git submodule add git@github.com:kaizen-ai/helpers.git helpers_root
  > git submodule init
  > git submodule update
  > git add .gitmodules helpers_root
  ```

- Create the `dev_script` dir
  ``` bash
  > PREFIX="sports_analytics"
  > DST_DIR="dev_scripts_${PREFIX}/thin_client"
  > mkdir $SDT_DIR
  > cp -r helpers_root/dev_scripts/thin_client/setenv.template.sh $DST_DIR/setenv.${PREFIX}.sh
  > cp -r helpers_root/dev_scripts/thin_client/tmux.template.sh $DST_DIR/tmux.${PREFIX}.sh
  ```

- It should look like:
  ```bash
  > ls -1 dev_scripts_sports_analytics/thin_client/*
  dev_scripts_sports_analytics/thin_client/setenv.sports_analytics.sh
  dev_scripts_sports_analytics/thin_client/tmux.sports_analytics.py
  ```
- Customize the `dev_scripts` dir
  - You need to decide if a new thin environment is needed or one can be reused
    (e.g., `helpers` one)

## How to test

- Make sure the setenv works
  ```bash
  > source dev_scripts_sports_analytics/thin_client/setenv.sports_analytics.sh
  ```

## Maintain the files in sync with the template

- Keep files in sync
  ```bash
  > vimdiff dev_scripts_sports_analytics/thin_client/setenv.sports_analytics.sh helpers_root/dev_scripts/thin_client/setenv.helpers.sh
  > vimdiff dev_scripts_sports_analytics/thin_client/setenv.sports_analytics.sh helpers_root/dev_scripts/thin_client/templates/setenv.template.sh
  ```

## Tmux links

- Create the global link
  ```bash
  > dev_scripts_sports_analytics/thin_client/tmux.sports_analytics.py --create_global_link
  ```

- Create the tmux session
  ```bash
  > dev_scripts_sports_analytics/thin_client/tmux.sports_analytics.py --index 1 --force_restart
  ```

## Create files

- Some files need to be copied from `helpers` to the root of the super-repo
  - `changelog.txt`: this is copied from the repo that builds the used container or
    started from scratch for a new container
  - `conftest.py`: configure `pytest`
  - `invoke.yaml`: configure `invoke`
  - `pytest.ini`: configure `pytest` preferences
  - `repo_config.py`: stores information about this specific repo (e.g., name, used
    container)
    - This needs to be modified
  - `tasks.py`: the `invoke` tasks available in this container
    - This needs to be modified
  - TODO(gp): Some should be links to `helpers`

## Build a container for a super-repo

- Copy the `devops` template dir
  ```bash
  > (cd helpers_root; git pull)
  > cp -r helpers_root/devops/templates/devops_with_build_stage devops
  ```
- If we don't need to build a container, but just reuse one we can delete
  the corresponding directory
  ```bash
  > rm -rf devops/docker_build
  ```
