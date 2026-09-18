import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  final firestore = FirebaseFirestore.instance;
  
  print('--- CHECKING QUEUE STATUS ---');
  final statusDoc = await firestore.collection('queue').doc('status').get();
  print('Status: ${statusDoc.data()}');
  
  print('--- CHECKING ALL TICKETS ---');
  final tickets = await firestore.collection('tickets').get();
  print('Total tickets: ${tickets.docs.length}');
  
  for(var doc in tickets.docs) {
    print('Ticket: ${doc.id} | Status: ${doc.data()['status']}');
  }
  
  // Reseteamos el estado global
  await firestore.collection('queue').doc('status').set({
    'currentAttending': 0,
    'estimatedWaitTimeMinutes': 0,
    'lastUpdatedAt': FieldValue.serverTimestamp(),
    'maxTicketGenerated': 0,
  });
  print('--- QUEUE RESET TO 0 ---');
  
  // Borramos tickets huerfanos (opcional)
  for(var doc in tickets.docs) {
     await firestore.collection('tickets').doc(doc.id).delete();
  }
  print('--- TICKETS DELETED ---');
}
