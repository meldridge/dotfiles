# Enable colors
autoload -U colors && colors

# History configuration
HISTFILE=~/.zsh_history
SAVEHIST=10000     # Increased from 1000 — because 1000 is *nothing*
HISTSIZE=10000     # Same here
NEWLINE=$'\n'

# Prompt setup — nice multi-line, left it as-is
PROMPT="%{$fg[red]%}%n%{$fg[green]%}@%m%{$fg[yellow]%}[%40<...<%~%<<]%{$reset_color%}${NEWLINE}$ "

# History options
setopt share_history           # Share history across terminals
setopt inc_append_history      # NEW: Append to history file immediately, not on shell exit
setopt hist_ignore_space       # Don't save commands starting with space
setopt hist_reduce_blanks      # NEW: Strip out useless extra spaces in commands

# Keybindings
bindkey "^[[A" up-line-or-search
bindkey "^[[F" end-of-line
bindkey "^[[H" beginning-of-line
bindkey "^[[3~" delete-char
bindkey -e                     # NEW: Explicitly use emacs keybindings (Zsh-native)

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

# SSH Agent via keychain
eval $(keychain --eval --timeout 30 --quiet)

# Add key fingerprint function
function fingerprint() {
    ssh-keygen -lf "$1"
}

# Auto-start tmux on shell login if not already inside one
if command -v tmux >/dev/null && [ -z "$TMUX" ]; then
    exec tmux new-session -A -s "$USER"
fi

# Optional editor export
export EDITOR=vim  # Or 'nvim' if you're a hipster. Set to what you actually use.

# Handy sudo-last-command alias
alias please='sudo $(fc -ln -1)'

# envman stub — left as-is, but you probably don’t need it
# Commenting out until you remember what it does. Avoid dead weight.
#[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
