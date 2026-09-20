import 'package:expense_app/core/widgets/app_text_fiield.dart';
import 'package:expense_app/features/auth/presentation/auth_state/auth_state.dart';
import 'package:expense_app/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:expense_app/widgets/expenses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({
    super.key,
  });

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final otpController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.status == AuthStatus.verifyingOtp;

    ref.listen(authNotifierProvider, (prev, next) {
      if (next.status == AuthStatus.authenticated) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) {
          return Expenses();
        }), (route) => false);
      }

      if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.errorMessage ?? 'Invalid OTP',
            ),
          ),
        );
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Verify your number',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Enter the 6-digit OTP sent to ${authState.phoneNumber}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                AppTextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  labelText: "OTP",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter OTP';
                    }

                    if (value.length != 6) {
                      return 'OTP must be 6 digits';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }
                            final otp = otpController.text.trim();
                            ref
                                .read(authNotifierProvider.notifier)
                                .verifyOtp(otp);
                          },
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Verify OTP',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
