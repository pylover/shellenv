SHELLENV_VERSION=1.1.0


function _fn_exists() { 
  declare -F "$1" > /dev/null; 
}


function _append {
  local -n _arr=$1
  local _var=${2}
  
  eval "_arr+=(${_var})"
}


function _array {
  local -n _value=$2
  local _name=${1}[@]
  _value=${!_name}
}


function shellenv_set {
	local name=$1
  local oldvalue=${!name}
	local value=$2

  if [ ${name} = "ENV_PREFIX" ]; then
    ENV_PREFIX=${value}
  fi

  if [ ! -z "${oldvalue}" ]; then 
	  declare -g "${ENV_PREFIX}_BACKUP_${name}=${oldvalue}"
  fi
	declare -g "${name}=$value"
  export ${name}
  _append ${ENV_PREFIX}_VARS ${name} 
}


function _unset {
	local backupname
  local name
  local vars
  local prefix=${ENV_PREFIX}
  _array ${prefix}_VARS vars

  for i in ${vars[@]}; do
    backupname=${prefix}_BACKUP_${i}
    if [ -z "${!backupname}" ]; then 
      unset "${i}"
    else
      declare -g "${i}=${!backupname}"
      export ${i}
    fi
    unset "${backupname}"
  done

  unset "${prefix}_VARS"
}


function _deactivate() {

  _fn_exists "shellenv_before_deactivate" && shellenv_before_deactivate

  local devar="${ENV_PREFIX}_backup_deactivate"
  if [ ! -z "${!devar}" ]; then 
    eval "${!devar}"
  else
    unset -f deactivate
  fi
  unset "${ENV_PREFIX}_backup_deactivate"
  _unset 


  _fn_exists "shellenv_after_deactivate" && shellenv_after_deactivate
}


function shellenv_init() {
  local title=$1
  local prefix=${title//-/_}

  if [ "$0" = "$2" ]; then
  	>&2 echo "Can not run this script, try to source it"
  	exit 1
  fi

  if [ "${ENV_PREFIX}" = "${prefix}" ]; then
    >&2 echo "Already inside ${prefix} environment"
    return 1
  fi

  eval "${prefix}_VARS=()"

  shellenv_set ENV_PREFIX ${prefix}
  shellenv_set ENV_TITLE ${title}
  shellenv_set PS1 "($title) $PS1"

  _fn_exists "deactivate" && \
    declare -g "${prefix}_backup_deactivate=$(declare -pf deactivate)"

  eval "$(echo "deactivate()"; declare -f _deactivate | tail -n +2)"
  export -f deactivate
}
