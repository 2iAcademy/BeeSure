import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { IncidentService } from './incident.service';
import { Incident } from './entities/incident.entity';

@Module({
    imports: [TypeOrmModule.forFeature([Incident])],
    providers: [IncidentService],
    exports: [IncidentService],
})
export class UsersModule {}