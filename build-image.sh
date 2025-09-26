#!/usr/bin/env bash

#### halt script on error
set -xe

# 1. 克隆代码（保持原逻辑）
git clone https://github.com/springjk/web-dev-docker.git
cd web-dev-docker

echo '##### Print docker version'
docker --version

echo '##### Print environment'
env | sort

# 2. 定义关键变量（新增：指定需要支持的架构列表，如 ARM64 + x86_64）
TARGET_ARCHITECTURES="linux/arm64,linux/amd64"  # 多架构列表（arm64对应ARM，amd64对应x86_64）
DOCKER_HUB_REPO="${DOCKER_USERNAME}/webdev"     # Docker Hub 仓库地址
ALIYUN_REPO="registry.cn-hangzhou.aliyuncs.com/springjk/webdev"  # 阿里云仓库地址
PRIVATE_REPO="${PRIVATE_REPOSITORY}/mirror/springjk/webdev"  # 私有仓库地址
NODE_VERSION=${NODE_VERSION:-"latest"}          # 默认Node版本为latest

echo "##### Build version: ${NODE_VERSION}, Target architectures: ${TARGET_ARCHITECTURES}"

# 3. 配置 Docker Buildx（启用多架构构建能力）
#  - 创建构建器实例（若不存在）
#  - 启用构建器（切换到多架构构建模式）
docker buildx create --name multiarch-builder --use || true
# 加载 qemu 模拟器（用于跨架构构建，如在x86机器上构建ARM镜像）
docker run --privileged --rm tonistiigi/binfmt --install all

# 4. 多架构构建并推送至所有仓库（合并构建以提高效率）
# 准备标签列表
TAGS="-t ${DOCKER_HUB_REPO}:latest -t ${ALIYUN_REPO}:latest -t ${PRIVATE_REPO}:latest"
if [[ ${NODE_VERSION} != "latest" && ${NODE_VERSION} != "NA" ]]; then
    TAGS="${TAGS} -t ${DOCKER_HUB_REPO}:${NODE_VERSION} -t ${ALIYUN_REPO}:${NODE_VERSION} -t ${PRIVATE_REPO}:${NODE_VERSION}"
fi

# 执行一次构建，推送到所有仓库
echo "##### Building and pushing to all registries"
docker buildx build \
  --platform "${TARGET_ARCHITECTURES}" \
  --build-arg NODE_VERSION="${NODE_VERSION}" \
  ${TAGS} \
  --push .

# 7. 验证推送结果（可选：查看仓库中的多架构镜像信息）
echo "##### Check Docker Hub multi-arch image info"
docker buildx imagetools inspect "${DOCKER_HUB_REPO}:latest"

echo "##### Check Aliyun multi-arch image info"
docker buildx imagetools inspect "${ALIYUN_REPO}:latest"

echo "##### Check Private Registry multi-arch image info"
docker buildx imagetools inspect "${PRIVATE_REPO}:latest"