import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../services/fcm_service.dart';

class FCMTestScreen extends StatefulWidget {
  const FCMTestScreen({Key? key}) : super(key: key);

  @override
  State<FCMTestScreen> createState() => _FCMTestScreenState();
}

class _FCMTestScreenState extends State<FCMTestScreen> {
  String _lastMessage = 'Aucun message reçu';
  int _messageCount = 0;
  late FCMService _fcmService;

  @override
  void initState() {
    super.initState();
    _fcmService = context.read<FCMService>();
    _initializeFCM();
  }

  Future<void> _initializeFCM() async {
    await _fcmService.initialize();

    // Écouter les messages
    _fcmService.onMessage.listen((message) {
      setState(() {
        _messageCount++;
        _lastMessage = '${message.notification?.title ?? 'Sans titre'}\n'
                      '${message.notification?.body ?? 'Sans contenu'}';
      });

      // Afficher SnackBar
      _showMessageSnackBar(message);
    });
  }

  void _showMessageSnackBar(RemoteMessage message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.notification?.title ?? 'Notification',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(message.notification?.body ?? ''),
          ],
        ),
        backgroundColor: Colors.blue[700],
        duration: Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _copyToken() {
    final token = _fcmService.token;
    if (token != null) {
      Clipboard.setData(ClipboardData(text: token));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Token copié !'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = _fcmService.token ?? 'Récupération...';

    return Scaffold(
      appBar: AppBar(
        title: Text('BeSecure - Test FCM'),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              await _fcmService.refreshToken();
              setState(() {});
            },
            tooltip: 'Rafraîchir token',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StatusCard(),
            SizedBox(height: 20),
            _StatsCard(messageCount: _messageCount, hasToken: token != 'Récupération...'),
            SizedBox(height: 20),
            _TokenCard(token: token, onCopy: _copyToken),
            SizedBox(height: 20),
            _LastMessageCard(message: _lastMessage),
            SizedBox(height: 20),
            _InstructionsCard(),
          ],
        ),
      ),
    );
  }
}

//==============================================================================
// WIDGETS COMPOSANTS
//==============================================================================

class _StatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Firebase Connecté', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Cloud Messaging actif', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final int messageCount;
  final bool hasToken;

  const _StatsCard({required this.messageCount, required this.hasToken});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.blue[50],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(Icons.notifications_active, 'Messages', messageCount.toString(), Colors.blue),
            Container(width: 1, height: 40, color: Colors.grey[300]),
            _StatItem(Icons.phone_android, 'Token', hasToken ? 'OK' : 'N/A', hasToken ? Colors.green : Colors.orange),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem(this.icon, this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }
}

class _TokenCard extends StatelessWidget {
  final String token;
  final VoidCallback onCopy;

  const _TokenCard({required this.token, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.vpn_key, color: Colors.blue),
                SizedBox(width: 8),
                Text('FCM Token', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: SelectableText(
                token,
                style: TextStyle(fontSize: 11, fontFamily: 'monospace', color: Colors.blue[900]),
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onCopy,
                icon: Icon(Icons.copy, size: 18),
                label: Text('Copier le token'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LastMessageCard extends StatelessWidget {
  final String message;

  const _LastMessageCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.message, color: Colors.orange),
                SizedBox(width: 8),
                Text('Dernier Message', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    message == 'Aucun message reçu' ? Icons.info_outline : Icons.check_circle_outline,
                    color: Colors.orange[700],
                  ),
                  SizedBox(width: 12),
                  Expanded(child: Text(message, style: TextStyle(color: Colors.orange[900]))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InstructionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.green[50],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.green[700]),
                SizedBox(width: 8),
                Text('Comment tester ?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green[900])),
              ],
            ),
            SizedBox(height: 12),
            _InstructionStep('1', 'Copie le token ci-dessus'),
            _InstructionStep('2', 'Va sur Firebase Console'),
            _InstructionStep('3', 'Cloud Messaging → Send test message'),
            _InstructionStep('4', 'Colle le token et envoie !'),
          ],
        ),
      ),
    );
  }
}

class _InstructionStep extends StatelessWidget {
  final String number;
  final String text;

  const _InstructionStep(this.number, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(color: Colors.green[700], shape: BoxShape.circle),
            child: Center(
              child: Text(number, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(color: Colors.green[900], fontSize: 14))),
        ],
      ),
    );
  }
}