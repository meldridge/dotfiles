autoload -U colors && colors

HISTFILE=~/.zsh_history
SAVEHIST=1000
HISTSIZE=1000
NEWLINE=$'\n'
PROMPT="%{$fg[red]%}%n%{$fg[green]%}@%m%{$fg[yellow]%}[%40<...<%~%<<]%{$reset_color%}${NEWLINE}$ "

setopt share_history
setopt hist_ignore_space

bindkey "^[[A" up-line-or-search
bindkey "^[[F" end-of-line
bindkey "^[[H" beginning-of-line
bindkey "^[[3~" delete-char

# Enable the builtin emacs(1) command line editor in sh(1),
# e.g. C-a -> beginning-of-line.
set -o emacs

# Uncomment this and comment the above to enable the builtin vi(1) command
# line editor in sh(1), e.g. ESC to go into visual mode.
#set -o vi


# some useful aliases
alias h='fc -l'
alias j=jobs
alias m=$PAGER
alias ll='ls -la'
alias l='ls -l'
alias g='egrep -i'
alias hist='history 1'

# Use lsd
# alias ls='lsd'
# alias lst='lsd --tree'

# Use Neovim
# alias vi='vim'
# alias vim='nvim'

# # be paranoid
# alias cp='cp -ip'
# alias mv='mv -i'
# alias rm='rm -i'

# SSH Agent
eval `keychain --eval --timeout 30`

# Add key fingerprint function
function fingerprint() { ssh-keygen -lf $1; }

# Install Ruby Gems to ~/.ruby/gems
export GEM_HOME="$HOME/.gems"
export PATH="$HOME/.gems/bin:$PATH"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Launch tmux
if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
	exec tmux new-session -A -s ${USER} >/dev/null 2>&1
fi

