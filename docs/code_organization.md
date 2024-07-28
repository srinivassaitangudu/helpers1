.semgrepignore
LICENSE
invoke.yaml
conftest.py


# 
dev_scripts.helpers/go_helpers.sh

go_helpers.sh
setenv.helpers.configure_env.sh
setenv.helpers.sh
tmux.helpers.sh


```bash
> DIR_NAME="helpers"
> ln -sf $(pwd)/dev_scripts.${DIR_NAME}/go_${DIR_NAME}.sh ~/go_${DIRNAME}.sh
```

E.g.,
```
> ln -sf /Users/saggese/src/helpers1/dev_scripts.helpers/go_helpers.sh ~/go_helpers.sh
```
