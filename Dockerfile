
FROM node:22-alpine
WORKDIR /app
COPY . .
RUN npm install -g pnpm@latest
RUN pnpm config set registry https://registry.npmmirror.com
RUN pnpm install
RUN cd src/ui/brain-ui && pnpm install && pnpm run build && cd ../../..
EXPOSE 3721
CMD ["pnpm", "run", "start"]
