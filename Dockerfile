# ⬆️ Stage 1: Build
FROM node:18-slim AS builder

ENV TZ=Asia/Bangkok

WORKDIR /app

COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# ⬇️ Stage 2: Runtime
FROM node:18-slim

WORKDIR /app

# ✅ Copy only what’s needed
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./
RUN npm ci --only=production

EXPOSE 4000

CMD ["node", "dist/main.js"]
