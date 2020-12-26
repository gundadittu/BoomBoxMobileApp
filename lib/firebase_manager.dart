import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_functions/cloud_functions.dart';

class FirebaseManager { 
  static FirebaseApp shared; 
  static FirebaseFunctions functions = FirebaseFunctions.instance; 
  static FirebaseFirestore firestore = FirebaseFirestore.instance;  
}