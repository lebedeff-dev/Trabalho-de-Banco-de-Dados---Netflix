# Painel

| Item | Valor |
|---|---|
| Disciplina | Laboratório de Banco de Dados (GPE17M40086, UBEC / Católica de Brasília) |
| Atividade | AT1 - Projeto - Implementação |
| Vale | 15 pontos (5 critérios x 3) |
| Prazo | **18/11/2026 às 23:59** |
| SGBD | MySQL (é o que a professora usa nos scripts) |
| Tema | Netflix (modelo do 1º trabalho, 13 tabelas) |
| Modo | Individual (o AVA mostra "Group 1", a nota vale para o grupo) |
| Entrega | `sql/netflix_bd.sql` (um arquivo, na ordem dos critérios) |
| Para apresentar | `sql/Script Versionado/` (o mesmo script em 9 arquivos, 01 a 09) |

## Mapa
- [[HANDOFF_CONTEXTO]] — regras e estado do trabalho
- [[Rubrica AT1]] — o que será avaliado
- [[Comparacao com a rubrica]] — conferência do resultado, critério por critério
- [[Modelo logico Netflix]] — as 13 tabelas, campos, ENUMs e FKs
- [[Feedback da professora (modelo logico)]] — modelo aprovado com 12/12
- [[Mapa dos materiais]] — o que a professora forneceu
- [[Padroes dos scripts da professora]] — o estilo seguido
- [[Passo a passo]] — checklist de execução

## Explicações para apresentar (uma por critério)
| Critério da rubrica | Arquivo em `sql/Script Versionado` | Nota |
|---|---|---|
| Estrutura do banco | `01_estrutura.sql` | [[Parte 1 - Estrutura (explicacao)]] |
| Inserção de dados | `02_inserts.sql` | [[Parte 2 - Inserts (explicacao)]] |
| Consultas SQL | `03_consultas.sql` | [[Parte 3 - Consultas (explicacao)]] |
| Scripts adicionais e índices | `04_indices.sql`, `05_procedures.sql` | [[Partes 4 e 5 - Indices e procedures (explicacao)]] |
| Recursos adicionais | `06_views.sql`, `07_triggers.sql`, `08_usuarios_permissoes.sql`, `09_transacoes.sql` | [[Partes 6 a 9 - Views, triggers, usuarios e transacoes (explicacao)]] |

Tudo o que saiu do script quando os comentários foram enxugados está em [[Comentarios retirados do script]].

## Estado
- [x] Pasta organizada na estrutura do repositório de exemplo
- [x] Vault criado
- [x] Repositório Git ligado e commits enviados
- [x] Parte 1: estrutura (13 tabelas, 12 FKs)
- [x] Parte 2: inserts (392 comandos, o mínimo: 30 por tabela; conta tem 32)
- [x] Parte 3: 12 consultas
- [x] Partes 4 e 5: 2 índices com justificativa e 3 procedures
- [x] Partes 6 a 9: 3 views, 3 triggers, 5 usuários com GRANT/REVOKE, 4 transações
- [x] Script completo testado em MySQL 8 (duas execuções seguidas, sem erro)
- [ ] Rodar no seu MySQL Workbench
- [ ] **Enviar no AVA até 18/11/2026 23:59**
