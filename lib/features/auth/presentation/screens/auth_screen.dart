import 'package:expense_app/core/widgets/app_button.dart';
import 'package:expense_app/core/widgets/app_text_fiield.dart';
import 'package:expense_app/features/auth/presentation/auth_state/auth_state.dart';
import 'package:expense_app/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:expense_app/features/auth/presentation/screens/otp_screen.dart';
import 'package:expense_app/features/auth/presentation/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthScreen();
}

class _AuthScreen extends ConsumerState<AuthScreen> {
  final mobileCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    mobileCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isLoading =
        ref.watch(authNotifierProvider).status == AuthStatus.sendingOtp;

    ref.listen(authNotifierProvider, (prev, next) {
      if (next.status == AuthStatus.otpSent) {
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
          return OtpScreen();
        }));
      }
      if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.errorMessage ?? 'Something went wrong',
            ),
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.sizeOf(context).height -
                  MediaQuery.paddingOf(context).vertical,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // App Logo
                  AppLogo(),
                  const SizedBox(height: 32),
                  // Title
                  const Text(
                    'Welcome to Hisaab App',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Description
                  const Text(
                    'Everything you need, all in one place.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  Form(
                    key: _formKey,
                    child: AppTextField(
                      enabled: isLoading ? false : true,
                      autovalidateMode: AutovalidateMode.disabled,
                      controller: mobileCtrl,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icon(Icons.phone_android),
                      labelText: "Enter mobile number",
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10)
                      ],
                      validator: (value) {
                        if (value == null) {
                          return "Please enter moible number";
                        }
                        if (value.length != 10) {
                          return "Mobile number must be 10 digits";
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  AppButton(
                      isLoading: isLoading,
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        final mobile = '+91${mobileCtrl.text.trim()}';
                        ref
                            .read(authNotifierProvider.notifier)
                            .onSendOtp(mobile);
                      },
                      title: "Continue"),

                  const Spacer(flex: 2),

                  // Guest
                  TextButton(
                    onPressed: () {
                      // Continue as guest
                    },
                    child: const Text(
                      'Continue as Guest',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.04),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
