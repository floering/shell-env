#!/bin/zsh
#
# $Id: .zshrc,v 1.314 2007/02/14 12:21:58 floering Exp $
#
# Ben's uber-zshrc, mostly derived from Adam Spiers' setup, modified
# from my old (early 90s) IBM setup for AMD.  NOTE: if you want to have the 
# crazy-cool color prompt randomizer you must use a supported font for
# the "fade" and "fire" prompts to work correctly.
# See zsh/prompts in my home directory.  I recommend the fkp font but 
# the vga11x19 font is larger for those who like large fonts.  You might 
# want to check out my .Eterm directory for an example terminal setup.

# to get the nice fonts run the alias "nicefonts" and restart your terminal
# window with the "fkp" (my favorite) or other fonts in /home/floering/X_fonts
# (This dir is replicated to all sites I have access to: SVDC, BDC, LSDC (Austin), MHDC)

[ -n "$INHERIT_ENV" ] && return 0

sh_load_status .zshrc

# {{{ What version are we running?

if ! (( $+ZSH_VERSION_TYPE )); then
  if [[ $ZSH_VERSION == 3.0.<->* ]]; then ZSH_STABLE_VERSION=yes; fi
  if [[ $ZSH_VERSION == 3.1.<->* ]]; then ZSH_DEVEL_VERSION=yes;  fi

  ZSH_VERSION_TYPE=old
  if [[ $ZSH_VERSION == 3.1.<6->* ||
        $ZSH_VERSION == 3.<2->.<->*  ||
        $ZSH_VERSION == 4.<->* ]]
  then
    ZSH_VERSION_TYPE=new
  fi
fi

# }}}
# {{{ Profiling

[[ -n "$ZSH_PROFILE_RC" ]] && which zmodload >&/dev/null && zmodload zsh/zprof

# }}}

# {{{ Options

sh_load_status 'setting options'

setopt                       \
     NO_all_export           \
        always_last_prompt   \
     NO_always_to_end        \
        append_history       \
        auto_cd              \
        auto_list            \
        auto_menu            \
     NO_auto_name_dirs       \
        auto_param_keys      \
        auto_param_slash     \
        auto_pushd           \
        auto_remove_slash    \
     NO_auto_resume          \
        bad_pattern          \
        bang_hist            \
     NO_beep                 \
     NO_brace_ccl            \
        correct_all          \
     NO_bsd_echo             \
     NO_cdable_vars          \
     NO_chase_links          \
     NO_clobber              \
        complete_aliases     \
        complete_in_word     \
     NO_correct              \
        correct_all          \
        csh_junkie_history   \
     NO_csh_junkie_loops     \
     NO_csh_junkie_quotes    \
     NO_csh_null_glob        \
        equals               \
        extended_glob        \
        extended_history     \
        function_argzero     \
        glob                 \
     NO_glob_assign          \
        glob_complete        \
     NO_glob_dots            \
        glob_subst           \
        hash_cmds            \
        hash_dirs            \
        hash_list_all        \
        hist_allow_clobber   \
        hist_beep            \
        hist_expire_dups_first \
        hist_ignore_dups     \
        hist_ignore_space    \
     NO_hist_no_store        \
        hist_verify          \
     NO_hup                  \
     NO_ignore_braces        \
     NO_ignore_eof           \
        interactive_comments \
     NO_ksh_glob             \
     NO_list_ambiguous       \
     NO_list_beep            \
        list_types           \
        long_list_jobs       \
        magic_equal_subst    \
     NO_mail_warning         \
     NO_mark_dirs            \
     NO_menu_complete        \
        multios              \
        nomatch              \
        notify               \
     NO_null_glob            \
        numeric_glob_sort    \
     NO_overstrike           \
        path_dirs            \
        posix_builtins       \
     NO_print_exit_value     \
     NO_prompt_cr            \
        prompt_subst         \
        pushd_ignore_dups    \
     NO_pushd_minus          \
        pushd_silent         \
        pushd_to_home        \
        rc_expand_param      \
     NO_rc_quotes            \
     NO_rm_star_silent       \
     NO_sh_file_expansion    \
        sh_option_letters    \
        short_loops          \
        sh_word_split        \
     NO_single_line_zle      \
     NO_sun_keyboard_hack    \
        unset                \
     NO_verbose              \
        zle

if [[ $ZSH_VERSION_TYPE == 'new' ]]; then
  setopt                       \
        hist_expire_dups_first \
        hist_ignore_all_dups   \
     NO_hist_no_functions      \
     NO_hist_save_no_dups      \
        inc_append_history     \
        list_packed            \
     NO_rm_star_wait
fi

if [[ $ZSH_VERSION == 3.0.<6->* || $ZSH_VERSION_TYPE == 'new' ]]; then
  setopt \
        hist_reduce_blanks
fi

# }}}
# {{{ Environment

sh_load_status 'setting environment'

# {{{ INFOPATH

[[ "$ZSH_VERSION_TYPE" == 'old' ]] || typeset -T INFOPATH infopath
typeset -U infopath # no duplicates
export INFOPATH
infopath=( 
          ~/local/$OSTYPE/{share/,}info(N)
          ~/{local/,}{share/,}info(N)
          /usr/{local/,}{share/,}info(N)
          $infopath
         )

# }}}
# {{{ MANPATH

case "$OSTYPE" in
  linux*)
    # Don't need to do anything through the cunningness
    # of AUTOPATH in /etc/man.config!
    ;;

  *)
    # Don't trust system-wide MANPATH?  Remember what it was, for reference.
    sysmanpath=$HOME/.sysmanpath.$HOST
    [ -e $sysmanpath ] || echo "$MANPATH" > $sysmanpath
    manpath=( )

    # ... or *do* trust system-wide MANPATH
    #MANPATH=/usr/local/bin:/usr/X11R6/bin:/usr/local/sbin:/usr/sbin:/sbin:$MANPATH

    for dir in "$path[@]"; do
      [[ "$dir" == */bin ]] || continue
      mandir="${dir//\/bin//man}"
      [[ -d "$mandir" ]] && manpath=( "$mandir" "$manpath[@]" )
    done

    ;;
esac

# }}}
# {{{ LANG

# Eterm sucks
if [[ "$LANG" == *UTF-8 ]] && grep Eterm /proc/$PPID/cmdline >&/dev/null; then
    LANG="${LANG%.UTF-8}"
fi

# }}}

# Variables used by zsh

# {{{ Choose word delimiter characters in line editor

WORDCHARS=''

# }}}
# {{{ Save a large history

HISTFILE=~/.zshhistory
HISTSIZE=20000
SAVEHIST=20000

# }}}
# {{{ Maximum size of completion listing

#LISTMAX=0    # Only ask if line would scroll off screen
LISTMAX=1000  # "Never" ask

# }}}
# {{{ Watching for other users

LOGCHECK=60
WATCHFMT="[%B%t%b] %B%n%b has %a %B%l%b from %B%M%b"

# }}}
# {{{ Auto logout

TMOUT=1800
#TRAPALRM () {
#  clear
#  echo Inactivity timeout on $TTY
#  echo
#  vlock -c
#  echo
#  echo Terminal unlocked. [ Press Enter ]
#}

# }}}

# }}}

# {{{ Completions

sh_load_status 'completion system'

# {{{ Set up new advanced completion system

if [[ "$ZSH_VERSION_TYPE" == 'new' ]]; then
  autoload -U compinit
  compinit -u # use with care!!
else
  print "\nAdvanced completion system not found; ignoring zstyle settings."
  function zstyle { }
  function compdef { }

  # an antiquated, barebones completion system is better than nowt
  which zmodload >&/dev/null && zmodload zsh/compctl
fi

# }}}
# {{{ General completion technique

# zstyle ':completion:*' completer \
#   _complete _prefix _approximate:-one _ignored \
#   _complete:-extended _approximate:-four
zstyle ':completion:*' completer _complete _prefix _ignored _complete:-extended

zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete

zstyle ':completion:*:approximate-one:*'  max-errors 1
zstyle ':completion:*:approximate-four:*' max-errors 4

# e.g. f-1.j<TAB> would complete to foo-123.jpeg
zstyle ':completion:*:complete-extended:*' \
  matcher 'r:|[.,_-]=* r:|=*'

# }}}
# {{{ Fancy menu selection when there's ambiguity

#zstyle ':completion:*' menu yes select interactive
#zstyle ':completion:*' menu yes=long select=long interactive
#zstyle ':completion:*' menu yes=10 select=10 interactive

# }}}
# {{{ Completion caching

zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

# }}}
# {{{ Expand partial paths

# e.g. /u/s/l/D/fs<TAB> would complete to
#      /usr/src/linux/Documentation/fs
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

# }}}
# {{{ Include non-hidden dirs in globbed file completions for certain commands

#zstyle ':completion::complete:*' \
#  tag-order 'globbed-files directories' all-files 
#zstyle ':completion::complete:*:tar:directories' file-patterns '*~.*(-/)'

# }}}
# {{{ Don't complete backup files (e.g. 'bin/foo~') as executables

zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# }}}
# {{{ Don't complete uninteresting users

zstyle ':completion:*:*:*:users' ignored-patterns \
        adm apache bin daemon games gdm halt ident junkbust lp mail mailnull \
        named news nfsnobody nobody nscd ntp operator pcap postgres radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs

# ... unless we really want to.
zstyle '*' single-ignored show

# }}}
# {{{ Output formatting

# Separate matches into groups
zstyle ':completion:*:matches' group 'yes'

# Describe each match group.
zstyle ':completion:*:descriptions' format "%B---- %d%b"

# Messages/warnings format
zstyle ':completion:*:messages' format '%B%U---- %d%u%b' 
zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b'
 
# Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

# }}}
# {{{ Array/association subscripts

# When completing inside array or association subscripts, the array
# elements are more useful than parameters so complete them first:
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters 

# }}}
# {{{ Completion for processes

zstyle ':completion:*:*:*:*:processes' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always

# }}}
# {{{ Simulate my old dabbrev-expand 3.0.5 patch 

zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# }}}
# {{{ Usernames

run_hooks .zsh/users.d
zstyle ':completion:*' users $zsh_users

## }}}
## {{{ Adam's Hostname completion
#
#if [[ "$ZSH_VERSION_TYPE" == 'new' ]]; then
#  # Extract hosts from /etc/hosts
#  : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}}
## _ssh_known_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*})
#else
#  # Older versions don't like the above cruft
#  _etc_hosts=()
#fi
#
#zsh_hosts=(
#    "$_etc_hosts[@]"
#    localhost
#)
#
#run_hooks .zsh/hosts.d
#zstyle ':completion:*' hosts $zs
#
## My first hack at hostname completion
#local knownhosts
#knownhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
#zstyle ':completion:*:(ssh|scp|sftp):*' hosts $knownhostsh_hosts
#
# this is for enabling of hostname completion on ssh known_hosts
# that is apparently not enabled in zsh by default (for shame) but comes
# for free in bash_completion

test ! -d "$HOME/.ssh" && mkdir "$HOME/.ssh"
test ! -f "$HOME/.ssh/known_hosts" && touch "$HOME/.ssh/known_hosts"
test ! -f "$HOME/.ssh/config" && touch "$HOME/.ssh/config"

zstyle ':completion:*:(scp|rsync):*' tag-order \
        'hosts:-host hosts:-domain:domain hosts:-ipaddr:IP\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order \
        users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
        users 'hosts:-host hosts:-domain:domain hosts:-ipaddr:IP\ address *'
zstyle ':completion:*:ssh:*' group-order \
        hosts-domain hosts-host users hosts-ipaddr

zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns \
        '*.*' loopback localhost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns \
        '<->.<->.<->.<->' '^*.*' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns \
        '^<->.<->.<->.<->' '127.0.0.<->'
zstyle ':completion:*:(ssh|scp|rsync):*:users' ignored-patterns \
        adm bin daemon halt lp named shutdown sync

zstyle -e ':completion:*:(ssh|scp|ping|host|nmap|rsync):*' hosts 'reply=(
        ${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) \
                        /dev/null)"}%%[#| ]*}//,/ }
        ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
        ${=${${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}}
        )'

#
# better kill completion:
#

# kill
#zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=$color[cyan]=$color[red]"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:kill:*' insert-ids single
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:processes' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# }}}
# {{{ (user, host) account pairs

run_hooks .zsh/accounts.d
zstyle ':completion:*:my-accounts'    users-hosts "$my_accounts[@]"
zstyle ':completion:*:other-accounts' users-hosts "$other_accounts[@]"

# }}}

# {{{ pdf

compdef _pdf pdf

# }}}

# {{{ Aliases and functions

sh_load_status 'aliases and functions'

# {{{ Motion/editing

# {{{ Better word navigation

# Remember, WORDCHARS is defined as a 'list of non-alphanumeric
# characters considered part of a word by the line editor'.

# Elsewhere we set it to the empty string.

_my_extended_wordchars='*?_-.[]~=&;!#$%^(){}<>:@,\\'
_my_extended_wordchars_space="${_my_extended_wordchars} "
_my_extended_wordchars_slash="${_my_extended_wordchars}/"

# is the current position \-quoted ?
is_backslash_quoted () {
    test "${BUFFER[$CURSOR-1,CURSOR-1]}" = "\\"
}

unquote-forward-word () {
    while is_backslash_quoted
      do zle .forward-word
    done
}

unquote-backward-word () {
    while is_backslash_quoted
      do zle .backward-word
    done
}

backward-to-space () {
    local WORDCHARS="${_my_extended_wordchars_slash}"
    zle .backward-word
    unquote-backward-word
}

forward-to-space () {
     local WORDCHARS="${_my_extended_wordchars_slash}"
     zle .forward-word
     unquote-forward-word
}

backward-to-/ () {
    local WORDCHARS="${_my_extended_wordchars}"
    zle .backward-word
    unquote-backward-word
}

forward-to-/ () {
     local WORDCHARS="${_my_extended_wordchars}"
     zle .forward-word
     unquote-forward-word
}

# Create new user-defined widgets pointing to eponymous functions.
zle -N backward-to-space
zle -N forward-to-space
zle -N backward-to-/
zle -N forward-to-/

# }}}
# {{{ kill-region-or-backward-(big-)word

# autoloaded
zle -N kill-region-or-backward-word
zle -N kill-region-or-backward-big-word

# }}}
# {{{ kill-big-word

kill-big-word () {
    local WORDCHARS="${_my_extended_wordchars_slash}"
    zle .kill-word
}

zle -N kill-big-word

# }}}
# {{{ transpose-big-words

# autoloaded
zle -N transpose-big-words

# }}}
# {{{ magic-forward-char

zle -N magic-forward-char

# }}}
# {{{ magic-forward-word

zle -N magic-forward-word

# }}}
# {{{ incremental-complete-word

# doesn't work?
zle -N incremental-complete-word

# }}}

# }}}
# {{{ zrecompile

autoload zrecompile

# }}}
# {{{ which/where

# reverse unwanted aliasing of `which' by distribution startup
# files (e.g. /etc/profile.d/which*.sh); zsh's 'which' is perfectly
# good as is.

alias which >&/dev/null && unalias which

# }}}
# {{{ run-help

alias run-help >&/dev/null && unalias run-help
autoload run-help

# }}}
# {{{ zcalc

autoload zcalc

# }}}
# {{{ Restarting zsh or bash; reloading .zshrc or functions

bash () {
  NO_SWITCH="yes" command bash "$@"
}

restart () {
  if jobs | grep . >/dev/null; then
    echo "Jobs running; won't restart." >&2
    jobs -l >&2
  else
    exec $SHELL $SHELL_ARGS "$@"
  fi
}
alias rstt=restart

profile () {
  ZSH_PROFILE_RC=1 $SHELL "$@"
}

reload () {
  if [[ "$#*" -eq 0 ]]; then
    . $zdotdir/.zshrc
  else
    local fn
    for fn in "$@"; do
      unfunction $fn
      autoload -U $fn
    done
  fi
}
compdef _functions reload

# }}}
# {{{ ls aliases

# jeez I'm lazy ...
alias l='ls -lh'
alias ll='ls -l'
alias la='ls -lha'
alias lla='ls -la'
alias lsa='ls -ah'
alias lsd='ls -d'
alias lsh='ls -dh .*'
alias lsr='ls -Rh'
alias ld='ls -ldh'
alias lt='ls -lth'
alias llt='ls -lt'
alias lrt='ls -lrth'
alias llrt='ls -lrt'
alias lart='ls -larth'
alias llart='ls -lart'
alias lr='ls -lRh'
alias llr='ls -lR'
alias lsL='ls -L'
alias lL='ls -Ll'
alias lS='ls -lSh'
alias lrS='ls -lrSh'
alias llS='ls -lS'
alias llrS='ls -lrS'
alias sl=ls # often screw this up

# }}}
# {{{ File management/navigation

# {{{ Changing/making/removing directory

alias -g ...=../..
alias -g ....=../../..
alias -g .....=../../../..
alias -g ......=../../../../..
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'
# blegh
alias ..='cd ..'
alias ../..='cd ../..'
alias ../../..='cd ../../..'
alias ../../../..='cd ../../../..'
alias ../../../../..='cd ../../../../..'

alias cd/='cd /'

alias 1='cd -'
alias 2='cd +2'
alias 3='cd +3'
alias 4='cd +4'
alias 5='cd +5'
alias 6='cd +6'
alias 7='cd +7'
alias 8='cd +8'
alias 9='cd +9'

# Sweet trick from zshwiki.org :-)
cd () {
  if (( $# != 1 )); then
    builtin cd "$@"
    return
  fi

  if [[ -f "$1" ]]; then
    builtin cd "$1:h"
  else
    builtin cd "$1"
  fi
}

z () {
  cd ~/"$1"
}

alias md='mkdir -p'
alias rd=rmdir

alias d='dirs -v'

po () {
  popd "$@"
  dirs -v
}

# }}}
# {{{ Renaming

autoload zmv
alias mmv='noglob zmv -W'

# }}}
# {{{ tree

alias tre='tree -C'

# }}}

# }}}
# {{{ Job/process control

alias j='jobs -l'
alias dn=disown

# }}}
# {{{ History

alias h='history 1 | less +G'
alias hh='history'

# }}}
# {{{ Environment

alias ts=typeset
compdef _typeset ts

# }}}
# {{{ Terminal

alias cls='clear'
alias term='echo $TERM'
# {{{ Changing terminal window/icon titles

which cx >&/dev/null || cx () { }

if [[ "$TERM" == ([Ex]term*|screen*) ]]; then
  # Could also look at /proc/$PPID/cmdline ...
  cx
fi

# }}}
alias sc=screen

# }}}
# {{{ Other users

compdef _users lh

alias f='finger -m'
compdef _finger f

# su changes window title, even if we're not a login shell
su () {
  command su "$@"
  cx
}

# So does sux in SUSE
sux () {
  command sux "$@"
  cx
}

# }}}
# {{{ No spelling correction

alias man='nocorrect man'
alias mysql='nocorrect mysql'
alias mysqlshow='nocorrect mysqlshow'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias rj='nocorrect rj'

# }}}
# {{{ X windows related

# {{{ export DISPLAY=:0.0

alias sd='export DISPLAY=:0.0'

# }}}

# }}}
# {{{ Different CVS setups

# Sensible defaults
unset CVS_SERVER
export CVSROOT
export CVS_RSH=ssh

# see scvs function

# }}}
# {{{ MIME handling

autoload zsh-mime-setup
zsh-mime-setup

# }}}
# {{{ Other programs

# {{{ less

alias v=less
alias vs='less -S'

# }}}
# {{{ editors

# emacs, windowed
e () {
  if [[ -n "$OTHER_USER" ]]; then
    emacs -l $ZDOTDIR/.emacs "$@" &!
  else
    dsa
    dga
    emacs "$@" &!
  fi
}

# enable ^Z
alias pico='/usr/bin/pico -z'

#if which vim >&/dev/null; then
#  alias vi=vim
#fi

# }}}
# {{{ remote logins

#ssh () {
#  setopt local_traps
#  trap 'cxx' INT EXIT QUIT KILL
#  dsa
#  # Pick out user@host word from argv; if it's not found, default to $1.
#  # Finally, strip off .* domain component, if any.
#  cx "${${${(M@)argv:#*@*}:-$1}%%.[a-z]*}" 
#  command ssh "$@"
#}

# Best to run this from .zshrc.local
#dsa >&DN || echo "ssh-agent setup failed; run dsa."

# }}}
# {{{ arch

if which larch >&/dev/null; then
  alias a=larch
  compdef _larch a
fi

# }}}
# {{{ bzip2

alias bz=bzip2
alias buz=bunzip2

# }}}

# {{{ Global aliases

# WARNING: global aliases are evil.  Use with caution.

# {{{ For screwed up keyboards missing pipe

#alias -g PIPE='|'

# }}}
# {{{ Paging with less / head / tail

#alias -g L='| less'
#alias -g LS='| less -S'
#alias -g EL='|& less'
#alias -g ELS='|& less -S'
#alias -g TRIM='| cut -c 1-$COLUMNS'

#alias -g H='| head'
#alias -g HL='| head -n $(( +LINES ? LINES - 4 : 20 ))'
#alias -g EH='|& head'
#alias -g EHL='|& head -n $(( +LINES ? LINES - 4 : 20 ))'

#alias -g T='| tail'
#alias -g TL='| tail -n $(( +LINES ? LINES - 4 : 20 ))'
#alias -g ET='|& tail'
#alias -g ETL='|& tail -n $(( +LINES ? LINES - 4 : 20 ))'

# }}}
# {{{ Sorting / counting

alias -g C='| wc -l'

alias -g S='| sort'
alias -g Su='| sort -u'
alias -g Sn='| sort -n'
alias -g Snr='| sort -nr'

# }}}
# {{{ Common filenames

alias -g DN=/dev/null
alias -g DZ=/dev/zero
alias -g VM=/var/log/messages

# }}}
# {{{ grep, xargs

alias -g G='| egrep --color=auto'
alias -g Gi='| egrep --color=auto -i'
alias -g Gl='| egrep --color=auto -l'
alias -g Gv='| egrep --color=auto -v'
alias -g EG='|& egrep --color=auto'
alias -g EGv='|& egrep --color=auto -v'

alias g='egrep --color=auto'
alias gi='egrep --color=auto -i'
alias gr='egrep --color=auto -r'
alias gl='egrep --color=auto -l'
alias gir='egrep --color=auto -ir'
alias gil='egrep --color=auto -il'
alias glr='egrep --color=auto -lr'
alias gilr='egrep --color=auto -ilr'

alias -g XA='| xargs'
alias -g X0='| xargs -0'
alias -g XG='| xargs egrep --color=auto'
alias -g XGv='| xargs egrep --color=auto -v'
alias -g X0G='| xargs -0 egrep --color=auto'
alias -g X0Gv='| xargs -0 egrep --color=auto -v'

# }}}
# {{{ awk

alias -g A='| awk '
alias -g A1="| awk '{print \$1}'"
alias -g A2="| awk '{print \$2}'"
alias -g A3="| awk '{print \$3}'"
alias -g A4="| awk '{print \$4}'"
alias -g A5="| awk '{print \$5}'"
alias -g A6="| awk '{print \$6}'"
alias -g A7="| awk '{print \$7}'"
alias -g A8="| awk '{print \$8}'"
alias -g A9="| awk '{print \$9}'"
alias -g EA='|& awk '
alias -g EA1="|& awk '{print \$1}'"
alias -g EA2="|& awk '{print \$2}'"
alias -g EA3="|& awk '{print \$3}'"
alias -g EA4="|& awk '{print \$4}'"
alias -g EA5="|& awk '{print \$5}'"
alias -g EA6="| awk '{print \$6}'"
alias -g EA7="| awk '{print \$7}'"
alias -g EA8="| awk '{print \$8}'"
alias -g EA9="| awk '{print \$9}'"

# }}}

# }}}

# }}}
# {{{ Key bindings 

sh_load_status 'key bindings'

bindkey -s '^X^Z' '%-^M'
bindkey -s '^[H' ' --help'
bindkey -s '^[V' ' --version'
bindkey '^[e' expand-cmd-path
#bindkey -s '^X?' '\eb=\ef\C-x*'
bindkey '^[^I'   reverse-menu-complete
bindkey '^X^N'   accept-and-infer-next-history
bindkey '^[p'    history-beginning-search-backward
bindkey '^[n'    history-beginning-search-forward
bindkey '^[P'    history-beginning-search-backward
bindkey '^[N'    history-beginning-search-forward
bindkey '^w'     kill-region-or-backward-word
bindkey '^[^W'   kill-region-or-backward-big-word
bindkey '^[T'    transpose-big-words
bindkey '^I'     complete-word
bindkey '^Xi'    incremental-complete-word
bindkey '^F'     magic-forward-char
# bindkey '^[b'    emacs-backward-word
# bindkey '^[f'    emacs-forward-word
bindkey '^[f'    magic-forward-word
bindkey '^[B'    backward-to-space
bindkey '^[F'    forward-to-space
bindkey '^[^b'   backward-to-/
bindkey '^[^f'   forward-to-/
bindkey '^[^[[C' emacs-forward-word
bindkey '^[^[[D' emacs-backward-word
bindkey '^R' history-incremental-search-backward

bindkey '^[D'  kill-big-word

if zmodload zsh/deltochar >&/dev/null; then
  bindkey '^[z' zap-to-char
  bindkey '^[Z' delete-to-char
fi

# Fix weird sequence that rxvt produces
bindkey -s '^[[Z' '\t'

alias no=ls  # for Dvorak

# }}}
# {{{ Miscellaneous

sh_load_status 'miscellaneous'

# {{{ ls colours

# moved to shared_env so people can choose to have this or not (for the colorblind)

# }}}
# {{{ Don't always autologout

if [[ "${TERM}" == ([Ex]term*|dtterm|screen*) ]]; then
  unset TMOUT
fi

# }}}

# }}}

# {{{ Specific to local setups

sh_load_status 'local hooks'
run_hooks .zshrc.d

# }}}

# {{{ Clear up after status display

if [[ $TERM == tgtelnet ]]; then
  echo
else
  echo -n "\r"
fi

# }}}
# {{{ Profile report

if [[ -n "$ZSH_PROFILE_RC" ]]; then
  zprof >! ~/zshrc.zprof
  exit
fi

# }}}

# {{{ Search for history loosing bug

which check_hist_size >&/dev/null && check_hist_size

# }}}

# {{{ lifted from AMD system profile (of which there is no zsh!)

export XREMOTETMPDIR=$HOME    # For X-remote feature of PC-Xware
export CAD=/proj/cad          # CAD working directory (platform indep)
export CADTOOLS=/tools/cad    # CAD release directory (platform dep)
export RCSINIT=-zLT           # set RCS to use Localtime

if [ -z "$USER" -a -x /usr/bin/whoami ]; then
    # HPSUX doesn't set $USER, so we need to use whoami
    export USER=`/usr/bin/whoami`
fi

export MAIL=/usr/spool/mail/$USER

# }}}

# }}}

