# --- 1) Build Stage ---
FROM node:20-alpine AS builder
# Prisma บน Alpine ต้องใช้ openssl + libc6-compat
RUN apk add --no-cache openssl libc6-compat

WORKDIR /app

# ใช้ Corepack เพื่อจัดการ Yarn เวอร์ชัน (Node 20 มี Corepack มาให้แล้ว)
RUN corepack enable
# ถ้าอยากตรึงเวอร์ชัน yarn ชัดๆ (เช่น v3/berry) ให้ปลดคอมเมนต์
# RUN corepack prepare yarn@stable --activate

# คัดลอกไฟล์ที่จำเป็นสำหรับการติดตั้ง dependency (รวม lockfile)
COPY package.json yarn.lock ./

# ติดตั้ง dependencies แบบ reproducible
RUN yarn install --frozen-lockfile

# คัดลอกซอร์สโค้ดทั้งหมด
COPY . .

# สร้าง Prisma Client และ build NestJS
RUN npx prisma generate
# หรือจะใช้: RUN yarn prisma generate
RUN yarn build

# --- 2) Production Stage ---
FROM node:20-alpine AS prod
# Prisma runtime บน Alpine
RUN apk add --no-cache openssl libc6-compat

WORKDIR /app

# คัดลอกของที่จำเป็นจาก builder
COPY --from=builder /app/package.json /app/yarn.lock ./
COPY --from=builder /app/node_modules ./node_modules   # เก็บ prisma CLI ไว้ใช้ตอน runtime
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/prisma ./prisma

ENV NODE_ENV=production
EXPOSE 4000

# ค่า default (workflow ของคุณจะ override อยู่แล้ว)
CMD ["node", "dist/src/main.js"]
