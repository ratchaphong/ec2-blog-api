# 📚 Blog API

RESTful API สำหรับระบบ Blog ที่รองรับการจัดการผู้ใช้, โปรไฟล์, โพสต์, หมวดหมู่, และคอมเมนต์  
สร้างด้วย **NestJS + Prisma + PostgreSQL** และมี **Swagger** สำหรับทดสอบ API

## 🚀 Features

- **User Management**: สมัครสมาชิก, จัดการข้อมูลผู้ใช้
- **Profile Management**: ข้อมูลโปรไฟล์แบบ 1-1 ต่อผู้ใช้
- **Post Management**: สร้าง/แก้ไข/ลบโพสต์, ตั้งสถานะ Published
- **Category Management**: จัดหมวดหมู่ของโพสต์ (Many-to-Many)
- **Comment System**: คอมเมนต์และการตอบกลับ (Nested Comments)
- **Swagger API Docs**: ทดสอบ API ได้ผ่านเบราว์เซอร์

## 🛠 Tech Stack

- **Backend**: [NestJS](https://nestjs.com/) + [Prisma ORM](https://www.prisma.io/)
- **Database**: PostgreSQL
- **API Docs**: Swagger
- **Container**: Docker & Docker Compose

## 📦 Installation

```bash
# 1. Clone repo
git clone <your-repo-url>
cd blog_api

# 2. ติดตั้ง dependencies
yarn install  # หรือ npm install

# 3. ตั้งค่า Environment variables
cp .env.example .env

# 4. รันด้วย Docker (PostgreSQL + Adminer)
docker compose up -d

# 5. รัน Prisma migration
npx prisma migrate dev

# 6. รันโปรเจกต์
yarn start:dev
```
