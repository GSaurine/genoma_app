# Dependências do Projeto - Genoma App

## Como usar este arquivo

Copie as dependências listadas abaixo e adicione ao seu `pubspec.yaml` do projeto.

## Dependências Requeridas

```yaml
name: genoma_app
description: "Sistema de Genoma - Aplicação Flutter"
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # =====================
  # STATE MANAGEMENT
  # =====================
  flutter_bloc: ^8.1.0
  bloc: ^8.1.0
  equatable: ^2.0.5

  # =====================
  # ROUTING
  # =====================
  go_router: ^10.0.0

  # =====================
  # HTTP & NETWORKING
  # =====================
  dio: ^5.3.0
  connectivity_plus: ^5.0.0

  # =====================
  # STORAGE & PERSISTENCE
  # =====================
  shared_preferences: ^2.2.0
  flutter_secure_storage: ^9.0.0

  # =====================
  # DEPENDENCY INJECTION
  # =====================
  get_it: ^7.6.0

  # =====================
  # DATE & TIME
  # =====================
  intl: ^0.19.0

  # =====================
  # JSON SERIALIZATION
  # =====================
  json_annotation: ^4.8.0

  # =====================
  # FUNCTIONAL PROGRAMMING
  # =====================
  dartz: ^0.10.1

  # =====================
  # UI & DESIGN
  # =====================
  google_fonts: ^6.0.0
  flutter_svg: ^2.0.7
  cached_network_image: ^3.3.0

  # =====================
  # OTHERS
  # =====================
  logger: ^2.0.0
  freezed_annotation: ^2.4.1

dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^3.0.0
  
  # =====================
  # CODE GENERATION
  # =====================
  build_runner: ^2.4.0
  json_serializable: ^6.7.0
  freezed: ^2.4.1

flutter:
  uses-material-design: true
  
  # =====================
  # ASSETS
  # =====================
  assets:
    - assets/images/
    - assets/icons/
    - assets/lottie/
  
  # =====================
  # FONTS
  # =====================
  fonts:
    - family: SFPro
      fonts:
        - asset: assets/fonts/SFProDisplay-Regular.otf
        - asset: assets/fonts/SFProDisplay-Bold.otf
          weight: 700

```

## Descrição das Dependências Principais

### State Management
- **flutter_bloc**: Implementação do padrão BLoC
- **bloc**: Biblioteca base do BLoC
- **equatable**: Comparação de objetos sem override equals

### Routing
- **go_router**: Sistema de roteamento moderno e nomeado

### Network
- **dio**: Cliente HTTP com interceptors
- **connectivity_plus**: Verificação de conexão

### Storage
- **shared_preferences**: Armazenamento local simples
- **flutter_secure_storage**: Armazenamento seguro de tokens

### Data Processing
- **json_annotation**: Anotações para serialização JSON
- **dartz**: Tipos funcionais (Either, Option)

### UI
- **google_fonts**: Fontes do Google
- **flutter_svg**: Renderizado de SVG
- **cached_network_image**: Cache de imagens

## Instalação

1. Abra um terminal na pasta do projeto
2. Execute: `flutter pub get`
3. Para gerar código (JSON, etc): `flutter pub run build_runner build`

## Troubleshooting

### Se encontrar erro de conflito de dependências
```bash
flutter pub upgrade
```

### Para limpar build
```bash
flutter clean
flutter pub get
```

### Para regenerar código
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```
