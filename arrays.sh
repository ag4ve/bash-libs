#!/bin/bash -

# $Id: arrays.sh,v 1.4 2015/12/12 17:41:56 swilson Exp $

#####
# arrays - functions for handling arrays
#####

source msg-handling.sh

#####
# join <string> <array>
#####
join()
{
  local IFS="$1"
  shift
  debug 7 "join [$1] out [$*]"
  echo "$*"
}

#####
# inarray <string> <array>
# Check if any element of an array is the search string
#####
inarray() 
{
  local n=$1 h
  shift
  for h ; do 
    if [[ $n = "$h" ]] ; then
      return 0
    fi
  done
  return 1
}
