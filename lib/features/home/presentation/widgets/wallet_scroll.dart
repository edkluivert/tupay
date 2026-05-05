import 'package:tupay/core/injections/injection.dart';
import 'package:tupay/features/features.dart';
import 'package:tupay/features/wallet/data/models/wallet_model.dart';
import 'package:tupay/features/wallet/presentation/widgets/wallet_card.dart';

class WalletScroll extends StatelessWidget {
  const WalletScroll({
    required this.wallets,
    super.key,
  });

  final List<WalletModel> wallets;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: wallets.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final wallet = wallets[index];

          return Align(
            alignment: Alignment.topCenter,
            child: WalletCard(
              wallet: wallet,
              onTap: () {
                if (wallet.currency == 'USD') {
                  sl<NavigationService>().navigateTo(Routes.wallet);
                }
              },
            ),
          );
        },
      ),
    );
  }
}