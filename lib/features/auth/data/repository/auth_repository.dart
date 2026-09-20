import 'package:expense_app/features/auth/data/firebase_auth_service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AuthRepository {
  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(FirebaseAuthException error) verificationFailed,
    required void Function(PhoneAuthCredential credential)
        verificationCompleted,
    required void Function(String verificationId) codeAutoRetrievalTimeout,
  });

  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String smsCode,
  });

  Future<UserCredential> signInAutomatically(PhoneAuthCredential credential);

  Future<UserCredential> createUserWithPhoneAndEmail(
      {required String email, required String password});

  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password});

  Stream<User?> authStateChanges();

  Future<void> signOut();
}

class AuthRepositoryImpl extends AuthRepository {
  final AuthService _authService;
  AuthRepositoryImpl(this._authService);
  @override
  Future<void> sendOtp(
      {required String phoneNumber,
      required void Function(String verificationId, int? resendToken) codeSent,
      required void Function(FirebaseAuthException error) verificationFailed,
      required void Function(String verificationId) codeAutoRetrievalTimeout,
      required void Function(PhoneAuthCredential credential)
          verificationCompleted}) async {
    await _authService.verifyPhone(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  @override
  Future<UserCredential> verifyOtp(
      {required String verificationId, required String smsCode}) {
    return _authService.signInWithCredential(
        verificationId: verificationId, smsCode: smsCode);
  }

  @override
  Future<UserCredential> signInAutomatically(PhoneAuthCredential credential) {
    return _authService.signInAutomatically(credential);
  }

  @override
  Future<UserCredential> createUserWithPhoneAndEmail(
      {required String email, required String password}) {
    return _authService.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) {
    return _authService.signInWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Stream<User?> authStateChanges() => _authService.authStateChange();

  @override
  Future<void> signOut() => _authService.logout();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authServiceProvider));
});
