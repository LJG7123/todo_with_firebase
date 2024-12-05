import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_with_firebase/models/user_model.dart';

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

  Future<UserModel> signInUser(String email, String password) async {
    userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    var snapshot = await _firestore
        .collection("users")
        .where("email", isEqualTo: userCredential?.user?.email)
        .get();
    var userData = snapshot.docs.first.data();
    return UserModel(name: userData["name"], email: userData["email"]);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
