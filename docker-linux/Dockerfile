FROM archlinux:base

RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm \
              base base-devel \
              man-pages man-db texinfo \
              git curl \
              bash zsh \
              fzf fd ripgrep \
              bat exa \
              tmux vim neovim \
              python python-pip

RUN python3 -m pip install --user --upgrade pynvim
# RUN vim -E -c PlugInstall -c qa

RUN usermod -s /bin/zsh root

WORKDIR /root

RUN git clone https://github.com/cescobaz/dotfile.git

RUN bash ./dotfile/install_base16.sh
RUN echo "a" | bash ./dotfile/install_shell_config.sh --only-links
RUN bash ./dotfile/install_tmux.sh --only-links
RUN bash ./dotfile/install_vim.sh --only-links

ENV TERM=screen-256color
RUN COLORTERM=truecolor

CMD tail -f /dev/null
