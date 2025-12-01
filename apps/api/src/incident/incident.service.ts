import {Injectable, NotFoundException, BadRequestException, UnauthorizedException, Logger} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Incident } from './entities/incident.entity';
import {CreateIncidentDto} from "./../auth/dto/create-incident.dto";
import {JwtPayload} from "../auth/auth.service";
import {authorize} from "passport";

@Injectable()
export class IncidentService {

    private readonly logger = new Logger(IncidentService.name);
    private readonly jwt : JwtPayload;
    constructor(
        @InjectRepository(Incident)
        private readonly incidentRepository: Repository<Incident>,
    ) {}

    async create(create_incident: CreateIncidentDto, req : Request){
        try {

           console.log(req.headers['authorization'])
            // String user_id = jwt.decode()

            const incident : Incident = this.incidentRepository.create({
                ...create_incident,
                declared_at: new Date(),
                closed_at: new Date(Date.now() + 60 * 60 * 1000),
                is_closed: false,
                validation_count: 0,
                negation_count: 0,
            });

            console.log(incident)

            return await this.incidentRepository.save(incident);
        } catch (error) {
            console.log(error)

            throw new BadRequestException('Erreur lors de la création de l’incident.');
        }
    }

    async findAll(): Promise<Incident[]> {
        return this.incidentRepository.find({
            order: { declared_at: 'DESC' },
        });
    }

    async findOne(id: number): Promise<Incident> {
        const incident = await this.incidentRepository.findOne({ where: { id } });

        if (!incident) {
            throw new NotFoundException(`Incident avec l’ID ${id} introuvable.`);
        }
        return incident;
    }

    async update(id: number, updateData: Partial<Incident>): Promise<Incident> {
        const incident = await this.findOne(id);

        Object.assign(incident, updateData);

        return await this.incidentRepository.save(incident);
    }

    async remove(id: number): Promise<void> {
        const incident = await this.findOne(id);
        await this.incidentRepository.remove(incident);
    }

    async closeIncident(id: number): Promise<Incident> {
        const incident = await this.findOne(id);

        if (incident.is_closed) {
            throw new BadRequestException('Cet incident est déjà fermé.');
        }

        incident.is_closed = true;
        incident.closed_at = new Date();

        return this.incidentRepository.save(incident);
    }

    async addValidation(id: number): Promise<{ message: string; incident: Incident }> {
        const incident = await this.findOne(id);
        if (!incident) throw new BadRequestException('Incident introuvable');

        incident.validation_count = Number(incident.validation_count) + 1;

        this.addValidationTime(incident);

        const updatedIncident = await this.incidentRepository.save(incident);

        return {
            message: `✅ Validation prise en compte. L’incident #${updatedIncident.id} a maintenant ${updatedIncident.validation_count} validation(s).`,
            incident: updatedIncident,
        };
    }

    async addNegation(id: number): Promise<{ message: string; incident: Incident }> {
        const incident = await this.findOne(id);
        incident.negation_count = Number(incident.negation_count) + 1;

        this.subtractNegationTime(incident)

        const updatedIncident = await this.incidentRepository.save(incident);

        return {
            message: `✅ Négation est  prise en compte. L’incident #${updatedIncident.id} a maintenant ${updatedIncident.negation_count} validation(s).`,
            incident: updatedIncident,
        };
    }


    private addValidationTime(incident: Incident): Incident {
        const { validation_count } = incident;
        let additionalMinutes = 0;

        if (validation_count <= 5) additionalMinutes = 15;
        else if (validation_count <= 10) additionalMinutes = 10;
        else if (validation_count <= 20) additionalMinutes = 5;
        else additionalMinutes = 0;

        if (additionalMinutes > 0) {
            incident.closed_at = new Date(
                incident.closed_at.getTime() + additionalMinutes * 60000,
            );
        }

        return incident;
    }
    private subtractNegationTime(incident: Incident): Incident {
        const { negation_count } = incident;

        if (negation_count >= 4) {
            // Clôture immédiate
            incident.is_closed = true;
            incident.closed_at = new Date();
        } else {
            // Retire 20 minutes par négation
            incident.closed_at = new Date(
                incident.closed_at.getTime() - 20 * 60000,
            );
        }

        return incident;
    }
}
