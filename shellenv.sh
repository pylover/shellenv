
# TODO: gaurd for run directly
# TODO: backup deactivate


TITLE="foo"
eval "${TITLE}_VARS=()"


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


function _set {
	local name=$1
  local oldvalue=${!name}
	local value=$2

  if [ ! -z "${oldvalue}" ]; then 
	  declare -g "${TITLE}_BACKUP_${name}=${oldvalue}"
  fi
	declare -g "${name}=$value"
  _append ${TITLE}_VARS ${name} 
  # eval "${TITLE}_VARS+=(${name})"
}


function _unset {
	local backupname
  local name
  local vars
  local title=${ENV_TITLE}
  _array ${title}_VARS vars

  for i in ${vars[@]}; do
    backupname=${title}_BACKUP_${i}
    echo "disposing: ${i} backup: ${!backupname}"
    if [ -z "${!backupname}" ]; then 
      unset "${i}"
    else
      declare -g "${i}=${!backupname}"
    fi
    unset "${backupname}"
  done
}


function _deactivate {
  _unset 
  unset -f deactivate
}
