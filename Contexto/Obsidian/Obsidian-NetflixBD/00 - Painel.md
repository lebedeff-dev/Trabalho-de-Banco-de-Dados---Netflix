# Painel

| Item | Valor |
|---|---|
| Disciplina | Laboratório de Banco de Dados (GPE17M40086, UBEC / Católica de Brasília) |
| Atividade | AT1 - Projeto - Implementação |
| Vale | 15 pontos (5 critérios x 3) |
| Prazo | **18/11/2026 às 23:59** |
| SGBD | MySQL (é o que a professora usa nos scripts) |
| Tema | Netflix (modelo do 1º trabalho, 13 tabelas) |
| Grupo | Luis Eduardo de Andrade Neves, Luís Guilherme Lebedeff Rocha Mota e Kaio Ramos Luiz (matrícula do Kaio pendente no cabeçalho) |
| Entrega | `sql/netflix_bd.sql` (um arquivo, na estrutura do template da professora) |
| Para apresentar | `sql/Script Versionado/` (o mesmo script em 6 arquivos, 01 a 06) |

## Mapa
- [[HANDOFF_CONTEXTO]] — regras e estado do trabalho
- [[Rubrica AT1]] — o que será avaliado
- [[Template da professora]] — a estrutura obrigatória do arquivo `.sql`
- [[Comparacao com a rubrica]] — conferência do resultado
- [[Modelo logico Netflix]] — as 13 tabelas, campos, ENUMs e FKs
- [[Feedback da professora (modelo logico)]] — modelo aprovado com 12/12
- [[Mapa dos materiais]] — o que a professora forneceu
- [[Padroes dos scripts da professora]] — o estilo seguido
- [[Passo a passo]] — checklist de execução

## Explicações para apresentar (uma por seção do template)
| Seção do template | Arquivo em `sql/Script Versionado` | Nota |
|---|---|---|
| 1. Estrutura | `01_estrutura.sql` | [[Parte 1 - Estrutura (explicacao)]] |
| 2. Inserts | `02_inserts.sql` | [[Parte 2 - Inserts (explicacao)]] |
| 3. Índices e 4. Scripts adicionais | `03_indices.sql`, `04_scripts_adicionais.sql` | [[Partes 3 e 4 - Indices e scripts adicionais (explicacao)]] |
| 5. Consultas | `05_consultas.sql` | [[Parte 5 - Consultas (explicacao)]] |
| 6. Recursos adicionais | `06_recursos_adicionais.sql` | [[Parte 6 - Recursos adicionais (explicacao)]] |

## Estado
- [x] Pasta organizada, vault criado, repositório Git ligado
- [x] Script reorganizado na estrutura do template da professora
- [x] 1: 13 tabelas, 12 FKs · 2: 392 inserts (30 por tabela; conta tem 32)
- [x] 3: 2 índices com justificativa · 4: seis exemplos comentados
- [x] 5: 10 consultas na distribuição do template
- [x] 6: 3 views, 2 triggers (BEFORE e AFTER), 3 usuários (1 excluído, 2 com REVOKE), COMMIT e ROLLBACK
- [x] Script completo e os 6 arquivos testados em MySQL 8
- [ ] Preencher a matrícula do Kaio no cabeçalho
- [ ] Rodar no seu MySQL Workbench
- [ ] **Enviar no AVA até 18/11/2026 23:59** (e comparecer à apresentação: sem presença a nota é zero)
