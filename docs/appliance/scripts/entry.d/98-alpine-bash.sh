#!/usr/bin/env sh
# Force sudo, shouldn't be needed in docker containers. But keeping as a failsafe. 
[ `whoami` = root ] || { sudo "$0" "$@"; exit $?; }

# Check for bash 
  BASH=$(which bash)
  if [[ -z ${BASH} ]]; then
    # Check distro
    if [[ -f /etc/os-release ]]; then
      . /etc/os-release
      DISTRO=$ID
      # Install from distro package manager
      case ${DISTRO,,} in
        alpine)
        echo "installing bash for ${DISTRO}"
        apk add bash
      esac
    else
      echo "'bash' not found and OS detection failed, bash is required"
      exit 0
    fi
  else 
    echo "'bash' exists skipping installation"
  fi