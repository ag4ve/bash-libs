#!/bin/bash

#####
# os-info - returns basic os info
# * NOTE: this may run any code in /etc/*-{version,release} and pollute
# your veriable namespace
#####

#####
# os_ver - returns (amont other possible clutter) $OS and $VER
#####

os_ver()
{
  if [[ -f /etc/os-release ]];then
    # freedesktop.org and systemd
    . /etc/os-release
    OS="$NAME"
    VER="$VERSION_ID"
  elif type lsb_release >/dev/null; then
    # linuxbase.org
    OS="$(lsb_release -si)"
    VER="$(lsb_release -sr)"
  elif [[ -f /etc/lsb-release ]]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS="$DISTRIB_ID"
    VER="$DISTRIB_RELEASE"
  elif [[ -f /etc/debian_version ]]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(< /etc/debian_version)
# TODO
#  elif [ -f /etc/SuSe-release ]; then
#  elif [ -f /etc/redhat-release ]; then
  else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS="$(uname -s)"
    VER="$(uname -r)"
  fi
}

