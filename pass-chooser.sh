#!/bin/bash -

# $Id: pass-chooser.sh,v 1.4 2015/12/12 17:41:56 swilson Exp $

#####
# choose-pass - determine which program to use to return a passphras
#####

source msg-handling.sh

#####
# passprog
# returns getpass variable
# if GETPASS is set to a valid password manager, tries to use it
#####
passprog()
{
  declare -g getpass
  # http://www.passwordstore.org/
  if type pass >/dev/null 2>&1 &&
    [[ ! -v GETPASS || $GETPASS == "pass" ]] ; 
  then
    getpass="pass"
    debug 2 "Using pass"
  # http://korelogic.com/Resources/Tools/whatpass
  elif type whatpass >/dev/null 2>&1 &&
    [[ ! -v GETPASS || $GETPASS == "whatpass" ]] ; 
  then
    getpass="whatpass"
    debug 2 "Using whatpass"
  # https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/security.1.html
  elif type security >/dev/null 2>&1 &&
    [[ ! -v GETPASS || $GETPASS == "security" ]] ;
  then
    getpass="security"
    debug 2 "Using security"
  # https://www.gnupg.org/
  elif type gpg >/dev/null 2>&1 &&
    [[ ! -v GETPASS || $GETPASS == "gpg" ]] ;
  then
    getpass="gpg"
    debug 2 "Using gpg"
  else
    die "No pass or whatpass."
  fi
}
