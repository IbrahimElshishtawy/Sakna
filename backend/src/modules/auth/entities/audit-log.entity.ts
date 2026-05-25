import {
  Entity,
  PrimaryColumn,
  Column,
  CreateDateColumn,
} from 'typeorm';

@Entity('audit_logs')
export class AuditLogEntity {
  @PrimaryColumn({ type: 'varchar', length: 50 })
  id: string;

  @Column({ type: 'varchar', length: 50, nullable: true })
  userId: string | null;

  @Column({ type: 'varchar', length: 50 })
  action: string;

  @Column({ type: 'varchar', length: 45 })
  ipAddress: string;

  @Column({ type: 'varchar', length: 500 })
  userAgent: string;

  @Column({ type: 'text', nullable: true })
  metadata: string | null; // Stores stringified JSON details

  @CreateDateColumn()
  createdAt: Date;

  constructor(partial: Partial<AuditLogEntity>) {
    Object.assign(this, partial);
  }
}
