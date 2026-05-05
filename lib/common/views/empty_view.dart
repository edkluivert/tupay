import 'package:tupay/common/widgets/widget.dart';
import 'package:tupay/core/extensions/other_extensions.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('No data yet.',
            style: context.appTextTheme.bodySmall14Regular?.copyWith(
              color: AppColors.textColor,
            ),
        ),
      ),
    );
  }
}