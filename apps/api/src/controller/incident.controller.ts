import {
    Controller,
    Get,
    Post,
    Patch,
    Delete,
    Param,
    Body,
    ParseIntPipe,
    HttpCode,
    HttpStatus, UseGuards, Req,
} from '@nestjs/common';
import { IncidentService } from './../incident/incident.service';
import { Incident } from './../incident/entities/incident.entity';
import {Public} from "../common/decorators/public.decorator";
import {Throttle, ThrottlerGuard} from "@nestjs/throttler";
import {RATE_LIMIT} from "../common/constants/app.constants";
import {CreateIncidentDto} from "../auth/dto/create-incident.dto";

@Controller('incidents')
export class IncidentController {
    constructor(private readonly incidentService: IncidentService) {}


    @Public()
    @UseGuards(ThrottlerGuard)
    @Throttle({
        default: { limit: RATE_LIMIT.AUTH_LIMIT, ttl: RATE_LIMIT.AUTH_TTL },
    })
    @Post( 'create_incident')
    async create(@Body() createIncidentDto: CreateIncidentDto, @Req() req) {

        console.log("hello j'envoie un incident");
        return this.incidentService.create(createIncidentDto, req);
    }

    @Public()
    @Get('all')
    async findAll(): Promise<Incident[]> {
        return this.incidentService.findAll();
    }

    @Public()
    @Get(':id')
    async findOne(
        @Param('id', ParseIntPipe) id: number): Promise<Incident> {

        return this.incidentService.findOne(id);
    }

    @Public()
    @Patch(':id')
    async update(
        @Param('id', ParseIntPipe) id: number,
        @Body() updateData: Partial<Incident>,
    ): Promise<Incident> {
        return this.incidentService.update(id, updateData);
    }

    @Delete(':id')
    @HttpCode(HttpStatus.NO_CONTENT)
    async remove(@Param('id', ParseIntPipe) id: number): Promise<void> {
        return this.incidentService.remove(id);
    }

    @Patch(':id/close')
    async closeIncident(@Param('id', ParseIntPipe) id: number): Promise<Incident> {
        return this.incidentService.closeIncident(id);
    }

    @Public()
    @Patch(':id/validate')
    async addValidation(@Param('id', ParseIntPipe) id: number): Promise<{ message: string; incident: Incident }> {
        return this.incidentService.addValidation(id);
    }

    @Public()
    @Patch(':id/negate')
    async addNegation(@Param('id', ParseIntPipe) id: number): Promise<{ message: string; incident: Incident }> {
        return this.incidentService.addNegation(id);
    }
}
