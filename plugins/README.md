# Boostish Plugins

Conventions:
- One plugin per directory: `plugins/<name>/`
- Entry file: `plugins/<name>/<name>.plugin.zsh`
- Optional: `README.md`, `assets/`, `completions/`, `bin/`
- Prefer a unique prefix for functions/vars to avoid collisions.

Load from `.zshrc`:
```
zinit snippet "$BOOSTISH_CONFIG_DIR/plugins/<name>/<name>.plugin.zsh"
```

Minimal template:
```
# plugins/my-plugin/my-plugin.plugin.zsh
: ${MY_PLUGIN_OPT:=default}

my_plugin_do() {
  # ...
}
```
