# Stage 1: Build
FROM node:20-slim AS builder

ENV TZ=Asia/Bangkok

WORKDIR /app

COPY package*.json ./
COPY prisma ./prisma        # ✅ เพิ่มบรรทัดนี้ เพื่อ copy schema.prisma
RUN npm install
RUN npx prisma generate     # ✅ สร้างไฟล์สำหรับ @prisma/client

COPY . .
RUN npm run build

# Stage 2: Runtime
FROM node:20-slim

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules # ✅ เพิ่มเพื่อให้ runtime ใช้ได้
COPY --from=builder /app/prisma ./prisma             # ✅ สำหรับกรณี runtime ใช้ prisma schema
COPY --from=builder /app/.prisma ./node_modules/.prisma # ✅ สำหรับบาง lib ที่ต้องใช้ client internals

RUN npm ci --only=production

EXPOSE 4000

CMD ["node", "dist/main.js"]
