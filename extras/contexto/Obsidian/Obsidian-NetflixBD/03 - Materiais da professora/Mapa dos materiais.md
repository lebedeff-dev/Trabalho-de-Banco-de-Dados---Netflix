# Mapa dos materiais da professora

Local: `extras/contexto/Materiais/`. O exemplo dela é um **banco de supermercado em MySQL**.

## Scripts SQL (`Scripts SQL/`)
| Arquivo | O que mostra | Serve para |
|---|---|---|
| `bd_supermercado.sql` | DROP/CREATE DATABASE (utf8mb4), `CREATE TABLE IF NOT EXISTS`, PK, FK, `UNIQUE`, `ENUM`, `AUTO_INCREMENT`, `DEFAULT` | Estrutura |
| `inserts_supermercado.sql` / `bd_supermercado-insert-completo.sql` | Inserts de exemplo, dados pensados para que todas as consultas retornem linhas | Inserts |
| `exercicios_joins_aluno.sql` / `exercicios_joins_gabarito.sql` | 8 exercícios: INNER (2, 3 e máx. tabelas), LEFT, RIGHT, SELF JOIN | Consultas |
| `bd_supermercado-exercicios - Copy.sql` / `-gabarito - Copy.sql` | Mais exercícios com gabarito | Consultas |
| `bd_supermercado-storeprocedure.sql` | `CREATE PROCEDURE` com e sem parâmetros, `DELIMITER //`, `CALL` | Scripts adicionais |
| `bd_supermercado-trigger - Copy.sql` | Triggers (`tg_historico_salario`, `tg_log_novo_pedido`, `tg_validar_estoque`) | Triggers |
| `bd_supermercado-grantrevoke.sql` | `CREATE USER ... IDENTIFIED BY`, `GRANT`, `REVOKE` por perfil de usuário | Usuários/permissões |
| `bd_supermercado-commit.sql` | `START TRANSACTION`, `COMMIT`, `ROLLBACK`, `SAVEPOINT` | Transações |

## PDFs (`Unidades de aprendizagem (PDF)/`)
01 Conceitos de BD · 02 SGBD · 03 MER · 04 Normalização · 05 SQL · 06 DDL · 07 Constraints · 08 DML · 09 DQL · 10 Cláusulas e operadores · 11 Triggers · 12 TCL · 13 DCL

## Modelagem (`Modelagem/`)
`DER_final.jpg`, `modelagem_logica.png`, `ModelagemConceitual.drawio`, `modelo_logica.mwb` (do supermercado).

## Outros (`Outros/`)
`sql.jpeg` (resumo de comandos e ordem de execução), `JOIN2.xlsx`, `Grant e Revoke - Prompt.html.zip`.

## O que só é citado nos PDFs (sem script de exemplo)
- **`CREATE INDEX`**: citado no PDF *06 - DDL* (CREATE/ALTER/DROP INDEX). Nenhum script usa.
- **`CREATE VIEW`**: citado no PDF *06 - DDL* (tabela virtual, resultado de um SELECT). Nenhum script usa.

A rubrica exige os dois. Como estão nos materiais dela, entram na forma mais simples. Ver [[HANDOFF_CONTEXTO]].

## Fora do escopo (não usar)
`CHECK` (só citado em vídeo de SQL Server no PDF 07) e quaisquer extras que a professora não mostrou.
