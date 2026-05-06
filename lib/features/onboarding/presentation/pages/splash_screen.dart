import 'dart:math' as math;

import 'package:tupay/features/features.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final List<String> _letters = const ['T', 'u', 'P', 'a', 'y'];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _letterAnimation(int index) {
    final start = index * 0.11;
    final end = start + 0.46;

    return CurvedAnimation(
      parent: _controller,
      curve: Interval(
        start,
        end.clamp(0.0, 1.0),
      ),
    );
  }

  Animation<double> get _logoBounceAnimation {
    return CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.72,
        1,
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _logoBounceAnimation,
          builder: (context, child) {
            final value = _logoBounceAnimation.value;
            final scale = 1 + (math.sin(value * math.pi) * 0.035);

            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(_letters.length, (index) {
              return _AnimatedSplashLetter(
                letter: _letters[index],
                animation: _letterAnimation(index),
                startOffset: screenWidth + (index * 56),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _AnimatedSplashLetter extends StatelessWidget {
  const _AnimatedSplashLetter({
    required this.letter,
    required this.animation,
    required this.startOffset,
  });

  final String letter;
  final Animation<double> animation;
  final double startOffset;

  double _collisionDx(double value) {
    if (value <= 0) return startOffset;

    if (value < 0.72) {
      final progress = Curves.easeOutCubic.transform(value / 0.72);
      return startOffset * (1 - progress) + 10;
    }

    if (value < 0.86) {
      final progress = Curves.easeOut.transform((value - 0.72) / 0.14);
      return 10 + (-4 - 10) * progress;
    }

    final progress = Curves.easeOut.transform((value - 0.86) / 0.14);
    return -4 + (0 - (-4)) * progress;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final value = animation.value;

          final dx = _collisionDx(value);
          final scaleBump = math.sin(value * math.pi) * 0.045;
          final scale = 1 + scaleBump;

          return Opacity(
            opacity: value == 0 ? 0 : 1,
            child: Transform.translate(
              offset: Offset(dx, 0),
              child: Transform.scale(
                scale: scale,
                child: child,
              ),
            ),
          );
        },
        child: Text(
          letter,
          textAlign: TextAlign.center,
          style: context.appTextTheme.heading!.copyWith(
            color: AppColors.white,
            fontSize: 56,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}