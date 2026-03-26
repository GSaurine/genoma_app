# 📋 Checklist de Desenvolvimento - Genoma App

## ✅ FASE 1: CORE SETUP (100% - COMPLETO)

### Core Layer
- [x] app_config.dart
- [x] app_colors.dart
- [x] app_theme.dart
- [x] app_routes.dart
- [x] api_endpoints.dart
- [x] app_strings.dart
- [x] app_assets.dart
- [x] exceptions.dart
- [x] failures.dart
- [x] dio_client.dart
- [x] auth_interceptor.dart
- [x] logging_interceptor.dart
- [x] network_info.dart
- [x] local_storage_service.dart
- [x] secure_storage_service.dart
- [x] validators.dart
- [x] formatters.dart
- [x] date_utils.dart
- [x] extensions.dart

### Shared Layer
- [x] custom_button.dart
- [x] custom_text_field.dart
- [x] custom_card.dart
- [x] loading_indicator.dart
- [x] error_message.dart
- [x] empty_state.dart
- [x] confirm_dialog.dart
- [x] main_layout.dart
- [x] responsive_layout.dart
- [x] scaffold_with_navbar.dart

### Infrastructure
- [x] injection_container.dart
- [x] app_router.dart
- [x] main.dart

### Documentação
- [x] ARCHITECTURE.md
- [x] DEPENDENCIES.md
- [x] QUICKSTART.md
- [x] CORE_SUMMARY.md

---

## ⏳ FASE 2: AUTH FEATURE (0% - TODO)

### Data Layer
- [ ] auth_local_datasource.dart
- [ ] auth_remote_datasource.dart
- [ ] user_model.dart
- [ ] auth_response_model.dart
- [ ] auth_repository_impl.dart

### Domain Layer
- [ ] user.dart (entity)
- [ ] auth_repository.dart (abstract)
- [ ] login_usecase.dart
- [ ] logout_usecase.dart
- [ ] get_current_user_usecase.dart
- [ ] register_usecase.dart
- [ ] refresh_token_usecase.dart

### Presentation Layer
- [ ] auth_cubit.dart
- [ ] auth_state.dart
- [ ] login_page.dart
- [ ] splash_page.dart
- [ ] register_page.dart
- [ ] forgot_password_page.dart
- [ ] login_form.dart (widget)

### Integration
- [ ] Registrar DataSources no injection_container.dart
- [ ] Registrar Repositories no injection_container.dart
- [ ] Registrar UseCases no injection_container.dart
- [ ] Registrar Cubits no injection_container.dart

---

## ⏳ FASE 3: PACIENTES FEATURE (0% - TODO)

### Data Layer
- [ ] pacientes_remote_datasource.dart
- [ ] paciente_model.dart
- [ ] paciente_params.dart
- [ ] pacientes_repository_impl.dart

### Domain Layer
- [ ] paciente.dart (entity)
- [ ] pacientes_repository.dart (abstract)
- [ ] get_pacientes_usecase.dart
- [ ] get_paciente_by_id_usecase.dart
- [ ] create_paciente_usecase.dart
- [ ] update_paciente_usecase.dart
- [ ] delete_paciente_usecase.dart

### Presentation Layer
- [ ] pacientes_cubit.dart
- [ ] pacientes_state.dart
- [ ] pacientes_list_page.dart
- [ ] paciente_detail_page.dart
- [ ] paciente_form_page.dart
- [ ] paciente_card.dart (widget)
- [ ] paciente_search_delegate.dart (widget)

### Integration
- [ ] Adicionar ao injection_container.dart
- [ ] Adicionar rotas em app_router.dart

---

## ⏳ FASE 4: MÉDICOS FEATURE (0% - TODO)

### Data Layer
- [ ] medicos_remote_datasource.dart
- [ ] medico_model.dart
- [ ] medicos_repository_impl.dart

### Domain Layer
- [ ] medico.dart (entity)
- [ ] medicos_repository.dart (abstract)
- [ ] get_medicos_usecase.dart
- [ ] get_medico_by_id_usecase.dart
- [ ] create_medico_usecase.dart
- [ ] update_medico_usecase.dart
- [ ] delete_medico_usecase.dart

### Presentation Layer
- [ ] medicos_cubit.dart
- [ ] medicos_state.dart
- [ ] medicos_list_page.dart
- [ ] medico_detail_page.dart
- [ ] medico_form_page.dart
- [ ] medico_card.dart (widget)

### Integration
- [ ] Adicionar ao injection_container.dart
- [ ] Adicionar rotas em app_router.dart

---

## ⏳ FASE 5: UTILIZADORES FEATURE (0% - TODO)

- [ ] Data layer (datasources, models, repositories)
- [ ] Domain layer (entities, repositories, usecases)
- [ ] Presentation layer (cubits, pages, widgets)
- [ ] Integration (injection, routing)

---

## ⏳ FASE 6: EMPRESAS FEATURE (0% - TODO)

- [ ] Data layer
- [ ] Domain layer
- [ ] Presentation layer
- [ ] Integration

---

## ⏳ FASE 7: TESTES FEATURE (0% - TODO)

- [ ] Data layer
- [ ] Domain layer
- [ ] Presentation layer
- [ ] Integration

---

## ⏳ FASE 8: PEDIDOS FEATURE (0% - TODO)

- [ ] Data layer
- [ ] Domain layer
- [ ] Presentation layer
- [ ] Integration

---

## ⏳ FASE 9: RESULTADOS FEATURE (0% - TODO)

- [ ] Data layer
- [ ] Domain layer
- [ ] Presentation layer
- [ ] Integration

---

## ⏳ FASE 10: MELHORIAS GERAIS (0% - TODO)

### Testing
- [ ] Unit tests para validators
- [ ] Unit tests para formatters
- [ ] Unit tests para utils
- [ ] Unit tests para repositories
- [ ] Unit tests para cubits
- [ ] Widget tests para componentes
- [ ] Integration tests

### Internationalization
- [ ] Setup i18n (intl package)
- [ ] Traduzir strings para inglês (opcional)

### Performance
- [ ] Optimizar imagens
- [ ] Lazy loading de features
- [ ] Caching de dados

### UX
- [ ] Splash screen customizada
- [ ] Animações de transição
- [ ] Bottom sheets
- [ ] Modals customizados
- [ ] Toast notifications completas

### Acessibilidade
- [ ] Semantic labels
- [ ] High contrast mode
- [ ] Screen reader support

### Analytics
- [ ] Firebase Analytics
- [ ] Event tracking
- [ ] Crash reporting

### Build & Deploy
- [ ] Configure signing (Android)
- [ ] Configure provisioning (iOS)
- [ ] Setup CI/CD
- [ ] Versioning strategy
- [ ] Release notes

---

## 📊 Estatísticas

### Completo
- Core Layer: 19/19 arquivos ✅
- Shared Layer: 10/10 arquivos ✅
- Main App: 2/2 arquivos ✅
- **Total: 31/31 arquivos ✅**

### Total de Features
- Auth: 0/13 arquivos
- Pacientes: 0/13 arquivos
- Médicos: 0/13 arquivos
- Utilizadores: 0/13 arquivos
- Empresas: 0/13 arquivos
- Testes: 0/13 arquivos
- Pedidos: 0/13 arquivos
- Resultados: 0/13 arquivos
- **Total: 0/104 arquivos**

---

## 📅 Estimativa de Timeline

### Fase 1: CORE (✅ 0h - 16h) [CONCLUÍDO]
**Tempo Estimado: 16 horas**

### Fase 2: Auth (⏳ ~20-24 horas)
**Tempo Estimado: 5-6 dias**

### Fase 3: Pacientes (⏳ ~20-24 horas)
**Tempo Estimado: 5-6 dias**

### Fase 4: Médicos (⏳ ~16-20 horas)
**Tempo Estimado: 4-5 dias**

### Fase 5-9: Outras Features (⏳ ~80-100 horas)
**Tempo Estimado: 3+ semanas**

### Fase 10: Melhorias (⏳ ~40-60 horas)
**Tempo Estimado: 2+ semanas**

**Total Estimado: 8-12 semanas para MVP completo**

---

## 🎯 Recomendações para Próximo Passo

1. **Próxima Fase: AUTH** (Prioridade ALTA)
   - É a base para todas outras features
   - Sem auth, não consegue acessar API
   - Uma vez pronta, libera todas outras features

2. **Ordem Sugerida**:
   1. ✅ Core (FEITO)
   2. Auth
   3. Pacientes
   4. Médicos
   5. Resto (conforme prioridade de negócio)

3. **Tips para Acelerar**:
   - Use o mesmo padrão para todas features
   - Copy-paste estrutura pronta e refatore
   - Crie generators/scripts para boilerplate
   - Teste conforme desenvolve

---

**Última Atualização: 12/03/2026**  
**Status Geral: 31/135 arquivos (23%)**
