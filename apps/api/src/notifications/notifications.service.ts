import {
  Injectable,
  Logger,
  NotFoundException,
  InternalServerErrorException,
} from '@nestjs/common';
import { FCMService } from '../firebase/fcm.service';
import { UsersService } from '../users/users.service';

@Injectable()
export class NotificationsService {
  private readonly logger = new Logger(NotificationsService.name);

  constructor(
    private readonly fcmService: FCMService,
    private readonly usersService: UsersService,
  ) {}

  /**
   * Envoie une notification de test à un utilisateur
   */
  async sendTestNotification(
    userId: string,
  ): Promise<{ message: string; success: boolean }> {
    try {
      this.logger.log(`Envoi de notification test à l'utilisateur ${userId}`);

      const user = await this.usersService.findById(userId);
      if (!user) {
        throw new NotFoundException('Utilisateur non trouvé');
      }

      if (!user.fcmToken) {
        this.logger.warn(
          `L'utilisateur ${userId} n'a pas de token FCM configuré`,
        );
        return {
          message: 'Utilisateur sans token FCM',
          success: false,
        };
      }

      await this.fcmService.sendToUser(
        user.fcmToken,
        {
          title: 'Test de notification',
          body: 'Ceci est une notification de test depuis BeSecure',
        },
        {
          type: 'test',
          userId: userId,
        },
      );

      this.logger.log(`Notification test envoyée avec succès à ${userId}`);
      return {
        message: 'Notification envoyée avec succès',
        success: true,
      };
    } catch (error) {
      this.logger.error(
        `Erreur lors de l'envoi de la notification test à ${userId}: ${error.message}`,
        error.stack,
      );
      throw new InternalServerErrorException(
        'Erreur lors de l\'envoi de la notification',
      );
    }
  }

  /**
   * Envoie une alerte de zone à plusieurs utilisateurs
   */
  async sendZoneAlert(
    userIds: string[],
    zoneId: string,
    zoneType: string,
    distance: number,
  ): Promise<{ sent: number; failed: number }> {
    try {
      this.logger.log(
        `Envoi d'alerte de zone ${zoneId} (${zoneType}) à ${userIds.length} utilisateurs`,
      );

      if (!userIds || userIds.length === 0) {
        this.logger.warn('Aucun utilisateur spécifié pour l\'alerte de zone');
        return { sent: 0, failed: 0 };
      }

      // Récupérer les utilisateurs
      const users = await this.usersService.findUsersByIds(userIds);
      this.logger.log(`${users.length} utilisateurs trouvés sur ${userIds.length} demandés`);

      // Filtrer les utilisateurs avec token FCM
      const usersWithToken = users.filter((user) => user.fcmToken);
      const usersWithoutToken = users.filter((user) => !user.fcmToken);

      if (usersWithoutToken.length > 0) {
        this.logger.warn(
          `${usersWithoutToken.length} utilisateurs sans token FCM: ${usersWithoutToken.map((u) => u.id).join(', ')}`,
        );
      }

      if (usersWithToken.length === 0) {
        this.logger.warn('Aucun utilisateur avec token FCM valide');
        return { sent: 0, failed: userIds.length };
      }

      // Préparer le message personnalisé selon le type de zone
      const notification = this.buildZoneNotification(
        zoneType,
        distance,
      );
      const data = {
        type: 'zone_alert',
        zoneId,
        zoneType,
        distance: distance.toString(),
      };

      // Extraire les tokens
      const tokens = usersWithToken.map((user) => user.fcmToken);

      // Envoyer les notifications
      await this.fcmService.sendToMultipleUsers(tokens, notification, data);

      const sent = usersWithToken.length;
      const failed = userIds.length - sent;

      this.logger.log(
        `Alerte de zone envoyée: ${sent} succès, ${failed} échecs`,
      );

      return { sent, failed };
    } catch (error) {
      this.logger.error(
        `Erreur lors de l'envoi de l'alerte de zone: ${error.message}`,
        error.stack,
      );
      throw new InternalServerErrorException(
        'Erreur lors de l\'envoi de l\'alerte de zone',
      );
    }
  }

  /**
   * Construit le message de notification selon le type de zone
   */
  private buildZoneNotification(
    zoneType: string,
    distance: number,
  ): { title: string; body: string } {
    const distanceText = distance < 1000
      ? `${Math.round(distance)}m`
      : `${(distance / 1000).toFixed(1)}km`;

    switch (zoneType) {
      case 'risk':
        return {
          title: '⚠️ Zone à risque détectée',
          body: `Une zone à risque se trouve à ${distanceText} de votre position`,
        };
      case 'prevention':
        return {
          title: '🛡️ Zone de prévention',
          body: `Zone de prévention à ${distanceText} - Restez vigilant`,
        };
      case 'validated':
        return {
          title: '✓ Zone validée',
          body: `Zone validée à ${distanceText} de votre position`,
        };
      default:
        return {
          title: '📍 Alerte de zone',
          body: `Une zone importante se trouve à ${distanceText}`,
        };
    }
  }
}
