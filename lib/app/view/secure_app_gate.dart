import 'package:tupay/app/app.dart';
import 'package:tupay/core/constants/app_colors.dart';

class SecureAppGate extends StatefulWidget {
  const SecureAppGate({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<SecureAppGate> createState() => _SecureAppGateState();
}

class _SecureAppGateState extends State<SecureAppGate>
    with WidgetsBindingObserver {
  SecureApplicationController? _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= SecureApplicationProvider.of(context, listen: false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null) return;

    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        controller.secure();

      case AppLifecycleState.resumed:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller..authSuccess(unlock: true)
          ..open();
        });

      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SecureGate(
      blurr: 10,
      opacity: 0.5,
      lockedBuilder: (context, secureNotifier) => const ColoredBox(
        color: AppColors.primaryColor,
        child: Center(
          child: Icon(
            Icons.lock_outline,
            size: 48,
            color: AppColors.secondaryColor,
          ),
        ),
      ),
      child: widget.child,
    );
  }
}