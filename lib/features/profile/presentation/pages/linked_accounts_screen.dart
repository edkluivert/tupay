import 'package:tupay/common/widgets/default_app_bar.dart';
import 'package:tupay/features/features.dart';
import 'package:tupay/features/profile/presentation/state_manager/profile_state.dart';
import 'package:tupay/features/profile/presentation/widgets/daily_limit_info.dart';
import 'package:tupay/features/profile/presentation/widgets/linked_accounts_widget.dart';
import 'package:tupay/features/profile/presentation/widgets/security_status_card.dart';

class LinkedAccountsScreen extends StatelessWidget {
  const LinkedAccountsScreen({
    required this.state,
    super.key,
  });

  final ProfileSuccess state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(title: 'Linked Accounts',) ,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePadding,
        ),
        child: Column(
          spacing: 24,
          children: [
            SecurityStatusCard(percent: state.securityPercent),

            DailyLimitCard(state: state),

            LinkedMethodsCard(state: state),
          ],
        ),
      ),
    );
  }
}
