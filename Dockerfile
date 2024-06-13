FROM node:20.6.0-bookworm AS base
RUN npm i -g pnpm@PNPM_VERSION
WORKDIR /app
CMD pnpm install && pnpm run dev
