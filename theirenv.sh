# shellenv example.
# Usage:
#   source theirenv.sh
#
source shellenv.sh


shellenv_init theirenv $BASH_SOURCE
shellenv_set FOO bar
