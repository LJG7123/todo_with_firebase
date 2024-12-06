import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_with_firebase/models/user_model.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
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
    return UserModel.fromJson(userData);
  }

  Future<void> resetPassword(String email) async {
    _auth.sendPasswordResetEmail(email: email);
  }

  Future<UserModel> signInWithGoogle() async {
    final googleAccount = await _googleSignIn.signIn();
    if (googleAccount == null) {
      throw Exception('Google Login Failed');
    }
    final googleAuth = await googleAccount.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    userCredential = await _auth.signInWithCredential(credential);

    return UserModel(
        name: googleAccount.displayName ?? 'null',
        email: googleAccount.email,
        isSocialSignedIn: true);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
