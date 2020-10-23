#!/usr/bin/env bash
# Must be run as sudo
[ `whoami` = root ] || { sudo "$0" "$@"; exit $?; }
DEPLOY="${DEPLOY:-/deploy}"
SCRIPTS_PATH="docs/appliance/scripts"
COMPOSE_PATH="docs/appliance/compose"
CONTAINER_PATH="docs/appliance/containers"
VARS_PATH=${VARS_PATH:-env}

# Set the environment variables
source ${DEPLOY}/${SCRIPTS_PATH}/vars.sh

# Array of all available stacks
all_stacks=('utilities' 'logging' 'alloy' 'caster' 'identity' 'player' 'steamfitter' 'traefik' 'vm' 'vm-console')

# Set the stacks
if [[ $# -gt 0 ]]; then
  STACKS=$@
else
  STACKS=${all_stacks[@]}
fi

echo "Deploying the following stacks ${STACKS[@]}"

##### FUNCTIONS ####"#
deploy(){
  s=${1}
  temp=/tmp/${s}
  
  echo "Deploying $s"
  docker stack deploy -c ${temp}/${s}-stack.yml ${s}_stack
  # rm -rf $temp
}

replace_configs(){
  s=${1}
  temp=/tmp/${s}
  regex=${2:-'.*\.(json|gitconfig)'}
  
  mkdir -p $temp
  # Copy files to tmp
  if [[ -d ${DEPLOY}/${COMPOSE_PATH}/${s} ]]; then
    echo "Prefer Compose Path, copying ${DEPLOY}/${COMPOSE_PATH}/${s} to ${temp}"
    cp -r ${DEPLOY}/${COMPOSE_PATH}/${s}/. ${temp}
  else 
    cp -r ${DEPLOY}/${s}/. ${temp}
  fi

  if [[ -d $temp ]]; then
    echo "Finding ${regex} files in ${dir}"
    # Get JSON files
    files=$(find ${temp} -type f -regextype posix-extended -regex ${regex})
    echo "Editing $files"
    for f in $files; do
      tf=${f}.tmp
      cp $f $tf
      # Replace Environment Variables
      cat $f | envsubst | tee $tf && mv -f $tf $f
    done
    echo $files
  fi
  if [[ ${ENABLE_SSL} == 'false' ]]; then
    source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh "https:\/\/" "http:\/\/" $temp
  else
    if [[ ${APPLIANCE_DEV} == 'false' ]]; then
      source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh "http:\/\/" "https:\/\/" $temp
    fi
  fi
}

##### END FUNCTIONS #####

##### SCRIPT #####
for s in ${STACKS[@]} ; do
  # traefik needs to know if SSL  
  if [[ ${s} == 'traefik' ]]; then 
    if [[ ${ENABLE_SSL} == "true" ]]; then 
      docker stack deploy -c "${DEPLOY}/${s}/${s}-stack-ssl.yml" ${s}_stack
    else
      docker stack deploy -c "${DEPLOY}/${s}/${s}-stack.yml" ${s}_stack
    fi
  elif [[ ${s} == 'steamfitter' ]]; then 
    # Do special steamfitter actions
    
    echo "Substituting environment variables for ${s}"
    replace_configs ${s} '.*\.(json|gitconfig|yaml|env)'
    # Reverse https in nginx configs
    if [[ ${ENABLE_SSL} == 'true' ]]; then
      source ${DEPLOY}/${SCRIPTS_PATH}/replace.sh "https:\/\/" "http:\/\/" "/tmp/${s}/st2.conf"
    fi
    #Copy runtime configs
    cp -r /tmp/${s}/runtime/. ${NFS_BASE_PATH}stackstorm/runtime
    cp -r /tmp/${s}/pack-configs/actions/. ${NFS_BASE_PATH}stackstorm/packs/vsphere/actions
    echo "deploying ${s}"
    if [[ ! -d ${NFS_BASE_PATH}stackstorm/packs/vsphere ]]; then 
      echo "vsphere pack not installed running first"
      deploy ${s}
      sleep 60
      soff ${s}
      sleep 20
      cp -r /tmp/${s}/pack-configs/actions/. ${NFS_BASE_PATH}stackstorm/packs/vsphere/actions
      deploy ${s}
    else
      deploy ${s}
    fi
  else
    # Deploy Stack
    echo "Substituting environment variables for ${s}"
    replace_configs ${s}
    echo "Deploying ${s}"
    deploy ${s}
  fi
done