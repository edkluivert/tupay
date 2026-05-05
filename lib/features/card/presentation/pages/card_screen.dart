import 'package:tupay/features/card/presentation/state_manager/card_cubit.dart';
import 'package:tupay/features/card/presentation/state_manager/card_state.dart';
import 'package:tupay/features/card/presentation/widgets/card_information_card.dart';
import 'package:tupay/features/card/presentation/widgets/recent_transactions_card.dart';
import 'package:tupay/features/card/presentation/widgets/security_control_card.dart';
import 'package:tupay/features/card/presentation/widgets/virtual_card.dart';
import 'package:tupay/features/features.dart';
import 'package:tupay/features/home/presentation/widgets/dashboard_app_bar.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CardCubit()..loadCard(),
      child: const _CardDetailsView(),
    );
  }
}

class _CardDetailsView extends StatelessWidget {
  const _CardDetailsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardCubit, CardState>(
      builder: (context, state) {
        return Scaffold(
          appBar: const DashboardAppBar(),
          body: SafeArea(
            child: Builder(
              builder: (context) {
                if (state is CardLoading) {
                  return const Center(
                    child: CustomCircularProgressIndicator(
                      color: AppColors.secondaryColor,
                    ),
                  );
                }

                if (state is CardError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: context.appTextTheme.bodyNormal16Regular?.copyWith(
                        color: AppColors.textColor,
                      ),
                    ),
                  );
                }

                if (state is! CardSuccess) {
                  return const SizedBox.shrink();
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.pagePadding,
                  ),
                  child: Column(
                    children: [
                      context.uiHelper.verticalSpace(24),

                      VirtualCard(state: state),

                      context.uiHelper.verticalSpace(24),

                      SecurityControlsCard(state: state),

                      context.uiHelper.verticalSpace(24),

                      CardInformationCard(state: state),

                      context.uiHelper.verticalSpace(24),

                      RecentTransactionsCard(
                        transactions: state.transactions,
                      ),

                      context.uiHelper.verticalSpace(32),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}













