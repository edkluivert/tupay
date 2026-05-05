import 'package:tupay/common/views/error_view.dart';
import 'package:tupay/common/widgets/bouncing_clickable.dart';
import 'package:tupay/features/features.dart';
import 'package:tupay/features/wallet/presentation/state_manager/wallet/wallet_cubit.dart';
import 'package:tupay/features/wallet/presentation/state_manager/wallet/wallet_state.dart';
import 'package:tupay/features/wallet/presentation/widgets/info_card.dart';
import 'package:tupay/features/wallet/presentation/widgets/wallet_quick_action_widget.dart';
import 'package:tupay/features/wallet/presentation/widgets/spending_card.dart';
import 'package:tupay/features/wallet/presentation/widgets/spending_trend_chart.dart';
import 'package:tupay/features/wallet/presentation/widgets/transaction_item.dart';
import 'package:tupay/features/wallet/presentation/widgets/wallet_app_bar.dart';
import 'package:tupay/features/wallet/presentation/widgets/wallet_balance_card.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WalletCubit()..loadWallet(),
      child: const _WalletView(),
    );
  }
}

class _WalletView extends StatelessWidget {
  const _WalletView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        return switch (state) {
          WalletLoading() => const Scaffold(
              body: Center(
                child: CustomCircularProgressIndicator(
                  color: AppColors.secondaryColor,
                ),
              ),
            ),
          WalletError(:final message) => ErrorView(message: message),
          WalletSuccess() => _SuccessBody(state: state),
        };
      },
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody({required this.state});

  final WalletSuccess state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WalletAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
        child: Column(
          children: [
            WalletBalanceCard(state: state),
            context.uiHelper.verticalSpace(48),


            WalletQuickActions(),
            context.uiHelper.verticalSpace(48),


            SpendingTrendCard(values: state.spendingTrend),
            context.uiHelper.verticalSpace(24),


            InfoCard(
              backgroundColor: AppColors.greenText1.withAlpha(10),
              borderColor: AppColors.secondaryColor.withAlpha(20),
              label: 'MONTHLY INTEREST',
              labelColor: AppColors.greenText2,
              leading: Row(
                children: [
                  const Icon(
                    Icons.savings_outlined,
                    color: AppColors.secondaryColor,
                    size: 20,
                  ),
                  context.uiHelper.horizontalSpace(8),
                  Text(
                    state.monthlyInterest,
                    style: context.appTextTheme.bodySmall14Regular?.copyWith(
                      fontSize: 16,
                      color: AppColors.secondary600,
                    ),
                  ),
                ],
              ),
              trailing: Text(
                'APY: 4.5% Fixed',
                style: context.appTextTheme.bodySmall14Regular?.copyWith(
                  fontSize: 12,
                  color: AppColors.greenText2,
                ),
              ),
            ),
            context.uiHelper.verticalSpace(48),


            InfoCard(
              backgroundColor: AppColors.white,
              borderColor: AppColors.grey50,
              labelColor: AppColors.grey400,
              label: 'PENDING TRANSFERS',
              leading: Row(
                spacing: 6,
                children: [
                  const Icon(
                    Icons.access_time,
                    color: AppColors.amber,
                    size: 20,
                  ),
                  Text(
                    state.pendingCount.toString().padLeft(2, '0'),
                    style: context.appTextTheme.bodySmall14Regular?.copyWith(
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
              trailing: Text(
                'Totaling ${state.pendingTotal}',
                style: context.appTextTheme.bodySmall14Regular?.copyWith(
                    fontSize: 12,
                  color: AppColors.grey200,
                 ),
              ),
            ),
            context.uiHelper.verticalSpace(48),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recent USD Activity',
                        style: context.appTextTheme.bodySmall14Regular?.copyWith(
                          fontSize: 16,
                          color: AppColors.textColor,
                        )),
                    Text('Filtered by USD Wallet',
                        style: context.appTextTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          color: AppColors.grey400,
                        )),
                  ],
                ),
                BouncyClickableWidget(
                  onTap: () {},
                  child: Text('View All', style: context.
                  appTextTheme.bodySmall14Regular?.copyWith(
                    fontSize: 16,
                    color: AppColors.secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
            context.uiHelper.verticalSpace(24),

            ...state.transactions.map(
                  (tx) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: TransactionItem(transaction: tx),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}





