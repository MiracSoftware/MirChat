import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _firebaseService.initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MirChat'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.message), text: 'SMS Mesajları'),
              Tab(icon: Icon(Icons.phone_callback), text: 'Arama Kayıtları'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSmsTab(),
            _buildCallsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildSmsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseService.getMessages(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text('Hata oluştu'));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return const Center(child: Text('Henüz SMS kaydı yok'));

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.sms)),
                title: Text(data['sender'] ?? 'Bilinmeyen Numara'),
                subtitle: Text(data['body'] ?? ''),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCallsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseService.getCalls(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text('Hata oluştu'));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return const Center(child: Text('Henüz arama kaydı yok'));

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.call_missed, color: Colors.white),
                ),
                title: Text(data['callerNumber'] ?? 'Gizli Numara'),
                subtitle: const Text('Gelen Arama Yakalandı'),
              ),
            );
          },
        );
      },
    );
  }
}