import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/theme/app_role.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import '../../core/di/app_role_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

// ─── Model ────────────────────────────────────────────────────
enum TransactionType { deposit, refund }

class BalanceTransaction {
  final String id;
  final String title;
  final String clientName;
  final String serviceName;
  final DateTime date;
  final double amount;
  final TransactionType type;

  const BalanceTransaction({
    required this.id,
    required this.title,
    required this.clientName,
    required this.serviceName,
    required this.date,
    required this.amount,
    required this.type,
  });
}

// ─── Screen ───────────────────────────────────────────────────
class MyBalanceScreen extends ConsumerWidget {
  const MyBalanceScreen({super.key});

  static final List<BalanceTransaction> _transactions = [
    BalanceTransaction(
      id: '1',
      title: 'Balance Deposit',
      clientName: 'Mr. Raju',
      serviceName: 'Elderly care',
      date: DateTime(2025, 1, 13),
      amount: 20.00,
      type: TransactionType.deposit,
    ),
    BalanceTransaction(
      id: '2',
      title: 'Balance Refund',
      clientName: 'Mr. Raju',
      serviceName: 'Elderly care',
      date: DateTime(2025, 1, 13),
      amount: 20.00,
      type: TransactionType.refund,
    ),
  ];

  double get _availableBalance => _transactions.fold(0.0, (sum, t) {
    return t.type == TransactionType.deposit ? sum + t.amount : sum - t.amount;
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = AppColors.primaryFor(ref.watch(appRoleProvider));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: "My Balance"),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // ─── Balance box ──────────────────────────────
            Center(
              child: Container(
                width: 160,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: primary, width: 1.5),
                ),
                child: Column(
                  children: [
                    AppText.h1('\$${_availableBalance.toStringAsFixed(2)}'),
                    const SizedBox(height: 4),
                    AppText.bodyMd('Available balance'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(color: AppColors.grey200, height: 1),
            const SizedBox(height: 16),

            // ─── Transaction list ─────────────────────────
            Expanded(
              child: ListView.separated(
                itemCount: _transactions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _TransactionCard(
                  transaction: _transactions[i],
                  primary: primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Transaction Card ─────────────────────────────────────────
class _TransactionCard extends StatelessWidget {
  final BalanceTransaction transaction;
  final Color primary;
  const _TransactionCard({required this.transaction, required this.primary});

  @override
  Widget build(BuildContext context) {
    final isDeposit = transaction.type == TransactionType.deposit;
    final amountColor = isDeposit
        ? AppColors.primaryFor(AppRole.provider)
        : AppColors.error;
    final amountText = isDeposit
        ? '+\$${transaction.amount.toStringAsFixed(2)}'
        : '-\$${transaction.amount.toStringAsFixed(2)}';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Wallet icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDeposit ? AppColors.successLight : AppColors.errorLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: AppText.h1(isDeposit ? '💵' : '💸')),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.h4(transaction.title),
                const SizedBox(height: 2),
                AppText.bodySm(transaction.clientName),
                AppText.bodyXs(
                  '${transaction.serviceName} · '
                  '${_fmt(transaction.date)}',
                ),
              ],
            ),
          ),

          // Amount
          AppText(
            amountText,
            style: AppTextStyles.labelLg.copyWith(
              color: amountColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

  static const _months = [
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
}
