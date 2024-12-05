import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final instance = AuthService();
  UserCredential? userCredential;

  Future<void> signUpUser(String name, String email, String password) async {
    userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    await _firestore.collection("users").doc(userCredential!.user!.uid).set({
      "name": name,
      "email": email,
    });
  }

  Future<void> signInUser(String email, String password) async {
    userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
