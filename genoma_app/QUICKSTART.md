# 🚀 Quick Start - Genoma App

## Setup Inicial

### 1. Instalar Dependências
```bash
cd genoma_app
flutter pub get
```

### 2. Gerar Código (JSON, etc)
```bash
flutter pub run build_runner build
```

### 3. Rodar Aplicação
```bash
flutter run
```

## 📱 Estrutura de Rotas

```
/splash          → Tela de splash
/login           → Login
/register        → Registro
/home            → Home
/pacientes       → Lista de pacientes
/medicos         → Lista de médicos
/testes          → Lista de testes
/pedidos         → Lista de pedidos
/resultados      → Lista de resultados
/settings        → Configurações
/profile         → Perfil do usuário
```

## 🎯 Como Adicionar uma Página

### 1. Criar Pasta Feature
```bash
mkdir lib/features/nova_feature
mkdir lib/features/nova_feature/{data,domain,presentation}
```

### 2. Criar Estrutura BLoC
```dart
// presentation/cubits/nova_feature_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

part 'nova_feature_state.dart';

class NovaFeatureCubit extends Cubit<NovaFeatureState> {
  NovaFeatureCubit() : super(NovaFeatureInitial());
  
  void doSomething() {
    emit(NovaFeatureLoading());
    // Lógica aqui
    emit(NovaFeatureSuccess());
  }
}
```

### 3. Criar Page
```dart
// presentation/pages/nova_feature_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/nova_feature_cubit.dart';

class NovaFeaturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NovaFeatureCubit, NovaFeatureState>(
      builder: (context, state) {
        if (state is NovaFeatureLoading) {
          return LoadingIndicator();
        }
        return Scaffold(
          appBar: AppBar(title: Text('Nova Feature')),
          body: Center(child: Text('Conteúdo')),
        );
      },
    );
  }
}
```

### 4. Adicionar Rota
```dart
// core/config/app_routes.dart
static const String novaFeature = '/nova-feature';

// router/app_router.dart
GoRoute(
  path: AppRoutes.novaFeature,
  name: 'novaFeature',
  builder: (context, state) => NovaFeaturePage(),
)
```

## 🎨 Usando Widgets Customizados

### CustomButton
```dart
CustomButton(
  label: 'Salvar',
  onPressed: () => print('Clicado!'),
  variant: ButtonVariant.primary,
)
```

### CustomTextField
```dart
CustomTextField(
  label: 'Email',
  controller: emailController,
  validator: AppValidators.validateEmail,
  prefixIcon: Icons.email,
)
```

### CustomCard
```dart
CustomCard(
  child: Text('Conteúdo do card'),
  onTap: () => print('Card clicado!'),
)
```

### EmptyState
```dart
EmptyState(
  title: 'Sem pacientes',
  description: 'Nenhum paciente cadastrado',
  actionLabel: 'Adicionar',
  onActionPressed: () => navigateTo('/pacientes/form'),
)
```

## 🔐 Autenticação

### Salvar Token
```dart
final secureStorage = getIt<SecureStorageService>();
await secureStorage.saveAuthToken(token);
```

### Recuperar Token
```dart
final token = await secureStorage.getAuthToken();
```

### O token é Automaticamente Adicionado nas Requisições
```dart
// AuthInterceptor adiciona automaticamente:
// Authorization: Bearer {token}
```

## 📝 Validação de Formulários

```dart
TextFormField(
  validator: (value) => AppValidators.validateEmail(value),
)

// Validadores disponíveis:
// - validateEmail
// - validatePassword
// - validatePasswordConfirmation
// - validateUsername
// - validateRequired
// - validateCPF
// - validateCNPJ
// - validatePhone
// - validateUrl
// - validateDate
// - validateMinLength
// - validateMaxLength
```

## 🎬 Formatação de Dados

```dart
// Moeda
AppFormatters.formatCurrency(1234.56) // R$ 1.234,56

// Data
AppFormatters.formatDate(DateTime.now()) // 12/03/2026

// Telefone
AppFormatters.formatPhone('21987654321') // (21) 98765-4321

// CPF
AppFormatters.formatCPF('12345678901') // 123.456.789-01

// Data Relativa
AppFormatters.formatRelativeDate(dateTime) // há 2 horas
```

## 📊 Fazendo Requisições HTTP

```dart
final dioClient = getIt<DioClient>();

// GET
final response = await dioClient.get('/pacientes');

// POST
final response = await dioClient.post(
  '/pacientes',
  data: {'nome': 'João'},
);

// PUT
await dioClient.put('/pacientes/1', data: update);

// DELETE
await dioClient.delete('/pacientes/1');
```

## 💾 Storage Local

### SharedPreferences
```dart
final storage = getIt<LocalStorageService>();
await storage.saveString('key', 'value');
final value = await storage.getString('key');
```

### SecureStorage (para tokens)
```dart
final secureStorage = getIt<SecureStorageService>();
await secureStorage.saveAuthToken('token123');
```

## 🌐 Verificar Conectividade

```dart
final networkInfo = getIt<NetworkInfo>();

if (await networkInfo.isConnected) {
  // Fazer requisição
} else {
  // Mostrar erro de conexão
}
```

## 🎨 Usar Cores da Paleta

```dart
Container(
  color: AppColors.primary,      // Azul
  child: Text(
    'Texto',
    style: TextStyle(color: AppColors.white),
  ),
)

// Cores disponíveis:
// AppColors.primary, primaryDark, primaryLight
// AppColors.secondary, secondaryDark, secondaryLight
// AppColors.error, success, warning, info
// AppColors.white, black, grey, greyLight, greyDark
```

## 🔔 Mostrar Notificações

### Erro
```dart
ErrorSnackBar.show(context, 'Erro ao salvar');
```

### Sucesso
```dart
SuccessSnackBar.show(context, 'Salvo com sucesso!');
```

### Diálogo de Confirmação
```dart
final confirmed = await ConfirmDialog.show(
  context,
  title: 'Confirmar',
  message: 'Deseja realmente deletar?',
  isDangerous: true,
);
```

## 📱 Responsividade

```dart
// Layout responsivo
ResponsiveLayout(
  mobileBody: MobileWidget(),
  tabletBody: TabletWidget(),
  desktopBody: DesktopWidget(),
)

// Grid responsivo
ResponsiveGrid(
  childCount: 6,
  mobileColumns: 1,
  tabletColumns: 2,
  desktopColumns: 3,
  itemBuilder: (context, index) => Item(index),
)
```

## 🐛 Debugging

### Logs HTTP
Os logs de requisições são mostrados no console automaticamente (modo debug).

### Usar Logger
```dart
final logger = Logger();
logger.d('Debug message');
logger.i('Info message');
logger.w('Warning message');
logger.e('Error message');
```

## 📖 Mais Informações

- Ver `ARCHITECTURE.md` para detalhes da arquitetura
- Ver `DEPENDENCIES.md` para lista de pacotes
- Ver pasta `lib/core/` para utilities disponíveis
- Ver `lib/shared/` para componentes reutilizáveis

## ✨ Boas Práticas

1. **Use Extension Methods**: `context.screenWidth`, `"text".capitalize()`
2. **Use AppValidators**: Para validação de entrada
3. **Use AppFormatters**: Para formatação de saída
4. **Use Constants**: Sempre use `AppStrings`, `AppRoutes`, não hard-code
5. **Use GetIt**: Para injeção de dependência, não `new NovaClasse()`
6. **Use BLoC Pattern**: Para lógica complexa
7. **Trate Errors**: Always use Failure pattern no domain layer

---

**Pronto para desenvolvimento! 🚀**
