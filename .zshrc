BOOSTISH_CONFIG_DIR="$HOME/.boostish"; export BOOSTISH_CONFIG_DIR

boostish_source() {
  local file="$BOOSTISH_CONFIG_DIR/$1"
  [[ -r "$file" ]] || return 0
  source "$file"
}

boostish_source 00-pre.zsh || return

# Load Zinit
source "${ZINIT_HOME}/zinit.zsh"

# Essential Annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-rust

# Plugins --------------------
zinit ice depth=1; zinit light zsh-users/zsh-autosuggestions
zinit ice depth=1; zinit light zsh-users/zsh-history-substring-search
zinit ice depth=1; zinit light Aloxaf/fzf-tab
zinit ice depth=1; zinit light zsh-users/zsh-syntax-highlighting
zinit ice depth=1; zinit light zsh-users/zsh-completions

zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::bgnotify
zinit snippet OMZP::encode64
zinit snippet OMZP::gh

boostish_source 20-completions.zsh

zinit ice lucid; zinit snippet "$BOOSTISH_CONFIG_DIR/plugins/minio/minio.plugin.zsh"

boostish_source 30-aliases.zsh

boostish_source 40-functions.zsh

boostish_source settings.zsh

boostish_source 50-highlightings.zsh

boostish_source 60-keybindings.zsh

# Powerlevel10k (with different configs per terminal)
zinit ice depth=1; zinit light romkatv/powerlevel10k

if [[ "$TERMINAL_EMULATOR" == "JetBrains-JediTerm" || -n "$VSCODE_INTEGRATED_TERMINAL" || "$TERM_PROGRAM" == "vscode" ]]; then
  boostish_p10k_file="91-p10k-pure.zsh"
else
  boostish_p10k_file="90-p10k.zsh"
fi

boostish_source "$boostish_p10k_file"
boostish_source 99-post.zsh
