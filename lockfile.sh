#!/bin/bash -

# $Id: lockfile.sh,v 1.6 2015/12/13 20:41:31 swilson Exp $

#####
# lockfile - functions for lockfile handling
#####

source msg-handling.sh
source user-check.sh

#####
# lockfile <filename>
# Atomically create a lockfile
#####
lockfile()
{
  debug 6 "lockfile [$@]"
  if [[ -z "$1" ]] ; then
    die 2 "No lockfile info defined\n"
  fi
  declare lockfile="$1"
  declare pid

  # Sanity checks
  not_world_write "$lockfile"
  can_write "$lockfile"

  # Check the pid of an old lockfile
  if [[ -f "$lockfile" ]] ; then
    debug 5 "[$lockfile] exists"
    pid=$(< $lockfile)
    if [[ $pid == *[!0-9]* ]]; then
      die 2 "Pid is not a number [$pid]\n"
    fi
    debug 4 "Prior pid [$pid]"
    if kill -0 $pid >/dev/null 2>&1 ; then
      die 2 "Lockfile [$lockfile] exists with pid [$pid]\n"
    else
      # Orphaned
      rm -f "$lockfile"
      debug 2 "Removed stale lock file [$lockfile]"
    fi
  fi

  # Write pid to a temp lockfile
  echo -n "$$" >"$lockfile.$$" 

  # Avoid race - ln will fail if the file is there and create the file if
  # it isn't - should be consistent on any posix filesystem
  if ln "$lockfile.$$" "$lockfile" ; then
    debug 5 "Lock obtained"
    rm -f "$lockfile.$$"
    trap "cleanup 0 $lockfile" EXIT
  else
    rm -f "$lockfile.$$"
    die 2 "Lockfile [$lockfile] exists\n"
  fi

  trap "cleanup 3 $lockfile" 1 2 15
}

#####
# cleanup <status> <file0, file1, file2...>
# Remove a list of files
#####
cleanup()
{
  debug 6 "cleanup [$@]"
  status="$1"
  shift
  for file ; do
    if [[ -f "$file" ]] ; then
      debug 5 "Removing [$file]"
      rm -f "$file"
    else
      warn "Cleanup file does not exist [$file]"
    fi
  done
  die "$status" "Done cleanup\n"
}

