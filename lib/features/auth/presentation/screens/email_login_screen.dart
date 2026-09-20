import 'package:expense_app/core/widgets/app_button.dart';
import 'package:expense_app/core/widgets/app_text_fiield.dart';
import 'package:expense_app/features/auth/presentation/auth_state/auth_state.dart';
import 'package:expense_app/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:expense_app/features/auth/presentation/widgets/app_logo.dart';
import 'package:expense_app/widgets/expenses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailLoginScreen extends ConsumerStatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmailLoginScreen();
}

class _EmailLoginScreen extends ConsumerState<EmailLoginScreen> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = true;
  bool isLogin = true;

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isLoading = ref.watch(authNotifierProvider).status ==
        AuthStatus.sendingEmailPassword;

    ref.listen(authNotifierProvider, (prev, next) {
      if (next.status == AuthStatus.authenticated) {
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
          return Expenses();
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
                    child: Column(
                      children: [
                        AppTextField(
                          enabled: isLoading ? false : true,
                          autovalidateMode: AutovalidateMode.disabled,
                          controller: emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icon(
                            Icons.email,
                            color: Theme.of(context).primaryColor,
                          ),
                          labelText: "Enter your email",
                          validator: (value) {
                            if (value == null) {
                              return "Please enter email";
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        AppTextField(
                          enabled: isLoading ? false : true,
                          autovalidateMode: AutovalidateMode.disabled,
                          controller: passwordCtrl,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: isPasswordVisible,
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).primaryColor,
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                              icon: isPasswordVisible
                                  ? Icon(
                                      Icons.visibility,
                                      color: Theme.of(context).primaryColor,
                                    )
                                  : Icon(Icons.visibility_off,
                                      color: Theme.of(context).primaryColor)),
                          labelText: "Enter password",
                          validator: (value) {
                            if (value == null) {
                              return "Please enter password";
                            }
                            if (value.length < 6) {
                              return "Password must be greater than 6 digits";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        if (!isLogin)
                          AppTextField(
                            enabled: isLoading ? false : true,
                            autovalidateMode: AutovalidateMode.disabled,
                            controller: confirmPassCtrl,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: isPasswordVisible,
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).primaryColor,
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                                icon: isPasswordVisible
                                    ? Icon(
                                        Icons.visibility,
                                        color: Theme.of(context).primaryColor,
                                      )
                                    : Icon(Icons.visibility_off,
                                        color: Theme.of(context).primaryColor)),
                            labelText: "Confirm Password",
                            validator: (value) {
                              if (value == null) {
                                return "Please enter password";
                              }
                              if (value.length < 6) {
                                return "Password must be greater than 6 digits";
                              }
                              return null;
                            },
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  AppButton(
                      isLoading: isLoading,
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        final email = emailCtrl.text.trim();
                        final password = passwordCtrl.text.trim();
                        final confirmPassword = confirmPassCtrl.text.trim();

                        if (password != confirmPassword && !isLogin) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Password does not match")));
                          return;
                        }
                        isLogin
                            ? ref
                                .read(authNotifierProvider.notifier)
                                .signInWithEmailAndPassword(
                                    password: password, email: email)
                            : ref
                                .read(authNotifierProvider.notifier)
                                .createUserWithEmailAndPassword(
                                    email: email, password: password);
                      },
                      title: isLogin ? "Login" : "Register"),

                  const Spacer(flex: 2),

                  // Guest
                  TextButton.icon(
                    icon: Icon(
                      isLogin ? Icons.add : Icons.login,
                      fontWeight: FontWeight.bold,
                    ),
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    label: Text(
                      isLogin ? 'Create an account' : "Already have an account",
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
