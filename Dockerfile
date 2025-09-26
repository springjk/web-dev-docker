# 显式指定 Node.js LTS 版本（建议固定如 20/18，避免版本波动，ARM 架构需匹配官方支持版本）
ARG NODE_VERSION=20

# 基于官方 Node 多架构镜像（slim 版轻量，自动适配 ARM/x86，无需额外配置架构）
FROM node:${NODE_VERSION}-slim

# 1. 配置时区（避免时间相关问题，无额外依赖）
RUN ln -sf /usr/share/zoneinfo/PRC /etc/localtime

# 2. 安装核心工具集（curl/wget/vim/git/zsh）+ 清理缓存（修复注释位置：注释需在续接符 \ 之前）
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \ 
        wget \ 
        vim \
        git \ 
        zsh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 3. 安装 oh-my-zsh（zsh 扩展工具，使用官方脚本，适配 ARM 架构）
# 注：|| true 避免脚本中非致命错误导致构建失败（如提示 Shell 切换）
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# 4. 配置三大包管理工具 + 国内源（核心需求，确保 ARM 环境依赖拉取加速）
RUN true \
    # npm 配置 npmmirror 国内源
    && npm config set registry https://registry.npmmirror.com || true \
    # 修复 yarn 权限问题（官方预安装 yarn 可能存在执行权限不足，ARM 环境同样适用）
    && chmod a+x /usr/local/bin/yarn /usr/local/lib/node_modules/yarn/bin/yarn.js || true \
    # yarn 配置 npmmirror 国内源
    && yarn config set registry https://registry.npmmirror.com || true \
    # 全局安装 pnpm（Node 官方镜像默认不含，通过 npm 内置命令安装，ARM 兼容）
    && npm install -g pnpm || true \
    # pnpm 配置 npmmirror 国内源 + 优化存储（可选：减少重复依赖占用空间）
    && pnpm config set registry https://registry.npmmirror.com || true \
    && pnpm config set store-dir ~/.pnpm-store || true

# 5. 基础环境配置（工作目录+数据卷，方便开发时挂载本地代码）
RUN mkdir -p /workspace
WORKDIR /workspace
VOLUME /workspace

# 6. 暴露常用端口（如前端 8080/后端 3000，根据项目需求调整，仅为声明作用）
EXPOSE 8080

# 7. 默认启动 zsh（符合工具集使用习惯，若需 bash 可改为 ["bash"]）
CMD ["zsh"]