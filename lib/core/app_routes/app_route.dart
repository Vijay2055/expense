import 'package:expense_app/core/constants/app_constants.dart';
import 'package:expense_app/core/layout/main_scaffold.dart';
import 'package:expense_app/core/layout/spalsh_screen.dart';
import 'package:expense_app/features/Expense/presentation/screens/add_customer_screen.dart';
import 'package:expense_app/features/Expense/presentation/screens/customer_expnse_screen.dart';
import 'package:expense_app/features/Expense/presentation/screens/customer_screen.dart';

import 'package:expense_app/features/auth/presentation/providers/auth_state_change_provider.dart';
import 'package:expense_app/features/auth/presentation/screens/email_login_screen.dart';
import 'package:expense_app/features/dashboard/presentation/screens/home_screen.dart';
import 'package:expense_app/features/emi/domain/entity/current_month_emi_entity.dart';
import 'package:expense_app/features/emi/presentation/screens/add_loan_screen.dart';
import 'package:expense_app/features/emi/presentation/screens/emi_screen.dart';
import 'package:expense_app/features/emi/presentation/screens/installment_screen.dart';
import 'package:expense_app/features/settings/presentation/screens/setting_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangeProvider);

  return GoRouter(
      initialLocation: AppConstants.initialLocation,
      debugLogDiagnostics: true,
      redirect: (context, state) {
        final isLoading = authState.isLoading;
        final isLoggedIn = authState.value != null;
        final isError = authState.hasError;

        final isGoingToSplash =
            state.matchedLocation == AppConstants.splashRoute;
        final isGoingToLogin = state.matchedLocation == AppConstants.loginRoute;

        if (isLoading) {
          return isGoingToSplash ? null : AppConstants.splashRoute;
        }

        if (isError) {
          return isGoingToLogin ? null : AppConstants.loginRoute;
        }

        if (!isLoggedIn) {
          return isGoingToLogin ? null : AppConstants.loginRoute;
        }

        if (isGoingToLogin || isGoingToSplash) {
          return AppConstants.homePage;
        }

        return null;
      },
      routes: [
        // inital redirect
        GoRoute(
            path: AppConstants.initialLocation,
            redirect: (_, __) {
              return AppConstants.splashRoute;
            }),

        // splash screen build

        //
        GoRoute(
            path: AppConstants.splashRoute,
            builder: (context, state) {
              return const SpalshScreen();
            }),

//  login

        GoRoute(
            path: AppConstants.loginRoute,
            builder: (context, state) {
              return EmailLoginScreen();
            }),

// shell route for navigator
        ShellRoute(
            builder: (context, state, child) {
              return MainScaffold(child: child);
            },
            routes: [
              GoRoute(
                path: AppConstants.homePage,
                builder: (context, state) => const HomeScreen(),
              ),
              GoRoute(
                path: AppConstants.emiPage,
                builder: (context, state) => const EmiScreen(),
              ),
              GoRoute(
                path: AppConstants.customerPage,
                builder: (context, state) => const CustomerScreen(),
              ),
              GoRoute(
                path: AppConstants.setting,
                builder: (context, state) {
                  return const SettingScreen();
                },
              ),
            ]),

        GoRoute(
            path: AppConstants.addCustomer,
            builder: (context, state) {
              return AddCustomerScreen();
            }),

        GoRoute(
            path: AppConstants.customerDetail,
            builder: (context, state) {
              final extra = state.extra as Map<String, String>;
              final id = extra['customerId'];

              return CustomerDetailScreen(customerId: id!);
            }),

        GoRoute(
            path: AppConstants.addLoan,
            builder: ((context, state) => const AddLoanScreen())),
        GoRoute(
            path: AppConstants.installment,
            builder: ((context, state) {
              final loan = state.extra as CurrentMonthEmiEntity;
              return InstallmentScreen(
                loan: loan,
              );
            })),
        GoRoute(
          path: AppConstants.customerDetail,
          builder: (context, state) {
            final customerId = state.pathParameters['customerId']!;

            return CustomerDetailScreen(customerId: customerId);
          },
        ),
      ]);
});
