/// Caminhos de assets (imagens, fontes, etc)
class AppAssets {
  // Diretório base
  static const String _baseImagePath = 'assets/images';
  static const String _baseIconPath = 'assets/icons';
  static const String _baseLottePath = 'assets/lottie';

  // Imagens
  static const String logo = '$_baseImagePath/logo.png';
  static const String logoWhite = '$_baseImagePath/logo_white.png';
  static const String splashBackground = '$_baseImagePath/splash_background.png';
  static const String emptyState = '$_baseImagePath/empty_state.png';
  static const String errorState = '$_baseImagePath/error_state.png';

  // Ícones
  static const String homeIcon = '$_baseIconPath/home.svg';
  static const String pacientesIcon = '$_baseIconPath/pacientes.svg';
  static const String medicosIcon = '$_baseIconPath/medicos.svg';
  static const String testesIcon = '$_baseIconPath/testes.svg';
  static const String pedidosIcon = '$_baseIconPath/pedidos.svg';
  static const String resultadosIcon = '$_baseIconPath/resultados.svg';
  static const String settingsIcon = '$_baseIconPath/settings.svg';
  static const String profileIcon = '$_baseIconPath/profile.svg';
  static const String logoutIcon = '$_baseIconPath/logout.svg';
  static const String searchIcon = '$_baseIconPath/search.svg';
  static const String filterIcon = '$_baseIconPath/filter.svg';
  static const String addIcon = '$_baseIconPath/add.svg';
  static const String editIcon = '$_baseIconPath/edit.svg';
  static const String deleteIcon = '$_baseIconPath/delete.svg';
  static const String downloadIcon = '$_baseIconPath/download.svg';
  static const String shareIcon = '$_baseIconPath/share.svg';

  // Animações Lottie
  static const String loadingAnimation = '$_baseLottePath/loading.json';
  static const String successAnimation = '$_baseLottePath/success.json';
  static const String errorAnimation = '$_baseLottePath/error.json';
  static const String emptyAnimation = '$_baseLottePath/empty.json';

  // Fontes customizadas (se houver)
  static const String fontSfPro = 'SFPro';
  static const String fontInter = 'Inter';
}
