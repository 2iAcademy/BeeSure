import {
  Controller,
  Post,
  Body,
  Param,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { NotificationsService } from './notifications.service';
import { Public } from '../common/decorators/public.decorator';

@Controller('notifications')
export class NotificationsController {
  constructor(private readonly notificationsService: NotificationsService) {}

  @Public()
  @Post('test/:userId')
  @HttpCode(HttpStatus.OK)
  async sendTestNotification(
    @Param('userId') userId: string,
  ): Promise<{ message: string; success: boolean }> {
    const result = await this.notificationsService.sendTestNotification(userId);
    return result;
  }

  @Public()
  @Post('zone-alert')
  @HttpCode(HttpStatus.OK)
  async sendZoneAlert(
    @Body()
    body: {
      userIds: string[];
      zoneId: string;
      zoneType: string;
      distance: number;
    },
  ): Promise<{ sent: number; failed: number }> {
    return this.notificationsService.sendZoneAlert(
      body.userIds,
      body.zoneId,
      body.zoneType,
      body.distance,
    );
  }
}
