# Ben's .bash_profile
#
# .bash_profile is invoked in preference to .profile by interactive
# login shells, and by non-interactive shells with the --login option.

# Allow disabling of all meddling with the environment
[ -n "$INHERIT_ENV" ] && return 0

if [ -f ~/.bashrc ]; then
  # Get the normal interactive stuff from .bashrc
  . ~/.bashrc
fi

. $ZDOT_RUN_HOOKS .bash_profile.d

