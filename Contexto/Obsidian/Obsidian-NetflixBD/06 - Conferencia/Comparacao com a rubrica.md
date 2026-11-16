# Comparação do resultado com a rubrica

Conferência feita em 16/11/2026, rodando `sql/netflix_bd.sql` completo num MySQL 8 (duas vezes seguidas, sem erro) e consultando o próprio banco.

## Critério por critério (nível 4 = 3 pontos)

| Critério | O que o nível 4 pede | O que foi entregue | Evidência | Situação |
|---|---|---|---|---|
| **Estrutura do banco** | Banco criado e tabelas conforme a modelagem, com PK, FK e relacionamentos | 13 tabelas iguais ao modelo aprovado (12/12) | No banco: 13 tabelas, 13 PK, 12 FK, 12 UNIQUE; regras CASCADE/RESTRICT iguais às do `.mwb` | Atende |
| **Inserção de dados** | No mínimo 30 INSERT em **todas** as tabelas | 392 INSERT: exatamente 30 em cada tabela (`conta` tem 32) | Contagem no arquivo e no banco: as 13 tabelas têm 30 (conta: 32) | Atende |
| **Consultas SQL** | Consultas corretas, com JOINs, filtros, agrupamentos e ordenação | 12 consultas, todas devolvem linhas | INNER, LEFT, RIGHT e SELF JOIN; WHERE (AND/OR/LIKE/IS NULL); GROUP BY; HAVING; ORDER BY; LIMIT | Atende |
| **Scripts adicionais e índices** | Índice + scripts adicionais, **com justificativa do campo indexado** | 2 índices com justificativa escrita + 3 stored procedures | `idx_titulo_nome`, `idx_historico_data_inicio` (usados pelo MySQL, conferido com EXPLAIN); 3 procedures com `CALL` | Atende (ver ressalva 1) |
| **Recursos adicionais** | Views, triggers, usuários, permissões e transações | 3 views, 3 triggers, 5 usuários, 11 GRANT/REVOKE, 4 transações | Triggers testadas (-10 virou 0; dia 31 virou 28; valor negativo ignorado); permissões testadas entrando com cada usuário; ROLLBACK e SAVEPOINT conferidos | Atende |

## Regras do trabalho

| Regra | Situação |
|---|---|
| Fiel ao modelo lógico aprovado | Sim: mesmas 13 tabelas, campos, tipos, UNIQUE e regras de FK. Nenhuma tabela a mais |
| Só o que está nos materiais da professora | Sim. Cada recurso tem a fonte anotada nas notas de explicação |
| Um arquivo `.sql` | Sim: `sql/netflix_bd.sql`, na ordem dos critérios |

## Ressalvas (o que não dá para garantir)

1. **"Scripts adicionais solicitados"**: a rubrica não diz quais são, e a página da atividade não tem enunciado. Interpretei como as **stored procedures**, que são o único tipo de script dos materiais dela ainda não coberto pelos outros critérios. Se a professora tiver dito em aula outra coisa, falta incluir.
2. **Índice e view**: os scripts dela não têm exemplo; só o PDF *06 - DDL* cita os dois. Usei a forma mais simples.
3. **Formas pequenas que não aparecem literalmente nos scripts dela**, mas são o mesmo comando: `UNIQUE` com duas colunas (já estava no modelo aprovado), `DROP USER IF EXISTS` e `ON DELETE RESTRICT`.
4. **Testado em MySQL 8.0** instalado nesta máquina, numa instância separada. Vale rodar uma vez no seu Workbench antes de entregar.

## O que falta fazer (não é do script)

- [ ] Rodar `sql/netflix_bd.sql` no seu MySQL Workbench e ver o resultado.
- [ ] **Enviar o arquivo no AVA até 18/11/2026 às 23:59.**
- [ ] Ler as notas de explicação em `05 - Script SQL`.
