import 'package:tupay/features/card/presentation/state_manager/card_state.dart';
import 'package:tupay/features/card/presentation/widgets/card_section.dart';
import 'package:tupay/features/card/presentation/widgets/info_block.dart';
import 'package:tupay/features/features.dart';

class CardInformationCard extends StatelessWidget {
  const CardInformationCard({
    required this.state,
    super.key,
  });

  final CardSuccess state;

  @override
  Widget build(BuildContext context) {
    return CardSection(
      title: 'CARD INFORMATION',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoBlock(
            label: 'Cardholder Name',
            value: _titleCase(state.cardHolder),
          ),
          context.uiHelper.verticalSpace(16),
          InfoBlock(
            label: 'Billing Address',
            value: state.billingAddress,
          ),
          context.uiHelper.verticalSpace(24),
          BouncyClickableWidget(
            onTap: () {},
            borderRadius: 8,
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.phone_iphone_rounded,
                      color: AppColors.white,
                      size: 22,
                    ),
                    context.uiHelper.horizontalSpace(12),
                    Text(
                      'Add to Apple Wallet',
                      style: context.appTextTheme.bodySmall14Regular?.copyWith(
                        color: AppColors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _titleCase(String value) {
    return value
        .toLowerCase()
        .split(' ')
        .map((word) {
      if (word.isEmpty) return word;
      return '${word[0].toUpperCase()}${word.substring(1)}';
    })
        .join(' ');
  }
}