import 'package:expense_app/features/auth/presentation/providers/auth_state_change_provider.dart';
import 'package:expense_app/features/auth/presentation/screens/email_login_screen.dart';
import 'package:expense_app/features/auth/presentation/widgets/authenticated_app.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangeProvider);
    return authState.when(
        data: (user) {
          if (user != null) {
            return AuthenticatedApp();
          }
          return EmailLoginScreen();
        },
        error: (errr, _) {
          return EmailLoginScreen();
        },
        loading: () => Scaffold(
              body: Center(
                child: Text("Please wait"),
              ),
            ));
  }
}
