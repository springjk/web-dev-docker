ARG NODE_VERSION=latest

FROM node:${NODE_VERSION}-slim

# system local config
RUN true \
  && ln -sf /usr/share/zoneinfo/PRC /etc/localtime

RUN apt-get update \
  && apt-get install -y \
  # 命令行工具
  zsh curl wget vim git

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true


RUN true \
  # npm china mirrors
  && npm config set registry https://registry.npmmirror.com \
  # fix yarn permission denied  https://github.com/nodejs/docker-node/issues/661
  && chmod a+x /usr/local/bin/yarn \
  # yarn china mirrors  https://github.com/nodejs/docker-node/issues/386
  && yarn config set registry https://registry.npmmirror.com || true \
  # install pnpm
  && npm install -g pnpm \
  && pnpm config set registry https://registry.npmmirror.com

RUN apt-get clean autoclean

RUN mkdir /workspace

WORKDIR /workspace

VOLUME /workspace

EXPOSE 8080

CMD ["zsh"]
