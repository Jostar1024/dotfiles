# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.emacs_doom/bin:$PATH
export PATH="$HOME/.dynamic-colors/bin:$PATH"
export PATH="$HOME/.asdf/shims:$PATH"

export TERM=xterm-256color
export EDITOR=/usr/bin/vim
export LC_CTYPE="en_US.utf8"

export KERL_BUILD_DOCS="yes"

export HISTCONTROL=ignoredups
export TMUX_TMPDIR=$HOME/.tmp/
# export PROMPT="%B%{$fg[cyan]%}%(4~|%-1~/.../%2~|%~)%u%b \$(git branch 2>/dev/null | grep '^*' | colrm 1 2)
# >%{$fg[cyan]%}>%B%(?.%{$fg[cyan]%}.%{$fg[red]%})>%{$reset_color%}%b "

# Path to your oh-my-zsh installation.
export ZSH="/home/yucheng/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="ys"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git fzf direnv sudo zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

alias ec="emacs -nw --no-x-resources"
alias zsh_config="emacs -nw ~/.zshrc"
alias ls="exa"
# alias tn="tmux new -s"
alias tn="tmux new-session -A -s"
alias ta="tmux attach -t"
alias k="kubectl"
alias docker=podman
alias cat="bat --style=plain --pager=never"

# DYNAMIC COLOR SWITCHER FOR URXVT
# source $HOME/.dynamic-colors/completions/dynamic-colors.zsh

# ASDF
. $HOME/.asdf/asdf.sh

# NIX
if [ -e /home/yucheng/.nix-profile/etc/profile.d/nix.sh ]; then . /home/yucheng/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# DIRENV
eval "$(direnv hook zsh)"

# GHCUP
[ -f "/home/yucheng/.ghcup/env" ] && source "/home/yucheng/.ghcup/env" # ghcup-env

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/yucheng/miniconda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/yucheng/miniconda/etc/profile.d/conda.sh" ]; then
        . "/home/yucheng/miniconda/etc/profile.d/conda.sh"
    else
        export PATH="/home/yucheng/miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Kubernetes setup
source <(kubectl completion zsh)
complete -F __start_kubectl k
export KUBECONFIG=$HOME/.kube/config:$(ls -d $HOME/.kube/config.d/* 2> /dev/null | paste -sd : -)

export OKTA_USERNAME=yuchengcao

# zsh time
if [[ `uname` == Darwin ]]; then
    MAX_MEMORY_UNITS=KB
else
    MAX_MEMORY_UNITS=MB
fi

TIMEFMT='%J   %U  user %S system %P cpu %*E total'$'\n'\
'avg shared (code):         %X KB'$'\n'\
'avg unshared (data/stack): %D KB'$'\n'\
'total (sum):               %K KB'$'\n'\
'max memory:                %M '$MAX_MEMORY_UNITS''$'\n'\
'page faults from disk:     %F'$'\n'\
'other page faults:         %R'
# -X leaves file contents on the screen when less exits.
# -F makes less quit if the entire output can be displayed on one screen.
# -R displays ANSI color escape sequences in "raw" form.
# -S disables line wrapping. Side-scroll to see long lines.

export LESS="-SRXF"


export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export FLYCTL_INSTALL="/home/yucheng/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# export FENNEL_PATH="/home/yucheng/community/fennel-cljlib/?/init.fnl;$FENNEL_PATH"
# export LUA_PATH="/home/yucheng/community/fennel-cljlib/?/init.lua;$LUA_PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ ! -f ~/.tubi_env ]] || source ~/.tubi_env
[ -s ~/.luaver/luaver ] && . ~/.luaver/luaver

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

source /home/yucheng/.config/broot/launcher/bash/br

nixify() {
  if [ ! -e ./.envrc ]; then
    echo "use nix" > .envrc
    direnv allow
  fi
  if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
    cat > default.nix <<'EOF'
with import <nixpkgs> {};
mkShell {
  nativeBuildInputs = [
    bashInteractive
  ];
}
EOF
    ${EDITOR:-vim} default.nix
  fi
}
flakify() {
  if [ ! -e flake.nix ]; then
    nix flake new -t github:nix-community/nix-direnv .
  elif [ ! -e .envrc ]; then
    echo "use flake" > .envrc
    direnv allow
  fi
  ${EDITOR:-vim} flake.nix
}
