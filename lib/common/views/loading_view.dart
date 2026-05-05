import 'package:tupay/common/widgets/widget.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomCircularProgressIndicator(
          color: AppColors.secondaryColor,
        ),
      ),
    );
  }
}
