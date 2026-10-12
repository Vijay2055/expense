import 'package:expense_app/features/auth/data/repository/auth_repository.dart';
import 'package:expense_app/features/auth/presentation/auth_state/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState();
  }

  Future<void> onSendOtp(String phoneNumber) async {
    state = state.copyWith(
      errorMessage: null,
      phoneNumber: phoneNumber,
      status: AuthStatus.sendingOtp,
    );
    await ref.read(authRepositoryProvider).sendOtp(
        phoneNumber: phoneNumber,
        codeSent: (verificationId, resendToken) {
          state = state.copyWith(
              status: AuthStatus.otpSent,
              verificationId: verificationId,
              resendToken: resendToken);
        },
        verificationFailed: (error) {
          state = state.copyWith(
              errorMessage: error.message ?? "Verification Failed",
              status: AuthStatus.error);
        },
        verificationCompleted: (credential) async {
          try {
            await ref
                .read(authRepositoryProvider)
                .signInAutomatically(credential);
            state = state.copyWith(status: AuthStatus.authenticated);
          } on FirebaseAuthException catch (e) {
            state = state.copyWith(
              status: AuthStatus.error,
              errorMessage: e.message,
            );
          }
        },
        codeAutoRetrievalTimeout: (verificationId) {
          state = state.copyWith(
            verificationId: verificationId,
          );
        });
  }

  Future<void> verifyOtp(String smsCode) async {
    final verificationId = state.verificationId;
    if (verificationId == null) {
      state = state.copyWith(
          status: AuthStatus.error, errorMessage: "Verification id not found");
      return;
    }

    state = state.copyWith(status: AuthStatus.verifyingOtp, errorMessage: null);

    try {
      await ref
          .read(authRepositoryProvider)
          .verifyOtp(verificationId: verificationId, smsCode: smsCode);
      state = state.copyWith(status: AuthStatus.authenticated);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: e.message ?? "Verification Failed");
    }
  }

  Future<void> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    state = state.copyWith(
        status: AuthStatus.sendingEmailPassword, errorMessage: "");

    try {
      await ref
          .read(authRepositoryProvider)
          .createUserWithPhoneAndEmail(email: email, password: password);
      state =
          state.copyWith(status: AuthStatus.authenticated, errorMessage: "");
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: e.message ?? "User creation failed");
    } catch (e) {
      state =
          state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> signInWithEmailAndPassword(
      {required String password, required String email}) async {
    state = state.copyWith(
        status: AuthStatus.sendingEmailPassword, errorMessage: null);
    try {
      await ref
          .read(authRepositoryProvider)
          .signInWithEmailAndPassword(email: email, password: password);
      state =
          state.copyWith(status: AuthStatus.authenticated, errorMessage: null);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: e.message ?? "Signing Failed");
    } catch (e) {
      state =
          state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }
}

final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
