# 用带编译工具的 Debian 镜像
FROM node:22-bookworm

# 安装编译依赖（解决 node-gyp 问题）
RUN apt-get update && apt-get install -y \
    python3 \
    build-essential \
    make \
    g++ \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 复制源码
COPY . .

# 安装 pnpm
RUN npm install -g pnpm@latest

# 配置国内源
RUN pnpm config set registry https://registry.npmmirror.com

# 1. 先安装所有依赖，但忽略构建脚本
RUN pnpm install --ignore-scripts

# 2. 手动允许关键依赖的构建脚本
RUN pnpm approve-builds better-sqlite3 electron playwright

# 3. 重新执行一次构建脚本
RUN pnpm install --force

# 构建前端 UI
RUN cd src/ui/brain-ui && pnpm install && pnpm run build && cd ../../..

EXPOSE 3721

CMD ["pnpm", "run", "start"]
