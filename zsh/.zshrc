# Enable colors
autoload -U colors && colors

# History configuration
HISTFILE=~/.zsh_history
SAVEHIST=10000
HISTSIZE=10000
NEWLINE=$'\n'

# Shows "⬢ <name>" when inside a distrobox/container
container() {
  # Distrobox: if CONTAINER_ID is set, we're in a distrobox
  [[ -n "${CONTAINER_ID-}" ]] || return 0

  local name=""
  if [[ -r /run/.containerenv ]]; then
    # podman-style file often contains: name="something"
    name="${${(M)${(f)"$(</run/.containerenv)"}:#name=*}#name=}"
    name="${name//\"/}"
  fi

  [[ -n "$name" ]] || name="$CONTAINER_ID"
  print -n "%F{magenta}⬢ ${name}%f "
}

# Prompt setup
setopt prompt_subst
PROMPT="%{$fg[red]%}%n%{$fg[green]%}@%m%{$fg[yellow]%}[%40<...<%~%<<]%{$reset_color%}${NEWLINE}$ "
RPROMPT='$(container)'$RPROMPT

# History options
setopt share_history           # Share history across terminals
setopt inc_append_history      # Append to history file immediately, not on shell exit
setopt hist_ignore_space       # Don't save commands starting with space
setopt hist_reduce_blanks      # Strip out useless extra spaces in commands

# Keybindings
bindkey -e                     # NEW: Explicitly use emacs keybindings (Zsh-native)
[[ -n ${terminfo[khome]} ]] && bindkey "${terminfo[khome]}" beginning-of-line
[[ -n ${terminfo[kend]}  ]] && bindkey "${terminfo[kend]}"  end-of-line
[[ -n ${terminfo[kdch1]} ]] && bindkey "${terminfo[kdch1]}" delete-char
[[ -n ${terminfo[kLFT5]} ]] && bindkey "${terminfo[kLFT5]}" backward-word
[[ -n ${terminfo[kRIT5]} ]] && bindkey "${terminfo[kRIT5]}" forward-word

# Useful aliases
alias h='fc -l'
alias j=jobs
alias m=$PAGER
alias ll='ls -la'
alias l='ls -l'
alias g='egrep -i'
alias hist='history 1'

# Optional/disabled aliases
# alias ls='lsd'
# alias lst='lsd --tree'
# alias vi='vim'
# alias vim='nvim'
# alias cp='cp -ip'
# alias mv='mv -i'
# alias rm='rm -i'

# xclip aliases
alias clipcopy="xclip -selection clipboard"
alias clippaste="xclip -o -selection clipboard"

# SSH Agent via keychain
command -v keychain >/dev/null && eval "$(keychain --eval --timeout 30 --quiet)"

# Add key fingerprint function
function fingerprint() {
    ssh-keygen -lf "$1"
}

# Auto-start tmux on shell login if not already inside one
if command -v tmux >/dev/null && [ -z "$TMUX" ]; then
    exec tmux new-session -A -s "$USER"
fi

# Optional editor export
export EDITOR=vim

# Handy sudo-last-command alias
alias please='sudo $(fc -ln -1)'

# envman stub for webi stuff
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# nvm stuff
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Go bins
export PATH=$PATH:$HOME/go/bin
