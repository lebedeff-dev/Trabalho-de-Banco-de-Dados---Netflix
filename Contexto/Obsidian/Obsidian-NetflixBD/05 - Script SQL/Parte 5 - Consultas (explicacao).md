# Seção 5 - Consultas (explicação para apresentar)

Arquivo: `05_consultas.sql` · Template: **5. Consultas SQL**. O template pede 10 consultas com a distribuição abaixo, usando `WHERE`, `GROUP BY`, `HAVING` e `ORDER BY` sempre que possível. Todas devolvem linhas.

## Ordem em que o MySQL executa uma consulta
`FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT` (do resumo `sql.jpeg` da professora). Explica por que `WHERE` não enxerga `COUNT(*)` e `HAVING` enxerga.

## As 10 consultas

| Nº | Exigência do template | O que responde | Tabelas | Linhas |
|---|---|---|---|---|
| 01 | Simples (1 tabela) | Contas do Brasil que precisam de atenção (`AND`, `OR`, `LIKE`, `IS NULL`) | conta | 9 |
| 02 | Simples (1 tabela) | Quantidade de títulos por tipo e intervalo de anos (`GROUP BY` + `HAVING`) | titulo | 4 |
| 03 | `INNER JOIN` (2) | Contas ativas com plano e valor | conta, plano | 27 |
| 04 | `INNER JOIN` (2) | Receita mensal por plano, só acima de R$ 100 (`SUM` + `HAVING`) | plano, conta | 3 |
| 05 | `INNER JOIN` (2) | Categorias com 4 ou mais títulos | categoria, titulo_categoria | 5 |
| 06 | `INNER JOIN` (2) | Os 5 títulos mais assistidos (`LIMIT`) | titulo, historico_visualizacao | 5 |
| 07 | `LEFT JOIN` | Títulos nunca assistidos (`IS NULL`) | titulo, historico_visualizacao | 12 |
| 08 | `RIGHT JOIN` | Quantidade de episódios de cada temporada (inclui 0) | episodio, temporada | 30 |
| 09 | 3 tabelas (INNER + LEFT) | Quantidade de perfis por conta (inclui 0) | conta, plano, perfil | 32 |
| 10 | 4 tabelas (INNER) | Títulos concluídos por conta, 2 ou mais (`HAVING`) | historico_visualizacao, perfil, conta, titulo | 4 |

Resultados que dá para citar: consulta 05 devolve Drama (5) e Comédia, Crime, Romance e Suspense (4 cada); consulta 04 devolve Padrão (R$ 279,30), Premium (R$ 223,60) e Básico (R$ 129,50).

## Conceitos (com a fonte da professora)

- **INNER JOIN**: só traz linhas que existem nas duas tabelas. Fonte: exercícios 01 a 03 de `exercicios_joins_gabarito.sql`.
- **LEFT JOIN**: mantém todas as linhas da tabela da esquerda; onde não há par, vem `NULL`. Fonte: exercícios 04 e 05.
- **`LEFT JOIN ... WHERE x IS NULL`**: acha "os que não têm" (títulos nunca assistidos). Fonte: gabarito, questões 32, 33 e 53.
- **RIGHT JOIN**: o LEFT espelhado, mantém a tabela da direita. Fonte: exercícios 06 e 07.
- **GROUP BY**: junta linhas em grupos para usar `COUNT`, `SUM`, `MIN`, `MAX`. Fonte: gabarito, Parte 16.
- **HAVING**: filtra os grupos **depois** de agrupar (`WHERE` filtra antes). Fonte: gabarito, Parte 17.
- **`COUNT(coluna)` x `COUNT(*)`**: `COUNT(PF.id_perfil)` não conta `NULL`, então conta sem perfil dá 0; `COUNT(*)` daria 1.
- **LIKE**: busca por padrão (`'%@exemplo.com'`). Fonte: gabarito, Parte 8.
- **LIMIT**: limita a quantidade de linhas. Fonte: gabarito, Parte 3 e questão 55.

## Detalhes que valem ponto

- **Consulta 04**: `WHERE` tira as contas não ativas antes de agrupar; `HAVING` tira os planos com receita baixa depois de somar.
- **Consulta 08**: `COUNT(E.id_episodio)` e não `COUNT(*)`, para a temporada sem episódio aparecer com 0. As temporadas 16 a 30 foram planejadas sem episódios nos inserts.
- **Consultas 07 a 09** só têm graça por causa dos dados "sem correspondência" planejados na seção 2.

## Perguntas prováveis

1. **Diferença entre INNER e LEFT JOIN?** INNER só traz o que tem par nas duas tabelas; LEFT traz tudo da esquerda, com `NULL` onde não há par.
2. **Diferença entre WHERE e HAVING?** WHERE filtra linhas antes do agrupamento; HAVING filtra grupos depois.
3. **Por que COUNT(PF.id_perfil) e não COUNT(*)?** Para a conta sem perfil aparecer com 0, e não 1.
4. **Por que repetir colunas no GROUP BY?** Toda coluna do SELECT que não é função de agregação precisa estar no GROUP BY.
5. **O que é RIGHT JOIN?** O LEFT JOIN espelhado: preserva a tabela da direita.
