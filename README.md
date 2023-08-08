# 前端开发环境 Docker 镜像
基于 Debain 版 linux，构建于 `Nodejs` 各大版本，包含  `node-sass` `yarn` `webpack` `zsh` `git` 等常用工具，开箱即用。


如果不需要作为开发环境而是将其作为命令行工具使用，参考以下用法：


 如需指定 node 版本则在 image 后增加 tag ，NODE 版本列表 [10 - 16](https://hub.docker.com/r/springjk/webdev/tags?page=1&ordering=last_updated)，`例：springjk/webdev:10`

**PS：工具式用法**


```bash
cd {your-project-path}
docker run --rm -v $(pwd):/workspace  springjk/webdev:{node-version} sh -c {your-command}
```

示例：

```bash
docker run --rm -v $(pwd):/workspace  springjk/webdev sh -c 'npm install';

docker run --rm -v $(pwd):/workspace  springjk/webdev sh -c 'node -v && yarn install && yarn run build';
# 指定 node 版本 [10-16]
docker run --rm -v $(pwd):/workspace  springjk/webdev:14 sh -c 'node -v && yarn install && yarn run build';
```

## 安装
初次安装请根据以下步骤执行，熟悉 Docker 的用户可修改 Dockerfile 自行编译使用。

**Setp0: 安装 Docker**

* [Docker 官方地址](https://www.docker.com/products/overview)

**Setp1: 下载镜像**

```bash
docker pull springjk/webdev
# 或指定版本
docker pull springjk/webdev:16
```

**Setp2: 创建常驻式容器**

```bash
docker run -itd -p <work-port>:8080 -v <workspace-path>:/workspace --name webdev --restart always springjk/webdev
```

> 请将 `<work-port>` 与 `<workspace-path>` 替换，restart=always 会使容器跟随 Dokcer 自动启动。

* `work-port` - 浏览器访问端口，容器 8080 端口映射本机端口
* `workspace-path` - 代码同步工作目录，Windows 版请确认该目录所在盘符已在 Docker 的配置中挂载

示例：

```bash
docker run -itd -p 80:8080 -v d:/git_workspace:/workspace --name webdev --restart=always springjk/webdev
docker run -itd -v /app:/workspace --name webdev --restart=always springjk/webdev

```

## 使用

```bash
docker exec -it webdev zsh
```

## 删除

```bash
docker rm -f webdev
```

## 镜像内容

### 基础环境

| 名称 | 说明 | 版本 |
| --- | --- | --- |
| [node](http://www.npmjs.com) | Node.js 基础环境 | 10-18 |

### 模块管理器

| 名称 | 说明 | 版本 |
| --- | --- | --- |
| [npm](http://www.npmjs.com) | Node.js 官方推出的 JavaScript 包工具 | latest |
| [yarn](https://yarnpkg.com) | Facebook 推出的开源 JavaScript 包工具 | latest |
| [pnpm](https://pnpm.io/) | 新一代的开源 JavaScript 包工具 | latest |


### 系统工具

| 名称 | 说明 | 版本 |
| --- | --- | --- |
| [curl](https://curl.haxx.se) | HTTP 请求工具 | latest |
| [wget](http://www.gnu.org/software/wget/wget.html) | 文件下载工具 | latest |
| [vim](http://www.vim.org) | 文本编辑器 | latest |
| [git](https://git-scm.com) | 免费、开源的分布式版本控制工具 | latest |
| [zsh](http://www.zsh.org) | 强大的 Shell 增强工具 | latest |
| [oh-my-zsh](http://ohmyz.sh) | zsh 的扩展工具 | latest |

### 本地化

* 时区修改为 `PRC`
* npm 及相关二进制包源修改为阿里源
* 添加 YARN、PNPM
