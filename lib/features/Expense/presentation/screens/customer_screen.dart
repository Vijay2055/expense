import 'package:expense_app/features/Expense/presentation/providers/customer_notifier.dart';
import 'package:expense_app/features/Expense/presentation/screens/add_customer_screen.dart';
import 'package:expense_app/features/Expense/presentation/widgets/customer_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerScreen extends ConsumerWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerState = ref.watch(customerListProvider);
    final notifier = ref.read(customerListProvider.notifier);

    ref.listen(customerListProvider, (prev, next) {
      if (next.message.isNotEmpty) {
        ScaffoldMessenger.of(context).clearSnackBars();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customers',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AddCustomerScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            tooltip: 'Add Customer',
          ),
        ],
      ),
      body: Column(
        children: [
          _CustomerFilters(
            onSearchChanged: notifier.searchCustomer,
            onDateSelected: notifier.filterByDate,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: customerState.isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Please wait...'),
                        SizedBox(height: 8),
                        CircularProgressIndicator(),
                      ],
                    ),
                  )
                : customerState.customers.isEmpty
                    ? const Center(
                        child: Text('No customer found'),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          8,
                          16,
                          16,
                        ),
                        itemCount: customerState.customers.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final customer = customerState.customers[index];

                          return CustomerCard(
                            customer: customer,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _CustomerFilters extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<DateTime?> onDateSelected;

  const _CustomerFilters({
    required this.onSearchChanged,
    required this.onDateSelected,
  });

  @override
  State<_CustomerFilters> createState() => _CustomerFiltersState();
}

class _CustomerFiltersState extends State<_CustomerFilters> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Search
          Expanded(
            child: SizedBox(
              height: 48,
              child: SearchBar(
                hintText: 'Search customers...',
                leading: const Icon(Icons.search),
                elevation: const WidgetStatePropertyAll(0),
                onChanged: widget.onSearchChanged,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Date filter
          SizedBox(
            height: 48,
            child: FilterChip(
              selected: selectedDate != null,
              avatar: const Icon(
                Icons.calendar_today_outlined,
                size: 18,
              ),
              label: Text(
                selectedDate == null ? 'All dates' : _formatDate(selectedDate!),
              ),
              deleteIcon: selectedDate != null
                  ? const Icon(Icons.close, size: 18)
                  : null,
              onDeleted: selectedDate != null
                  ? () {
                      setState(() {
                        selectedDate = null;
                      });

                      widget.onDateSelected(null);
                    }
                  : null,
              onSelected: (_) async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDate: selectedDate ?? DateTime.now(),
                );

                if (date == null) return;

                setState(() {
                  selectedDate = date;
                });

                widget.onDateSelected(date);
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
