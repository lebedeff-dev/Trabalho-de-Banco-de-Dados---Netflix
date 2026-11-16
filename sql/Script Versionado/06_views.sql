-- ==========================================================
-- BANCO DE DADOS NETFLIX - ARQUIVO 06 DE 09
-- Views
-- Critério da atividade: Recursos adicionais do banco
--
-- Pré-requisito: executar antes os arquivos 01 a 05, nesta ordem.
-- Este arquivo é a PARTE 6 do script completo (sql/netflix_bd.sql),
-- separada para facilitar a leitura e a apresentação.
-- ==========================================================

USE NETFLIX;

-- ==========================================================
-- PARTE 6 - VIEWS
-- ----------------------------------------------------------
-- Uma VIEW é uma tabela virtual: ela guarda uma consulta
-- (SELECT) com um nome. Os dados continuam nas tabelas
-- originais; a view só mostra o resultado.
-- ==========================================================

-- VIEW 1 - Contas ativas com o plano
-- Mostra os dados da conta SEM a senha (senha_hash fica de fora).
CREATE VIEW vw_contas_ativas AS
SELECT C.id_conta, C.email, C.pais, C.data_cadastro,
       P.nome AS plano, P.valor_mensal, P.qualidade_maxima
FROM conta C
INNER JOIN plano P ON P.id_plano = C.id_plano
WHERE C.status = 'Ativa';

-- Usando a view como se fosse uma tabela:
SELECT * FROM vw_contas_ativas ORDER BY email;

-- VIEW 2 - Catálogo com a categoria principal
-- LEFT JOIN para os títulos sem categoria também aparecerem.
CREATE VIEW vw_catalogo AS
SELECT T.id_titulo, T.nome, T.tipo, T.ano_lancamento,
       T.classificacao_indicativa, CA.nome AS categoria_principal
FROM titulo T
LEFT JOIN titulo_categoria TC ON TC.id_titulo = T.id_titulo
                             AND TC.categoria_principal = 1
LEFT JOIN categoria CA ON CA.id_categoria = TC.id_categoria
WHERE T.disponivel = 1;

SELECT * FROM vw_catalogo ORDER BY nome;

-- VIEW 3 - Ranking de títulos assistidos
CREATE VIEW vw_ranking_titulos AS
SELECT T.id_titulo, T.nome, T.tipo,
       COUNT(H.id_visualizacao) AS visualizacoes
FROM titulo T
LEFT JOIN historico_visualizacao H ON H.id_titulo = T.id_titulo
GROUP BY T.id_titulo, T.nome, T.tipo;

SELECT * FROM vw_ranking_titulos ORDER BY visualizacoes DESC LIMIT 10;
