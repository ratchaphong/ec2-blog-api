// prisma/seed.ts
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  // ลบข้อมูลเก่า (เลือกใส่ถ้าต้องการ reset)
  await prisma.comment.deleteMany();
  await prisma.post.deleteMany();
  await prisma.profile.deleteMany();
  await prisma.user.deleteMany();

  // สร้างผู้ใช้
  const user = await prisma.user.create({
    data: {
      id: '1d2c3b4a-5e6f-7g8h-9i0j-k1l2m3n4o5p6', // กำหนด ID ชัดเจนเพื่อใช้ทดสอบ
      name: 'Alice Example',
      email: 'alice@example.com',
    },
  });

  console.log('✅ Seeded user:', user);
}

main()
  .catch((e) => {
    console.error('❌ Error seeding:', e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
