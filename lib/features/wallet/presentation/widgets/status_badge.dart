import 'package:tupay/features/features.dart';
import 'package:tupay/features/wallet/data/models/transaction_model.dart';


class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.status,
    super.key,
  });

  final TransactionStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      TransactionStatus.success => ('Success',
      AppColors.greenText1.withAlpha(20), AppColors.success600),
      TransactionStatus.pending => ('Pending', AppColors.lightGrey100,
      AppColors.grey500),
      TransactionStatus.failed  => ('Failed', AppColors.red100.withAlpha(20),
      AppColors.red),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: context.appTextTheme.bodySmall14Regular?.copyWith(
          color: fg,
          fontSize: 10,
        ),
      ),
    );
  }
}
