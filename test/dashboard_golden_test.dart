// Golden tests for the main Dashboard.


// flutter test --update-goldens test/dashboard_golden_test.dart


//   flutter test test/dashboard_golden_test.dart


import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tupay/core/theme/tupay_theme.dart';
import 'package:tupay/features/home/presentation/state_manager/home_cubit.dart';
import 'package:tupay/features/home/presentation/state_manager/home_state.dart';
import 'package:tupay/features/wallet/data/models/transaction_model.dart';
import 'package:tupay/features/wallet/data/models/wallet_model.dart';


class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}



const _wallets = [
  WalletModel(
    currency: 'NGN',
    currencySymbol: '₦',
    countryFlag: '🇳🇬',
    countryName: 'NIGERIA',
    balance: '4,850,200.00',
  ),
  WalletModel(
    currency: 'CNY',
    currencySymbol: '¥',
    countryFlag: '🇨🇳',
    countryName: 'CHINA',
    balance: '85,000',
  ),
];

final _transactions = [
  TransactionModel(
    id: 'tx001',
    title: 'Wallet Funding',
    subtitle: 'Via Bank Transfer',
    amount: '250,000',
    currencySymbol: '₦',
    type: TransactionType.credit,
    status: TransactionStatus.success,
    category: TransactionCategory.walletFunding,
    timestamp: DateTime(2024, 1, 15, 14, 30),
  ),
  TransactionModel(
    id: 'tx002',
    title: 'RMB Transfer',
    subtitle: 'To Wei Liu',
    amount: '15,000',
    currencySymbol: '¥',
    type: TransactionType.debit,
    status: TransactionStatus.success,
    category: TransactionCategory.transfer,
    timestamp: DateTime(2024, 1, 14, 9),
  ),
];


Widget _harness(MockHomeCubit cubit) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: TupayTheme.createLightThemeData(),
    home: BlocProvider<HomeCubit>.value(
      value: cubit,
      child: const _DashboardProxy(),
    ),
  );
}

class _DashboardProxy extends StatelessWidget {
  const _DashboardProxy();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is! HomeSuccess) return const SizedBox.shrink();

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [

                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B4332),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TOTAL BALANCE',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.balanceVisible
                              ? '₦ ${state.totalBalance}'
                              : '₦ ••••••••',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withAlpha(50),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            state.changePercent,
                            style: const TextStyle(
                              color: Color(0xFF4ADE80),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),


                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final tx = state.transactions[i];
                        return Card(
                          key: ValueKey(tx.id),
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(tx.title),
                            subtitle: Text(tx.subtitle),
                            trailing: Text(
                              tx.formattedAmount,
                              style: TextStyle(
                                color: tx.isCredit
                                    ? const Color(0xFF16A34A)
                                    : const Color(0xFFDC2626),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: state.transactions.length,
                    ),
                  ),
                ),

                if (state.transactions.isEmpty)
                  const SliverFillRemaining(
                    child: Center(child: Text('No transactions yet')),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}


void main() {
  late MockHomeCubit cubit;

  setUp(() => cubit = MockHomeCubit());
  tearDown(() => cubit.close());


  const viewport = Size(390, 844);


  testWidgets('dashboard golden — balance visible', (tester) async {
    final successState = HomeSuccess(
      totalBalance: '4,850,200.00',
      changePercent: '+2.4%',
      wallets: _wallets,
      transactions: _transactions,
    );

    whenListen(cubit, Stream.value(successState), initialState: successState);

    await tester.binding.setSurfaceSize(viewport);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_harness(cubit));
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/dashboard/balance_visible.png'),
    );
  });


  testWidgets('dashboard golden — balance hidden', (tester) async {
    final hiddenState = HomeSuccess(
      totalBalance: '4,850,200.00',
      changePercent: '+2.4%',
      wallets: _wallets,
      transactions: _transactions,
      balanceVisible: false, // privacy mode ON
    );

    whenListen(cubit, Stream.value(hiddenState), initialState: hiddenState);

    await tester.binding.setSurfaceSize(viewport);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_harness(cubit));
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/dashboard/balance_hidden.png'),
    );
  });


  testWidgets('dashboard golden — no transactions', (tester) async {
    final emptyState = HomeSuccess(
      totalBalance: '0.00',
      changePercent: '+0.0%',
      wallets: const [],
      transactions: const [],
    );

    whenListen(cubit, Stream.value(emptyState), initialState: emptyState);

    await tester.binding.setSurfaceSize(viewport);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_harness(cubit));
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/dashboard/no_transactions.png'),
    );
  });


  testWidgets('shows masked balance when balanceVisible is false',
      (tester) async {
    final state = HomeSuccess(
      totalBalance: '4,850,200.00',
      changePercent: '+2.4%',
      wallets: _wallets,
      transactions: _transactions,
      balanceVisible: false,
    );
    whenListen(cubit, Stream.value(state), initialState: state);

    await tester.pumpWidget(_harness(cubit));
    await tester.pump();

    expect(find.text('₦ ••••••••'), findsOneWidget);
    expect(find.textContaining('4,850,200.00'), findsNothing);
  });


  testWidgets('shows real balance when balanceVisible is true', (tester) async {
    final state = HomeSuccess(
      totalBalance: '4,850,200.00',
      changePercent: '+2.4%',
      wallets: _wallets,
      transactions: _transactions,
    );
    whenListen(cubit, Stream.value(state), initialState: state);

    await tester.pumpWidget(_harness(cubit));
    await tester.pump();

    expect(find.text('₦ 4,850,200.00'), findsOneWidget);
    expect(find.text('₦ ••••••••'), findsNothing);
  });


  testWidgets('renders changePercent badge', (tester) async {
    final state = HomeSuccess(
      totalBalance: '25,000.00',
      changePercent: '-1.2%',
      wallets: _wallets,
      transactions: _transactions,
    );
    whenListen(cubit, Stream.value(state), initialState: state);

    await tester.pumpWidget(_harness(cubit));
    await tester.pump();

    expect(find.text('-1.2%'), findsOneWidget);
  });


  testWidgets('renders transaction titles in list', (tester) async {
    final state = HomeSuccess(
      totalBalance: '4,850,200.00',
      changePercent: '+2.4%',
      wallets: _wallets,
      transactions: _transactions,
    );
    whenListen(cubit, Stream.value(state), initialState: state);

    await tester.pumpWidget(_harness(cubit));
    await tester.pump();

    expect(find.text('Wallet Funding'), findsOneWidget);
    expect(find.text('RMB Transfer'), findsOneWidget);
  });
}
