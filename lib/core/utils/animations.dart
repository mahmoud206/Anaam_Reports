import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class AppAnimations {
  // Pre-configured animation effects
  static const fadeInSlideUp = <Effect<dynamic>>[
    FadeEffect(duration: Duration(milliseconds: 500)),
    SlideEffect(
      begin: Offset(0, 0.5),
      end: Offset.zero,
      duration: Duration(milliseconds: 500),
    )
  ];

  static const fadeInSlideRight = <Effect<dynamic>>[
    FadeEffect(duration: Duration(milliseconds: 500)),
    SlideEffect(
      begin: Offset(-0.5, 0),
      end: Offset.zero,
      duration: Duration(milliseconds: 500),
    )
  ];

  static const fadeInScale = <Effect<dynamic>>[
    FadeEffect(duration: Duration(milliseconds: 300)),
    ScaleEffect(
      begin: Offset(0.8, 0.8),
      end: Offset(1, 1),
      duration: Duration(milliseconds: 500),
    )
  ];

  // Pre-built animated widgets
  static Widget shimmerText(String text, {TextStyle? style}) {
    return Text(text, style: style)
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
      delay: 1000.ms,
      duration: 1000.ms,
      color: Colors.white.withOpacity(0.2),
    );
  }

  static Widget loadingIndicator({double size = 100, Color? color}) {
    return Lottie.asset(
      'assets/animations/loading.json',
      width: size,
      height: size,
      fit: BoxFit.contain,
      delegates: LottieDelegates(
        values: [
          ValueDelegate.color(
            const ['**'],
            value: color ?? Colors.green,
          ),
        ],
      ),
    );
  }

  static Widget successAnimation({double size = 150, VoidCallback? onComplete}) {
    return Lottie.asset(
      'assets/animations/success.json',
      width: size,
      height: size,
      fit: BoxFit.contain,
      repeat: false,
      delegates: LottieDelegates(
        values: [
          ValueDelegate.color(
            const ['**', 'fill'],
            value: Colors.green,
          ),
        ],
      ),
      onLoaded: (composition) {
        if (onComplete != null) {
          onComplete(); // Trigger the callback if it's not null
        }
      },
    );
  }

  static Widget errorAnimation({double size = 150}) {
    return Lottie.asset(
      'assets/animations/error.json',
      width: size,
      height: size,
      fit: BoxFit.contain,
      repeat: false,
    );
  }

  // Animation extensions for common widgets
  static Widget animatedContainer({
    required Widget child,
    Duration delay = const Duration(milliseconds: 0),
    List<Effect<dynamic>> effects = fadeInSlideUp,
  }) {
    return child.animate(delay: delay).then().addEffects(effects);
  }

  static Widget animatedListItem({
    required Widget child,
    required int index,
    List<Effect<dynamic>> effects = fadeInSlideRight,
  }) {
    return child.animate(delay: (100 * index).ms).then().addEffects(effects);
  }

  // Page transition animations
  static Route slideRightRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Route fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  static Route scaleRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  // Animation controllers
  static AnimationController createAnimationController(TickerProvider vsync) {
    return AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 800),
      reverseDuration: const Duration(milliseconds: 500),
    );
  }

  // Color animation utilities
  static ColorTween createPrimaryColorTween(BuildContext context) {
    return ColorTween(
      begin: Theme.of(context).primaryColor.withOpacity(0.5),
      end: Theme.of(context).primaryColor,
    );
  }
}

// Extension methods for common animation patterns
extension AnimatedWidgetExtensions on Widget {
  Widget animateEntrance({
    Duration delay = const Duration(milliseconds: 0),
    List<Effect<dynamic>> effects = AppAnimations.fadeInSlideUp,
  }) {
    return animate(delay: delay).then().addEffects(effects);
  }

  Widget animateOnTap(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: this,
    );
  }
}
