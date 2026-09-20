import 'package:expense_app/features/Expense/presentation/providers/customer_notifier.dart';
import 'package:expense_app/features/Expense/presentation/providers/expense_notifier.dart';
import 'package:expense_app/features/Expense/presentation/screens/add_expense_screen.dart';
import 'package:expense_app/features/Expense/presentation/widgets/customer_detail_header.dart';
import 'package:expense_app/features/Expense/presentation/widgets/customer_detail_summary_card.dart';
import 'package:expense_app/features/Expense/presentation/widgets/expense_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerDetailScreen extends ConsumerStatefulWidget {
  final String customerId;

  const CustomerDetailScreen({
    super.key,
    required this.customerId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerDetailScreen();
}

class _CustomerDetailScreen extends ConsumerState<CustomerDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      ref
          .read(expenseListProvider.notifier)
          .loadExpense(customerId: widget.customerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Watch only the required customer.
    final customer = ref.watch(
      customerListProvider.select(
        (state) => state.customers
            .where((customer) => customer.id == widget.customerId)
            .firstOrNull,
      ),
    );

    final expenses = ref.watch(
      expenseListProvider.select(
        (state) => state.expenses
            .where((expense) => expense.customerId == widget.customerId)
            .toList(),
      ),
    );

    if (customer == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Customer Details'),
        ),
        body: const Center(
          child: Text('Customer not found'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Customer Details'),
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                children: [
                  CustomerDetailHeader(
                    name: customer.name,
                    phone: customer.phone,
                    address: customer.address,
                  ),
                  const SizedBox(height: 16),
                  CustomerDetailSummaryCard(
                    totalInAmount: customer.totalInAmount,
                    totalOutAmount: customer.totalOutAmount,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        'Transactions',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${expenses.length} transactions',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          if (expenses.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyExpenses(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList.separated(
                itemCount: expenses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return ExpenseItemCard(
                    expense: expenses[index],
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Open Add Expense screen.
          //
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddExpenseScreen(
                customerId: widget.customerId,
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }
}

/// ------------------------------------------------------------
/// EMPTY STATE
/// ------------------------------------------------------------

class _EmptyExpenses extends StatelessWidget {
  const _EmptyExpenses();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Add an expense to start tracking transactions.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
