import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:phone_lap/models/analyzer.dart';

class AnalyzerProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userId;
  Analyzer? analyzer;
  Future<bool> addAnlayzer(Analyzer analyzer) async {
    try {
      await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .set(analyzer.toMap());
      this.analyzer = analyzer;
      notifyListeners();
      return true;
    } catch (e) {
      notifyListeners();
      return false;
    }
  }

  void getData(String? uid) {
    this.userId = uid;
    notifyListeners();
  }

  Future<Analyzer?>? getAnalyzer([String? id]) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await _firestore.collection('users').doc(id ?? userId).get();

    analyzer = Analyzer.fromMap(doc.data()!);

    notifyListeners();
    return analyzer;
  }

  void clear() {
    this.userId = null;
    this.analyzer = null;
    notifyListeners();
  }
}
