FROM node:25.2.1-alpine AS packages
WORKDIR /app/
RUN --mount=type=bind,target=/docker-context \
    cd /docker-context/; \
    find . -name "package.json" -mindepth 0 -maxdepth 4 -exec cp --parents "{}" /app/ \;

FROM node:25.2.1-alpine AS builder
RUN apk add --no-cache bash

WORKDIR /app
COPY --from=packages /app/ .
RUN npm install
COPY . .
RUN npm run build

FROM nginx:1.29.4-alpine
COPY --from=builder /app/_static /usr/share/nginx/html
EXPOSE 80