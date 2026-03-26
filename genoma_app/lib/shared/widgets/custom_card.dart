import 'package:flutter/material.dart';
import '../../core/config/app_colors.dart';

/// Widget de Card customizado
class CustomCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double elevation;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;
  final Border? border;
  final BoxShadow? boxShadow;

  const CustomCard({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.white,
    this.elevation = 2,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.onTap,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: border,
        boxShadow: boxShadow != null ? [boxShadow!] : null,
      ),
      child: Card(
        elevation: elevation,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        color: backgroundColor,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}
