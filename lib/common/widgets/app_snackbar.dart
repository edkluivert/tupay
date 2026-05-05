import 'package:tupay/common/widgets/widget.dart';

class AppSnackBar {
  const AppSnackBar._();

  static void showFailure(
      BuildContext context, {
        required String message,
      }) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.red100,
      icon: Icons.error_outline_rounded,
    );
  }

  static void showSuccess(
      BuildContext context, {
        required String message,
      }) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.success600,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  static void _show(
      BuildContext context, {
        required String message,
        required Color backgroundColor,
        required IconData icon,
      }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: backgroundColor,
          elevation: 0,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              Icon(
                icon,
                color: AppColors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}