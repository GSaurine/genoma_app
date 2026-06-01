import 'package:flutter/material.dart';

class StateView extends StatelessWidget {
  final bool loading;
  final String? error;
  final bool empty;
  final Widget? child;
  final VoidCallback? onRetry;

  const StateView({Key? key, required this.loading, this.error, this.empty = false, this.child, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            if (onRetry != null)
              ElevatedButton(onPressed: onRetry, child: const Text('Tentar novamente')),
          ],
        ),
      );
    }
    if (empty) return const Center(child: Text('Nenhum registro encontrado'));
    return child ?? const SizedBox.shrink();
  }
}
