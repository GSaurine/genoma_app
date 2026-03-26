import 'package:intl/intl.dart';

/// Formatadores para exibição de dados
class AppFormatters {
  /// Formata CPF
  static String formatCPF(String cpf) {
    final cleanCPF = cpf.replaceAll(RegExp(r'\D'), '');
    if (cleanCPF.length != 11) return cpf;
    return '${cleanCPF.substring(0, 3)}.${cleanCPF.substring(3, 6)}.${cleanCPF.substring(6, 9)}-${cleanCPF.substring(9)}';
  }

  /// Formata CNPJ
  static String formatCNPJ(String cnpj) {
    final cleanCNPJ = cnpj.replaceAll(RegExp(r'\D'), '');
    if (cleanCNPJ.length != 14) return cnpj;
    return '${cleanCNPJ.substring(0, 2)}.${cleanCNPJ.substring(2, 5)}.${cleanCNPJ.substring(5, 8)}/​${cleanCNPJ.substring(8, 12)}-${cleanCNPJ.substring(12)}';
  }

  /// Formata telefone
  static String formatPhone(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    if (cleanPhone.length < 10) return phone;

    if (cleanPhone.startsWith('55')) {
      // Internacional
      final areaCode = cleanPhone.substring(2, 4);
      final firstPart = cleanPhone.substring(4, 9);
      final secondPart = cleanPhone.substring(9);
      return '+55 ($areaCode) $firstPart-$secondPart';
    } else {
      // Local
      final areaCode = cleanPhone.substring(0, 2);
      final firstPart = cleanPhone.substring(2, 7);
      final secondPart = cleanPhone.substring(7);
      return '($areaCode) $firstPart-$secondPart';
    }
  }

  /// Formata moeda brasileira
  static String formatCurrency(double value) {
    return NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$ ',
      decimalDigits: 2,
    ).format(value);
  }

  /// Formata número com separador de milhar
  static String formatNumber(num value) {
    return NumberFormat('#,##0', 'pt_BR').format(value);
  }

  /// Formata percentual
  static String formatPercentage(double value, {int decimals = 2}) {
    return NumberFormat.percentPattern().format(value / 100);
  }

  /// Formata data
  static String formatDate(DateTime date, {String pattern = 'dd/MM/yyyy'}) {
    return DateFormat(pattern, 'pt_BR').format(date);
  }

  /// Formata data e hora
  static String formatDateTime(DateTime dateTime, {String pattern = 'dd/MM/yyyy HH:mm'}) {
    return DateFormat(pattern, 'pt_BR').format(dateTime);
  }

  /// Formata apenas hora
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm', 'pt_BR').format(dateTime);
  }

  /// Formata data relativa (ex: "há 2 horas")
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'agora mesmo';
    } else if (difference.inMinutes < 60) {
      return 'há ${difference.inMinutes} minuto(s)';
    } else if (difference.inHours < 24) {
      return 'há ${difference.inHours} hora(s)';
    } else if (difference.inDays < 7) {
      return 'há ${difference.inDays} dia(s)';
    } else {
      return formatDate(date);
    }
  }

  /// Remove caracteres especiais
  static String removeSpecialCharacters(String text) {
    return text.replaceAll(RegExp(r'[^\w\s]'), '');
  }

  /// Capitaliza primeira letra
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Capitaliza cada palavra
  static String capitalizeWords(String text) {
    return text
        .split(' ')
        .map((word) => capitalize(word))
        .join(' ');
  }

  /// Limita número de caracteres com ellipsis
  static String limitCharacters(String text, int limit) {
    if (text.length <= limit) return text;
    return '${text.substring(0, limit)}...';
  }

  /// Formata arquivo por tamanho
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  /// Remove máscara de números
  static String removeNumberMask(String value) {
    return value.replaceAll(RegExp(r'\D'), '');
  }
}
