-- ==========================================================
-- BANCO DE DADOS NETFLIX - ARQUIVO 05 DE 06
-- Seção do template da atividade: 5. Consultas SQL
-- Pré-requisito: executar antes os arquivos 01 a 04, nesta ordem.
-- ==========================================================

USE NETFLIX;

-- ==========================================================
-- 5. CONSULTAS SQL (QUERIES)
-- ==========================================================

-- ----------------------------------------------------------
-- CONSULTA 01 - Simples (1 tabela: conta)
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
-- CONSULTA 02 - Simples (1 tabela: titulo)
-- Quantidade de títulos disponíveis por tipo e o intervalo de
-- anos de lançamento. Só aparecem os tipos com 2 ou mais títulos.
-- ----------------------------------------------------------
SELECT tipo,
       COUNT(*)            AS qtd_titulos,
       MIN(ano_lancamento) AS lancamento_mais_antigo,
       MAX(ano_lancamento) AS lancamento_mais_recente
FROM titulo
WHERE disponivel = 1
  AND ano_lancamento >= 2000
GROUP BY tipo
HAVING COUNT(*) >= 2
ORDER BY qtd_titulos DESC;

-- ----------------------------------------------------------
-- CONSULTA 03 - INNER JOIN (2 tabelas: conta e plano)
-- E-mail, país, plano e valor das contas ATIVAS, em ordem de
-- e-mail.
-- ----------------------------------------------------------
SELECT C.email, C.pais, P.nome AS plano, P.valor_mensal
FROM conta C
INNER JOIN plano P ON P.id_plano = C.id_plano
WHERE C.status = 'Ativa'
ORDER BY C.email;

-- ----------------------------------------------------------
-- CONSULTA 04 - INNER JOIN (2 tabelas: plano e conta)
-- Receita mensal por plano: soma o valor das contas ATIVAS e
-- mostra apenas os planos com receita acima de R$ 100,00.
-- ----------------------------------------------------------
SELECT P.nome              AS plano,
       COUNT(C.id_conta)   AS contas_ativas,
       SUM(P.valor_mensal) AS receita_mensal
FROM plano P
INNER JOIN conta C ON C.id_plano = P.id_plano
WHERE C.status = 'Ativa'
GROUP BY P.id_plano, P.nome
HAVING SUM(P.valor_mensal) > 100
ORDER BY receita_mensal DESC;

-- ----------------------------------------------------------
-- CONSULTA 05 - INNER JOIN (2 tabelas: categoria e titulo_categoria)
-- Categorias que têm 4 ou mais títulos, da maior para a menor.
-- ----------------------------------------------------------
SELECT CA.nome AS categoria, COUNT(*) AS qtd_titulos
FROM categoria CA
INNER JOIN titulo_categoria TC ON TC.id_categoria = CA.id_categoria
GROUP BY CA.id_categoria, CA.nome
HAVING COUNT(*) >= 4
ORDER BY qtd_titulos DESC, CA.nome;

-- ----------------------------------------------------------
-- CONSULTA 06 - INNER JOIN (2 tabelas: titulo e historico_visualizacao)
-- Os 5 títulos mais assistidos.
-- ----------------------------------------------------------
SELECT T.nome AS titulo, T.tipo, COUNT(*) AS visualizacoes
FROM titulo T
INNER JOIN historico_visualizacao H ON H.id_titulo = T.id_titulo
GROUP BY T.id_titulo, T.nome, T.tipo
ORDER BY visualizacoes DESC, T.nome
LIMIT 5;

-- ----------------------------------------------------------
-- CONSULTA 07 - LEFT JOIN (2 tabelas: titulo e historico_visualizacao)
-- Títulos que NUNCA foram assistidos.
-- ----------------------------------------------------------
SELECT T.id_titulo, T.nome, T.tipo, T.ano_lancamento
FROM titulo T
LEFT JOIN historico_visualizacao H ON H.id_titulo = T.id_titulo
WHERE H.id_visualizacao IS NULL
ORDER BY T.nome;

-- ----------------------------------------------------------
-- CONSULTA 08 - RIGHT JOIN (2 tabelas: episodio e temporada)
-- Quantidade de episódios de CADA temporada. As temporadas que
-- ainda não têm episódio também aparecem (com 0).
-- ----------------------------------------------------------
SELECT TE.id_temporada,
       TE.numero_temporada,
       COUNT(E.id_episodio) AS qtd_episodios
FROM episodio E
RIGHT JOIN temporada TE ON TE.id_temporada = E.id_temporada
GROUP BY TE.id_temporada, TE.numero_temporada
ORDER BY qtd_episodios DESC, TE.id_temporada;

-- ----------------------------------------------------------
-- CONSULTA 09 - 3 tabelas (INNER JOIN e LEFT JOIN: conta, plano e perfil)
-- Para CADA conta: e-mail, plano e quantidade de perfis. As
-- contas sem perfil aparecem com 0.
-- ----------------------------------------------------------
SELECT C.email,
       P.nome              AS plano,
       COUNT(PF.id_perfil) AS qtd_perfis
FROM conta C
INNER JOIN plano  P  ON P.id_plano  = C.id_plano
LEFT  JOIN perfil PF ON PF.id_conta = C.id_conta
GROUP BY C.id_conta, C.email, P.nome
ORDER BY qtd_perfis DESC, C.email;

-- ----------------------------------------------------------
-- CONSULTA 10 - 4 tabelas (INNER JOIN: historico_visualizacao,
-- perfil, conta e titulo)
-- Quantidade de títulos concluídos e soma da duração deles por
-- conta. Só aparecem as contas com 2 ou mais concluídos.
-- ----------------------------------------------------------
SELECT C.email,
       COUNT(*)               AS titulos_concluidos,
       SUM(T.duracao_minutos) AS minutos_dos_titulos
FROM historico_visualizacao H
INNER JOIN perfil PF ON PF.id_perfil = H.id_perfil
INNER JOIN conta  C  ON C.id_conta   = PF.id_conta
INNER JOIN titulo T  ON T.id_titulo  = H.id_titulo
WHERE H.concluido = 1
GROUP BY C.id_conta, C.email
HAVING COUNT(*) >= 2
ORDER BY titulos_concluidos DESC, C.email;
