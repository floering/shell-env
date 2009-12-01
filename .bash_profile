# Ben's .bash_profile
#
# $Id: .bash_profile,v 1.16 2006-03-13 10:57:52 adam Exp $

# .bash_profile is invoked in preference to .profile by interactive
# login shells, and by non-interactive shells with the --login option.

# Allow disabling of all meddling with the environment
[ -n "$INHERIT_ENV" ] && return 0

if [ -f ~/.bashrc ]; then
  # Get the normal interactive stuff from .bashrc
  . ~/.bashrc
fi

. $ZDOT_RUN_HOOKS .bash_profile.d

