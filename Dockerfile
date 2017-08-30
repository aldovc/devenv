FROM debian

ENV HOME=/root

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
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    python \
    python-pip \
    python-dev \
    python-setuptools \
    python-virtualenv

# Getting custom dotfiles
RUN git clone https://github.com/aldovc/dotfiles.git ~/.dotfiles

# Installing oh-my-zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh &&\
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc &&\
    chsh -s /bin/zsh

# VIM Vundle
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Symlink tmux
RUN ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf

# Symlink and configure vim with Vundle
RUN ln -s ~/.dotfiles/vim/vimrc ~/.vimrc && vim +PluginInstall +qall

# Symlink git
RUN ln -s ~/.dotfiles/git/gitconfig ~/.gitconfig

# Install rbenv
RUN git clone git://github.com/sstephenson/rbenv.git /usr/local/rbenv

# Install ruby-build
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/ruby-build && \
    /usr/local/ruby-build/install.sh

# Setup rbenv
ENV RBENV_ROOT /usr/local/rbenv
ENV PATH $RBENV_ROOT/shims:$RBENV_ROOT/bin:$PATH
ENV CONFIGURE_OPTS --disable-install-doc

RUN echo "export RBENV_ROOT=${RBENV_ROOT}" >> /etc/profile.d/rbenv.sh && \
    echo "export PATH=${RBENV_ROOT}/shims:${RBENV_ROOT}/bin:\$PATH" >> /etc/profile.d/rbenv.sh && \
    echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN eval "$(rbenv init -)"

# Install nvm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
