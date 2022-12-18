# shellenv example.
# Usage:
#   source myenv.sh
#
HERE=`dirname "$(readlink -f "$BASH_SOURCE")"`
source ${HERE}/../shellenv.sh


shellenv_init myenv $BASH_SOURCE
shellenv_set FOO baz
