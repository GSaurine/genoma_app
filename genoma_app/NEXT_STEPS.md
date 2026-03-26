# Próximos Passos - Genoma App

## ✅ Status Atual: 0 Erros de Compilação

A aplicação foi refatorada para usar implementações stub dos serviços que dependem de pacotes externos. Todos os arquivos agora compilam com sucesso!

## 🚀 Próximos Passos

### 1. Instalar Dependências (CRÍTICO)

Execute no diretório `genoma_app`:

```bash
flutter pub get
```

Isto instalará todos os packages necessários listados em `pubspec.yaml`:
- `dio: ^5.3.0` - Cliente HTTP
- `go_router: ^10.0.0` - Roteamento
- `flutter_bloc: ^8.1.0` - State Management
- `get_it: ^7.5.0` - Dependency Injection
- `shared_preferences: ^2.1.0` - Armazenamento local
- `flutter_secure_storage: ^8.0.0` - Armazenamento seguro
- `connectivity_plus: ^5.0.0` - Verificação de rede
- `intl: ^0.19.0` - Internacionalização
- E outras...

### 2. Restaurar Implementações Completas

Após instalar packages, os seguintes arquivos devem ser restaurados com suas implementações completas:

#### Serviços de Rede
- `lib/core/network/dio_client.dart`
  - Implementar com imports de `package:dio/dio.dart`
  - Restaurar métodos GET/POST/PUT/PATCH/DELETE com Dio
  
- `lib/core/network/interceptors/auth_interceptor.dart`
  - Implementar estendendo `Interceptor` de Dio
  - Adicionar Bearer token automaticamente
  
- `lib/core/network/interceptors/logging_interceptor.dart`
  - Implementar estendendo `Interceptor` de Dio
  - Logar requests/responses automaticamente

#### Serviços de Armazenamento
- `lib/core/storage/local_storage_service.dart`
  - Implementar com `SharedPreferences`
  - Usar métodos setString/getString/setInt/etc
  
- `lib/core/storage/secure_storage_service.dart`
  - Implementar com `FlutterSecureStorage`
  - Armazenar tokens de forma segura

#### Utilities
- `lib/core/utils/formatters.dart`
  - Importar `package:intl/intl.dart`
  - Restaurar NumberFormat e DateFormat

#### Roteamento
- `lib/router/app_router.dart`
  - Importar `package:go_router/go_router.dart`
  - Restaurar GoRouter com todas as rotas (8+ features)
  - Restaurar navegação entre telas
  
- `lib/main.dart`
  - Mudar de `MaterialApp` para `MaterialApp.router`
  - Usar `appRouter` ao invés de `HomePlaceholder`
  - Restaurar `setupDependencies()` na main async

#### Injeção de Dependências
- `lib/injection_container.dart`
  - Importar `package:get_it/get_it.dart`
  - Implementar `setupDependencies()` com GetIt
  - Registrar todos os serviços

### 3. Verificar Build

Após restaurar implementações:

```bash
flutter analyze  # Verificar análise estática
flutter build apk  # Ou outro target (web, ios, etc)
```

### 4. Testar Funcionamento

```bash
flutter run
```

Isto iniciará a aplicação no dispositivo/emulador conectado.

### 5. Iniciar Desenvolvimento de Features

Próximas features a implementar (em ordem de prioridade):

1. **Auth Feature** (ALTA PRIORIDADE)
   - Autenticação/Login
   - Registro de usuários
   - Reset de senha
   - Gerenciamento de tokens

2. **Pacientes Feature**
   - CRUD completo
   - Listagem com paginação
   - Detalhes do paciente
   - Busca e filtros

3. **Médicos Feature**
   - CRUD completo
   - Listagem e detalhes

4. **Demais Features**
   - Utilizadores
   - Empresas
   - Testes
   - Pedidos
   - Resultados

Veja `CHECKLIST.md` para detalhes de arquivos a criar para cada feature.

## 📋 Referência Rápida de Implementação

Cada feature deve seguir Clean Architecture com estrutura:

```
features/[feature_name]/
├── data/
│   ├── datasources/
│   │   ├── local_datasource.dart
│   │   └── remote_datasource.dart
│   ├── models/
│   │   └── [model]_model.dart
│   └── repositories/
│       └── [feature]_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── [entity].dart
│   ├── repositories/
│   │   └── [feature]_repository.dart
│   └── usecases/
│       └── [usecase].dart
└── presentation/
    ├── bloc/
    │   ├── [bloc]_bloc.dart
    │   ├── [bloc]_event.dart
    │   └── [bloc]_state.dart
    ├── pages/
    │   └── [page]_page.dart
    └── widgets/
        └── [custom_widget].dart
```

## 🔧 Troubleshooting

Se após `flutter pub get` ainda houver erros:

1. **Limpar build**:
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Verificar versão do Flutter**:
   ```bash
   flutter --version
   ```

3. **Simular iOS/Web**:
   ```bash
   flutter run -d web  # Para testar no browser
   ```

4. **Restaurar pubspec.yaml** se corrompido:
   - Verifique arquivo em `genoma_app/pubspec.yaml`
   - Compare com `DEPENDENCIES.md

## 📚 Documentação

- [ARCHITECTURE.md](ARCHITECTURE.md) - Visão geral da arquitetura
- [DEPENDENCIES.md](DEPENDENCIES.md) - Lista completa de dependências
- [QUICKSTART.md](QUICKSTART.md) - Guia rápido de início
- [CHECKLIST.md](CHECKLIST.md) - Checklist de features a implementar

## ✨ Conclusão

A estrutura base está pronta e compilando com sucesso! 

Próximo passo é executar `flutter pub get` para instalar os packages, restaurar as implementações completas, e começar o desenvolvimento das features.

Boa sorte! 🚀
