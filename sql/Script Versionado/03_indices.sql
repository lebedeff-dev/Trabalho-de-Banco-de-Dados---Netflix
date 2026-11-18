-- ==========================================================
-- BANCO DE DADOS NETFLIX - ARQUIVO 03 DE 06
-- Seção do template da atividade: 3. Índices (com justificativa)
-- Pré-requisito: executar antes os arquivos 01 a 02, nesta ordem.
-- ==========================================================

USE NETFLIX;

-- ==========================================================
-- 3. ÍNDICES
-- ----------------------------------------------------------
-- PK, FK e UNIQUE já ganham índice no MySQL. Os dois índices
-- abaixo são em campos que não são chave.
-- ==========================================================

-- ÍNDICE 1 - titulo.nome
-- Justificativa: o nome é o campo mais pesquisado do catálogo e não
-- tinha índice, porque não é chave nem UNIQUE. Com o índice, a busca
-- por nome não lê a tabela inteira.
CREATE INDEX idx_titulo_nome ON titulo (nome);

-- ÍNDICE 2 - historico_visualizacao.data_inicio
-- Justificativa: o histórico é a tabela que mais cresce e os
-- relatórios filtram por período (WHERE e ORDER BY em data_inicio).
-- Com o índice, o filtro não percorre todas as linhas.
CREATE INDEX idx_historico_data_inicio ON historico_visualizacao (data_inicio);
