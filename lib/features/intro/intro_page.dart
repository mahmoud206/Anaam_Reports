import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:vet_reports_app/app/app_routes.dart';
import 'package:vet_reports_app/core/constants/strings.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _animationCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward().then((_) {
      setState(() => _animationCompleted = true);
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() {
    Future.delayed(500.ms, () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.databaseSelector);
      }
    });
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
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              Lottie.asset(
                'assets/animations/vet_intro.json',
                controller: _controller,
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 30),

              // App Name
              Text(
                AppStrings.appName,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.5, end: 0),

              const SizedBox(height: 20),

              // Version Info
              Text(
                'الإصدار 2025',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white70,
                ),
              ).animate().fadeIn(delay: 1000.ms),

              const Spacer(),

              // Skip Button (appears after 1.5 seconds)
              if (_animationCompleted)
                TextButton(
                  onPressed: () => _navigateToNextScreen(),
                  child: Text(
                    'تخطي',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ).animate().fadeIn(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}