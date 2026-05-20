# Installation

Suggested order:

* [macOS] manually install brew
* install-config
* [linux] install-zsh (missing playbook)
* install fzf and ripgrep
* install-nerdfonts ([macOS] should add it manually to "Font Book")
* install-base16-shell (please check the playbook and dedicated scripts)
* install-kitty
* install-tmux
* install-neovim
* config-neovim

## installer-simple

`installer-simple.yml` is a reusable playbook for the common case of "install one
or more packages and symlink every file under `home/.config/<config_path>/` into
`~/.config/<config_path>/`". Other playbooks import it with `vars:` instead of
re-implementing the same three tasks.

Example — `install-htop.yml` is a thin wrapper:

```yaml
- name: Install htop
  ansible.builtin.import_playbook: installer-simple.yml
  vars:
    packages:
      - htop
    config_path: htop
```
