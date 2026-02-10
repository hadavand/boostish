# Boostish Plugins

Conventions:
- One plugin per directory: `plugins/<name>/`
- Entry file: `plugins/<name>/<name>.plugin.zsh`
- Optional: `README.md`, `assets/`, `completions/`, `bin/`
- Prefer a unique prefix for functions/vars to avoid collisions.

Load behavior:
```
for boostish_plugin in "$BOOSTISH_CONFIG_DIR"/plugins/*/*.plugin.zsh(N); do
  source "$boostish_plugin"
done
```

Completion behavior:
- `plugins/<name>/completions/` is auto-added to `fpath` before `compinit`.
- Put completion files there using zsh completion naming (`_<command>`).

Minimal template:
```
# plugins/my-plugin/my-plugin.plugin.zsh
: ${MY_PLUGIN_OPT:=default}

my_plugin_do() {
  # ...
}
```
