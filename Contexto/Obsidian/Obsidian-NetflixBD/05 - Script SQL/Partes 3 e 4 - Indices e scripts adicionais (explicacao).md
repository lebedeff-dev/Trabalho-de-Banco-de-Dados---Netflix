# Seções 3 e 4 - Índices e scripts adicionais (explicação para apresentar)

Arquivos: `03_indices.sql` e `04_scripts_adicionais.sql` · Template: seções **3. Índices** e **4. Scripts adicionais (como comentários)**.

## Seção 3 - Índices

**O que é:** um índice funciona como o índice de um livro. O banco acha as linhas sem ler a tabela inteira.

**Fonte:** o PDF *06 - DDL* cita `CREATE INDEX` ("cria um novo índice em uma tabela"). Forma usada: `CREATE INDEX nome ON tabela (coluna);`.

| Índice | Campo | Justificativa (também escrita no script) |
|---|---|---|
| `idx_titulo_nome` | `titulo.nome` | A busca por nome é a pesquisa mais comum num catálogo de streaming. O campo não é chave nem UNIQUE, então não tinha índice. Com o índice o MySQL acha o título sem ler a tabela inteira. |
| `idx_historico_data_inicio` | `historico_visualizacao.data_inicio` | É a tabela que mais cresce (um registro a cada vez que alguém assiste) e os relatórios são por período. O campo aparece no `WHERE` e no `ORDER BY`. |

**Por que não indexei as FKs?** O MySQL já cria índice automaticamente para chave primária, chave estrangeira e campo `UNIQUE`. Indexar de novo seria redundante.

**Custo:** deixa a leitura mais rápida, mas cada `INSERT`/`UPDATE` fica um pouco mais lento, porque o índice também é atualizado. Por isso não se indexa tudo.

## Seção 4 - Scripts adicionais (comentados)

O template pede seis exemplos, **comentados** para não alterar o banco. Para demonstrar, tira-se o `-- ` do comando.

| Pedido | Comando no script |
|---|---|
| Exclusão do banco | `DROP DATABASE NETFLIX;` |
| Exclusão de uma tabela | `DROP TABLE configuracao_perfil;` |
| Exclusão de uma coluna | `ALTER TABLE pessoa DROP COLUMN biografia;` |
| Adição de coluna não prevista | `ALTER TABLE pessoa ADD COLUMN email_contato VARCHAR(120);` |
| Edição de um registro | `UPDATE conta SET telefone = '(61) 99999-0000' WHERE id_conta = 1;` |
| Exclusão de um registro | `DELETE FROM participacao WHERE id_participacao = 30;` |

Todos foram testados (descomentados numa cópia) e executam sem erro.

- `UPDATE` e `DELETE` sempre com `WHERE`: sem ele, atingem a tabela inteira.
- `ALTER TABLE ... ADD COLUMN` muda a estrutura, por isso fica comentado: a modelagem aprovada não pode mudar.

## Perguntas prováveis

1. **Por que escolheu esses campos para o índice?** São campos muito usados em busca e filtro que ainda não tinham índice (não são chave).
2. **Por que não indexou todos os campos?** Índice ocupa espaço e deixa a escrita mais lenta.
3. **As FKs não precisam de índice?** Já têm: o MySQL cria automaticamente.
4. **Diferença entre DROP TABLE e DELETE?** `DROP TABLE` apaga a tabela inteira (estrutura e dados); `DELETE` apaga linhas e a tabela continua existindo.
5. **Por que os comandos estão comentados?** Para demonstrar domínio técnico sem destruir o banco durante a execução.
