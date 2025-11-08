import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class userdataprovider with ChangeNotifier {
  Map<String, dynamic>? _userData;
  Future userdata() async {
    try {
      var currentUserid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserid)
          .get();
      var user = snap.data() as Map<String, dynamic>;
      _userData = user;

      notifyListeners();
      return _userData;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      _userData = null; // Clear cached user data
      notifyListeners();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
