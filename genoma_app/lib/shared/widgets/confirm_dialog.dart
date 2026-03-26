import 'package:flutter/material.dart';
import '../../core/config/app_colors.dart';

/// Widget de diálogo de confirmação
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String positiveLabel;
  final String negativeLabel;
  final VoidCallback onPositive;
  final VoidCallback? onNegative;
  final Color positiveButtonColor;
  final bool isDangerous;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.positiveLabel = 'Confirmar',
    this.negativeLabel = 'Cancelar',
    required this.onPositive,
    this.onNegative,
    this.positiveButtonColor = AppColors.primary,
    this.isDangerous = false,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String positiveLabel = 'Confirmar',
    String negativeLabel = 'Cancelar',
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: title,
        message: message,
        positiveLabel: positiveLabel,
        negativeLabel: negativeLabel,
        onPositive: () => Navigator.of(context).pop(true),
        onNegative: () => Navigator.of(context).pop(false),
        isDangerous: isDangerous,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            if (onNegative != null) onNegative!();
            Navigator.of(context).pop();
          },
          child: Text(negativeLabel),
        ),
        ElevatedButton(
          onPressed: () {
            onPositive();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isDangerous ? AppColors.error : positiveButtonColor,
          ),
          child: Text(positiveLabel),
        ),
      ],
    );
  }
}
