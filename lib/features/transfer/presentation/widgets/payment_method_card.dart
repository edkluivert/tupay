import 'package:tupay/features/features.dart';
import 'package:tupay/features/transfer/presentation/state_manager/transfer_flow_state.dart';
import 'package:tupay/features/transfer/presentation/widgets/section_tile.dart';
import 'package:tupay/features/transfer/presentation/widgets/white_card.dart';


class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    required this.state,
    required this.onPaymentMethodTap,
    super.key,
  });

  final TransferFlowState state;
  final ValueChanged<PaymentMethodType> onPaymentMethodTap;

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('PAYMENT METHOD'),
          context.uiHelper.verticalSpace(16),
          ...TransferFlowState.paymentMethods.map((method) {
            final selected = method.type == state.selectedPaymentMethod;
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _PaymentMethodTile(
                method: method,
                selected: selected,
                onTap: () => onPaymentMethodTap(method.type),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final PaymentMethodOption method;
  final bool selected;
  final VoidCallback onTap;

  IconData _icon(PaymentMethodType type) => switch (type) {
    PaymentMethodType.tupayBalance => Icons.account_balance_wallet,
    PaymentMethodType.applePay => Icons.apple,
    PaymentMethodType.googlePay => Icons.g_mobiledata_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return BouncyClickableWidget(
      onTap: onTap,
      borderRadius: 12,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.secondaryColor.withValues(alpha: 0.10)
              : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.secondaryColor : AppColors.inputBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _icon(method.type),
                    color: selected ? AppColors.secondaryColor : AppColors.textColor,
                    size: 22,
                  ),
                  context.uiHelper.horizontalSpace(8),
                  Text(
                    method.title,
                    style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                      color: AppColors.textColor,
                    ),
                  ),
                  context.uiHelper.verticalSpace(4),
                  Text(
                    method.subtitle,
                    style: context.appTextTheme.bodySmall14Regular?.copyWith(
                      color: selected ? AppColors.secondaryColor : AppColors.textColor2,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: AppColors.secondaryColor, size: 18),
          ],
        ),
      ),
    );
  }
}