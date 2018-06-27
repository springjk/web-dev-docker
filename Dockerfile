ARG BUILD_FROM=node:8.11.3-stretch
FROM $BUILD_FROM

RUN apt-get update \
  && apt-get install -y \
  # node-sass 等编译依赖
  make gcc g++ python \
  # 命令行工具
  zsh curl wget vim git

RUN npm install -g \
  cnpm --registry=https://registry.npm.taobao.org \
  yarn \
  anywhere

RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# china mirrors
RUN true \
  # npm china mirrors
  && npm  config set registry https://registry.npm.taobao.org \
  && yarn config set registry https://registry.npm.taobao.org \
  && yarn config set sass_binary_site https://npm.taobao.org/mirrors/node-sass -g \
  && yarn config set nvm_nodejs_org_mirror http://npm.taobao.org/mirrors/node -g \
  # debian china mirrors
  && sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
  # timezone to china
  && ln -sf /usr/share/zoneinfo/PRC /etc/localtime \
  # just for fun
  && echo 'ZSH_THEME="random"' > ~/.oh-my-zsh/custom/custom.zsh \
  # This loads nvm
  && echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.oh-my-zsh/custom/custom.zsh \
  && echo '[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"' >> ~/.oh-my-zsh/custom/custom.zsh

RUN mkdir /workspace

WORKDIR /workspace

VOLUME /workspace

EXPOSE 8080

CMD ["zsh"]