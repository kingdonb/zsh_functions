HISTSIZE=10000000
SAVEHIST=10000000
setopt hist_ignore_all_dups
setopt hist_ignore_space

export GPG_TTY=$(tty)

export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$PATH:$HOME/go/bin"
export FLUX_SYSTEM_NAMESPACE=cozy-fluxcd

bindkey -e
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

source $HOME/zsh_functions/zsh_aliases

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export PATH="/opt/homebrew/opt/node@20/bin:$PATH"

source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

autoload -Uz compinit && compinit

. <(flux completion zsh)
. <(helm completion zsh)
. <(kconf completion zsh)
