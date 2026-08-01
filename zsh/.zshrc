# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=50000   # in-memory size; keep larger than SAVEHIST
SAVEHIST=10000   # persisted to $HISTFILE
NEWLINE=$'\n'

# Shows "⬢ <name>" when inside a container (distrobox / podman / toolbox / docker).
# Disabled by default. To enable: uncomment the function below AND the
# matching RPROMPT line in the "Prompt setup" block.
# container() {
#   [[ -n "${CONTAINER_ID-}" || -r /run/.containerenv || -f /.dockerenv ]] || return 0
#   local name
#   name=$(awk -F'"' '/^name=/ {print $2; exit}' /run/.containerenv 2>/dev/null)
#   [[ -n "$name" ]] || name="${CONTAINER_ID:-container}"
#   print -n "%F{magenta}⬢ ${name}%f "
# }

# Prompt setup
setopt prompt_subst
# PROMPT="%F{red}%n%F{green}@%m%F{yellow}[%40<...<%~%<<]%f${NEWLINE}$ "   # pre-starship fallback
eval "$(starship init zsh)"
# RPROMPT='$(container)'$RPROMPT   # uncomment alongside container() above

# History options
setopt share_history           # share history across terminals (implies inc_append_history)
setopt hist_ignore_space       # don't save commands starting with space
setopt hist_reduce_blanks      # collapse runs of whitespace inside commands
setopt extended_history        # record timestamp and duration for each entry
setopt hist_ignore_all_dups    # remove older duplicates when a command repeats
setopt hist_find_no_dups       # don't show duplicates when searching history
setopt hist_verify             # show !!/!$ expansion before running it
setopt hist_expire_dups_first  # prune dups first when SAVEHIST is hit

# Completion system
autoload -Uz compinit
compinit -C
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Keybindings
bindkey -e                     # NEW: Explicitly use emacs keybindings (Zsh-native)
[[ -n ${terminfo[khome]} ]] && bindkey "${terminfo[khome]}" beginning-of-line
[[ -n ${terminfo[kend]}  ]] && bindkey "${terminfo[kend]}"  end-of-line
[[ -n ${terminfo[kdch1]} ]] && bindkey "${terminfo[kdch1]}" delete-char
[[ -n ${terminfo[kLFT5]} ]] && bindkey "${terminfo[kLFT5]}" backward-word
[[ -n ${terminfo[kRIT5]} ]] && bindkey "${terminfo[kRIT5]}" forward-word

# fzf — fuzzy finder. Completion (**<TAB>) + keybindings (Ctrl-R history,
# Ctrl-T file picker, Alt-C cd). Sourced after compinit and the keybindings
# block so fzf's bindings win. Debian ships these under examples/.
export FZF_TMUX=1   # inside tmux, open the finder in a split pane; remove to draw in-pane
[[ -f /usr/share/doc/fzf/examples/completion.zsh ]]   && source /usr/share/doc/fzf/examples/completion.zsh
[[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh

# Useful aliases
alias h='fc -l'
alias ll='ls -la'
alias l='ls -l'
alias g='git'

# Optional/disabled aliases
# alias ls='lsd'
# alias lst='lsd --tree'
# alias vi='vim'
# alias vim='nvim'
# alias cp='cp -ip'
# alias mv='mv -i'
# alias rm='rm -i'

# Clipboard aliases (wayland)
alias clipcopy="wl-copy"
alias clippaste="wl-paste"

# SSH Agent via keychain
command -v keychain >/dev/null && eval "$(keychain --eval --timeout 30 --quiet)"

# SSH SK Helper (FIDO2 security keys via Windows OpenSSH, WSL only)
if [[ -n "$WSL_DISTRO_NAME" ]] && [[ -x "/mnt/c/Windows/System32/OpenSSH/ssh-sk-helper.exe" ]]; then
    export SSH_SK_HELPER="/mnt/c/Windows/System32/OpenSSH/ssh-sk-helper.exe"
fi

# Editor: first available, in order of preference.
for _ed in nvim vim vi; do
    if command -v "$_ed" >/dev/null 2>&1; then
        export EDITOR="$_ed"
        export VISUAL="$_ed"
        break
    fi
done
unset _ed

# Node Version Manager stuff
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Go bins + ~/.local/bin (uv, pipx, etc.) on PATH
typeset -U path PATH
path+=("$HOME/.local/bin")
path+=("$HOME/go/bin")
#source "$HOME/.local/bin/env"

# UV completions
command -v uv >/dev/null && eval "$(uv generate-shell-completion zsh)"

# Auto-start tmux on interactive login if not already inside a multiplexer.
# Guards: interactive shell, real TTY, tmux installed, not nested in tmux/screen,
# not VS Code's integrated terminal.
# if [[ $- == *i* ]] && [[ -t 1 ]] \
#     && command -v tmux >/dev/null \
#     && [[ -z "$TMUX" && -z "$STY" && "$TERM_PROGRAM" != "vscode" ]]; then
#     exec tmux new-session -A -s "$USER"
# fi
