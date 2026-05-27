# 换成基于Debian的Node镜像，自带编译环境，完美解决node-gyp问题
FROM node:22-bookworm

# 安装node-gyp必需的依赖：Python、build-essential、make等
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    build-essential \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

# 安装pnpm
RUN npm install -g pnpm@latest

# 配置国内源
RUN pnpm config set registry https://registry.npmmirror.com

# 安装依赖（去掉--frozen-lockfile，避免锁文件问题）
RUN pnpm install

# 构建前端UI
RUN cd src/ui/brain-ui && pnpm install && pnpm run build && cd ../../..

EXPOSE 3721

CMD ["pnpm", "run", "start"]
