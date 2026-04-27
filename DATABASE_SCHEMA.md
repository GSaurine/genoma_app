# Esquema da Base de Dados (Genoma)

Este ficheiro lista todas as tabelas e os seus atributos conforme as migrações do backend.

---

### 1. perfis
| Atributo | Tipo | Notas |
| :--- | :--- | :--- |
| id | CHAR(36) | PRIMARY KEY, UUID |
| nome | VARCHAR(50) | NOT NULL, UNIQUE |
| ativo | BOOLEAN | DEFAULT TRUE |

### 2. empresas
| Atributo | Tipo | Notas |
| :--- | :--- | :--- |
| id | CHAR(36) | PRIMARY KEY, UUID |
| nome | VARCHAR(100) | NOT NULL |
| morada | TEXT | |
| codigo_postal | VARCHAR(20) | |
| telefone | VARCHAR(20) | |
| email | VARCHAR(100) | UNIQUE |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |
| ativo | BOOLEAN | DEFAULT TRUE |

### 3. utilizadores
| Atributo | Tipo | Notas |
| :--- | :--- | :--- |
| id | CHAR(36) | PRIMARY KEY, UUID |
| perfil_id | CHAR(36) | FK (perfis.id) |
| empresa_id | CHAR(36) | FK (empresas.id) |
| nome | VARCHAR(100) | NOT NULL |
| email | VARCHAR(100) | NOT NULL, UNIQUE |
| telefone | VARCHAR(20) | |
| password_hash | TEXT | NOT NULL |
| ativo | BOOLEAN | DEFAULT TRUE |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |

### 4. medicos
| Atributo | Tipo | Notas |
| :--- | :--- | :--- |
| utilizador_id | CHAR(36) | PRIMARY KEY, FK (utilizadores.id) |
| num_ordem | VARCHAR(20) | NOT NULL, UNIQUE |
| especialidade | VARCHAR(100) | |
| ativo | BOOLEAN | DEFAULT TRUE |

### 5. testes
| Atributo | Tipo | Notas |
| :--- | :--- | :--- |
| id | CHAR(36) | PRIMARY KEY, UUID |
| nome | VARCHAR(100) | NOT NULL |
| preco | DECIMAL(10,2) | DEFAULT 0.00 |
| descricao | TEXT | |
| ativo | BOOLEAN | DEFAULT TRUE |

### 6. itens_pesquisa
| Atributo | Tipo | Notas |
| :--- | :--- | :--- |
| id | CHAR(36) | PRIMARY KEY, UUID |
| codigo | VARCHAR(10) | NOT NULL, UNIQUE |
| descricao | VARCHAR(100) | NOT NULL |
| ativo | BOOLEAN | DEFAULT TRUE |

### 7. teste_composicao
| Atributo | Tipo | Notas |
| :--- | :--- | :--- |
| teste_id | CHAR(36) | PRIMARY KEY, FK (testes.id) |
| item_id | CHAR(36) | PRIMARY KEY, FK (itens_pesquisa.id) |

### 8. pacientes
| Atributo | Tipo | Notas |
| :--- | :--- | :--- |
| id | CHAR(36) | PRIMARY KEY, UUID |
| nome | VARCHAR(100) | NOT NULL |
| data_nascimento | DATE | NOT NULL |
| genero | VARCHAR(20) | |
| nif | VARCHAR(20) | UNIQUE |
| telemovel | VARCHAR(20) | |
| email | VARCHAR(100) | |
| morada | TEXT | |
| altura | DECIMAL(5,2) | |
| peso | DECIMAL(5,2) | |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |
| ativo | BOOLEAN | DEFAULT TRUE |

### 9. pedidos_exames
| Atributo | Tipo | Notas |
| :--- | :--- | :--- |
| id | CHAR(36) | PRIMARY KEY, UUID |
| paciente_id | CHAR(36) | FK (pacientes.id) |
| medico_id | CHAR(36) | FK (medicos.utilizador_id) |
| teste_id | CHAR(36) | FK (testes.id) |
| empresa_id | CHAR(36) | FK (empresas.id) |
| data_pedido | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |
| status | VARCHAR(30) | DEFAULT 'Pendente' |
| notas_clinicas | TEXT | |
| ativo | BOOLEAN | DEFAULT TRUE |

### 10. resultados_detalhados
| Atributo | Tipo | Notas |
| :--- | :--- | :--- |
| id | CHAR(36) | PRIMARY KEY, UUID |
| pedido_id | CHAR(36) | FK (pedidos_exames.id) |
| item_id | CHAR(36) | FK (itens_pesquisa.id) |
| resultado | VARCHAR(100) | |
| observacoes | TEXT | |
| data_resultado | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |
| ativo | BOOLEAN | DEFAULT TRUE |

### 11. postos
| Atributo | Tipo | Notas |
| :--- | :--- | :--- |
| id | CHAR(36) | PRIMARY KEY, UUID |
| entidade_id | CHAR(36) | FK (empresas.id) |
| nome | VARCHAR(100) | NOT NULL |
| codigo_posto | VARCHAR(20) | UNIQUE |
| localizacao | TEXT | |

### 12. lotes
| Atributo | Tipo | Notas |
| :--- | :--- | :--- |
| id | CHAR(36) | PRIMARY KEY, UUID |
| numero_lote | VARCHAR(50) | NOT NULL, UNIQUE |
| tipo_kit_id | CHAR(36) | |
| data_criacao | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |
| quantidade_inicial| INT | DEFAULT 0 |

### 13. kits
| Atributo | Tipo | Notas |
| :--- | :--- | :--- |
| id | CHAR(36) | PRIMARY KEY, UUID |
| numero_kit | VARCHAR(50) | |
| tracking | VARCHAR(100) | |
| codigo_barras | VARCHAR(50) | NOT NULL, UNIQUE |
| tipo_kit_id | CHAR(36) | |
| lote_id | CHAR(36) | FK (lotes.id) |
| empresa_id | CHAR(36) | FK (empresas.id) |
| posto_id | CHAR(36) | FK (postos.id) |
| status | VARCHAR(30) | DEFAULT 'Na Empresa' |
| data_validade | DATE | |

### 14. processos
| Atributo | Tipo | Notas |
| :--- | :--- | :--- |
| id | CHAR(36) | PRIMARY KEY, UUID |
| numero_processo | VARCHAR(20) | NOT NULL, UNIQUE |
| paciente_id | CHAR(36) | FK (pacientes.id) |
| medico_id | CHAR(36) | FK (medicos.utilizador_id) |
| posto_id | CHAR(36) | FK (postos.id) |
| kit_id | CHAR(36) | FK (kits.id) |
| status_id | VARCHAR(30) | |
| data_entrada | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |
| notas | TEXT | |


### 15. resultados_geneticos
| Atributo | Tipo | Notas |
| :--- | :--- | :--- |
| id | CHAR(36) | PRIMARY KEY, UUID |
| processo_id | CHAR(36) | FK (processos.id) |
| cromossoma | VARCHAR(10) | |
| resultado_valor | VARCHAR(50) | |
| probabilidade | VARCHAR(50) | |
| tipo_resultado | VARCHAR(20) | |

### 16. assets_resultados
| Atributo | Tipo | Notas |
| :--- | :--- | :--- |
| id | CHAR(36) | PRIMARY KEY, UUID |
| processo_id | CHAR(36) | FK (processos.id) |
| url_ficheiro | TEXT | NOT NULL |
| tipo_ficheiro | VARCHAR(10) | DEFAULT 'PDF' |
| data_upload | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |

### 17. logs_auditoria
| Atributo | Tipo | Notas |
| :--- | :--- | :--- |
| id | CHAR(36) | PRIMARY KEY |
| empresa_id | CHAR(36) | FK (empresas.id) |
| utilizador_id | CHAR(36) | FK (utilizadores.id) |
| acao | VARCHAR(100) | |
| tabela_afetada | VARCHAR(100) | |
| registro_id | CHAR(36) | |
| data | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |

### 18. informacao_clinica
| Atributo | Tipo | Notas |
| :--- | :--- | :--- |
| id | CHAR(36) | PRIMARY KEY, UUID |
| processo_id | CHAR(36) | FK (processos.id) |
| semanas_gravidez | INT | |
| dias_gravidez | INT | |
| tipo_gravidez | ENUM | 'singular', 'gemelar' |
| quer_saber_sexo | BOOLEAN | DEFAULT FALSE |
| motivo_prescricao | TEXT | |
| data_registo | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |

### 19. colheitas
| Atributo | Tipo | Notas |
| :--- | :--- | :--- |
| id | CHAR(36) | PRIMARY KEY, UUID |
| processo_id | CHAR(36) | FK (processos.id) |
| posto_id | CHAR(36) | FK (postos.id) |
| data_prevista | DATE | |
| periodo | ENUM | 'Manhã', 'Tarde', 'Noite' |
| data_efetiva | DATETIME | |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |

### 20. facturacao
| Atributo | Tipo | Notas |
| :--- | :--- | :--- |
| id | CHAR(36) | PRIMARY KEY, UUID |
| processo_id | CHAR(36) | FK (processos.id), ON DELETE CASCADE |
| preco_teste | DECIMAL(10,2) | DEFAULT 0.00 |
| numero_fatura | VARCHAR(50) | |
| data_fatura | DATE | |
| entidade_multibanco | VARCHAR(20) | |
| referencia_multibanco | VARCHAR(20) | |
| comissao | BOOLEAN | DEFAULT FALSE |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |


