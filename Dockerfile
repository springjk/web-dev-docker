FROM node:6.11.1-alpine

RUN apk add --no-cache \
  # 时区设置
  ca-certificates tzdata \
  # 命令行工具
  bash curl wget vim git

# 本地化
RUN true \
  # 淘宝镜像
  && npm config set registry https://registry.npm.taobao.org \
  && yarn config set registry https://registry.npm.taobao.org \
  && yarn config set sass_binary_site https://npm.taobao.org/mirrors/node-sass -g \
  && yarn config set nvm_nodejs_org_mirror http://npm.taobao.org/mirrors/node -g \
  # 包管理器中科大镜像
  && rm /etc/apk/repositories \
  && echo "http://mirrors.ustc.edu.cn/alpine/v3.4/main/" > /etc/apk/repositories \
  && echo "http://mirrors.ustc.edu.cn/alpine/v3.4/community/" >> /etc/apk/repositories \
  # 修改时区
  && ln -sf /usr/share/zoneinfo/PRC /etc/localtime

EXPOSE 8080

RUN mkdir /workspace

WORKDIR /workspace

VOLUME /workspace

CMD ["bash"]