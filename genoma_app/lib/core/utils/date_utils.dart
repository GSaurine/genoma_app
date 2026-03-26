/// Utilitários para trabalhar com datas
class AppDateUtils {
  /// Obtém a diferença em dias entre duas datas
  static int daysBetween(DateTime from, DateTime to) {
    return to.difference(from).inDays;
  }

  /// Verifica se a data é hoje
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  /// Verifica se a data é ontem
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
  }

  /// Verifica se a data é amanhã
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day;
  }

  /// Obtém o primeiro dia do mês
  static DateTime firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Obtém o último dia do mês
  static DateTime lastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1).subtract(const Duration(days: 1));
  }

  /// Obtém o primeiro dia da semana
  static DateTime firstDayOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  /// Obtém o último dia da semana
  static DateTime lastDayOfWeek(DateTime date) {
    return date.add(Duration(days: 7 - date.weekday));
  }

  /// Verifica se o ano é bissexto
  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  /// Obtém a idade a partir da data de nascimento
  static int getAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    
    return age;
  }

  /// Verifica se a data é válida
  static bool isValidDate(String dateString) {
    try {
      DateTime.parse(dateString);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Obtém nome do dia da semana
  static String getDayOfWeekName(DateTime date) {
    const days = ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'];
    return days[date.weekday - 1];
  }

  /// Obtém nome do mês
  static String getMonthName(DateTime date) {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return months[date.month - 1];
  }

  /// Formata duração
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours h $minutes min';
    } else if (minutes > 0) {
      return '$minutes min $seconds seg';
    } else {
      return '${seconds}seg';
    }
  }

  /// Converte timestamp para DateTime
  static DateTime fromTimestamp(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Converte DateTime para timestamp
  static int toTimestamp(DateTime date) {
    return date.millisecondsSinceEpoch;
  }

  /// Obtém a próxima ocorrência de um determinado dia da semana
  static DateTime getNextDayOfWeek(int dayOfWeek) {
    final now = DateTime.now();
    var daysToAdd = dayOfWeek - now.weekday;
    
    if (daysToAdd <= 0) {
      daysToAdd += 7;
    }
    
    return now.add(Duration(days: daysToAdd));
  }

  /// Verifica se duas datas são no mesmo dia
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Cria DateTime a partir de componentes
  static DateTime createDate(int year, int month, int day, {int hour = 0, int minute = 0, int second = 0}) {
    return DateTime(year, month, day, hour, minute, second);
  }

  /// Obtém o início do dia (00:00:00)
  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Obtém o final do dia (23:59:59)
  static DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }
}
