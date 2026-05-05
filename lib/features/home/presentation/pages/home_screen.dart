import 'package:tupay/common/views/empty_view.dart';
import 'package:tupay/common/views/error_view.dart';
import 'package:tupay/common/views/loading_view.dart';
import 'package:tupay/features/features.dart';
import 'package:tupay/features/home/presentation/state_manager/home_cubit.dart';
import 'package:tupay/features/home/presentation/state_manager/home_state.dart';
import 'package:tupay/features/home/presentation/widgets/balance_card.dart';
import 'package:tupay/features/home/presentation/widgets/dashboard_app_bar.dart';
import 'package:tupay/features/home/presentation/widgets/quick_action_widget.dart';
import 'package:tupay/features/home/presentation/widgets/section_header.dart';
import 'package:tupay/features/home/presentation/widgets/wallet_scroll.dart';
import 'package:tupay/features/wallet/presentation/widgets/transaction_item.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..loadHome(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return switch (state) {
          HomeLoading() => const LoadingView(),
          HomeError(:final message) => ErrorView(message: message),
          HomeEmpty() => const EmptyView(),
          HomeSuccess() => _SuccessView(state: state),
        };
      },
    );
  }
}


class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.state});

  final HomeSuccess state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DashboardAppBar(),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BalanceCardDelegate(
                totalBalance: state.totalBalance,
                changePercent: state.changePercent,
                balanceVisible: state.balanceVisible,
                onToggleVisibility: () =>
                    context.read<HomeCubit>().toggleBalanceVisibility(),
              ),

              context.uiHelper.verticalSpace(24),


              QuickActions(),

              context.uiHelper.verticalSpace(26),


              SectionHeader(
                title: 'Wallets',
                actionLabel: 'Manage',
                onActionTap: () {},
              ),
              context.uiHelper.verticalSpace(14),
              WalletScroll(wallets: state.wallets),

              context.uiHelper.verticalSpace(26),


              SectionHeader(
                title: 'Recent Transactions',
                actionLabel: 'See all',
                onActionTap: () {},
              ),
              context.uiHelper.verticalSpace(14),

              ...state.transactions.map(
                    (tx) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TransactionItem(transaction: tx),
                ),
              ),

         
              context.uiHelper.verticalSpace(80)
            ]
          ),
        ),
      ),
    );
  }
}







