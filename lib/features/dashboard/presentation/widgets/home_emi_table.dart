import 'package:flutter/material.dart';

class HomeEmiTable extends StatelessWidget {
  const HomeEmiTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _EmiCard(
          bankName: 'State Bank of India',
          shortName: 'SBI',
          amount: '₹8,450',
          installment: 'EMI #04',
          dueDate: 'Sep 25',
          isPaid: false,
        ),
        const SizedBox(height: 10),
        _EmiCard(
          bankName: 'Central Bank of India',
          shortName: 'CBI',
          amount: '₹6,200',
          installment: 'EMI #07',
          dueDate: 'Sep 28',
          isPaid: true,
        ),
        const SizedBox(height: 10),
        _EmiCard(
          bankName: 'HDFC Bank',
          shortName: 'HDFC',
          amount: '₹3,850',
          installment: 'EMI #02',
          dueDate: 'Sep 30',
          isPaid: false,
        ),
      ],
    );
  }
}

class _EmiCard extends StatelessWidget {
  const _EmiCard({
    required this.bankName,
    required this.shortName,
    required this.amount,
    required this.installment,
    required this.dueDate,
    required this.isPaid,
  });

  final String bankName;
  final String shortName;
  final String amount;
  final String installment;
  final String dueDate;
  final bool isPaid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final statusColor =
        isPaid ? const Color(0xFF146C2E) : const Color(0xFFB54708);

    final statusBackground =
        isPaid ? const Color(0xFFE8F5E9) : const Color(0xFFFFF4E5);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              shortName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bankName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      installment,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Container(
                      width: 3,
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 7),
                      decoration: BoxDecoration(
                        color: colorScheme.onSurfaceVariant,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      'Due $dueDate',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isPaid ? 'PAID' : 'PENDING',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
