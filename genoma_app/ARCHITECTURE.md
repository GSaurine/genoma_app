# Genoma App - Flutter Frontend

## 🏗️ Arquitetura

Este projeto segue a **Clean Architecture** com **BLoC Pattern** para gerenciamento de estado.

### Estrutura de Pastas

```
lib/
├── main.dart                          # Ponto de entrada
├── app.dart                           # Configuração da aplicação
├── injection_container.dart           # Injeção de dependência (GetIt)
├── router/
│   └── app_router.dart               # Configuração de rotas (GoRouter)
│
├── core/                              # Camada base
│   ├── config/
│   │   ├── app_config.dart           # Configurações gerais
│   │   ├── app_colors.dart           # Paleta de cores
│   │   ├── app_theme.dart            # Temas claro/escuro
│   │   └── app_routes.dart           # Rotas da aplicação
│   │
│   ├── constants/
│   │   ├── api_endpoints.dart        # URLs da API
│   │   ├── app_strings.dart          # Strings/Textos
│   │   └── app_assets.dart           # Caminhos de assets
│   │
│   ├── errors/
│   │   ├── exceptions.dart           # Exceções personalizadas
│   │   └── failures.dart             # Padrão Failure
│   │
│   ├── network/
│   │   ├── dio_client.dart           # Cliente HTTP (Dio)
│   │   ├── interceptors/
│   │   │   ├── auth_interceptor.dart
│   │   │   └── logging_interceptor.dart
│   │   └── network_info.dart         # Verificação de conectividade
│   │
│   ├── storage/
│   │   ├── local_storage_service.dart    # SharedPreferences
│   │   └── secure_storage_service.dart   # Tokens seguros
│   │
│   └── utils/
│       ├── validators.dart           # Validadores de formulário
│       ├── formatters.dart           # Formatadores de dados
│       ├── date_utils.dart           # Utilidades de data
│       └── extensions.dart           # Extension methods
│
├── features/                          # Features (organizado por domínio)
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── cubits/
│   │       ├── pages/
│   │       └── widgets/
│   │
│   ├── pacientes/
│   ├── medicos/
│   ├── utilizadores/
│   ├── empresas/
│   ├── testes/
│   ├── pedidos/
│   └── resultados/
│
├── shared/                            # Componentes compartilhados
│   ├── widgets/
│   │   ├── custom_button.dart
│   │   ├── custom_text_field.dart
│   │   ├── custom_card.dart
│   │   ├── loading_indicator.dart
│   │   ├── error_message.dart
│   │   ├── empty_state.dart
│   │   └── confirm_dialog.dart
│   │
│   └── layouts/
│       ├── main_layout.dart
│       ├── responsive_layout.dart
│       └── scaffold_with_navbar.dart
```

## 🚀 Setup Inicial

### Dependências Requeridas

```yaml
# pubspec.yaml

dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.0
  bloc: ^8.1.0

  # Routing
  go_router: ^10.0.0

  # HTTP Client
  dio: ^5.3.0
  connectivity_plus: ^5.0.0

  # Storage
  shared_preferences: ^2.2.0
  flutter_secure_storage: ^9.0.0

  # Dependency Injection
  get_it: ^7.6.0

  # Date & Time
  intl: ^0.19.0

  # JSON Serialization
  json_annotation: ^4.8.0

  # Utilities
  equatable: ^2.0.5
  dartz: ^0.10.1

  # Others
  google_fonts: ^6.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^3.0.0
  build_runner: ^2.4.0
  json_serializable: ^6.7.0
```

## 📝 Convenções de Código

### 1. **Naming Conventions**
- **Arquivos**: `snake_case` (ex: `auth_cubit.dart`)
- **Classes**: `PascalCase` (ex: `AuthCubit`)
- **Variáveis**: `camelCase` (ex: `userName`)
- **Constantes**: `SCREAMING_SNAKE_CASE` (ex: `MAX_RETRY`)

### 2. **Clean Architecture Layers**

#### Data Layer
- **DataSources**: Abstraem a comunicação com APIs ou BD
- **Models**: Extendem Entities com funcionalidades JSON
- **Repositories**: Implementam os repositories do domain

#### Domain Layer
- **Entities**: Modelos puros sem dependências externas
- **Repositories**: Abstratos que definem o contrato
- **UseCases**: Lógica de negócio reutilizável

#### Presentation Layer
- **Cubits/BLoCs**: Gerenciamento de estado
- **Pages**: Telas completas
- **Widgets**: Componentes reutilizáveis

### 3. **Padrão de Error Handling**

```dart
// Domain usa Failure
Either<Failure, Success> execute();

// Presentation converte para UI
onFailure: (failure) => showError(failure.message),
```

## 🎨 Temas e Cores

- **Primária**: `#1E88E5` (Azul)
- **Secundária**: `#43A047` (Verde)
- **Erro**: `#E53935` (Vermelho)
- **Sucesso**: `#4CAF50` (Verde claro)

## 📱 Tela Principal

Atualmente a rota inicial é `/splash`. Configure a rota desejada em `router/app_router.dart`

## 🔐 Autenticação

O token de autenticação é armazenado de forma segura usando `FlutterSecureStorage` e automaticamente adicionado a todas as requisições via `AuthInterceptor`.

## 📚 Recursos Importantes

- `AppRoutes`: Constantes de rotas
- `AppStrings`: Todas as strings da aplicação
- `AppColors`: Paleta de cores
- `AppValidators`: Validadores de formulário
- `AppFormatters`: Formatadores de dados
- `AppDateUtils`: Utilitários de data

## 🛠️ Próximos Passos

1. Criar models para cada feature
2. Implementar datasources (remote)
3. Implementar repositories
4. Criar use cases
5. Configurar Cubits/BLoCs
6. Desenvolver UI das pages
7. Integrar com backend

---

**Desenvolvido com ❤️ em Flutter**
