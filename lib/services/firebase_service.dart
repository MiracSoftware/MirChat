import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // FCM Bildirim İzni ve Token Alma
  Future<void> initNotification() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await _fcm.getToken();
      print("FCM Token: $token");
    }
  }

  // J7 Prime'dan Gelen SMS'i Firestore'a Kaydetme
  Future<void> saveSms({required String sender, required String body}) async {
    await _db.collection('messages').add({
      'sender': sender,
      'body': body,
      'timestamp': FieldValue.serverTimestamp(),
      'device': 'J7 Prime',
    });
  }

  // J7 Prime'dan Gelen Aramayı Firestore'a Kaydetme
  Future<void> saveCallLog({required String callerNumber}) async {
    await _db.collection('calls').add({
      'callerNumber': callerNumber,
      'timestamp': FieldValue.serverTimestamp(),
      'device': 'J7 Prime',
    });
  }

  // Anlık Mesajları Dinleme Stream'i
  Stream<QuerySnapshot> getMessages() {
    return _db
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Anlık Arama Kayıtlarını Dinleme Stream'i
  Stream<QuerySnapshot> getCalls() {
    return _db
        .collection('calls')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}