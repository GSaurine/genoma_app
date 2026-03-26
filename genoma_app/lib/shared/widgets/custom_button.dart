import 'package:flutter/material.dart';
import '../../core/config/app_colors.dart';

/// Widget de botão customizado
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isSmall = size == ButtonSize.small;
    final isMedium = size == ButtonSize.medium;

    final padding = isSmall
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
        : isMedium
            ? const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
            : const EdgeInsets.symmetric(horizontal: 32, vertical: 16);

    final fontSize = isSmall ? 12.0 : isMedium ? 14.0 : 16.0;

    Widget buttonContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null && !isLoading) ...[
          Icon(icon, size: fontSize + 2),
          const SizedBox(width: 8),
        ],
        if (isLoading)
          SizedBox(
            width: fontSize,
            height: fontSize,
            child: const CircularProgressIndicator(strokeWidth: 2),
          )
        else
          Text(label, style: TextStyle(fontSize: fontSize)),
      ],
    );

    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton(
          onPressed: isEnabled && !isLoading ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: buttonContent,
        );

      case ButtonVariant.secondary:
        return ElevatedButton(
          onPressed: isEnabled && !isLoading ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.white,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: buttonContent,
        );

      case ButtonVariant.outline:
        return OutlinedButton(
          onPressed: isEnabled && !isLoading ? onPressed : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: buttonContent,
        );

      case ButtonVariant.text:
        return TextButton(
          onPressed: isEnabled && !isLoading ? onPressed : null,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: padding,
          ),
          child: buttonContent,
        );

      case ButtonVariant.danger:
        return ElevatedButton(
          onPressed: isEnabled && !isLoading ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.white,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: buttonContent,
        );
    }
  }
}

enum ButtonVariant { primary, secondary, outline, text, danger }
enum ButtonSize { small, medium, large }
