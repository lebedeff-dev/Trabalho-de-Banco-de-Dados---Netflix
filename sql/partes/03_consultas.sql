-- ==========================================================
-- BANCO DE DADOS NETFLIX - ARQUIVO 03 DE 09
-- Consultas SQL
-- Critério da atividade: Consultas SQL (queries)
--
-- Pré-requisito: executar antes os arquivos 01 a 02, nesta ordem.
-- Este arquivo é a PARTE 3 do script completo (sql/netflix_bd.sql),
-- separada para facilitar a leitura e a apresentação.
-- ==========================================================

USE NETFLIX;

-- ==========================================================
-- PARTE 3 - CONSULTAS SQL
-- ----------------------------------------------------------
-- 12 consultas com JOINs, filtros, agrupamentos e ordenação.
-- Seguem os tipos trabalhados nos exercícios da professora:
--   INNER JOIN ........ consultas 01, 02 e 03
--   LEFT JOIN ......... consultas 04 e 05
--   RIGHT JOIN ........ consultas 06 e 07
--   SELF JOIN ......... consulta  08
--   GROUP BY / HAVING . consultas 09, 11 e 12
--   Filtros (WHERE) ... consulta  10
-- ==========================================================

-- ----------------------------------------------------------
-- CONSULTA 01 - INNER JOIN - 2 tabelas
-- Lista o e-mail, o país, o nome do plano e o valor mensal
-- de todas as contas ATIVAS, em ordem de e-mail.
-- Tabelas: conta, plano
-- ----------------------------------------------------------
SELECT C.email, C.pais, P.nome AS plano, P.valor_mensal
FROM conta C
INNER JOIN plano P ON P.id_plano = C.id_plano
WHERE C.status = 'Ativa'
ORDER BY C.email;

-- ----------------------------------------------------------
-- CONSULTA 02 - INNER JOIN - 3 tabelas
-- Mostra cada perfil com o e-mail da conta e o plano contratado,
-- apenas dos perfis infantis.
-- Tabelas: perfil, conta, plano
-- ----------------------------------------------------------
SELECT PF.nome AS perfil, C.email, P.nome AS plano, P.telas_simultaneas
FROM perfil PF
INNER JOIN conta C ON C.id_conta = PF.id_conta
INNER JOIN plano P ON P.id_plano = C.id_plano
WHERE PF.perfil_infantil = 1
ORDER BY C.email;

-- ----------------------------------------------------------
-- CONSULTA 03 - INNER JOIN - 7 tabelas
-- Relatório do que foi assistido ATÉ O FIM: perfil, e-mail da
-- conta, plano, título, tipo, categoria principal, dispositivo
-- e data de início formatada.
-- Tabelas: historico_visualizacao, perfil, conta, plano,
--          titulo, titulo_categoria, categoria
-- ----------------------------------------------------------
SELECT PF.nome                              AS perfil,
       C.email                              AS conta,
       P.nome                               AS plano,
       T.nome                               AS titulo,
       T.tipo,
       CA.nome                              AS categoria_principal,
       H.dispositivo,
       DATE_FORMAT(H.data_inicio, '%d/%m/%Y') AS assistido_em
FROM historico_visualizacao H
INNER JOIN perfil           PF ON PF.id_perfil   = H.id_perfil
INNER JOIN conta            C  ON C.id_conta     = PF.id_conta
INNER JOIN plano            P  ON P.id_plano     = C.id_plano
INNER JOIN titulo           T  ON T.id_titulo    = H.id_titulo
INNER JOIN titulo_categoria TC ON TC.id_titulo   = T.id_titulo
INNER JOIN categoria        CA ON CA.id_categoria = TC.id_categoria
WHERE H.concluido = 1
  AND TC.categoria_principal = 1
ORDER BY H.data_inicio;
-- Comentário: sem o filtro categoria_principal = 1, cada
-- visualização apareceria repetida, uma vez por categoria do título.

-- ----------------------------------------------------------
-- CONSULTA 04 - LEFT JOIN - 2 tabelas
-- Lista os títulos que NUNCA foram assistidos.
-- O LEFT JOIN mantém todos os títulos; os que não têm histórico
-- ficam com NULL, e o WHERE seleciona exatamente esses.
-- Tabelas: titulo, historico_visualizacao
-- ----------------------------------------------------------
SELECT T.id_titulo, T.nome, T.tipo, T.ano_lancamento
FROM titulo T
LEFT JOIN historico_visualizacao H ON H.id_titulo = T.id_titulo
WHERE H.id_visualizacao IS NULL
ORDER BY T.nome;

-- ----------------------------------------------------------
-- CONSULTA 05 - LEFT JOIN - 3 tabelas (com agrupamento)
-- Para CADA conta, mostra o e-mail, o plano e a quantidade de
-- perfis. Contas sem perfil aparecem com 0.
-- Tabelas: conta, plano, perfil
-- ----------------------------------------------------------
SELECT C.email,
       P.nome            AS plano,
       COUNT(PF.id_perfil) AS qtd_perfis
FROM conta C
INNER JOIN plano  P  ON P.id_plano  = C.id_plano
LEFT  JOIN perfil PF ON PF.id_conta = C.id_conta
GROUP BY C.id_conta, C.email, P.nome
ORDER BY qtd_perfis DESC, C.email;
-- Comentário: COUNT(PF.id_perfil) conta só valores não nulos.
-- COUNT(*) daria 1 para as contas sem perfil.

-- ----------------------------------------------------------
-- CONSULTA 06 - RIGHT JOIN - 2 tabelas
-- Lista TODAS as temporadas com seus episódios. As temporadas
-- que ainda não têm episódio também aparecem (com NULL).
-- Tabelas: episodio, temporada (nesta ordem no FROM)
-- ----------------------------------------------------------
SELECT TE.id_temporada, TE.numero_temporada, E.numero_episodio, E.titulo_episodio
FROM episodio E
RIGHT JOIN temporada TE ON TE.id_temporada = E.id_temporada
ORDER BY TE.id_temporada, E.numero_episodio;
-- Comentário: temporada está à DIREITA, então todas as temporadas
-- são preservadas. É o LEFT JOIN "espelhado".

-- ----------------------------------------------------------
-- CONSULTA 07 - RIGHT JOIN - 3 tabelas (com agrupamento)
-- Mostra TODOS os perfis, o e-mail da conta, a quantidade de
-- títulos assistidos e o total de minutos. Perfis que nunca
-- assistiram a nada aparecem com 0.
-- Tabelas: historico_visualizacao, perfil, conta
-- ----------------------------------------------------------
SELECT PF.nome                         AS perfil,
       C.email,
       COUNT(H.id_visualizacao)        AS qtd_titulos,
       COALESCE(SUM(H.minuto_parada), 0) AS minutos_assistidos
FROM historico_visualizacao H
RIGHT JOIN perfil PF ON PF.id_perfil = H.id_perfil
INNER JOIN conta  C  ON C.id_conta   = PF.id_conta
GROUP BY PF.id_perfil, PF.nome, C.email
ORDER BY minutos_assistidos DESC;
-- Comentário: COALESCE troca o NULL da soma por 0.

-- ----------------------------------------------------------
-- CONSULTA 08 - SELF JOIN
-- Lista os pares de títulos do MESMO tipo lançados no MESMO ano.
-- Cada par aparece uma única vez e um título não forma par
-- com ele mesmo.
-- Tabela: titulo (unida com ela mesma)
-- ----------------------------------------------------------
SELECT A.nome AS titulo_1, B.nome AS titulo_2, A.tipo, A.ano_lancamento
FROM titulo A
INNER JOIN titulo B
        ON A.tipo = B.tipo
       AND A.ano_lancamento = B.ano_lancamento
       AND A.id_titulo < B.id_titulo
ORDER BY A.ano_lancamento, A.nome;
-- Comentário: A.id_titulo < B.id_titulo evita o título pareado com
-- ele mesmo e os pares repetidos invertidos.

-- ----------------------------------------------------------
-- CONSULTA 09 - GROUP BY com HAVING
-- Categorias que têm 5 ou mais títulos, da maior para a menor.
-- Tabelas: categoria, titulo_categoria
-- ----------------------------------------------------------
SELECT CA.nome AS categoria, COUNT(*) AS qtd_titulos
FROM categoria CA
INNER JOIN titulo_categoria TC ON TC.id_categoria = CA.id_categoria
GROUP BY CA.id_categoria, CA.nome
HAVING COUNT(*) >= 5
ORDER BY qtd_titulos DESC, CA.nome;
-- Comentário: WHERE filtra linhas antes de agrupar;
-- HAVING filtra os grupos depois do agrupamento.

-- ----------------------------------------------------------
-- CONSULTA 10 - Filtros (WHERE com AND, OR, LIKE e IS NULL)
-- Contas do Brasil que precisam de atenção do atendimento:
-- estão suspensas, canceladas ou não têm telefone cadastrado.
-- Tabela: conta
-- ----------------------------------------------------------
SELECT id_conta, email, telefone, status
FROM conta
WHERE pais = 'BR'
  AND email LIKE '%@exemplo.com'
  AND (status = 'Suspensa' OR status = 'Cancelada' OR telefone IS NULL)
ORDER BY status, email;

-- ----------------------------------------------------------
-- CONSULTA 11 - Os 5 títulos mais assistidos
-- Agrupa o histórico por título, ordena pela quantidade e
-- limita o resultado.
-- Tabelas: titulo, historico_visualizacao
-- ----------------------------------------------------------
SELECT T.nome AS titulo, T.tipo, COUNT(*) AS visualizacoes
FROM titulo T
INNER JOIN historico_visualizacao H ON H.id_titulo = T.id_titulo
GROUP BY T.id_titulo, T.nome, T.tipo
ORDER BY visualizacoes DESC, T.nome
LIMIT 5;

-- ----------------------------------------------------------
-- CONSULTA 12 - Receita mensal por plano
-- Soma o valor mensal das contas ATIVAS de cada plano e mostra
-- apenas os planos com receita acima de R$ 100,00.
-- Tabelas: plano, conta
-- ----------------------------------------------------------
SELECT P.nome                AS plano,
       COUNT(C.id_conta)     AS contas_ativas,
       SUM(P.valor_mensal)   AS receita_mensal
FROM plano P
INNER JOIN conta C ON C.id_plano = P.id_plano
WHERE C.status = 'Ativa'
GROUP BY P.id_plano, P.nome
HAVING SUM(P.valor_mensal) > 100
ORDER BY receita_mensal DESC;
