# 用带完整编译环境的 Node 22 镜像
FROM node:22-bookworm

# 安装 node-gyp 必需的系统依赖
RUN apt-get update && apt-get install -y \
    python3 \
    build-essential \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 一次性复制所有源码（包括 package.json）
COPY . .

# 安装 pnpm
RUN npm install -g pnpm@latest

# 配置国内源，加速依赖下载
RUN pnpm config set registry https://registry.npmmirror.com

# 安装依赖，全程忽略所有脚本，不依赖锁文件
RUN pnpm install --ignore-scripts --force

# 直接启动服务，不执行任何构建脚本
EXPOSE 3721
CMD ["pnpm", "run", "start"]
