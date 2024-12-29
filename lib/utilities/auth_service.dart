import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;

  bool get isSignedInWithGoogle {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return false;
    }

    return currentUser.providerData
        .any((info) => info.providerId == 'google.com');
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error signing in with Google:$e');
      return null;
    }
  }

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print('Error signing in with email: $e');
      rethrow;
    }
  }

  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print('Error signing up with email: $e');
      rethrow;
    }
  }

  Future<UserCredential?> signOut() async {
    try {
      await _auth.signOut();

      if (isSignedInWithGoogle) {
        await _googleSignIn.signOut();
      }
    } catch (e) {
      print('Error Signing Out: $e');
      rethrow;
    }
  }
}
