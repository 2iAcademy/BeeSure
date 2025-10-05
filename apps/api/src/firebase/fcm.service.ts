import { Injectable, Inject, Logger } from '@nestjs/common';
import * as admin from 'firebase-admin';

@Injectable()
export class FCMService {
  private readonly logger = new Logger(FCMService.name);

  constructor(
    @Inject('FIREBASE_ADMIN') private readonly firebaseAdmin: admin.app.App,
  ) {}

  /**
   * Envoie une notification push à un utilisateur
   */
  async sendToUser(
    fcmToken: string,
    notification: { title: string; body: string },
    data?: Record<string, string>,
  ): Promise<void> {
    try {
      const message: admin.messaging.Message = {
        token: fcmToken,
        notification: {
          title: notification.title,
          body: notification.body,
        },
        data: data || {},
        android: {
          priority: 'high',
          notification: {
            sound: 'default',
          },
        },
        apns: {
          payload: {
            aps: {
              contentAvailable: true,
              sound: 'default',
            },
          },
        },
      };

      const response = await this.firebaseAdmin.messaging().send(message);
      this.logger.log(
        `Notification envoyée avec succès: ${response} pour token: ${fcmToken.substring(0, 10)}...`,
      );
    } catch (error) {
      this.handleSendError(error, fcmToken);
    }
  }

  /**
   * Envoie une notification push à plusieurs utilisateurs
   */
  async sendToMultipleUsers(
    tokens: string[],
    notification: { title: string; body: string },
    data?: Record<string, string>,
  ): Promise<void> {
    if (tokens.length === 0) {
      this.logger.warn('Aucun token FCM fourni pour l\'envoi multiple');
      return;
    }

    try {
      const message: admin.messaging.MulticastMessage = {
        tokens,
        notification: {
          title: notification.title,
          body: notification.body,
        },
        data: data || {},
        android: {
          priority: 'high',
          notification: {
            sound: 'default',
          },
        },
        apns: {
          payload: {
            aps: {
              contentAvailable: true,
              sound: 'default',
            },
          },
        },
      };

      const response = await this.firebaseAdmin
        .messaging()
        .sendEachForMulticast(message);

      this.logger.log(
        `Notifications envoyées: ${response.successCount}/${tokens.length} succès`,
      );

      // Log des erreurs individuelles
      if (response.failureCount > 0) {
        response.responses.forEach((resp, idx) => {
          if (!resp.success) {
            const errorCode = resp.error?.code || 'unknown';
            const token = tokens[idx];
            this.logger.error(
              `Échec envoi pour token ${token.substring(0, 10)}...: ${errorCode}`,
            );
          }
        });
      }
    } catch (error) {
      this.logger.error(
        `Erreur lors de l'envoi multiple de notifications: ${error.message}`,
        error.stack,
      );
      throw error;
    }
  }

  /**
   * Gère les erreurs d'envoi de notification
   */
  private handleSendError(error: any, token: string): void {
    const errorCode = error?.code || 'unknown';
    const truncatedToken = token.substring(0, 10) + '...';

    switch (errorCode) {
      case 'messaging/invalid-registration-token':
        this.logger.error(
          `Token FCM invalide: ${truncatedToken} - Code: ${errorCode}`,
        );
        break;
      case 'messaging/registration-token-not-registered':
        this.logger.error(
          `Token FCM non enregistré: ${truncatedToken} - Code: ${errorCode}`,
        );
        break;
      case 'messaging/invalid-argument':
        this.logger.error(
          `Argument invalide pour le token: ${truncatedToken} - Code: ${errorCode}`,
        );
        break;
      default:
        this.logger.error(
          `Erreur d'envoi FCM pour ${truncatedToken} - Code: ${errorCode} - Message: ${error.message}`,
          error.stack,
        );
    }

    throw error;
  }
}
