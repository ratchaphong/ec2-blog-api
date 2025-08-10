# --- 1) Build Stage ---
FROM node:20-alpine AS builder
# Prisma บน Alpine ต้องใช้ openssl + libc6-compat
RUN apk add --no-cache openssl libc6-compat

WORKDIR /app

# ติดตั้ง deps แบบ cache-friendly
COPY package*.json ./
RUN npm ci

# คัดลอกโค้ดทั้งหมด
COPY . .

# สร้าง Prisma Client และ build NestJS
RUN npx prisma generate
RUN npm run build

# --- 2) Production Stage ---
FROM node:20-alpine AS prod
# ให้ Prisma runtime ทำงานได้บน Alpine
RUN apk add --no-cache openssl libc6-compat

WORKDIR /app

# คัดลอกของที่จำเป็นจาก builder
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules   # คง prisma CLI เพื่อใช้ npx prisma ตอน runtime
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/prisma ./prisma

ENV NODE_ENV=production
EXPOSE 4000

# ค่า default (จะถูก override โดย workflow ที่ใช้ sh -c ...)
CMD ["node", "dist/src/main.js"]
