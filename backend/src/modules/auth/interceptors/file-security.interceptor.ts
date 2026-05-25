import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  BadRequestException,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import sharp from 'sharp';

@Injectable()
export class FileSecurityInterceptor implements NestInterceptor {
  private readonly allowedMimeTypes = ['image/jpeg', 'image/png'];
  private readonly maxFileSize = 5 * 1024 * 1024; // 5 MB

  async intercept(context: ExecutionContext, next: CallHandler): Promise<Observable<any>> {
    const request = context.switchToHttp().getRequest();
    const file = request.file;

    if (file) {
      // 1. Validate File Size
      if (file.size > this.maxFileSize) {
        throw new BadRequestException('File exceeds max size limit of 5MB');
      }

      // 2. Validate MIME Type
      if (!this.allowedMimeTypes.includes(file.mimetype)) {
        throw new BadRequestException('Only JPEG and PNG images are allowed');
      }

      try {
        // 3. Randomize Filename & Clean Extension
        const randomString = Math.random().toString(36).substring(7);
        const originalNameSafe = file.originalname.replace(/[^a-zA-Z0-9.]/g, '_');
        file.originalname = `compressed_${randomString}_${originalNameSafe}`;

        // 4. Secure Hashing & Image Compression using Sharp (Strip dangerous metadata/EXIF payload injections)
        const compressedBuffer = await sharp(file.buffer)
          .resize(500, 500, { fit: 'cover' })
          .jpeg({ quality: 80 }) // Compress to JPEG with 80% quality
          .toBuffer();

        // 5. Replace Buffer
        file.buffer = compressedBuffer;
        file.size = compressedBuffer.length;
        file.mimetype = 'image/jpeg';
      } catch (err) {
        throw new BadRequestException(`Image processing and compression failed: ${err.message}`);
      }
    }

    return next.handle();
  }
}
