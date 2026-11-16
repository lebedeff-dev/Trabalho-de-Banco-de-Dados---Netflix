# Parte 3 - Consultas (explicação para apresentar)

Arquivo: `sql/netflix_bd.sql` (seção PARTE 3) · Critério: **Consultas SQL (3 pts)**: "JOINs, filtros, agrupamentos e ordenação".
Testado: as 12 consultas rodam e **todas devolvem linhas**.

## Ordem em que o MySQL executa uma consulta
`FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT` (do resumo `sql.jpeg` da professora). Ajuda a explicar por que `WHERE` não enxerga `COUNT(*)` e `HAVING` enxerga.

## As 12 consultas

| Nº | Tipo | O que responde | Tabelas | Linhas |
|---|---|---|---|---|
| 01 | INNER JOIN, 2 tabelas | Contas ativas com o plano e o valor | conta, plano | 27 |
| 02 | INNER JOIN, 3 tabelas | Perfis infantis com conta e plano | perfil, conta, plano | 3 |
| 03 | INNER JOIN, 7 tabelas | Relatório do que foi assistido até o fim | historico, perfil, conta, plano, titulo, titulo_categoria, categoria | 13 |
| 04 | LEFT JOIN + `IS NULL` | Títulos nunca assistidos | titulo, historico | 12 |
| 05 | LEFT JOIN + GROUP BY | Quantidade de perfis por conta (inclui 0) | conta, plano, perfil | 32 |
| 06 | RIGHT JOIN, 2 tabelas | Todas as temporadas, com ou sem episódio | episodio, temporada | 45 |
| 07 | RIGHT JOIN + GROUP BY | Títulos e minutos assistidos por perfil (inclui 0) | historico, perfil, conta | 30 |
| 08 | SELF JOIN | Pares de títulos do mesmo tipo e ano | titulo (2x) | 14 |
| 09 | GROUP BY + HAVING | Categorias com 4 ou mais títulos | categoria, titulo_categoria | 5 |
| 10 | WHERE (AND, OR, LIKE, IS NULL) | Contas que precisam de atenção | conta | 9 |
| 11 | GROUP BY + ORDER BY + LIMIT | Os 5 títulos mais assistidos | titulo, historico | 5 |
| 12 | GROUP BY + HAVING + SUM | Receita mensal por plano (acima de R$ 100) | plano, conta | 3 |

Resultados que dá para citar: a consulta 09 devolve Drama (5), Comédia, Crime, Romance e Suspense (4 cada); a consulta 12 devolve Padrão (R$ 279,30), Premium (R$ 223,60) e Básico (R$ 129,50).

## Conceitos (com a fonte da professora)

- **INNER JOIN**: só traz linhas que existem nas duas tabelas. Fonte: exercícios 01 a 03 de `exercicios_joins_gabarito.sql`.
- **LEFT JOIN**: mantém todas as linhas da tabela da esquerda; onde não há par, vem `NULL`. Fonte: exercícios 04 e 05.
- **`LEFT JOIN ... WHERE x IS NULL`**: truque para achar "os que não têm" (títulos nunca assistidos). Fonte: gabarito, questões 32, 33 e 53.
- **RIGHT JOIN**: o LEFT "espelhado", mantém a tabela da direita. Fonte: exercícios 06 e 07.
- **SELF JOIN**: a tabela unida com ela mesma, usando dois apelidos (A e B). `A.id < B.id` evita o par consigo mesmo e os pares invertidos. Fonte: exercício 08 (pessoas da mesma cidade).
- **GROUP BY**: junta linhas em grupos para usar `COUNT`, `SUM`. Fonte: gabarito, Parte 16.
- **HAVING**: filtra os grupos **depois** de agrupar (`WHERE` filtra antes). Fonte: gabarito, Parte 17.
- **`COUNT(coluna)` x `COUNT(*)`**: `COUNT(PF.id_perfil)` não conta `NULL`, então conta sem perfil dá 0. `COUNT(*)` daria 1. Fonte: comentário do exercício 05.
- **COALESCE(x, 0)**: troca `NULL` por 0. Fonte: exercícios 05 e 07.
- **Alias (`AS`, apelidos de tabela)**: `conta C`, `P.nome AS plano`. Fonte: todos os exercícios.
- **LIKE**: busca por padrão (`'%@exemplo.com'`). Fonte: gabarito, Parte 8.
- **DATE_FORMAT**: mostra a data em `dd/mm/aaaa`. Fonte: gabarito, questão 42.
- **LIMIT**: limita a quantidade de linhas. Fonte: gabarito, Parte 3 e questão 55.

## Detalhes que valem ponto na explicação

- **Consulta 03**: sem `TC.categoria_principal = 1`, as visualizações dos títulos com duas categorias (1, 2, 3, 11 e 12) apareceriam repetidas. É o mesmo cuidado do exercício 03 dela (a Gabriela duplicada sem o filtro de data).
- **Consultas 04 a 07** só têm graça por causa dos dados "sem correspondência" planejados na Parte 2.
- **Consulta 12**: `WHERE` tira as contas não ativas antes de agrupar; `HAVING` tira os planos com receita baixa depois de somar.

## Perguntas prováveis

1. **Diferença entre INNER e LEFT JOIN?** INNER só traz o que tem par nas duas tabelas; LEFT traz tudo da esquerda, com `NULL` onde não há par.
2. **Diferença entre WHERE e HAVING?** WHERE filtra linhas antes do agrupamento; HAVING filtra grupos depois.
3. **Por que `A.id_titulo < B.id_titulo` no SELF JOIN?** Para o título não parear com ele mesmo e o par não aparecer duas vezes invertido.
4. **Por que COUNT(PF.id_perfil) e não COUNT(*)?** Para a conta sem perfil aparecer com 0, e não 1.
5. **Por que repetir colunas no GROUP BY?** Toda coluna do SELECT que não é função de agregação precisa estar no GROUP BY.
6. **O que é RIGHT JOIN?** O LEFT JOIN espelhado: preserva a tabela da direita.
