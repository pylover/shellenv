# shellenv example.
# Usage:
#   source myenv.sh
#
source shellenv.sh


shellenv_init myenv $BASH_SOURCE
shellenv_set FOO baz
