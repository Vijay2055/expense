enum AuthStatus {
  initial,
  sendingOtp,
  otpSent,
  sendingEmailPassword,
  verifyingOtp,
  authenticated,
  error,
}

class AuthState {
  final AuthStatus status;
  final String? verificationId;
  final int? resendToken;
  final String? phoneNumber;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.verificationId,
    this.resendToken,
    this.phoneNumber,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? verificationId,
    int? resendToken,
    String? phoneNumber,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      verificationId: verificationId ?? this.verificationId,
      resendToken: resendToken ?? this.resendToken,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      errorMessage: errorMessage,
    );
  }
}
