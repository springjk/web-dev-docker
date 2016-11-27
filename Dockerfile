FROM node:6.9.1-alpine

RUN apk add --no-cache \
  # node-sass 编译依赖
  make gcc g++ python \
  # 时区设置
  ca-certificates tzdata \
  # 命令行工具
  zsh curl wget vim git


RUN npm install -g \
  # 模块管理工具
  cnpm \
  yarn \
  # 模块加载工具
  webpack \
  bower \
  browserify \
  # 构建工具
  gulp \
  grunt \
  # 编译工具
  babel \
  less \
  node-sass \
  coffee-script \
  # 框架工具
  vue-cli \
  # 开发工具
  webpack-dev-server \
  anywhere

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# 本地化
RUN
  # npm 淘宝镜像
  npm config set registry 'https://registry.npm.taobao.org' \
  # 包管理器中科大镜像
  rm /etc/apk/repositories \
  echo "http://mirrors.ustc.edu.cn/alpine/v3.4/main/" > /etc/apk/repositories \
  echo "http://mirrors.ustc.edu.cn/alpine/v3.4/community/" >> /etc/apk/repositories \
  # 修改时区
  ln -sf /usr/share/zoneinfo/PRC /etc/localtime \
  # just for fun
  echo 'ZSH_THEME="random"' > /root/.oh-my-zsh/custom/custom.zsh

EXPOSE 8080

RUN mkdir /workspace

WORKDIR /workspace

VOLUME /workspace

CMD ["zsh"]