-- ==========================================================
-- BANCO DE DADOS NETFLIX - ARQUIVO 03 DE 09
-- Critério da atividade: Consultas SQL (queries)
-- Pré-requisito: executar antes os arquivos 01 a 02, nesta ordem.
-- ==========================================================

USE NETFLIX;

-- ==========================================================
-- PARTE 3 - CONSULTAS SQL
-- ----------------------------------------------------------
-- 12 consultas com JOINs, filtros, agrupamentos e ordenação.
-- ==========================================================

-- ----------------------------------------------------------
-- CONSULTA 01 - INNER JOIN - 2 tabelas
-- Lista o e-mail, o país, o nome do plano e o valor mensal
-- de todas as contas ATIVAS, em ordem de e-mail.
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

-- ----------------------------------------------------------
-- CONSULTA 04 - LEFT JOIN - 2 tabelas
-- Lista os títulos que NUNCA foram assistidos.
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
-- ----------------------------------------------------------
SELECT C.email,
       P.nome            AS plano,
       COUNT(PF.id_perfil) AS qtd_perfis
FROM conta C
INNER JOIN plano  P  ON P.id_plano  = C.id_plano
LEFT  JOIN perfil PF ON PF.id_conta = C.id_conta
GROUP BY C.id_conta, C.email, P.nome
ORDER BY qtd_perfis DESC, C.email;

-- ----------------------------------------------------------
-- CONSULTA 06 - RIGHT JOIN - 2 tabelas
-- Lista TODAS as temporadas com seus episódios. As temporadas
-- que ainda não têm episódio também aparecem (com NULL).
-- ----------------------------------------------------------
SELECT TE.id_temporada, TE.numero_temporada, E.numero_episodio, E.titulo_episodio
FROM episodio E
RIGHT JOIN temporada TE ON TE.id_temporada = E.id_temporada
ORDER BY TE.id_temporada, E.numero_episodio;

-- ----------------------------------------------------------
-- CONSULTA 07 - RIGHT JOIN - 3 tabelas (com agrupamento)
-- Mostra TODOS os perfis, o e-mail da conta, a quantidade de
-- títulos assistidos e o total de minutos. Perfis que nunca
-- assistiram a nada aparecem com 0.
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

-- ----------------------------------------------------------
-- CONSULTA 08 - SELF JOIN
-- Lista os pares de títulos do MESMO tipo lançados no MESMO ano.
-- Cada par aparece uma única vez e um título não forma par
-- com ele mesmo.
-- ----------------------------------------------------------
SELECT A.nome AS titulo_1, B.nome AS titulo_2, A.tipo, A.ano_lancamento
FROM titulo A
INNER JOIN titulo B
        ON A.tipo = B.tipo
       AND A.ano_lancamento = B.ano_lancamento
       AND A.id_titulo < B.id_titulo
ORDER BY A.ano_lancamento, A.nome;

-- ----------------------------------------------------------
-- CONSULTA 09 - GROUP BY com HAVING
-- Categorias que têm 4 ou mais títulos, da maior para a menor.
-- ----------------------------------------------------------
SELECT CA.nome AS categoria, COUNT(*) AS qtd_titulos
FROM categoria CA
INNER JOIN titulo_categoria TC ON TC.id_categoria = CA.id_categoria
GROUP BY CA.id_categoria, CA.nome
HAVING COUNT(*) >= 4
ORDER BY qtd_titulos DESC, CA.nome;

-- ----------------------------------------------------------
-- CONSULTA 10 - Filtros (WHERE com AND, OR, LIKE e IS NULL)
-- Contas do Brasil que precisam de atenção do atendimento:
-- estão suspensas, canceladas ou não têm telefone cadastrado.
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
