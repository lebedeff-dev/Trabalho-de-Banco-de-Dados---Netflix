# Comparação do resultado com a rubrica e o template

Conferência feita em 17/11/2026, rodando `sql/netflix_bd.sql` completo num MySQL 8 (sem erro) e os 6 arquivos de `sql/Script Versionado` em ordem (sem erro). Os comandos comentados da seção 4 e os casos de erro dos triggers foram testados à parte.

## Template da professora, item por item ([[Template da professora]])

| Item do template | Entregue | Situação |
|---|---|---|
| Cabeçalho: identificação do grupo e "alterações na modelagem" | 3 integrantes; marcado "Não" (matrícula do Kaio pendente) | Atende (falta a matrícula) |
| 1. Banco e tabelas conforme a modelagem | 13 tabelas, 13 PK, 12 FK, 12 UNIQUE, iguais ao modelo aprovado | Atende |
| 2. Mínimo de 30 INSERT por tabela | 392 INSERT: 30 em cada tabela (conta tem 32) | Atende |
| 3. Pelo menos um índice, com justificativa | 2 índices, justificativa no script | Atende |
| 4. Seis exemplos comentados (DROP DATABASE, DROP TABLE, DROP COLUMN, ADD COLUMN, UPDATE e DELETE de um registro) | Os 6, comentados | Atende |
| 5. 2 simples, 4 INNER (2 tabelas), 1 LEFT, 1 RIGHT, 1 com 3 tabelas, 1 com 4 tabelas | 10 consultas, todas com linhas; nenhuma é só SELECT/FROM/ORDER BY | Atende |
| 6. 3 views | 3 | Atende |
| 6. 2 triggers, 1 BEFORE e 1 AFTER | `tg_validar_renovacao` (BEFORE UPDATE) e `tg_sincronizar_cobranca` (AFTER UPDATE) | Atende |
| 6. 3 usuários com permissões distintas | admin_netflix, analista, atendente | Atende |
| 6. Excluir 1 usuário | `DROP USER analista` | Atende |
| 6. Revogar privilégios de 2 usuários | admin_netflix (DELETE, DROP) e atendente (UPDATE em status) | Atende |
| 6. COMMIT e ROLLBACK | 1 exemplo de cada | Atende |
| Um único arquivo `.sql` | `sql/netflix_bd.sql` | Atende |
| Nada além do pedido | Sem procedures, sem SAVEPOINT, sem consultas extras | Atende |

## Critérios da rubrica (nível 4 = 3 pontos cada)

| Critério | Evidência |
|---|---|
| Estrutura do banco | 13 tabelas iguais ao modelo; regras CASCADE/RESTRICT iguais às do `.mwb` |
| Inserção de dados | Contagem no arquivo e no banco: 30 em cada tabela |
| Consultas SQL | JOINs, filtros (AND/OR/LIKE/IS NULL), GROUP BY, HAVING, ORDER BY, LIMIT |
| Scripts adicionais e índices | 2 índices justificados + 6 exemplos comentados |
| Recursos adicionais | Triggers testadas (renovação válida passou; conta suspensa, data voltando e dia errado bloqueados; cobrança 1 → 0 → 1); permissões e REVOKE conferidos com `SHOW GRANTS`; ROLLBACK devolveu 55,90 |

## Ressalvas

1. **Índice e view**: os scripts da professora não têm exemplo; só o PDF *06 - DDL* cita os dois. Usei a forma mais simples.
2. **`DROP DATABASE IF EXISTS` no início** e **`DROP USER IF EXISTS`** antes da criação dos usuários: servem para o script poder rodar mais de uma vez. O exemplo de exclusão pedido pelo template está na seção 4 (comentado) e na seção 6 (`DROP USER analista`).
3. **Testado em MySQL 8.0** numa instância separada nesta máquina. Vale rodar uma vez no seu Workbench antes de entregar.
4. Matrículas no cabeçalho: Luis Eduardo `UC25200028` e Luís Guilherme `UC25200734`. A do Kaio ainda falta.

## O que falta fazer (não é do script)

- [ ] Matrícula do Kaio no cabeçalho.
- [ ] Rodar `sql/netflix_bd.sql` no seu MySQL Workbench.
- [ ] **Enviar o arquivo no AVA até 18/11/2026 às 23:59** e comparecer à apresentação.
