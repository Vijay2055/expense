import 'package:flutter/material.dart';

class CustomerDetailSummaryCard extends StatelessWidget {
  final double totalInAmount;
  final double totalOutAmount;

  const CustomerDetailSummaryCard({
    super.key,
    required this.totalInAmount,
    required this.totalOutAmount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final balance = totalInAmount - totalOutAmount;

    final bool isIn = balance > 0;
    final bool isOut = balance < 0;

    final statusText = isIn
        ? 'IN'
        : isOut
            ? 'OUT'
            : 'SETTLED';

    final displayAmount = balance.abs();

    final Color balanceColor = isIn
        ? Colors.green
        : isOut
            ? Colors.red
            : theme.colorScheme.onSurfaceVariant;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _AmountItem(
                    title: 'Total In',
                    amount: totalInAmount,
                    icon: Icons.arrow_downward_rounded,
                    color: Colors.green,
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: theme.colorScheme.outlineVariant,
                ),
                Expanded(
                  child: _AmountItem(
                    title: 'Total Out',
                    amount: totalOutAmount,
                    icon: Icons.arrow_upward_rounded,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(
              color: theme.colorScheme.outlineVariant,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Balance',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Text(
                  '₹${displayAmount.toStringAsFixed(0)} $statusText',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: balanceColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountItem extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;

  const _AmountItem({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: color,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
