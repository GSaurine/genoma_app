/// Validadores para formulários
class AppValidators {
  /// Valida email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }

    return null;
  }

  /// Valida senha
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }

    return null;
  }

  /// Valida confirmação de senha
  static String? validatePasswordConfirmation(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }

    if (value != password) {
      return 'As senhas não correspondem';
    }

    return null;
  }

  /// Valida nome de usuário
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome de usuário é obrigatório';
    }

    if (value.length < 3) {
      return 'Nome de usuário deve ter pelo menos 3 caracteres';
    }

    if (value.length > 20) {
      return 'Nome de usuário não pode ter mais de 20 caracteres';
    }

    return null;
  }

  /// Valida campo obrigatório
  static String? validateRequired(String? value, {String fieldName = 'Campo'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  /// Valida CPF (formato básico)
  static String? validateCPF(String? value) {
    if (value == null || value.isEmpty) {
      return 'CPF é obrigatório';
    }

    final cpfRegex = RegExp(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$|^\d{11}$');
    if (!cpfRegex.hasMatch(value)) {
      return 'CPF inválido';
    }

    return null;
  }

  /// Valida telefone
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefone é obrigatório';
    }

    final phoneRegex = RegExp(r'^(\+55)?[\s]?(\(\d{2}\))?[\s]?\d{4,5}[-\s]?\d{4}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Telefone inválido';
    }

    return null;
  }

  /// Valida URL
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL é obrigatória';
    }

    try {
      Uri.parse(value);
      return null;
    } catch (e) {
      return 'URL inválida';
    }
  }

  /// Valida data
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Data é obrigatória';
    }

    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'Data inválida';
    }
  }

  /// Valida mínimo de caracteres
  static String? validateMinLength(String? value, int minLength) {
    if (value == null || value.isEmpty) {
      return 'Campo é obrigatório';
    }

    if (value.length < minLength) {
      return 'Mínimo de $minLength caracteres';
    }

    return null;
  }

  /// Valida máximo de caracteres
  static String? validateMaxLength(String? value, int maxLength) {
    if (value != null && value.length > maxLength) {
      return 'Máximo de $maxLength caracteres';
    }

    return null;
  }

  /// Valida CNPJ
  static String? validateCNPJ(String? value) {
    if (value == null || value.isEmpty) {
      return 'CNPJ é obrigatório';
    }

    final cnpjRegex = RegExp(r'^\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}$|^\d{14}$');
    if (!cnpjRegex.hasMatch(value)) {
      return 'CNPJ inválido';
    }

    return null;
  }
}
