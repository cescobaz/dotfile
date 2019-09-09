# Buro home

## Install

Set up alias in your shell environment

```bash
alias home-git='git --work-tree=$HOME --git-dir=$HOME/.home-git'
```

Then clone the repo.

```bash
git clone [URL]
mv ./xhome/.git .home-git
echo '*' >> .home-git/info/exclude
```

Now reset/checkout repo to master.

Run the installer

```bash
~/.p/macosx_install.sh
```

Setup your environment adding the following to your shell config

```bash
source "$HOME/.p/aliases"
source "$HOME/.p/env"
```
