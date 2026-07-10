import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedGradientCard extends StatefulWidget {
  final Widget child;
  final Gradient gradient;
  const AnimatedGradientCard({super.key, required this.child, this.gradient = AppColors.primaryGradient});

  @override
  State<AnimatedGradientCard> createState() => _AnimatedGradientCardState();
}

class _AnimatedGradientCardState extends State<AnimatedGradientCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
  AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();
  late final Animation<double> _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        decoration: BoxDecoration(gradient: widget.gradient, borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.all(20),
        child: widget.child,
      ),
    );
  }
}