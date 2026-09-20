import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AuthService {
  Future<void> verifyPhone({
    required String phoneNumber,
    required void Function(PhoneAuthCredential credential)
        verificationCompleted,
    required void Function(FirebaseAuthException e) verificationFailed,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(String verificationId) codeAutoRetrievalTimeout,
  });

  Future<UserCredential> signInWithCredential(
      {required String verificationId, required String smsCode});

  Future<UserCredential> signInAutomatically(PhoneAuthCredential credential);
  Future<UserCredential> createUserWithEmailAndPassword(
      {required String email, required String password});

  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password});

  Stream<User?> authStateChange();

  Future<void> logout();
}

class AuthServiceImpl implements AuthService {
  final FirebaseAuth _auth;
  AuthServiceImpl(this._auth);
  @override
  Future<void> verifyPhone(
      {required String phoneNumber,
      required void Function(PhoneAuthCredential credential)
          verificationCompleted,
      required void Function(FirebaseAuthException e) verificationFailed,
      required void Function(String verificationId, int? resendToken) codeSent,
      required void Function(String verificationId)
          codeAutoRetrievalTimeout}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  @override
  Future<UserCredential> signInWithCredential(
      {required String verificationId, required String smsCode}) async {
    final credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    return _auth.signInWithCredential(credential);
  }

  @override
  Future<UserCredential> signInAutomatically(
      PhoneAuthCredential credential) async {
    return await _auth.signInWithCredential(credential);
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return credential;
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    final credential =
      await  _auth.signInWithEmailAndPassword(email: email, password: password);
    return credential;
  }

  @override
  Stream<User?> authStateChange() {
    // TODO: implement authStateChange
    return _auth.authStateChanges();
  }

  @override
  Future<void> logout() async {
 return await  _auth.signOut();
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final _auth = FirebaseAuth.instance;
  return AuthServiceImpl(_auth);
});
