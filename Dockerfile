FROM node:6.9.1-alpine

RUN apk add --no-cache make gcc g++ python zsh curl wget vim git

RUN npm install -g \
  cnpm \
  yarn \
  vue-cli \
  webpack \
  webpack-dev-server \
  bower \
  browserify \
  gulp \
  grunt \
  babel \
  less \
  node-sass \
  coffee-script

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

EXPOSE 8080

RUN mkdir /workspace

WORKDIR /workspace

VOLUME /workspace

CMD ["zsh"]