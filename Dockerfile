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
  && npm config set disturl https://npmmirror.com/dist \
  && npm config set sass_binary_site https://npmmirror.com/mirrors/node-sass \
  && npm config set electron_mirror https://npmmirror.com/mirrors/electron \
  && npm config set puppeteer_download_host https://npmmirror.com/mirrors \
  && npm config set chromedriver_cdnurl https://npmmirror.com/mirrors/chromedriver \
  && npm config set operadriver_cdnurl https://npmmirror.com/mirrors/operadriver \
  && npm config set phantomjs_cdnurl https://npmmirror.com/mirrors/phantomjs \
  && npm config set selenium_cdnurl https://npmmirror.com/mirrors/selenium \
  # install pnpm
  && npm install -g pnpm \
  # fix yarn permission denied  https://github.com/nodejs/docker-node/issues/661
  && chmod a+x /usr/local/bin/yarn \
  # yarn china mirrors  https://github.com/nodejs/docker-node/issues/386
  && yarn config set registry https://registry.npmmirror.com || true

RUN apt-get clean autoclean

RUN mkdir /workspace

WORKDIR /workspace

VOLUME /workspace

EXPOSE 8080

CMD ["zsh"]
