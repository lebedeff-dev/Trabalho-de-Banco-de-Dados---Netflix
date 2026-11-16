# Partes 4 e 5 - Índices e procedures (explicação para apresentar)

Arquivo: `sql/netflix_bd.sql` · Critério: **Scripts adicionais e índices (3 pts)**: "criação de índice e todos os scripts adicionais, **com justificativa adequada para o campo indexado**".

## Parte 4 - Índices

**O que é:** um índice funciona como o índice de um livro. O banco acha as linhas sem ler a tabela inteira.

**Fonte:** o PDF *06 - DDL* cita `CREATE INDEX` ("cria um novo índice em uma tabela"). Os scripts da professora não têm exemplo, então usei a forma mais simples: `CREATE INDEX nome ON tabela (coluna);`.

| Índice | Campo | Justificativa |
|---|---|---|
| `idx_titulo_nome` | `titulo.nome` | A busca por nome é a pesquisa mais comum num catálogo de streaming. O campo não é chave nem UNIQUE, então não tinha índice. |
| `idx_historico_data_inicio` | `historico_visualizacao.data_inicio` | É a tabela que mais cresce (um registro a cada vez que alguém assiste) e os relatórios são por período. O campo aparece no `WHERE` e no `ORDER BY`. |

**Por que não indexei as FKs (`id_plano`, `id_conta`...)?** Porque o MySQL já cria índice automaticamente para chave primária, chave estrangeira e campo `UNIQUE`. Indexar de novo seria redundante. Esse é um bom argumento para a justificativa.

**Conferido:** rodei `EXPLAIN` nas duas consultas de exemplo e o MySQL usou os dois índices (`key = idx_titulo_nome` e `key = idx_historico_data_inicio`). O `EXPLAIN` não está no script porque a professora não mostrou esse comando.

**Custo de um índice:** deixa a leitura mais rápida, mas cada `INSERT`/`UPDATE` fica um pouco mais lento, porque o índice também precisa ser atualizado. Por isso não se indexa tudo.

## Parte 5 - Stored procedures (os "scripts adicionais")

**O que é:** um bloco de comandos guardado no banco, executado com `CALL`.
**Fonte:** `bd_supermercado-storeprocedure.sql` (sem parâmetro, com parâmetro `IN`, com `UPDATE`).

| Procedure | Parâmetros | O que faz | Modelo da professora |
|---|---|---|---|
| `sp_contas_por_plano()` | nenhum | Relatório: quantas contas cada plano tem | `sp_produtos_estoque_baixo` / `sp_relatorio_pedidos` |
| `sp_titulos_por_ano(ano_min, ano_max)` | 2 de entrada | Títulos lançados entre dois anos (`BETWEEN`) | `sp_produtos_por_preco` |
| `sp_alterar_status_conta(conta_id, novo_status)` | 2 de entrada | Muda o status de uma conta (`UPDATE`) | `sp_baixar_estoque` |

**`DELIMITER //`:** dentro da procedure há vários `;`. Trocar o delimitador para `//` evita que o MySQL ache que o comando terminou no primeiro `;`. No fim, `DELIMITER ;` volta ao normal.

**`IN`:** parâmetro de entrada, o valor que se passa no `CALL`.

## Perguntas prováveis

1. **Por que escolheu esses campos para o índice?** São campos muito usados em busca e filtro que ainda não tinham índice (não são chave).
2. **Por que não criou índice em todos os campos?** Índice ocupa espaço e deixa a escrita mais lenta.
3. **As FKs não precisam de índice?** Já têm: o MySQL cria automaticamente.
4. **Qual a vantagem de uma procedure?** Guarda a lógica no banco; quem usa só chama `CALL`, sem reescrever a consulta.
5. **Para que serve o DELIMITER?** Para o MySQL não encerrar a procedure no primeiro `;` de dentro dela.
6. **Onde a professora mostrou índice?** No PDF de DDL (CREATE/ALTER/DROP INDEX).
