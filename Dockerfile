# 显式指定 Node.js LTS 版本（建议固定如 20/18，避免版本波动，ARM 架构需匹配官方支持版本）
ARG NODE_VERSION=20

# 基于官方 Node 多架构镜像（slim 版轻量，自动适配 ARM/x86，无需额外配置架构）
FROM node:${NODE_VERSION}-slim

# 1. 配置时区（避免时间相关问题，无额外依赖）
RUN ln -sf /usr/share/zoneinfo/PRC /etc/localtime

# 2. 安装核心工具集和 CA 证书
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
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

# 4. 配置三大包管理工具 + 国内源（核心需求，确保依赖拉取加速）
RUN true \
    # npm 配置 npmmirror 国内源
    && npm config set registry https://registry.npmmirror.com \
    # 启用 corepack 并安装最新版 yarn
    && corepack enable \
    && corepack prepare yarn@stable --activate \
    # yarn 配置 npmmirror 国内源（yarn 4+ 新语法）
    && yarn config set npmRegistryServer "https://registry.npmmirror.com" \
    # pnpm 配置 npmmirror 国内源 + 优化存储
    && pnpm config set registry https://registry.npmmirror.com \
    && pnpm config set store-dir ~/.pnpm-store

# 5. 基础环境配置（工作目录+数据卷，方便开发时挂载本地代码）
RUN mkdir -p /workspace
WORKDIR /workspace
VOLUME /workspace

# 6. 暴露常用端口（如前端 8080/后端 3000，根据项目需求调整，仅为声明作用）
EXPOSE 8080

# 7. 默认启动 zsh（符合工具集使用习惯，若需 bash 可改为 ["bash"]）
CMD ["zsh"]