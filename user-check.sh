#!/bin/bash

# $Id: user-check.sh,v 1.6 2015/12/13 20:37:29 swilson Exp $

#####
# user-check - determine user access
#####

source msg-handling.sh

#####
# is_root - die if a user does not have root access
#####
is_root()
{
  if [[ ! -w / || "$EUID" != 0 ]]; then 
    die "Please run $0 as root." 
  fi
}

#####
# not_world_write <string>
# Die if the directory is world-writable
#####
not_world_write()
{
  local dir="${1%/*}"

  local mode=$(stat -L -c "%04a" "$dir")
  if (( $mode & 0002 != 0 )) ; then
    die "Refusing to use world-writable directory [$dir]"
  fi
}

#####
# can_write <string>
# Die if the directory can not be written to
#####
can_write()
{
  local dir="${1%/*}"

  if [[ ! -w "$dir" ]] ; then
    die "Cannot write to directory [$dir]"
  fi
}

