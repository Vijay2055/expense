
import 'package:expense_app/core/layout/main_scaffold.dart';
import 'package:expense_app/features/dashboard/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticatedApp extends ConsumerStatefulWidget {
  const AuthenticatedApp({super.key});

  @override
  ConsumerState<AuthenticatedApp> createState() => _AuthenticatedAppState();
}

class _AuthenticatedAppState extends ConsumerState<AuthenticatedApp> {
  @override
  void initState() {
    super.initState();

    // Future.microtask(() {
    //   ref.read(syncManagerProvider).start();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return const MainScaffold(child: HomeScreen());
  }
}
