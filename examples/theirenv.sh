# shellenv example.
# Usage:
#   source theirenv.sh
#
HERE=`dirname "$(readlink -f "$BASH_SOURCE")"`
source ${HERE}/../shellenv.sh


shellenv_init theirenv $BASH_SOURCE
shellenv_set FOO bar
