import 'package:flutter_svg/svg.dart';
import 'package:tupay/core/injections/injection.dart';
import 'package:tupay/features/app_bottom_nav/presentation/state_manager/app_bottom_nav_cubit.dart';
import 'package:tupay/features/app_bottom_nav/presentation/state_manager/bottom_nav_state.dart';
import 'package:tupay/features/card/presentation/pages/card_screen.dart';
import 'package:tupay/features/features.dart';
import 'package:tupay/features/home/presentation/pages/home_screen.dart';
import 'package:tupay/features/profile/presentation/pages/profile_screen.dart';
import 'package:tupay/features/transfer/presentation/pages/transfer_flow_screen.dart';

class AppBottomNavScreen extends StatefulWidget {
  const AppBottomNavScreen({super.key});

  @override
  State<AppBottomNavScreen> createState() => _AppBottomNavScreenState();
}

class _AppBottomNavScreenState extends State<AppBottomNavScreen>
    with WidgetsBindingObserver {
  final appBottomNavCubit = sl<AppBottomNavCubit>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: appBottomNavCubit,
        ),
      ],
      child: BlocBuilder<AppBottomNavCubit, BottomNavState>(
        builder: (context, tabIndex) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (c, s) {
              if (tabIndex.index > 0) {
                context.read<AppBottomNavCubit>().changeTabIndex(0);
              }
            },
            child: Scaffold(
              body: IndexedStack(
                index: tabIndex.index,
                children: [
                  HomeScreen(),
                  CardScreen(),
                  TransferFlowScreen(),
                  ProfileScreen(),
                ],
              ),
              bottomNavigationBar: Container(
                height: 108,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.14),
                      blurRadius: 30,
                      spreadRadius: 2,
                      offset: const Offset(0, -6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 2,
                    ),
                    child: BottomNavigationBar(
                      unselectedItemColor: AppColors.grey200,
                      selectedItemColor: AppColors.secondaryColor,
                      unselectedLabelStyle:
                      theme.bodyNormal16Bold?.copyWith(
                        color: AppColors.grey200,
                        fontSize: 13,
                        letterSpacing: 1.2,
                      ),
                      selectedLabelStyle: theme.bodyNormal16Bold?.copyWith(
                        fontSize: 13,
                        color: AppColors.secondaryColor,
                        letterSpacing: 1.2,
                      ),
                      showSelectedLabels: true,
                      showUnselectedLabels: true,
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: AppColors.white,
                      elevation: 0,
                      currentIndex: tabIndex.index,
                      onTap: (index) {
                        context
                            .read<AppBottomNavCubit>()
                            .changeTabIndex(index);
                        appBottomNavCubit.toggleWidth();
                      },
                      items: _buildNavigationItems(),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<BottomNavigationBarItem> _buildNavigationItems() {
    return [
      _buildNavItem(
        activeIcon: AppAssets.homeActive.svg,
        inactiveIcon: AppAssets.home.svg,
        label: 'HOME',
      ),
      _buildNavItem(
        activeIcon: AppAssets.card.svg,
        inactiveIcon: AppAssets.card.svg,
        label: 'CARDS',
      ),
      _buildNavItem(
        activeIcon: AppAssets.transfer.svg,
        inactiveIcon: AppAssets.transfer.svg,
        label: 'TRANSFER',
      ),
      _buildNavItem(
        activeIcon: AppAssets.user.svg,
        inactiveIcon: AppAssets.user.svg,
        label: 'PROFILE',
      ),
    ];
  }

  BottomNavigationBarItem _buildNavItem({
    required String activeIcon,
    required String inactiveIcon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Stack(
          children: [
            Center(
              child: SvgPicture.asset(
                inactiveIcon,
                colorFilter: const ColorFilter.mode(
                  AppColors.grey200,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(
          bottom: 4,
        ),
        child: Stack(
          children: [
            Center(
              child: SvgPicture.asset(
                activeIcon,
                colorFilter: const ColorFilter.mode(
                  AppColors.secondaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
      label: label,
    );
  }
}