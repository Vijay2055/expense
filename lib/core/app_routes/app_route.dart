import 'package:expense_app/core/constants/app_constants.dart';
import 'package:expense_app/core/layout/main_scaffold.dart';
import 'package:expense_app/features/Expense/presentation/screens/customer_expnse_screen.dart';
import 'package:expense_app/features/Expense/presentation/screens/customer_screen.dart';
import 'package:expense_app/features/dashboard/presentation/screens/home_screen.dart';
import 'package:expense_app/features/emi/presentation/screens/add_loan_screen.dart';
import 'package:expense_app/features/emi/presentation/screens/emi_screen.dart';
import 'package:expense_app/features/settings/presentation/screens/setting_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter =
    GoRouter(initialLocation: AppConstants.homePage, routes: [
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
          routes: [
            GoRoute(
              path: AppConstants.addLoan,
              builder: ((context, state) => const AddLoanScreen())
              )
          ]
        ),
        GoRoute(
          path: AppConstants.customerPage,
          builder: (context, state) => const CustomerScreen(),
          routes: [
            GoRoute(
              path: AppConstants.customerDetail,
              builder: (context, state) {
                final customerId = state.pathParameters['customerId']!;

                return CustomerDetailScreen(customerId: customerId);
              },
            ),
          ],
        ),
        GoRoute(
          path: AppConstants.setting,
          builder: (context, state) {
            return const SettingScreen();
          },
        ),
      ])
]);
