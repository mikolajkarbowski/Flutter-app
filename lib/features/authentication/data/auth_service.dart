import 'package:firebase_auth/firebase_auth.dart';

enum SignInResult {
  invalidEmail,
  userDisabled,
  userNotFound,
  wrongPassword,
  success,
}

class AuthService {
  AuthService({required this.firebaseInstance});
  final FirebaseAuth firebaseInstance;
  bool get isSignedIn => currentUser != null;

  Stream<bool> get isSignedInStream =>
      firebaseInstance.userChanges().map((user) => user != null);

  String get userEmail => currentUser!.email!;

  String get userName => currentUser!.displayName!;

  User? get currentUser => firebaseInstance.currentUser;

  Future<SignInResult> signInWithEmail(String email, String password) async {
    try {
      if (isSignedIn) {
        await firebaseInstance.signOut();
      }

      await firebaseInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return SignInResult.success;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return SignInResult.invalidEmail;
        case 'user-disabled':
          return SignInResult.userDisabled;
        case 'user-not-found' || 'invalid-credential':
          return SignInResult.userNotFound;
        case 'wrong-password':
          return SignInResult.wrongPassword;
        default:
          rethrow;
      }
    }
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      if (isSignedIn) {
        await firebaseInstance.signOut();
      }

      await firebaseInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  Future<void> signOut() => firebaseInstance.signOut();
}
