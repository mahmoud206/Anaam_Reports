import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final double elevation;
  final bool disabled;

  const AppButton({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.elevation = 4,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: disabled
              ? Colors.grey.shade400
              : backgroundColor ?? theme.primaryColor,
          foregroundColor: textColor ?? Colors.white,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: disabled || isLoading ? null : onPressed,
        child: isLoading
            ? const CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: theme.textTheme.titleLarge?.copyWith(
                color: textColor ?? Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ).animate(
        onPlay: (controller) => controller.repeat(),
      ).shimmer(
        delay: 1000.ms,
        duration: 1000.ms,
        color: Colors.white.withOpacity(0.2),
      ),
    );
  }
}