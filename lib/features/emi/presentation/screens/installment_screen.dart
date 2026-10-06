import 'package:expense_app/features/emi/domain/entity/current_month_emi_entity.dart';
import 'package:expense_app/features/emi/presentation/applications/providers/intallment_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/installment_result_entity.dart';

class InstallmentScreen extends ConsumerStatefulWidget {
  final CurrentMonthEmiEntity loan;

  const InstallmentScreen({
    super.key,
    required this.loan,
  });

  @override
  ConsumerState<InstallmentScreen> createState() => _InstallmentScreenState();
}

class _InstallmentScreenState extends ConsumerState<InstallmentScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(installmentProvider.notifier).loadInstallment(
            loandId: widget.loan.loanId,
            annualIntr: widget.loan.interestRate,
            principal: widget.loan.principal,
            tenureMonth: widget.loan.tenureMonths,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(installmentProvider);

    final installments = state.data;

    return Scaffold(
      appBar: AppBar(
        title: const Text('EMI Schedule'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _buildContent(
                context,
                installments,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<InstallmentResultEntity> installments,
  ) {
    if (installments.isEmpty) {
      return _buildEmptyState(context);
    }

    return _buildTable(
      context,
      installments,
    );
  }

  Widget _buildTable(
    BuildContext context,
    List<InstallmentResultEntity> installments,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DataTable(
      showCheckboxColumn: false,

      // Keeps the table compact on mobile.
      columnSpacing: 24,
      horizontalMargin: 16,

      headingRowHeight: 48,
      dataRowMinHeight: 58,
      dataRowMaxHeight: 64,

      headingRowColor: WidgetStatePropertyAll(
        colorScheme.surfaceContainerHighest,
      ),

      headingTextStyle: theme.textTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),

      dataTextStyle: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface,
      ),

      columns: const [
        DataColumn(
          label: Text('#'),
        ),
        DataColumn(
          label: Text('Due Date'),
        ),
        DataColumn(
          numeric: true,
          label: Text('EMI'),
        ),
        DataColumn(
          numeric: true,
          label: Text('Principal'),
        ),
        DataColumn(
          numeric: true,
          label: Text('Interest'),
        ),
        DataColumn(
          numeric: true,
          label: Text('Balance'),
        ),
        DataColumn(
          label: Text('Status'),
        ),
        DataColumn(
          label: Text('Action'),
        ),
      ],

      rows: installments.map(
        (installment) {
          return DataRow(
            cells: [
              DataCell(
                Text(
                  installment.installmentNumber.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataCell(
                Text(
                  _formatDate(
                    installment.dueDate,
                  ),
                ),
              ),
              DataCell(
                Text(
                  _formatMoney(
                    installment.emi,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataCell(
                Text(
                  _formatMoney(
                    installment.principalAmount,
                  ),
                ),
              ),
              DataCell(
                Text(
                  _formatMoney(
                    installment.interestAmount,
                  ),
                ),
              ),
              DataCell(
                Text(
                  _formatMoney(
                    installment.remainingAmount,
                  ),
                ),
              ),
              DataCell(
                _buildStatus(
                  context,
                  installment.isPaid,
                ),
              ),
              DataCell(
                _buildAction(
                  context,
                  installment,
                ),
              ),
            ],
          );
        },
      ).toList(),
    );
  }

  Widget _buildStatus(
    BuildContext context,
    bool isPaid,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    final backgroundColor = isPaid
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerHighest;

    final foregroundColor =
        isPaid ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPaid ? Icons.check_circle_outline : Icons.schedule_outlined,
            size: 14,
            color: foregroundColor,
          ),
          const SizedBox(width: 5),
          Text(
            isPaid ? 'Paid' : 'Pending',
            style: TextStyle(
              color: foregroundColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction(
    BuildContext context,
    InstallmentResultEntity installment,
  ) {
    if (installment.isPaid) {
      return Icon(
        Icons.check_circle,
        size: 22,
        color: Theme.of(context).colorScheme.primary,
      );
    }

    return FilledButton(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 36),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
        ),
        visualDensity: VisualDensity.compact,
      ),
      onPressed: () {
        _showPaymentDialog(
          context,
          installment,
        );
      },
      child: const Text('Pay'),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 56,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(
            'No installments found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your EMI schedule will appear here.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(
    BuildContext context,
    InstallmentResultEntity installment,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Confirm Payment',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Installment #${installment.installmentNumber}',
              ),
              const SizedBox(height: 8),
              Text(
                'EMI: ${_formatMoney(installment.emi)}',
              ),
              const SizedBox(height: 4),
              Text(
                'Due Date: ${_formatDate(installment.dueDate)}',
              ),
              const SizedBox(height: 16),
              const Text(
                'Do you want to mark this installment as paid?',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                // Your existing payment logic here.
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  String _formatMoney(double? value) {
    if (value == null) {
      return '-';
    }

    return '₹${value.toStringAsFixed(2)}';
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '-';
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
