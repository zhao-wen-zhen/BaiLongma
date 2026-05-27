# 用带编译工具的 Debian 镜像
FROM node:22-bookworm

# 安装编译依赖（解决 node-gyp 问题）
RUN apt-get update && apt-get install -y \
    python3 \
    build-essential \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 复制源码
COPY . .

# 安装 pnpm
RUN npm install -g pnpm@latest

# 配置国内源
RUN pnpm config set registry https://registry.npmmirror.com

# 1. 先安装所有依赖，但忽略构建脚本（避免触发 PowerShell）
RUN pnpm install --ignore-scripts

# 2. 手动放行关键依赖，跳过 Electron
RUN pnpm approve-builds better-sqlite3 playwright

# 3. 强制安装，只构建非 Electron 依赖
RUN pnpm install --force --ignore-scripts

# 4. 只构建前端 UI，不执行任何 Electron 相关脚本
RUN cd src/ui/brain-ui && pnpm install && pnpm run build && cd ../../..

EXPOSE 3721

# 启动白龙马的核心服务，不启动 Electron
CMD ["pnpm", "run", "start"]
