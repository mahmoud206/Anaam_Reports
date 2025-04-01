import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class IntroAnimation extends StatefulWidget {
  final VoidCallback onComplete;

  const IntroAnimation({super.key, required this.onComplete});

  @override
  State<IntroAnimation> createState() => _IntroAnimationState();
}

class _IntroAnimationState extends State<IntroAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/vet_intro.json',
              controller: _controller,
              width: 300,
              height: 300,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 30),
            Text(
              'نظام تقارير العيادة البيطرية',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.5, end: 0),
            const SizedBox(height: 20),
            Text(
              'إصدار 2025',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white70,
              ),
            ).animate().fadeIn(delay: 1000.ms),
          ],
        ),
      ),
    );
  }
}