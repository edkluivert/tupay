import 'package:flutter_svg/svg.dart';
import 'package:tupay/features/features.dart';

class AuthHeaderIcon extends StatelessWidget {
  const AuthHeaderIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.greenText1,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              offset: const Offset(0, 1),
              blurRadius: 2,
            )
          ]
      ),
      child: Center(
        child: SvgPicture.asset(AppAssets.secure.svg),
      ),
    );
  }
}
