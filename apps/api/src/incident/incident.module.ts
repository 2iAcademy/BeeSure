import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { IncidentService } from './incident.service';
import { Incident } from './entities/incident.entity';
import {IncidentController} from "../controller/incident.controller";

@Module({
    imports: [TypeOrmModule.forFeature([Incident])],
    controllers: [IncidentController],
    providers: [IncidentService],
    exports: [IncidentService],
})

export class IncidentModule {}