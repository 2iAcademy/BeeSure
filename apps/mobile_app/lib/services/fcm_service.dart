// lib/services/fcm_service.dart

import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FCMService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  String? _token;
  String? get token => _token;

  // Stream controllers pour notifier les listeners
  final _messageController = StreamController<RemoteMessage>.broadcast();
  final _tokenController = StreamController<String>.broadcast();

  Stream<RemoteMessage> get onMessage => _messageController.stream;
  Stream<String> get onTokenRefresh => _tokenController.stream;

  //==========================================================================
  // INITIALISATION
  //==========================================================================

  Future<void> initialize() async {
    print('🔥 FCMService: Initialisation...');

    // 1. Récupérer le token
    await _getToken();

    // 2. Écouter les changements de token
    _listenToTokenRefresh();

    // 3. Configurer les handlers de messages
    _setupMessageHandlers();

    print('✅ FCMService: Prêt');
  }

  //==========================================================================
  // GESTION DU TOKEN
  //==========================================================================

  Future<void> _getToken() async {
    try {
      _token = await _fcm.getToken();

      if (_token != null) {
        _tokenController.add(_token!);
        // TODO: Envoyer au backend
        // await _sendTokenToBackend(_token!);
      }
    } catch (e) {
      print('❌ Erreur récupération token: $e');
    }
  }

  void _listenToTokenRefresh() {
    _fcm.onTokenRefresh.listen((newToken) {
      _token = newToken;
      _tokenController.add(newToken);
      // TODO: Mettre à jour dans le backend
    });
  }

  //==========================================================================
  // HANDLERS DE MESSAGES
  //==========================================================================

  void _setupMessageHandlers() {
    // Messages foreground
    FirebaseMessaging.onMessage.listen((message) {
      _messageController.add(message);
    });

    // Tap sur notification (background)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessageTap(message);
    });

    // Vérifier message initial
    _checkInitialMessage();
  }

  Future<void> _checkInitialMessage() async {
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      print('🚀 App ouverte via notification');
      _handleMessageTap(initialMessage);
    }
  }

  void _handleMessageTap(RemoteMessage message) {
    // TODO: Naviguer vers la bonne page
    if (message.data.containsKey('zoneId')) {
      print('   → Navigation vers zone: ${message.data['zoneId']}');
      // Utiliser un GlobalKey<NavigatorState> ou GetIt pour naviguer
    }
  }

  //==========================================================================
  // MÉTHODES PUBLIQUES
  //==========================================================================

  /// Envoyer le token au backend
  Future<void> sendTokenToBackend() async {
    if (_token == null) {
      print('⚠️ Pas de token à envoyer');
      return;
    }

    try {
      // TODO: Implémenter l'appel API
      print('📤 Envoi token au backend...');
      // await _apiService.post('/users/me/fcm-token', {'token': _token});
      print('✅ Token envoyé');
    } catch (e) {
      print('❌ Erreur envoi token: $e');
    }
  }

  /// Rafraîchir le token manuellement
  Future<void> refreshToken() async {
    await _fcm.deleteToken();
    await _getToken();
  }

  //==========================================================================
  // CLEANUP
  //==========================================================================

  void dispose() {
    _messageController.close();
    _tokenController.close();
  }
}