import 'package:tupay/common/widgets/widget.dart';
import 'package:tupay/core/extensions/other_extensions.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.message,
   this.onTap,
    super.key,
  });
  final String message;

  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.red100, size: 48),
            const SizedBox(height: 16),
            Text(message, style: context.appTextTheme.bodyMedium?.copyWith(

            )),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onTap,
              child: Text('Retry', style: context.appTextTheme
                  .bodySmall14Regular?.copyWith(
                color: AppColors.textColor,
              )),
            ),
          ],
        ),
      ),
    );
  }
}

