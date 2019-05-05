FROM node:10.15-slim

# system local config
RUN true \
  # debian china mirrors
  && sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
  && sed -i 's/security.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
  # timezone to china
  && ln -sf /usr/share/zoneinfo/PRC /etc/localtime

RUN apt-get update \
  && apt-get install -y \
  # node-sass 等编译依赖
  make gcc g++ python \
  # 命令行工具
  zsh curl wget vim git

RUN npm install -g \
  anywhere

RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true


RUN true \
  # npm china mirrors
  && npm config set registry https://registry.npm.taobao.org \
  && npm config set disturl https://npm.taobao.org/dist \
  && npm config set sass_binary_site https://npm.taobao.org/mirrors/node-sass \
  && npm config set electron_mirror https://npm.taobao.org/mirrors/electron \
  && npm config set puppeteer_download_host https://npm.taobao.org/mirrors \
  && npm config set chromedriver_cdnurl https://npm.taobao.org/mirrors/chromedriver \
  && npm config set operadriver_cdnurl https://npm.taobao.org/mirrors/operadriver \
  && npm config set phantomjs_cdnurl https://npm.taobao.org/mirrors/phantomjs \
  && npm config set selenium_cdnurl https://npm.taobao.org/mirrors/selenium \
  # fix yarn permission denied  https://github.com/nodejs/docker-node/issues/661
  && chmod a+x /usr/local/bin/yarn \
  # yarn china mirrors  https://github.com/nodejs/docker-node/issues/386
  && yarn config set registry https://registry.npm.taobao.org || true \
  # just for fun
  && echo 'ZSH_THEME="random"' > ~/.oh-my-zsh/custom/custom.zsh \
  # loads nvm
  && echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.oh-my-zsh/custom/custom.zsh \
  && echo '[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"' >> ~/.oh-my-zsh/custom/custom.zsh

RUN mkdir /workspace

WORKDIR /workspace

VOLUME /workspace

EXPOSE 8080

CMD ["zsh"]