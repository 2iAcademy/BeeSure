import {Injectable, NotFoundException, BadRequestException, UnauthorizedException, Logger} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Incident } from './entities/incident.entity';
import {CreateIncidentDto} from "./../auth/dto/create-incident.dto";

@Injectable()
export class IncidentService {

    private readonly logger = new Logger(IncidentService.name);
    constructor(
        @InjectRepository(Incident)
        private readonly incidentRepository: Repository<Incident>,
    ) {}



    /**
     * ✅ Créer un nouvel incident
     */
    async create(create_incident: CreateIncidentDto, userToken?: string){
        try {

            /* if (!userToken) {
                 throw new UnauthorizedException('Token utilisateur manquant.');
             }*/
            const incident : Incident = this.incidentRepository.create({
                ...create_incident,
                declared_at: new Date(),
                is_closed: false,
                validation_count: 0,
                negation_count: 0,
            });

            console.log(incident)

            this.logger.log(`Création d’un incident pour l’utilisateur ${create_incident.user_id}`);
          console.log(`Détails incident : ${JSON.stringify(incident, null, 2)}`);

            return await this.incidentRepository.save(incident);
        } catch (error) {
            console.log(error)

            throw new BadRequestException('Erreur lors de la création de l’incident.');
        }
    }

    /**
     * 🔍 Récupérer tous les incidents
     */
    async findAll(): Promise<Incident[]> {
        return this.incidentRepository.find({
            order: { declared_at: 'DESC' },
        });
    }

    /**
     * 🔍 Récupérer un incident par son ID
     */
    async findOne(id: number): Promise<Incident> {
        const incident = await this.incidentRepository.findOne({ where: { id } });

        if (!incident) {
            throw new NotFoundException(`Incident avec l’ID ${id} introuvable.`);
        }

        return incident;
    }

    /**
     * ✏️ Mettre à jour un incident
     */
    async update(id: number, updateData: Partial<Incident>): Promise<Incident> {
        const incident = await this.findOne(id);

        Object.assign(incident, updateData);

        return await this.incidentRepository.save(incident);
    }

    /**
     * ❌ Supprimer un incident
     */
    async remove(id: number): Promise<void> {
        const incident = await this.findOne(id);
        await this.incidentRepository.remove(incident);
    }

    /**
     * 🚨 Fermer un incident
     */
    async closeIncident(id: number): Promise<Incident> {
        const incident = await this.findOne(id);

        if (incident.is_closed) {
            throw new BadRequestException('Cet incident est déjà fermé.');
        }

        incident.is_closed = true;
        incident.closed_at = new Date();

        return this.incidentRepository.save(incident);
    }

    /**
     * ✅ Ajouter une validation à un incident
     */
    async addValidation(id: number): Promise<Incident> {
        const incident = await this.findOne(id);

        incident.validation_count += 1;

        // Optionnel : prolonger expire_incident_at selon la logique métier
        incident.expire_incident_at = this.extendExpiration(
            incident.expire_incident_at,
            incident.validation_count,
        );

        return this.incidentRepository.save(incident);
    }

    /**
     * ❌ Ajouter une négation (refus)
     */
    async addNegation(id: number): Promise<Incident> {
        const incident = await this.findOne(id);
        incident.negation_count += 1;
        return this.incidentRepository.save(incident);
    }

    /**
     * ⏳ Extension de la durée de validité selon le nombre de validations
     */
    private extendExpiration(currentDate: Date, validationCount: number): Date {
        const newDate = new Date(currentDate);

        if (validationCount <= 5) {
            newDate.setMinutes(newDate.getMinutes() + 15);
        } else if (validationCount <= 10) {
            newDate.setMinutes(newDate.getMinutes() + 10);
        } else if (validationCount <= 20) {
            newDate.setMinutes(newDate.getMinutes() + 5);
        }

        return newDate;
    }
}
