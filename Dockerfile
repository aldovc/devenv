FROM debian

MAINTAINER Aldo Vega <aldovc>

RUN apt-get update && apt-get dist-upgrade -y -q && apt-get update && apt-get -y -q autoclean && apt-get -y -q autoremove

RUN apt-get install -y \
    curl \
    zsh \
    tmux \
    vim-nox \
    git \
    wget \
    locales-all \
    gcc \
    build-essential \
    make \
    cmake \
    libssl1.0-dev \
    libreadline-dev \
    zlib1g-dev \
    python \
    python-pip \
    python-dev \
    python-setuptools \
    python-virtualenv \
    sudo

# Configuring dev user
RUN chmod 440 /etc/sudoers

RUN useradd dev --shell /bin/zsh --create-home && echo "dev:dev" | chpasswd && adduser dev sudo

USER dev

# Getting custom dotfiles
RUN git clone https://github.com/aldovc/dotfiles.git ~/.dotfiles

# Installing oh-my-zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh &&\
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# VIM Vundle
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Symlink tmux
RUN ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf

# Symlink and configure vim with Vundle
RUN ln -s ~/.dotfiles/vim/vimrc ~/.vimrc && vim +PluginInstall +qall

# Symlink git
RUN ln -s ~/.dotfiles/git/gitconfig ~/.gitconfig

# Install rbenv
RUN git clone git://github.com/rbenv/rbenv.git ~/.rbenv

# Install ruby-build
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

ENV PATH /home/dev/.rbenv/bin:$PATH

ENV PATH /home/dev/.rbenv/shims:$PATH

# Install nvm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash

CMD ["/sbin/init"]
