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

  if [ ${name} = "ENV_TITLE" ]; then
    ENV_TITLE=${value}
  fi

  if [ ! -z "${oldvalue}" ]; then 
	  declare -g "${ENV_TITLE}_BACKUP_${name}=${oldvalue}"
  fi
	declare -g "${name}=$value"
  _append ${ENV_TITLE}_VARS ${name} 
}


function _unset {
	local backupname
  local name
  local vars
  local title=${ENV_TITLE}
  _array ${title}_VARS vars

  for i in ${vars[@]}; do
    backupname=${title}_BACKUP_${i}
    if [ -z "${!backupname}" ]; then 
      unset "${i}"
    else
      declare -g "${i}=${!backupname}"
    fi
    unset "${backupname}"
  done

  unset "${title}_VARS"
}


function _deactivate() {
  local devar="${ENV_TITLE}_backup_deactivate"
  if [ ! -z "${!devar}" ]; then 
    eval "${!devar}"
  else
    unset -f deactivate
  fi
  unset "${ENV_TITLE}_backup_deactivate"
  _unset 
}


function shellenv_init() {
  local title=$1

  if [ "$0" = "$2" ]; then
  	>&2 echo "Can not run this script, try to source it"
  	exit 1
  fi

  if [ "${ENV_TITLE}" = "${title}" ]; then
    >&2 echo "Already inside ${title} environment"
    return 1
  fi

  eval "${title}_VARS=()"

  shellenv_set ENV_TITLE ${title}
  shellenv_set PS1 "($ENV_TITLE) $PS1"

  _fn_exists "deactivate" && \
    declare -g "${title}_backup_deactivate=$(declare -pf deactivate)"

  eval "$(echo "deactivate()"; declare -f _deactivate | tail -n +2)"
  export -f deactivate
}
