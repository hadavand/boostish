BOOSTISH_CONFIG_DIR="$HOME/.boostish"
export BOOSTISH_CONFIG_DIR

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

boostish_source 20-completions.zsh

# Plugins --------------------
zinit ice depth=1
zinit light zsh-users/zsh-autosuggestions
zinit ice depth=1
zinit light zsh-users/zsh-history-substring-search
zinit ice depth=1
zinit light Aloxaf/fzf-tab
zinit ice depth=1
zinit light zsh-users/zsh-syntax-highlighting
zinit ice depth=1
zinit light zsh-users/zsh-completions

zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::bgnotify
zinit snippet OMZP::encode64
zinit snippet OMZP::gh

# fzf (manual preferred; fallback to zinit)
if [[ ! -d "$HOME/.fzf" ]]; then
  zinit ice depth=1 nocompile \
    atclone'./install --bin --no-update-rc --no-key-bindings --no-completion' \
    atpull'%atclone'
  zinit light junegunn/fzf
fi

boostish_fzf_dir=""
if [[ -d "$HOME/.fzf" ]]; then
  boostish_fzf_dir="$HOME/.fzf"
elif [[ -d "${ZINIT_HOME%/*}/plugins/junegunn---fzf" ]]; then
  boostish_fzf_dir="${ZINIT_HOME%/*}/plugins/junegunn---fzf"
fi

if [[ -n "$boostish_fzf_dir" ]]; then
  if [[ ! -x "$boostish_fzf_dir/bin/fzf" && -x "$boostish_fzf_dir/install" ]]; then
    "$boostish_fzf_dir/install" --bin --no-update-rc --no-key-bindings --no-completion
  fi
  path=("$boostish_fzf_dir/bin" $path)
  [[ -r "$boostish_fzf_dir/shell/completion.zsh" ]] && source "$boostish_fzf_dir/shell/completion.zsh"
  [[ -r "$boostish_fzf_dir/shell/key-bindings.zsh" ]] && source "$boostish_fzf_dir/shell/key-bindings.zsh"
fi

for boostish_plugin in "$BOOSTISH_CONFIG_DIR"/plugins/*/*.plugin.zsh(N); do
  source "$boostish_plugin"
done

boostish_source 30-aliases.zsh

boostish_source 40-functions.zsh

boostish_source settings.zsh

boostish_source 50-highlightings.zsh

boostish_source 60-keybindings.zsh

# Powerlevel10k (with different configs per terminal)
zinit ice depth=1
zinit light romkatv/powerlevel10k

if _boostish_pure_p10k_terminal; then
  boostish_source 91-p10k-pure.zsh
else
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
  boostish_source 91-p10k-boostish.zsh
fi

unfunction _boostish_pure_p10k_terminal 2>/dev/null

boostish_source 98-post.zsh
boostish_source 99-local.zsh
