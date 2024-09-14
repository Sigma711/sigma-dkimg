FROM ubuntu:24.04

RUN arch=$(dpkg --print-architecture) && \
  if [ "$arch" = "amd64" ] || [ "$arch" = "i386" ]; then \
  sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list.d/ubuntu.sources; \
  else \
  sed -i 's@//.*ports.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list.d/ubuntu.sources; \
  fi
RUN sed -i 's@//.*security.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list.d/ubuntu.sources;

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y autoconf \
  automake \
  autopoint \
  autojump && \
  apt-get clean
RUN apt-get install -y binutils-dev \
  build-essential \
  ccache \
  clang \
  clangd && \
  apt-get clean
RUN apt-get install -y cloc \
  cmake \
  curl \
  flex \
  flex-doc \
  git && \
  apt-get clean
RUN apt-get install -y gperf \
  graphviz \
  help2man \
  libc-ares-dev && \
  apt-get clean
RUN apt-get install -y libaio-dev \
  libboost-dev \
  libbz2-dev \
  libcurl4-openssl-dev && \
  apt-get clean
RUN apt-get install -y libdouble-conversion-dev \
  libdwarf-dev \
  libelf-dev && \
  apt-get clean
RUN apt-get install -y libevent-dev \
  libevhtp-dev \
  libevhtp-doc \
  libfmt-dev \
  libfmt-doc \
  libfuse2 && \
  apt-get clean
RUN apt-get install -y libgflags-dev \
  libgflags-doc \
  libgoogle-glog-dev \
  libgoogle-perftools-dev \
  libgmock-dev \
  libgrpc++-dev && \
  apt-get clean
RUN apt-get install -y libgtest-dev \
  libhiredis-dev \
  libiberty-dev \
  libjemalloc-dev \
  libleveldb-dev \
  liblz4-dev && \
  apt-get clean
RUN apt-get install -y liblzma-dev \
  liblzma-doc \
  libmbedtls-dev \
  libmbedtls-doc \
  libmysqlcppconn-dev \
  libprotobuf-dev && \
  apt-get clean
RUN apt-get install -y libprotoc-dev \
  libreadline-dev \
  librocksdb-dev \
  libsnappy-dev \
  libsodium-dev && \
  apt-get clean
RUN apt-get install -y libssl-dev \
  libthrift-dev \
  libtool \
  libtool-doc && \
  apt-get clean
RUN apt-get install -y libunwind-dev \
  libzstd-dev \
  lld && \
  apt-get clean
RUN apt-get install -y mysql-client \
  mysql-server \
  neofetch \
  net-tools \
  nodejs \
  npm \
  nscd && \
  apt-get clean
RUN apt-get install -y openssh-client \
  openssh-server \
  protobuf-compiler \
  python3 \
  ranger \
  redis && \
  apt-get clean
RUN apt-get install -y rocksdb-tools \
  screenfetch \
  software-properties-common \
  sudo \
  texinfo \
  thrift-compiler \
  tree && \
  apt-get clean
RUN apt-get install -y uuid \
  vim \
  wget \
  zlib1g-dev \
  zsh && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN add-apt-repository -y ppa:longsleep/golang-backports && \
  apt-get update && \
  apt-get install -y golang-go && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /usr/bin/zsh sigma711 && \
  echo 'sigma711 ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
  echo 'root ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
  echo 'sigma711:000411' | chpasswd && \
  echo 'root:000411' | chpasswd

USER sigma711

WORKDIR /home/sigma711

RUN sh -c "$(curl -fsSL https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh)" && \
  sed -i 's/ZSH_THEME=".*"/ZSH_THEME="example"/' ~/.zshrc

RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

RUN sed -i 's/plugins=(git)/plugins=(git colored-man-pages zsh-syntax-highlighting)/' ~/.zshrc && \
  echo 'neofetch -a' >> ~/.zshrc

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
  echo 'source $HOME/.cargo/env' >> ~/.zshrc

USER root

RUN mkdir /var/run/sshd && \
  ssh-keygen -A && \
  echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
  echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
