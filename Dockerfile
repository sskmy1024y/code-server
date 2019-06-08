FROM codercom/code-server

USER root
WORKDIR /root

RUN apt-get update \
 && apt-get install -y \
    libx11-xcb1 \
    libasound2 \
    curl \
    gnupg2 \
    git \
    python \
    g++ \
    gcc \
    libc6-dev \
    make \
    pkg-config \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*


# Install node
ARG nvm_version="0.34.0"
ARG node_version="11.14.0"
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v$nvm_version/install.sh | bash \
 && . /root/.bashrc \
 && nvm install v$node_version \
 && nvm use v$node_version \
 && npm i -g yarn


COPY scripts /usr/local/bin
COPY extensions.txt /root

# Install vscode extensions
RUN chmod -R 755 install-extensions.sh
RUN install-extensions.sh

COPY settings.json /root/.code-server/User/settings.json

WORKDIR /root/project
