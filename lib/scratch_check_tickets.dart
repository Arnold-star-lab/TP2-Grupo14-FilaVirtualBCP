import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  final firestore = FirebaseFirestore.instance;
  
  print('--- TICKETS FOR 12345678 ---');
  final tickets = await firestore.collection('tickets').where('userDni', isEqualTo: '12345678').get();
  for(var doc in tickets.docs) {
    print('Ticket: ${doc.id} | Status: ${doc.data()['status']} | Num: ${doc.data()['ticketNumber']}');
  }
}
