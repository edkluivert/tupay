import 'package:tupay/features/features.dart';
import 'package:tupay/features/transfer/presentation/state_manager/transfer_flow_state.dart';


class TransferStepper extends StatelessWidget {
  const TransferStepper({
    required this.currentStep,
    required this.onStepTap,
    super.key,
  });

  final TransferStep currentStep;
  final ValueChanged<TransferStep> onStepTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepItem(
          number: 1,
          label: 'Amount',
          isActive: currentStep == TransferStep.amount,
          isCompleted: currentStep.index > TransferStep.amount.index,
          onTap: () => onStepTap(TransferStep.amount),
        ),
        const Spacer(),
        _StepItem(
          number: 2,
          label: 'Recipient',
          isActive: currentStep == TransferStep.recipient,
          isCompleted: currentStep.index > TransferStep.recipient.index,
          onTap: () => onStepTap(TransferStep.recipient),
        ),
        const Spacer(),
        _StepItem(
          number: 3,
          label: 'Review',
          isActive: currentStep == TransferStep.review,
          isCompleted: false,
          onTap: () => onStepTap(TransferStep.review),
        ),
      ],
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.number,
    required this.label,
    required this.isActive,
    required this.isCompleted,
    required this.onTap,
  });

  final int number;
  final String label;
  final bool isActive;
  final bool isCompleted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = isActive || isCompleted;
    final color = active ? AppColors.secondaryColor : AppColors.textColor1;

    return BouncyClickableWidget(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: active ? AppColors.secondaryColor : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 1.5),
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: AppColors.white, size: 14)
                  : Text(
                '$number',
                style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                  color: active ? AppColors.white : AppColors.textColor1,
                ),
              ),
            ),
          ),
          context.uiHelper.horizontalSpace(8),
          Text(
            label,
            style: context.appTextTheme.bodyNormal16Regular?.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}