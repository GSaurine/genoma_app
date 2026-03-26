import 'package:flutter/material.dart';

/// Extension methods para adicionar funcionalidades extras
extension StringExtension on String {
  /// Capitaliza a primeira letra
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Verifica se é um email válido
  bool isValidEmail() {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Remove espaços em branco
  String removeWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Converte para camelCase
  String toCamelCase() {
    List<String> words = split(' ');
    String camelCase = words.first.toLowerCase();
    for (int i = 1; i < words.length; i++) {
      camelCase += words[i].capitalize();
    }
    return camelCase;
  }

  /// Converte para snake_case
  String toSnakeCase() {
    // Dart RegExp não suporta lookbehind, usando alternativa
    final result = StringBuffer();
    for (var i = 0; i < length; i++) {
      final char = this[i];
      if (char == char.toUpperCase() && i > 0 && this[i - 1] != '_') {
        result.write('_${char.toLowerCase()}');
      } else {
        result.write(char.toLowerCase());
      }
    }
    return result.toString();
  }

  /// Verifica se a string contém apenas números
  bool isNumeric() {
    return RegExp(r'^-?\d+$').hasMatch(this);
  }

  /// Limita número de caracteres
  String limitCharacters(int limit) {
    if (length <= limit) return this;
    return '${substring(0, limit)}...';
  }
}

extension ListExtension<T> on List<T> {
  /// Remove duplicatas da lista
  List<T> removeDuplicates() {
    return toSet().toList();
  }

  /// Agrupa elementos por uma chave
  Map<K, List<T>> groupBy<K>(K Function(T) keyFunction) {
    final grouped = <K, List<T>>{};
    for (var element in this) {
      final key = keyFunction(element);
      grouped.putIfAbsent(key, () => []).add(element);
    }
    return grouped;
  }

  /// Verifica se a lista está vazia
  bool get isEmpty => length == 0;

  /// Verifica se a lista não está vazia
  bool get isNotEmpty => length > 0;

  /// Obtém o primeiro elemento seguramente
  T? get firstOrNull => isNotEmpty ? first : null;

  /// Obtém o último elemento seguramente
  T? get lastOrNull => isNotEmpty ? last : null;
}

extension NumExtension on num {
  /// Converte milissegundos para segundos
  Duration get milliseconds => Duration(milliseconds: toInt());

  /// Converte segundos para Duration
  Duration get seconds => Duration(seconds: toInt());

  /// Converte minutos para Duration
  Duration get minutes => Duration(minutes: toInt());

  /// Converte horas para Duration
  Duration get hours => Duration(hours: toInt());

  /// Converte dias para Duration
  Duration get days => Duration(days: toInt());

  /// Arredonda para número específico de casas decimais
  double toDecimal(int decimal) {
    return double.parse(toStringAsFixed(decimal));
  }
}

extension DateTimeExtension on DateTime {
  /// Obtém apenas a data sem hora
  DateTime get dateOnly {
    return DateTime(year, month, day);
  }

  /// Adiciona dias
  DateTime addDays(int days) {
    return add(Duration(days: days));
  }

  /// Subtrai dias
  DateTime subtractDays(int days) {
    return subtract(Duration(days: days));
  }

  /// Verifica se é hoje
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Verifica se é ontem
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  /// Verifica se é amanhã
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  /// Obtém o início do dia
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  /// Obtém o final do dia
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59);
  }
}

extension ContextExtension on BuildContext {
  /// Obtém a altura da tela
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Obtém a largura da tela
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Obtém o padding da tela (areas seguras)
  EdgeInsets get padding => MediaQuery.of(this).padding;

  /// Verifica se é modo portrait
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;

  /// Verifica se é modo landscape
  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;

  /// Verifica se o dispositivo é grande (tablet/desktop)
  bool get isLargeScreen => screenWidth > 600;

  /// Obtém o device pixel ratio
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// Pega o tamanho segura inferior (para devices com notch)
  double get viewInsetsBottom => MediaQuery.of(this).viewInsets.bottom;
}

extension WidgetExtension on Widget {
  /// Adiciona padding ao widget
  Padding withPadding(EdgeInsets padding) {
    return Padding(padding: padding, child: this);
  }

  /// Adiciona center ao widget
  Center withCenter() {
    return Center(child: this);
  }

  /// Adiciona singlechildscrollview
  SingleChildScrollView withScroll() {
    return SingleChildScrollView(child: this);
  }
}
