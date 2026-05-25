import { Injectable, OnModuleInit, OnModuleDestroy, Logger } from '@nestjs/common';
import Redis from 'ioredis';

@Injectable()
export class RedisService implements OnModuleInit, OnModuleDestroy {
  private client: Redis;
  private readonly logger = new Logger('RedisService');

  onModuleInit() {
    const host = process.env.REDIS_HOST || 'localhost';
    const port = Number(process.env.REDIS_PORT) || 6379;

    this.logger.log(`Connecting to Redis at ${host}:${port}...`);
    this.client = new Redis({
      host,
      port,
      maxRetriesPerRequest: 3,
      retryStrategy: (times) => {
        const delay = Math.min(times * 100, 2000);
        return delay;
      },
    });

    this.client.on('connect', () => {
      this.logger.log('Successfully connected to Redis cache');
    });

    this.client.on('error', (err) => {
      this.logger.error('Redis Client Error:', err.message);
    });
  }

  onModuleDestroy() {
    this.client.disconnect();
  }

  async get(key: string): Promise<string | null> {
    try {
      return await this.client.get(key);
    } catch (err) {
      this.logger.error(`Error reading key "${key}" from Redis:`, err.message);
      return null;
    }
  }

  async set(key: string, value: string): Promise<void> {
    try {
      await this.client.set(key, value);
    } catch (err) {
      this.logger.error(`Error writing key "${key}" to Redis:`, err.message);
    }
  }

  async setex(key: string, seconds: number, value: string): Promise<void> {
    try {
      await this.client.setex(key, seconds, value);
    } catch (err) {
      this.logger.error(`Error writing key "${key}" with expiration to Redis:`, err.message);
    }
  }

  async del(key: string): Promise<void> {
    try {
      await this.client.del(key);
    } catch (err) {
      this.logger.error(`Error deleting key "${key}" from Redis:`, err.message);
    }
  }

  async exists(key: string): Promise<boolean> {
    try {
      const count = await this.client.exists(key);
      return count > 0;
    } catch (err) {
      this.logger.error(`Error checking existence of key "${key}" in Redis:`, err.message);
      return false;
    }
  }
}
