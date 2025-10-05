import { Module, Global } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import * as admin from 'firebase-admin';
import { FCMService } from './fcm.service';

@Global()
@Module({
  imports: [ConfigModule],
  providers: [
    {
      provide: 'FIREBASE_ADMIN',
      useFactory: () => {
        const serviceAccount = require('../config/firebase-admin-key.json');

        return admin.initializeApp({
          credential: admin.credential.cert(serviceAccount),
          projectId: 'beesure-472509',
        });
      },
    },
    FCMService,
  ],
  exports: ['FIREBASE_ADMIN', FCMService],
})
export class FirebaseModule {}
