-- ==========================================================
-- BANCO DE DADOS NETFLIX - ARQUIVO 03 DE 06
-- Seção do template da atividade: 3. Índices (com justificativa)
-- Pré-requisito: executar antes os arquivos 01 a 02, nesta ordem.
-- ==========================================================

USE NETFLIX;

-- ==========================================================
-- 3. ÍNDICES
-- ----------------------------------------------------------
-- Chaves primárias, chaves estrangeiras e campos UNIQUE já têm
-- índice automático no MySQL. Os índices abaixo são em campos
-- que NÃO são chave, mas são muito usados em buscas.
-- ==========================================================

-- ÍNDICE 1 - nome do título
-- Justificativa: a busca por nome é a pesquisa mais comum em um
-- catálogo de streaming (o usuário digita o nome do filme ou da
-- série). O campo nome não é chave nem UNIQUE, então não tinha
-- índice. Com o índice, o MySQL localiza o título sem ler a
-- tabela inteira, e a tabela titulo é a que mais cresce.
CREATE INDEX idx_titulo_nome ON titulo (nome);

-- ÍNDICE 2 - data de início da visualização
-- Justificativa: historico_visualizacao é a tabela que mais
-- recebe registros (cada vez que alguém assiste a algo) e os
-- relatórios costumam ser por período ("o que foi assistido em
-- outubro"). O campo data_inicio é usado no WHERE e no ORDER BY
-- desses relatórios e não tinha índice. Com ele, o filtro por
-- período não precisa percorrer todo o histórico.
CREATE INDEX idx_historico_data_inicio ON historico_visualizacao (data_inicio);
