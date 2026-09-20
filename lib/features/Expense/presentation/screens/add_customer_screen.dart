import 'package:expense_app/core/widgets/app_text_fiield.dart';
import 'package:expense_app/features/Expense/presentation/providers/customer_notifier.dart';
import 'package:expense_app/features/Expense/providers/usecase_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddCustomerScreen extends ConsumerStatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  ConsumerState<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends ConsumerState<AddCustomerScreen> {
  final _nameCtrl = TextEditingController();
  final _phonCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameCtrl.dispose();
    _phonCtrl.dispose();
    _addressCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Customer"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  controller: _nameCtrl,
                  labelText: "Name",
                  keyboardType: TextInputType.name,
                  prefixIcon: Icon(Icons.person),
                  validator: (value) {
                    if (value == null && value!.isEmpty) {
                      return "Name is required";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                AppTextField(
                  controller: _phonCtrl,
                  labelText: "Mobile",
                  keyboardType: TextInputType.number,
                  prefixIcon: Icon(Icons.phone_android),
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        value.length != 10) {
                      return "Phone number must be 10 digits";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                AppTextField(
                  controller: _addressCtrl,
                  labelText: "Address",
                  keyboardType: TextInputType.text,
                  prefixIcon: Icon(Icons.location_on),
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 3) {
                      return "Invalid Address";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      final name = _nameCtrl.text.trim();
                      final address = _addressCtrl.text.trim();
                      final mobile = _phonCtrl.text.trim();

                      final result =
                          await ref.watch(addCustomerUsecaseProvider)(
                        name: name,
                        address: address,
                        mobile: mobile,
                      );
                      result.fold(ifLeft: (failure) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(failure.message)));
                      }, ifRight: (response) {
                        ref.invalidate(customerListProvider);
                        Navigator.of(context).pop();
                      });
                    },
                    icon: Icon(Icons.add),
                    label: Text("Add"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
