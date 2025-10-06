import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    Index,
    CreateDateColumn,
    UpdateDateColumn,
} from 'typeorm';
import { v4 as uuidv4 } from 'uuid';

@Entity('INCIDENT')
export class Incident {
    @PrimaryGeneratedColumn('increment', { type: 'bigint' })
    id: number;

    @Index('incident_validation_id_index')
    @Column({ type: 'uuid', nullable: false, default: () => `'${uuidv4()}'` })
    validation_id: string;

    @Index('incident_user_id_index')
    @Column({ type: 'uuid', nullable: false })
    user_id: string;

    @Index('incident_type_id_index')
    @Column({ type: 'uuid', nullable: false })
    type_id: string;

    @Index('incident_declared_at_index')
    @Column({ type: 'timestamp', nullable: false })
    declared_at: Date;

    @Index('incident_closed_at_index')
    @Column({ type: 'timestamp', nullable: true })
    closed_at: Date | null;

    @Column({ type: 'text', nullable: false })
    description: string;

    // 🗺️ Localisation : latitude et longitude
    @Column({ type: 'float', nullable: false })
    location_latt: number;

    @Column({ type: 'float', nullable: false })
    location_long: number;

    @Column({ type: 'boolean', default: false })
    is_closed: boolean;

    /**
     * ⏳ expire_incident_at :
     * Les 5 premières validations ajoutent 15 minutes chacune.
     * Les validations 6 à 10 ajoutent 10 minutes chacune.
     * Les validations suivantes (11 à 20) ajoutent 5 minutes chacune.
     * Au-delà de 20 validations, aucune durée n’est ajoutée.
     */
    @Column({
        type: 'timestamp',
        nullable: false,
        default: () => "CURRENT_TIMESTAMP + interval '1 hour'",
        comment:
            'Les 5 premières validations ajoutent 15 minutes chacune. ' +
            'Les validations 6 à 10 ajoutent 10 minutes chacune. ' +
            'Les validations suivantes (11 à 20) ajoutent 5 minutes chacune. ' +
            'Au-delà de 20 validations, aucune durée n’est ajoutée.',
    })
    expire_incident_at: Date;

    @Column({ type: 'bigint', default: 0 })
    validation_count: number;

    @Column({ type: 'bigint', default: 0 })
    negation_count: number;
}
