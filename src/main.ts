// main.ts
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

async function bootstrap() {
  const PORT = Number(process.env.PORT) || 4000;

  const app = await NestFactory.create(AppModule);

  console.log(`🚀 Server listening on port ${PORT}`);
  console.log(`📚 Swagger: /swagger`);
  console.log(`🔗 DATABASE_URL: ${process.env.DATABASE_URL || ''}`);

  app.enableCors({
    origin: [
      'http://localhost:3001', // dev frontend ของคุณ
      'http://13.229.80.189', // prod frontend (ถ้ามีโดเมนค่อยใส่โดเมนแทน IP)
    ],
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: false, // ถ้ามี cookie/credential ค่อยเปลี่ยนเป็น true
  });

  const config = new DocumentBuilder()
    .setTitle('Blog API')
    .setDescription('The blog API with NestJS + Prisma')
    .setVersion('1.0')
    .addServer('/api') // << สำคัญ
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('swagger', app, document);

  await app.listen(PORT);
}
bootstrap();
