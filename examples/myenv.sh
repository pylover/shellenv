# shellenv example.
# Usage:
#   source myenv.sh
#
# Use it locally
HERE=`dirname "$(readlink -f "$BASH_SOURCE")"`
source ${HERE}/../shellenv.sh

# Or global
# source /usr/local/lib/shellenv.sh


shellenv_init myenv $BASH_SOURCE
shellenv_set FOO baz


shellenv_before_deactivate() {
  echo "Deactivating ${ENV_TITLE}"
}


shellenv_after_deactivate() {
  echo "Virtual environment ${ENV_TITLE} has been deactivated successfully."
}
