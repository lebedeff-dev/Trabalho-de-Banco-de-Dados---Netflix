-- ==========================================================
-- BANCO DE DADOS NETFLIX - ARQUIVO 04 DE 09
-- Índices (com justificativa)
-- Critério da atividade: Scripts adicionais e índices
--
-- Pré-requisito: executar antes os arquivos 01 a 03, nesta ordem.
-- Este arquivo é a PARTE 4 do script completo (sql/netflix_bd.sql),
-- separada para facilitar a leitura e a apresentação.
-- ==========================================================

USE NETFLIX;

-- ==========================================================
-- PARTE 4 - ÍNDICES
-- ----------------------------------------------------------
-- Um índice funciona como o índice de um livro: o banco
-- encontra as linhas sem precisar ler a tabela inteira.
--
-- Observação: as chaves primárias, as chaves estrangeiras e os
-- campos UNIQUE já têm índice criado automaticamente pelo
-- MySQL. Por isso os índices abaixo foram criados em campos
-- que NÃO são chave, mas são muito usados em buscas.
-- ==========================================================

-- ÍNDICE 1 - nome do título
-- Justificativa: a busca por nome é a pesquisa mais comum em um
-- catálogo de streaming (o usuário digita o nome do filme ou da
-- série). O campo nome não é chave nem UNIQUE, então não tinha
-- índice. A tabela titulo também é a que mais cresce no catálogo.
CREATE INDEX idx_titulo_nome ON titulo (nome);

-- Consulta que aproveita o índice:
SELECT id_titulo, nome, tipo
FROM titulo
WHERE nome LIKE 'O%'
ORDER BY nome;

-- ÍNDICE 2 - data de início da visualização
-- Justificativa: historico_visualizacao é a tabela que mais
-- recebe registros (cada vez que alguém assiste a algo) e os
-- relatórios costumam ser por período ("o que foi assistido em
-- outubro"). O campo data_inicio é usado no WHERE e no ORDER BY
-- desses relatórios e não tinha índice.
CREATE INDEX idx_historico_data_inicio ON historico_visualizacao (data_inicio);

-- Consulta que aproveita o índice:
SELECT id_visualizacao, id_perfil, id_titulo, data_inicio
FROM historico_visualizacao
WHERE data_inicio >= '2026-10-01' AND data_inicio < '2026-11-01'
ORDER BY data_inicio;
