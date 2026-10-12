import 'package:expense_app/features/emi/presentation/applications/providers/add_loan_notifier.dart';
import 'package:expense_app/features/emi/presentation/applications/providers/currentEmiListNotifier.dart';
import 'package:expense_app/features/emi/presentation/applications/states/add_loan_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddLoanScreen extends ConsumerStatefulWidget {
  const AddLoanScreen({super.key});

  @override
  ConsumerState<AddLoanScreen> createState() => _AddLoanScreenState();
} 

class _AddLoanScreenState extends ConsumerState<AddLoanScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _bankController;
  late final TextEditingController _principalController;
  late final TextEditingController _rateController;

  @override
  void initState() {
    super.initState();

    _bankController = TextEditingController();
    _principalController = TextEditingController();
    _rateController = TextEditingController();

    _bankController.addListener(() {
      ref
          .read(addLoanNotifierProvider.notifier)
          .setBankName(_bankController.text);
    });

    _principalController.addListener(() {
      ref
          .read(addLoanNotifierProvider.notifier)
          .setPrincipal(_principalController.text);
    });

    _rateController.addListener(() {
      ref
          .read(addLoanNotifierProvider.notifier)
          .setInterestRate(_rateController.text);
    });
  }

  @override
  void dispose() {
    _bankController.dispose();
    _principalController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    ref.listen<AddLoanState>(
      addLoanNotifierProvider,
      (previous, next) {
        if (next.isSuccess && previous?.isSuccess != true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Loan added successfully'),
            ),
          );

          Navigator.of(context).pop(true);
        }

        if (next.errorMessage != null &&
            next.errorMessage != previous?.errorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
            ),
          );
        }
      },
    );

    final state = ref.watch(addLoanNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffF7F8FA),
        foregroundColor: Colors.black87,
        title: const Text(
          'Add New Loan',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(colorScheme),
                const SizedBox(height: 28),
                _buildSectionTitle(
                  icon: Icons.account_balance_rounded,
                  title: 'Loan Details',
                ),
                const SizedBox(height: 12),
                _buildBankField(),
                const SizedBox(height: 24),
                _buildSectionTitle(
                  icon: Icons.currency_rupee_rounded,
                  title: 'Loan Amount',
                ),
                const SizedBox(height: 12),
                _buildPrincipalField(),
                const SizedBox(height: 24),
                _buildSectionTitle(
                  icon: Icons.trending_up_rounded,
                  title: 'Interest & Tenure',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildRateField(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTenureField(state),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(
                  icon: Icons.calendar_month_rounded,
                  title: 'Loan Start Date',
                ),
                const SizedBox(height: 12),
                _buildDatePicker(state),
                const SizedBox(height: 24),
                if (state.calculatedEmi != null) _buildEmiPreview(state),
                const SizedBox(height: 28),
                _buildSubmitButton(state),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.account_balance_wallet_rounded,
            color: Colors.white,
            size: 34,
          ),
          SizedBox(height: 16),
          Text(
            'Track your loan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Add your loan details and we’ll calculate your monthly EMI.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildBankField() {
    return TextFormField(
      controller: _bankController,
      textInputAction: TextInputAction.next,
      decoration: _inputDecoration(
        label: 'Bank / Lender',
        hint: 'e.g. HDFC Bank',
        prefixIcon: Icons.account_balance_rounded,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Enter bank or lender name';
        }
        return null;
      },
    );
  }

  Widget _buildPrincipalField() {
    return TextFormField(
      controller: _principalController,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      textInputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'^\d*\.?\d{0,2}'),
        ),
      ],
      decoration: _inputDecoration(
        label: 'Principal Amount',
        hint: '5,00,000',
        prefixIcon: Icons.currency_rupee_rounded,
      ),
      validator: (value) {
        final amount = double.tryParse(value ?? '');

        if (amount == null || amount <= 0) {
          return 'Enter a valid amount';
        }

        return null;
      },
    );
  }

  Widget _buildRateField() {
    return TextFormField(
      controller: _rateController,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      textInputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'^\d*\.?\d{0,2}'),
        ),
      ],
      decoration: _inputDecoration(
        label: 'Interest Rate',
        hint: '10.5',
        prefixIcon: Icons.percent_rounded,
      ),
      validator: (value) {
        final rate = double.tryParse(value ?? '');

        if (rate == null || rate < 0) {
          return 'Invalid rate';
        }

        return null;
      },
    );
  }

  Widget _buildTenureField(AddLoanState state) {
    return DropdownButtonFormField<int>(
      value: state.tenureMonths,
      isExpanded: true,
      decoration: _inputDecoration(
        label: 'Tenure',
        hint: 'Months',
        prefixIcon: Icons.schedule_rounded,
      ),
      items: const [
        6,
        12,
        18,
        24,
        36,
        48,
        60,
        72,
        84,
        120,
      ].map((months) {
        return DropdownMenuItem<int>(
          value: months,
          child: Text(
            '$months months',
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) return;

        ref.read(addLoanNotifierProvider.notifier).setTenure(value);
      },
    );
  }

  Widget _buildDatePicker(AddLoanState state) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _selectDate(state.startDate),
      child: InputDecorator(
        decoration: _inputDecoration(
          label: 'Start Date',
          hint: '',
          prefixIcon: Icons.calendar_month_rounded,
        ),
        child: Text(
          _formatDate(state.startDate),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildEmiPreview(AddLoanState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xffE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 6),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estimated Monthly EMI',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '₹${_formatAmount(state.calculatedEmi!)}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _summaryItem(
                '${state.interestRate}%',
                'Interest',
              ),
              const SizedBox(width: 24),
              _summaryItem(
                '${state.tenureMonths}',
                'Months',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(AddLoanState state) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: state.isSubmitting
            ? null
            : () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }

                ref.read(addLoanNotifierProvider.notifier).addLoan();
                ref.invalidate(currentMonthEmiNotifierProvider);
              },
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: state.isSubmitting
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded),
                  SizedBox(width: 8),
                  Text(
                    'Add Loan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(prefixIcon),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xffE5E7EB),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xff2563EB),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
      ),
    );
  }

  Future<void> _selectDate(DateTime currentDate) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected == null) return;

    ref.read(addLoanNotifierProvider.notifier).setStartDate(selected);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} '
        '${_monthName(date.month)} '
        '${date.year}';
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match.group(1)},',
        );
  }
}
