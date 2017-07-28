#!/bin/zsh
# zhoujb.cn@gmail.com
#  

# Lines configured by zsh-newuser-install
# End of lines configured by zsh-newuser-install
# The following lines added by compinstall
zstyle :compinstall filename '/home/amas/.zshrc'

autoload -Uz compinit



#-------------------------------------------------------------- [ Module.Zmv ]
autoload -Uz zmv


# 命令提示符
#autoload -U promptinit
#promptinit
#prompt walters

#-------------------------------------------------------------- [ History ]
SAVEHIST=10000
HISTSIZE=10000
HISTFILE=~/.histfile

#-------------------------------------------------------------- [ My Vars ]
MY_X11_BROWER=chromium
MY_TTY_BROWER=w3m
MY_EMACS=emacs
MY_EMACS_CLIENT=emacsclient
MY_PDF_READER=evince
MY_TTY_VIM=vim
MY_X11_VIM=gvim


setopt INC_APPEND_HISTORY   # append history record
setopt HIST_IGNORE_DUPS     # remove duplicate command ($fc -l will get unique command list)
setopt EXTENDED_HISTORY     # add timestaps
setopt HIST_IGNORE_ALL_DUPS # remove duplicate command in history files ($history will  get unique command list)
setopt HIST_IGNORE_SPACE
setopt AUTO_PUSHD           # auto pushd after cd , press $cd -<tab> show dir stack
setopt PUSHD_IGNORE_DUPS    # remove duplicate path


# word pattern 
WORDCHARS='*?_-[]~=&;!#$%^(){}<>' 

#-------------------------------------------------------------- [ PATH ]
path=(~/bin $path /usr/local/bin)



#-------------------------------------------------------------- [ Term Colors ]
# Color Name: cyan white yellow magenta black
#             blue red   default grey green
autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
    typeset -A FG 
    typeset -A BG

    colors
    for c in cyan white yellow magenta black blue red default grey green; do
        FG[$c]=$fg[$c]
        BG[$c]=$bg[$c]
        FG[b-$c]=$terminfo[bold]$fg[$c]
        BG[b-$c]=$terminfo[bold]$bg[$c]
        # ps-*-* : prompts colors
        FG[ps-$c]=%{$fg[$c]%}
        BG[ps-$c]=%{$bg[$c]%}
        FG[ps-b-$c]=%{$terminfo[bold]$fg[$c]%}
        BG[ps-b-$c]=%{$terminfo[bold]$bg[$c]%}
    done
    TR=%{$terminfo[sgr0]%} # terminal reset
fi

ls-colors() {
    for c in ${(k)fg} ; do
        print $terminfo[sgr0]$fg[$c]$c --- $terminfo[bold]$fg[$c]$c
    done
}

update-prompt() {
    local name=$(get-git-current-branch-name)

    if [[ -z $name ]]; then
        eval PROMPT='$FG[ps-b-yellow]%%\ $TR'
        eval PROMPT='$FG[ps-b-yellow]$\ $TR'
    else    
        local changed=$(git diff --quiet ; echo $?)
        local status_color

        if [[ changed -ne 0 ]]; then
            # something changed
            status_color='$FG[ps-b-red]'
        else
            # nothing changed
            status_color='$FG[ps-b-green]'
        fi

        eval PROMPT=$status_color'$name$FG[ps-b-yellow]\>\ $TR'
    fi
    
}

get-git-current-branch-name() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

#-------------------------------------------------------------- [ Prompt ]
RPS_EXIT_CODE="%(?..:$FG[ps-b-red][%?])"
eval RPROMPT='$FG[ps-b-cyan]%~$RPS_EXIT_CODE$TR' 

#-------------------------------------------------------------- [ zsh.precmd ]
precmd() {
    # run before each command
    # update tags related EV 
    # update-tags-path-env ~/.etags.d
    update-prompt
}

# $1: tag file root
update-tags-path-env() {
    local tagsDir=${1}/$(pwd)

    if [[ -z $1 ]]; then          
        export GTAGSROOT=''
        export GTAGSDBPATH=''
        msgI GTAGSROOT=${etagsRoot}
        msgI GTAGSDBPATH=${etagsDbPath}
        return -2
    fi 

    local etagsRoot=''
    local etagsDbPath=''

    if [[ -f $tagsDir/cscope.files ]]; then
                
        etagsRoot=$(pwd)
        etagsDbPath=${tagsDir}

        export GTAGSROOT=${etagsRoot}
        export GTAGSDBPATH=${etagsDbPath}
        # msgI GTAGSROOT=${etagsRoot}
        # msgI GTAGSDBPATH=${etagsDbPath}
    fi
}


#======================================================
# Options
#

setopt AUTO_LIST
setopt AUTO_MENU
setopt MENU_COMPLETE
autoload -U compinit
compinit

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh.d/cache
zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate

#避免CVS目录出现在补全列表中
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'
zstyle ':completion:*:cd:*' ignore-parents parent pwd

#路径补全
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'

zstyle ':completion:*' menu select
zstyle ':completion:*:*:default' force-list always

# highlight complete list 
whence dircolors > /dev/null  && eval $(dircolors -b)
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

#错误校正      
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

#kill 命令补全      
compdef pkill=kill
compdef pkill=killall
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'

#补全类型提示分组 
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format "$FG[b-cyan]--- %d ---$TR"
zstyle ':completion:*:messages' format "$FG[yellow]--- %d ---$TR"
zstyle ':completion:*:warnings' format "$FG[b-red]--- No Matches Found ---$TR"

#If you end up using a directory as argument, this will remove the trailing slash (usefull in ln)
zstyle ':completion:*' squeeze-slashes true

#-------------------------------------------------------------- [ Zsh.Alises | Hashes ]
source ~/.zsh.d/global/hash-d
source ~/.zsh.d/global/alias-s
source ~/.zsh.d/global/alias-g
source ~/.zsh.d/global/alias

source ~/.zsh.d/global/alias.${$(uname):l}

#-------------------------------------------------------------- [ Zsh.PreludeFunctions ]
if [[ -d ~zshd/funcs.d ]]; then
    fpath=(~zshd/funcs.d  $fpath)
    autoload ~zshd/funcs.d/*(:t)
fi

[[ -d ~self.fun ]] && fpath=(~self.fun $fpath) && autoload ~self.fun/*(:t)


#-------------------------------------------------------------- [ Zsh.Zle.UserWidget ]
fpath=(~/.zsh.d/zle.d $fpath)
autoload ~/.zsh.d/zle.d/*(:t)
set -A zleUserWidget $(echo ~/.zsh.d/zle.d/*(:t))
for func in $zleUserWidget; do
    zle -N $func
done

#-------------------------------------------------------------- [ Zsh.CompletionFunctions]
fpath=(~/.zsh.d/completion.funcs $fpath)
autoload ~/.zsh.d/completion.funcs/*(:t)
compinit
#-------------------------------------------------------------- [ Zsh.KeyBindings ]
source ~/.zsh.d/global/bindkey



start-emacs-client() {
    $MY_EMACS_CLIENT -n "$@" || (  $MY_EMACS -T Emacs --name main && $MY_EMACS_CLIENT -n "$@" )
}


HIGHT_THEME=pablo

#-------------------------------------------------------------- [ Etc.Modules ]
# TODO(amas): move it to completion dir
import() {
    local target="@*";
    [[ -r "$target" ]] && . "$target"
}

. ~/.zsh.d/module/git-flow-completion.zsh
. ~/.zsh.d/module/antlr.zsh
export PATH="/usr/local/sbin:$PATH"
PHP_AUTOCONF="/usr/local/bin/autoconf"

#-------------------------------------------------------------- [alias]
alias grep='grep --color=auto'
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

#-------------------------------------------------------------- [virtualenvwrapper]
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
source /usr/local/bin/virtualenvwrapper.sh

#-------------------------------------------------------------- [mysql]
export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"

#-------------------------------------------------------------- [variable]
dev_service171="hx133455@10.218.132.171"                        #测网服务器
dev_service230="hx133455@100.69.196.230"                        #不清楚作用
test_service="hx133455@10.101.92.215"                           #压测服务器
daily_service="hx133455@10.189.200.64"                          #日常服务器
login_service="hx133455@login1.eu13.alibaba.org"                #线上跳板机

pp_port="127.0.0.1:8001"
fool_port="127.0.0.1:8002"
sns_port="127.0.0.1:8003"
oss_port="127.0.0.1:8004"
crd_port="127.0.0.1:8005"

#-------------------------------------------------------------- [fix vim ack warning]
export LC_ALL=$LANG
