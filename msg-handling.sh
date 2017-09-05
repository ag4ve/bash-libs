#!/bin/bash

# $Id: msg-handling.sh,v 1.14 2015/12/12 17:41:56 swilson Exp $

#####
# msg-handling - contains functions to handle messages.
#####

#####
# die [status] "<message>\n"
#####
die()
{
  if [[ "${1#[-+]}" == [0-9]* ]] ; then
    status="$1"
    shift
  else
    status=1
  fi
  echo -ne "$@" >&2
  exit "$status"
}

#####
# warn <message>
#####
warn()
{
  echo -ne "WARN: $@\n" >&2
}

#####
# debug <level> "<message>"
# print a message for levels up to and including the absolute debug value or
# print message that match the debug levels if =<debug> values is used
# writes to $debug_file if it is set
#####
debug()
{
  : "${debug:=0}"
  declare level
  if [[ "${1#[+-]}" == [0-9]* ]] ; then
    level="${1#[+-]}"
    shift
  fi
  local output="$@"

  # Define a proper output function
  if ! declare -f _debug_out >/dev/null 2>&1 ; then
    if [[ -n "${debug_file:-}" ]] ; then
      _debug_out()
      {
        echo -ne "$@\n" >> "${debug_file:-}"
      }
    else
      _debug_out()
      {
        warn "DEBUG $@"
      }
    fi
  fi
  
  if [[ -n "${level:-}" ]] ; then
    # Pin to a debug level
    if [[ "$debug" == "="* && "${debug#=}" == "$level" ]] ; then
      _debug_out "[$level]: $output"
    # Less than or equal to level
    elif [[ "$debug" != "="* ]] && (( level <= debug )) ; then
      _debug_out "[$level]: $output"
    fi
  # Script didn't set a debug level
  elif (( debug != 0 )) ; then
    _debug_out "[nul]: $output"
  fi
}

