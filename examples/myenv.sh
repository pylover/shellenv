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
