import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DecorativeBackground extends StatelessWidget {
  final Widget child;
  final bool showIcons;

  const DecorativeBackground({
    super.key,
    required this.child,
    this.showIcons = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Soft blurred color blobs
        Positioned(
          top: -80,
          right: -60,
          child: _blob(220, AppColors.primary.withOpacity(0.12)),
        ),
        Positioned(
          top: 180,
          left: -90,
          child: _blob(180, AppColors.secondary.withOpacity(0.10)),
        ),
        Positioned(
          bottom: -100,
          right: -50,
          child: _blob(260, AppColors.accent.withOpacity(0.08)),
        ),

        // Faint floating study icons
        if (showIcons) ...[
          _floatingIcon(Icons.menu_book_rounded, top: 90, left: 24, size: 46, angle: -0.15),
          _floatingIcon(Icons.school_rounded, top: 40, right: 40, size: 38, angle: 0.2),
          _floatingIcon(Icons.lightbulb_rounded, bottom: 140, left: 30, size: 34, angle: 0.1),
          _floatingIcon(Icons.auto_awesome_rounded, bottom: 220, right: 20, size: 28, angle: -0.2),
        ],

        // Actual screen content on top
        child,
      ],
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _floatingIcon(
      IconData icon, {
        double? top,
        double? bottom,
        double? left,
        double? right,
        required double size,
        required double angle,
      }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Transform.rotate(
        angle: angle,
        child: Icon(icon, size: size, color: AppColors.primary.withOpacity(0.06)),
      ),
    );
  }
}