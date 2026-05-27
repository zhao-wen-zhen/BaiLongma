# 用带完整依赖的 Node 22 镜像
FROM node:22-bookworm

# 安装必需的系统依赖（解决 node-gyp 和 powershell 报错）
RUN apt-get update && apt-get install -y \
    python3 \
    build-essential \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 1. 先复制根目录的 package.json，不复制脚本
COPY package.json pnpm-lock.yaml ./

# 2. 直接安装依赖，完全忽略所有脚本
RUN npm install -g pnpm@latest && \
    pnpm config set registry https://registry.npmmirror.com && \
    pnpm install --ignore-scripts --force

# 3. 复制全部源码
COPY . .

# 4. 直接启动服务，不执行任何构建脚本
EXPOSE 3721
CMD ["pnpm", "run", "start"]
