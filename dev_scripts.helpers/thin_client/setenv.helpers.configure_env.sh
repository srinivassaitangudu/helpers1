#
# Configure environment specific to this project.
#

echo "# Configure env"

# AWS profiles which are propagated to Docker.
export CK_AWS_PROFILE="ck"

# These variables are propagated to Docker.
export CK_ECR_BASE_PATH="623860924167.dkr.ecr.eu-north-1.amazonaws.com"
export CK_AWS_S3_BUCKET="cryptokaizen-data"

export DEV1="172.30.2.136"
export DEV2="172.30.2.128"

# Print some specific env vars.
printenv | egrep "AM_|CK|AWS_" | sort

# Set up custom path to the alembic.ini file.
# See https://alembic.sqlalchemy.org/en/latest/tutorial.html#editing-the-ini-file
export ALEMBIC_CONFIG="alembic/alembic.ini"

alias i="invoke"
alias it="invoke traceback"
alias itpb="pbpaste | traceback_to_cfile.py -i - -o cfile"
alias ih="invoke --help"
alias il="invoke --list"

# Print the aliases.
alias

# Add autocomplete for `invoke`.
#source $AMP/dev_scripts/invoke_completion.sh
