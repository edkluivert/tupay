import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tupay/core/constants/app_assets.dart';
import 'package:tupay/core/core.dart';

class BouncyWidget extends StatefulWidget {

  const BouncyWidget({
    required this.child,
    this.interval = const Duration(seconds: 3),
    this.duration = const Duration(seconds: 3),
    super.key,
  });
  final Widget child;
  final Duration interval;
  final Duration duration;

  @override
  State<BouncyWidget> createState() => _BouncyWidgetState();
}

class _BouncyWidgetState extends State<BouncyWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(widget.interval, () {
          _controller.forward(from: 0);
        });
      }
    });

    _scaleAnimation = Tween<double>(begin: 1, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}

class RightTransition extends StatefulWidget {

  const RightTransition({required this.child,
    this.duration = const Duration(milliseconds: 500),
    super.key,
  });
  final Widget child;
  final Duration duration;

  @override
  State<RightTransition> createState() => _RightTransitionState();
}

class _RightTransitionState extends State<RightTransition> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..forward();

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ),);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: widget.child,
    );
  }
}

class LeftTransition extends StatefulWidget {

  const LeftTransition({required this.child,
    this.duration = const Duration(milliseconds: 500),
    super.key,
  });
  final Widget child;
  final Duration duration;

  @override
  State<LeftTransition> createState() => _LeftTransitionState();
}

class _LeftTransitionState extends State<LeftTransition> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..forward();

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ),);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: widget.child,
    );
  }
}



class ListTransition extends StatefulWidget {

  const ListTransition({
    required this.index,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    super.key,
  });
  final int index;
  final Duration duration;
  final Widget child;

  @override
  State<ListTransition> createState() => _ListTransitionState();
}

class _ListTransitionState extends State<ListTransition> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _animations = List.generate(10, (index) {
      return Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(0.1 * index, 1, curve: Curves.easeInOut),
      ),);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animations[widget.index],
      child: widget.child,
    );
  }
}




class BellShakeAnimation extends StatefulWidget {

  const BellShakeAnimation({
    this.isLooping = false, // Play once
    this.notificationCount = 0, // No notifications
    this.onClick,
    super.key,
  });
  final bool isLooping;
  final int notificationCount;
  final GestureTapCallback? onClick;

  @override
  State<BellShakeAnimation> createState() => _BellShakeAnimationState();
}

class _BellShakeAnimationState extends State<BellShakeAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int _prevCount = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 0.25 * pi), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 0.25 * pi, end: -0.25 * pi), weight: 30),
      TweenSequenceItem(tween: Tween(begin: -0.25 * pi, end: 0.15 * pi), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.15 * pi, end: -0.1 * pi), weight: 15),
      TweenSequenceItem(tween: Tween(begin: -0.1 * pi, end: 0.05 * pi), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 0.05 * pi, end: 0), weight: 15),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isLooping) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant BellShakeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If notification count increases and looping is off, shake the bell
    if (!widget.isLooping && widget.notificationCount > _prevCount) {
      _controller.forward(from: 0);
    }

    _prevCount = widget.notificationCount; // Update previous count
  }

  /// Start animation manually
  void startShake() {
    if (!widget.isLooping) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {

    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: startShake,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            child: InkWell(
              onTap: widget.onClick ?? () {

              },
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:8),
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animation.value,
                        child: child,
                      );
                    },
                    child: const Icon(Icons.notifications_none_outlined,
                     size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),

          if (widget.notificationCount > 0)
          Positioned(
            left: 30,
            top: 5,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
