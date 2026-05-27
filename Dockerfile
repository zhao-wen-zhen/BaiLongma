# 用带编译环境的 Debian 镜像
FROM node:22-bookworm

# 安装 node-gyp 必需的系统依赖
RUN apt-get update && apt-get install -y \
    python3 \
    build-essential \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 复制全部源码
COPY . .

# 安装 pnpm
RUN npm install -g pnpm@latest

# 配置国内源，加速依赖下载
RUN pnpm config set registry https://registry.npmmirror.com

# 安装依赖，**强制忽略所有脚本**（不触发 Electron 构建）
RUN pnpm install --ignore-scripts --force

# 直接运行服务端入口，不执行 package.json 里的 start 命令（避开 Electron）
EXPOSE 3721
CMD ["node", "src/index.js"]
