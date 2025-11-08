import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagramer/models/user_model.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<model.User> getUserDetails() async {
    String currentuser = _auth.currentUser!.uid;

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentuser)
        .get();
    return model.User.fromSnap(documentSnapshot);
  }

  Future<String> signUp({
    required String email,
    required String password,
    required String username,
    required String bio,
  }) async {
    String res = 'Some errors occurred';
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        model.User newUser = model.User(
          uid: cred.user!.uid,
          email: email,
          username: username,
          bio: bio,
          photoUrl:
              'https://www.shutterstock.com/image-vector/blank-avatar-photo-place-holder-600nw-1114445501.jpg', // You can set a default profile image URL
          followers: [],
          following: [],
        );

        await _firebaseFirestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(newUser.toJson());

        return res = 'succeed';
      } else {
        res = 'Please fill in all the fields';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Sign in with Google
  Future<String> signinWithGoogle(BuildContext context) async {
    String res = 'Some errors occurred';
    try {
      // Force sign-out to always show account chooser
      await _googleSignIn.signOut();
      // Start the Google sign-in process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return 'sing in canceled';
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google [UserCredential]
      await _auth.signInWithCredential(credential);
      res = 'succeed';
    } on FirebaseAuthException catch (e) {
      // Handle error with Firebase authentication
      _showErrorDialog(
          context, e.message ?? 'An error occurred during Google Sign-In.');
    } catch (e) {
      _showErrorDialog(context, e.toString());
      print(e.toString());
    }
    return res;
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    String res = 'Some errors occurred';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'succeed';
      } else {
        res = 'Please fill in all the fields';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Show error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Sign out
  Future<void> singout() async {
    return await _auth.signOut();
  }
}
