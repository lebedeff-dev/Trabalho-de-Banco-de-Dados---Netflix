# Template da professora

Fonte: `Contexto/Proposta/Template - Projeto - Implementacao.sql`. É o arquivo que define **o que e em que ordem** entregar. O script do trabalho segue exatamente essa estrutura.

## Regras do template
- Entregar **um único arquivo `.sql`**.
- Cabeçalho com a identificação do grupo (nomes e matrículas) e o campo "houve alteração na modelagem?" (neste trabalho: **Não**).
- "Arquivos desorganizados não serão corrigidos."
- "Consultas muito simples não serão aceitas": nada de só `SELECT`, `FROM` e `ORDER BY`.
- Sempre que possível, usar `WHERE` com operadores diferentes, `GROUP BY`, `HAVING` e `ORDER BY`.
- Presença na apresentação é obrigatória para ter nota.
- Se o modelo não permitir algum JOIN pedido, escrever a justificativa técnica (aqui todos os JOINs foram possíveis).

## O que cada seção pede e onde está no script

| Seção do template | O que pede | Onde está |
|---|---|---|
| 1. Criação do banco e estrutura | Banco e tabelas conforme a modelagem | `01_estrutura.sql` |
| 2. Inserção de dados | Mínimo de 30 `INSERT` em cada tabela | `02_inserts.sql` |
| 3. Índices | Pelo menos um índice, com justificativa e benefício de desempenho | `03_indices.sql` |
| 4. Scripts adicionais (como comentários) | `DROP DATABASE`, `DROP TABLE`, `DROP COLUMN`, `ADD COLUMN`, `UPDATE` e `DELETE` de um registro | `04_scripts_adicionais.sql` |
| 5. Consultas | 2 simples (1 tabela), 4 `INNER JOIN` (2 tabelas), 1 `LEFT`, 1 `RIGHT`, 1 com 3 tabelas, 1 com 4 tabelas | `05_consultas.sql` |
| 6. Recursos adicionais | 3 views; 2 triggers (1 `BEFORE` e 1 `AFTER`); 3 usuários com permissões distintas; excluir 1 usuário; revogar privilégios de 2; exemplo de `COMMIT` e de `ROLLBACK` | `06_recursos_adicionais.sql` |

Regra seguida no trabalho: **não entra nada que o template não peça**, para ficar mais fácil de explicar na apresentação.
