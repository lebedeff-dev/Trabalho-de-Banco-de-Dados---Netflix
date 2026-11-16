-- ==========================================================
-- BANCO DE DADOS NETFLIX
-- Laboratório de Banco de Dados - AT1 - Implementação
-- SGBD: MySQL 8
--
-- Implementação fiel ao modelo lógico aprovado
-- (Banco de dados/netflix.mwb): 13 tabelas e 12 chaves
-- estrangeiras.
--
-- Estilo baseado no bd_supermercado.sql da professora.
--
-- Conteúdo deste arquivo, na ordem dos critérios da atividade:
--
--   Critério "Estrutura do banco de dados"
--     PARTE 1 - Estrutura (banco e 13 tabelas)
--   Critério "Inserção de dados"
--     PARTE 2 - Inserção de dados (mínimo de 30 INSERT por tabela)
--   Critério "Consultas SQL (queries)"
--     PARTE 3 - Consultas (JOINs, filtros, agrupamentos, ordenação)
--   Critério "Scripts adicionais e índices"
--     PARTE 4 - Índices (com justificativa do campo indexado)
--     PARTE 5 - Stored procedures
--   Critério "Recursos adicionais do banco"
--     PARTE 6 - Views
--     PARTE 7 - Triggers
--     PARTE 8 - Usuários e permissões (GRANT e REVOKE)
--     PARTE 9 - Transações (COMMIT, ROLLBACK e SAVEPOINT)
--
-- Como executar: abra este arquivo no MySQL Workbench e execute
-- tudo (o script recria o banco do zero a cada execução).
-- ==========================================================


-- ==========================================================
-- PARTE 1 - ESTRUTURA DO BANCO
-- ==========================================================

-- Garante recriação limpa do banco (útil para testes)
DROP DATABASE IF EXISTS NETFLIX;

-- Criação com charset UTF-8 moderno (utf8mb4)
CREATE DATABASE IF NOT EXISTS NETFLIX
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_unicode_ci;

USE NETFLIX;


-- ----------------------------------------------------------
-- Ordem de criação:
-- uma tabela com chave estrangeira só pode ser criada
-- DEPOIS da tabela que ela referencia.
--
--   Grupo 1 (sem chave estrangeira):
--     plano, categoria, pessoa, titulo
--   Grupo 2:
--     conta (-> plano), temporada (-> titulo)
--   Grupo 3:
--     dados_cobranca (-> conta), perfil (-> conta),
--     episodio (-> temporada)
--   Grupo 4:
--     configuracao_perfil (-> perfil),
--     titulo_categoria (-> titulo, categoria),
--     participacao (-> pessoa, titulo),
--     historico_visualizacao (-> perfil, titulo)
-- ----------------------------------------------------------


-- ==========================================================
-- GRUPO 1 - TABELAS SEM CHAVE ESTRANGEIRA
-- ==========================================================

-- PLANO: planos de assinatura oferecidos
CREATE TABLE IF NOT EXISTS plano (
    id_plano          INT PRIMARY KEY AUTO_INCREMENT,
    nome              VARCHAR(40)   NOT NULL UNIQUE,
    descricao         TEXT,
    valor_mensal      DECIMAL(6,2)  NOT NULL,
    qualidade_maxima  ENUM('SD','HD','Full HD','4K UHD') NOT NULL,
    telas_simultaneas TINYINT       NOT NULL,
    permite_download  TINYINT(1)    NOT NULL DEFAULT 1,
    data_criacao      DATE          NOT NULL
);

-- CATEGORIA: gêneros do catálogo (Ação, Drama, Comédia...)
CREATE TABLE IF NOT EXISTS categoria (
    id_categoria    INT PRIMARY KEY AUTO_INCREMENT,
    nome            VARCHAR(50) NOT NULL UNIQUE,
    descricao       TEXT,
    codigo_interno  CHAR(4)     NOT NULL UNIQUE,
    ativa           TINYINT(1)  NOT NULL DEFAULT 1,
    data_criacao    DATE        NOT NULL
);

-- PESSOA: atores, diretores, roteiristas etc.
CREATE TABLE IF NOT EXISTS pessoa (
    id_pessoa       INT PRIMARY KEY AUTO_INCREMENT,
    nome            VARCHAR(100) NOT NULL,
    nome_artistico  VARCHAR(100),
    data_nascimento DATE,
    nacionalidade   VARCHAR(50)  NOT NULL,
    biografia       TEXT,
    em_atividade    TINYINT(1)   NOT NULL DEFAULT 1
);

-- TITULO: filmes, séries, documentários e stand-ups do catálogo
CREATE TABLE IF NOT EXISTS titulo (
    id_titulo                INT PRIMARY KEY AUTO_INCREMENT,
    nome                     VARCHAR(150) NOT NULL,
    sinopse                  TEXT,
    tipo                     ENUM('Filme','Serie','Documentario','Stand-up') NOT NULL,
    ano_lancamento           SMALLINT     NOT NULL,
    classificacao_indicativa ENUM('L','10','12','14','16','18') NOT NULL,
    duracao_minutos          INT,
    idioma_original          VARCHAR(30)  NOT NULL,
    data_adicao_catalogo     DATE         NOT NULL,
    disponivel               TINYINT(1)   NOT NULL DEFAULT 1
);


-- ==========================================================
-- GRUPO 2 - TABELAS QUE DEPENDEM DO GRUPO 1
-- ==========================================================

-- CONTA: conta de assinatura (cada conta tem UM plano)
-- Relacionamento 1:N -> plano (1) x conta (N)
CREATE TABLE IF NOT EXISTS conta (
    id_conta      INT PRIMARY KEY AUTO_INCREMENT,
    id_plano      INT          NOT NULL,
    email         VARCHAR(120) NOT NULL UNIQUE,
    senha_hash    VARCHAR(255) NOT NULL,
    telefone      VARCHAR(15),
    pais          CHAR(2)      NOT NULL DEFAULT 'BR',
    data_cadastro DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status        ENUM('Ativa','Suspensa','Cancelada') NOT NULL DEFAULT 'Ativa',
    FOREIGN KEY (id_plano) REFERENCES plano (id_plano)
    ON DELETE RESTRICT
        -- Não permite excluir um plano que ainda tem contas.
    ON UPDATE CASCADE
);

-- TEMPORADA: temporadas de uma série
-- Relacionamento 1:N -> titulo (1) x temporada (N)
CREATE TABLE IF NOT EXISTS temporada (
    id_temporada     INT PRIMARY KEY AUTO_INCREMENT,
    id_titulo        INT        NOT NULL,
    numero_temporada TINYINT    NOT NULL,
    nome             VARCHAR(100),
    ano_lancamento   SMALLINT   NOT NULL,
    data_estreia     DATE       NOT NULL,
    sinopse          TEXT,
    disponivel       TINYINT(1) NOT NULL DEFAULT 1,
    UNIQUE (id_titulo, numero_temporada),
        -- Um título não pode ter duas "Temporada 1".
    FOREIGN KEY (id_titulo) REFERENCES titulo (id_titulo)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


-- ==========================================================
-- GRUPO 3
-- ==========================================================

-- DADOS_COBRANCA: forma de pagamento da conta
-- Relacionamento 1:1 -> o UNIQUE em id_conta garante
-- no máximo UMA cobrança por conta.
CREATE TABLE IF NOT EXISTS dados_cobranca (
    id_cobranca            INT PRIMARY KEY AUTO_INCREMENT,
    id_conta               INT          NOT NULL UNIQUE,
    nome_titular           VARCHAR(100) NOT NULL,
    forma_pagamento        ENUM('Cartao de Credito','Cartao de Debito','Pix','Boleto') NOT NULL,
    ultimos_quatro_digitos CHAR(4),
    dia_vencimento         TINYINT      NOT NULL,
    data_proxima_cobranca  DATE         NOT NULL,
    cobranca_ativa         TINYINT(1)   NOT NULL DEFAULT 1,
    FOREIGN KEY (id_conta) REFERENCES conta (id_conta)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- PERFIL: perfis de uma conta (ex.: Pai, Mãe, Crianças)
-- Relacionamento 1:N -> conta (1) x perfil (N)
CREATE TABLE IF NOT EXISTS perfil (
    id_perfil       INT PRIMARY KEY AUTO_INCREMENT,
    id_conta        INT         NOT NULL,
    nome            VARCHAR(50) NOT NULL,
    avatar          VARCHAR(60) NOT NULL DEFAULT 'padrao',
    data_criacao    DATE        NOT NULL,
    perfil_infantil TINYINT(1)  NOT NULL DEFAULT 0,
    pin             CHAR(4),
    UNIQUE (id_conta, nome),
        -- Uma conta não pode ter dois perfis com o mesmo nome.
    FOREIGN KEY (id_conta) REFERENCES conta (id_conta)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- EPISODIO: episódios de uma temporada
-- Relacionamento 1:N -> temporada (1) x episodio (N)
CREATE TABLE IF NOT EXISTS episodio (
    id_episodio     INT PRIMARY KEY AUTO_INCREMENT,
    id_temporada    INT          NOT NULL,
    numero_episodio TINYINT      NOT NULL,
    titulo_episodio VARCHAR(120) NOT NULL,
    sinopse         TEXT,
    duracao_minutos INT          NOT NULL,
    data_estreia    DATE         NOT NULL,
    disponivel      TINYINT(1)   NOT NULL DEFAULT 1,
    UNIQUE (id_temporada, numero_episodio),
    FOREIGN KEY (id_temporada) REFERENCES temporada (id_temporada)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


-- ==========================================================
-- GRUPO 4
-- ==========================================================

-- CONFIGURACAO_PERFIL: preferências de um perfil
-- Relacionamento 1:1 -> UNIQUE em id_perfil.
CREATE TABLE IF NOT EXISTS configuracao_perfil (
    id_configuracao       INT PRIMARY KEY AUTO_INCREMENT,
    id_perfil             INT         NOT NULL UNIQUE,
    idioma_interface      VARCHAR(20) NOT NULL DEFAULT 'Portugues',
    idioma_legenda        VARCHAR(20) NOT NULL DEFAULT 'Portugues',
    legendas_ativas       TINYINT(1)  NOT NULL DEFAULT 1,
    reproducao_automatica TINYINT(1)  NOT NULL DEFAULT 1,
    qualidade_preferida   ENUM('Automatica','Baixa','Media','Alta') NOT NULL DEFAULT 'Automatica',
    data_atualizacao      DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_perfil) REFERENCES perfil (id_perfil)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- TITULO_CATEGORIA: tabela associativa (N:N titulo x categoria)
-- Um título tem várias categorias e uma categoria tem vários títulos.
CREATE TABLE IF NOT EXISTS titulo_categoria (
    id_titulo_categoria INT PRIMARY KEY AUTO_INCREMENT,
    id_titulo           INT        NOT NULL,
    id_categoria        INT        NOT NULL,
    categoria_principal TINYINT(1) NOT NULL DEFAULT 0,
    ordem_exibicao      TINYINT    NOT NULL DEFAULT 1,
    data_associacao     DATE       NOT NULL,
    UNIQUE (id_titulo, id_categoria),
        -- Não repete a mesma categoria no mesmo título.
    FOREIGN KEY (id_titulo) REFERENCES titulo (id_titulo)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria)
    ON DELETE RESTRICT
        -- Não permite excluir uma categoria que está em uso.
    ON UPDATE CASCADE
);

-- PARTICIPACAO: tabela associativa (N:N pessoa x titulo)
-- Uma pessoa atua/dirige em vários títulos e um título tem várias pessoas.
CREATE TABLE IF NOT EXISTS participacao (
    id_participacao INT PRIMARY KEY AUTO_INCREMENT,
    id_pessoa       INT        NOT NULL,
    id_titulo       INT        NOT NULL,
    funcao          ENUM('Ator','Diretor','Roteirista','Produtor','Dublador') NOT NULL,
    nome_personagem VARCHAR(80),
    papel_principal TINYINT(1) NOT NULL DEFAULT 0,
    ordem_credito   TINYINT    NOT NULL DEFAULT 1,
    UNIQUE (id_pessoa, id_titulo, funcao),
        -- A mesma pessoa pode ser Ator E Diretor do mesmo título,
        -- mas não duas vezes na mesma função.
    FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (id_titulo) REFERENCES titulo (id_titulo)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- HISTORICO_VISUALIZACAO: tabela associativa (N:N perfil x titulo)
-- Registra o que cada perfil assistiu.
CREATE TABLE IF NOT EXISTS historico_visualizacao (
    id_visualizacao          INT PRIMARY KEY AUTO_INCREMENT,
    id_perfil                INT        NOT NULL,
    id_titulo                INT        NOT NULL,
    data_inicio              DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_ultima_visualizacao DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    minuto_parada            INT        NOT NULL DEFAULT 0,
    concluido                TINYINT(1) NOT NULL DEFAULT 0,
    dispositivo              ENUM('TV','Celular','Notebook','Tablet','Console') NOT NULL,
    UNIQUE (id_perfil, id_titulo),
        -- Um registro por perfil e título.
    FOREIGN KEY (id_perfil) REFERENCES perfil (id_perfil)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (id_titulo) REFERENCES titulo (id_titulo)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- ==========================================================
-- PARTE 2 - INSERÇÃO DE DADOS
-- ----------------------------------------------------------
-- Dados fictícios, criados apenas para demonstração
-- (nomes, e-mails e hashes de senha não são reais).
--
-- Cada tabela tem no mínimo 30 comandos INSERT (um por linha).
-- Os ids são informados de propósito, para deixar as chaves
-- estrangeiras fáceis de conferir. Como o banco é recriado do
-- zero no início do script, os ids sempre começam em 1.
--
-- A ordem segue a das tabelas: primeiro as tabelas "mãe",
-- depois as que têm chave estrangeira.
--
-- Os dados foram pensados para que as consultas (JOINs) tenham
-- casos "sem correspondência", como no exemplo da professora:
--   * Planos sem contas: 8 e 9, 11, 13, 15 a 30
--   * Contas sem perfil: 25 a 32
--   * Contas sem dados de cobrança: 5 e 32
--   * Categorias sem títulos: 3, 5, 9 a 11, 14 a 22, 24 a 30
--   * Títulos sem categoria: 26 a 30
--   * Pessoas sem participação: 1, 3 a 5, 10, 12, 16 e 17, 21, 25, 27 a 30
--   * Títulos nunca assistidos: 1, 8 e 9, 11 e 12, 17, 25 a 30
--   * Temporadas sem episódios: 16 a 30
-- ==========================================================

SET NAMES utf8mb4;  -- garante que os acentos sejam gravados corretamente

-- ----------------------------------------------------------
-- PLANO (30)
-- Os planos 1 a 5 são os regulares.
-- Planos sem nenhuma conta (sem correspondência no LEFT JOIN): 8 e 9, 11, 13, 15 a 30.
-- ----------------------------------------------------------
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (1, 'Mobile', 'Assista no celular e no tablet. Plano regular.', 19.90, 'SD', 1, 1, '2019-04-01');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (2, 'Básico', 'Uma tela em HD. Plano regular.', 25.90, 'HD', 1, 1, '2019-06-30');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (3, 'Padrão com Anúncios', 'Duas telas em Full HD, com anúncios. Plano regular.', 18.90, 'Full HD', 2, 0, '2019-09-28');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (4, 'Padrão', 'Duas telas em Full HD, sem anúncios. Plano regular.', 39.90, 'Full HD', 2, 1, '2019-12-27');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (5, 'Premium', 'Quatro telas em 4K, sem anúncios. Plano regular.', 55.90, '4K UHD', 4, 1, '2020-03-26');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (6, 'Mobile Estudante', 'Assista no celular e no tablet. Desconto para estudantes.', 9.95, 'SD', 1, 1, '2020-06-24');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (7, 'Básico Estudante', 'Uma tela em HD. Desconto para estudantes.', 12.95, 'HD', 1, 1, '2020-09-22');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (8, 'Padrão com Anúncios Estudante', 'Duas telas em Full HD, com anúncios. Desconto para estudantes.', 9.45, 'Full HD', 2, 0, '2020-12-21');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (9, 'Padrão Estudante', 'Duas telas em Full HD, sem anúncios. Desconto para estudantes.', 19.95, 'Full HD', 2, 1, '2021-03-21');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (10, 'Premium Estudante', 'Quatro telas em 4K, sem anúncios. Desconto para estudantes.', 27.95, '4K UHD', 4, 1, '2021-06-19');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (11, 'Mobile Família', 'Assista no celular e no tablet. Condição especial para famílias.', 27.86, 'SD', 1, 1, '2021-09-17');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (12, 'Básico Família', 'Uma tela em HD. Condição especial para famílias.', 36.26, 'HD', 1, 1, '2021-12-16');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (13, 'Padrão com Anúncios Família', 'Duas telas em Full HD, com anúncios. Condição especial para famílias.', 26.46, 'Full HD', 2, 0, '2022-03-16');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (14, 'Padrão Família', 'Duas telas em Full HD, sem anúncios. Condição especial para famílias.', 55.86, 'Full HD', 2, 1, '2022-06-14');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (15, 'Premium Família', 'Quatro telas em 4K, sem anúncios. Condição especial para famílias.', 78.26, '4K UHD', 4, 1, '2022-09-12');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (16, 'Mobile Promocional', 'Assista no celular e no tablet. Preço promocional por tempo limitado.', 15.92, 'SD', 1, 1, '2022-12-11');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (17, 'Básico Promocional', 'Uma tela em HD. Preço promocional por tempo limitado.', 20.72, 'HD', 1, 1, '2023-03-11');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (18, 'Padrão com Anúncios Promocional', 'Duas telas em Full HD, com anúncios. Preço promocional por tempo limitado.', 15.12, 'Full HD', 2, 0, '2023-06-09');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (19, 'Padrão Promocional', 'Duas telas em Full HD, sem anúncios. Preço promocional por tempo limitado.', 31.92, 'Full HD', 2, 1, '2023-09-07');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (20, 'Premium Promocional', 'Quatro telas em 4K, sem anúncios. Preço promocional por tempo limitado.', 44.72, '4K UHD', 4, 1, '2023-12-06');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (21, 'Mobile Legado', 'Assista no celular e no tablet. Plano antigo mantido para clientes antigos.', 17.91, 'SD', 1, 1, '2024-03-05');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (22, 'Básico Legado', 'Uma tela em HD. Plano antigo mantido para clientes antigos.', 23.31, 'HD', 1, 1, '2024-06-03');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (23, 'Padrão com Anúncios Legado', 'Duas telas em Full HD, com anúncios. Plano antigo mantido para clientes antigos.', 17.01, 'Full HD', 2, 0, '2024-09-01');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (24, 'Padrão Legado', 'Duas telas em Full HD, sem anúncios. Plano antigo mantido para clientes antigos.', 35.91, 'Full HD', 2, 1, '2024-11-30');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (25, 'Premium Legado', 'Quatro telas em 4K, sem anúncios. Plano antigo mantido para clientes antigos.', 50.31, '4K UHD', 4, 1, '2025-02-28');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (26, 'Mobile Corporativo', 'Assista no celular e no tablet. Plano para empresas.', 31.84, 'SD', 1, 1, '2025-05-29');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (27, 'Básico Corporativo', 'Uma tela em HD. Plano para empresas.', 41.44, 'HD', 1, 1, '2025-08-27');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (28, 'Padrão com Anúncios Corporativo', 'Duas telas em Full HD, com anúncios. Plano para empresas.', 30.24, 'Full HD', 2, 0, '2025-11-25');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (29, 'Padrão Corporativo', 'Duas telas em Full HD, sem anúncios. Plano para empresas.', 63.84, 'Full HD', 2, 1, '2026-02-23');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (30, 'Premium Corporativo', 'Quatro telas em 4K, sem anúncios. Plano para empresas.', 89.44, '4K UHD', 4, 1, '2026-05-24');

-- ----------------------------------------------------------
-- CATEGORIA (30)
-- Categorias sem nenhum título (sem correspondência): 3, 5, 9 a 11, 14 a 22, 24 a 30.
-- As categorias 28 a 30 estão inativas (ativa = 0).
-- ----------------------------------------------------------
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (1, 'Ação', 'Títulos da categoria Ação.', 'ACAO', 1, '2020-01-10');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (2, 'Aventura', 'Títulos da categoria Aventura.', 'AVEN', 1, '2020-01-25');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (3, 'Animação', 'Títulos da categoria Animação.', 'ANIM', 1, '2020-02-09');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (4, 'Comédia', 'Títulos da categoria Comédia.', 'COME', 1, '2020-02-24');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (5, 'Comédia Romântica', 'Títulos da categoria Comédia Romântica.', 'CORO', 1, '2020-03-10');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (6, 'Crime', 'Títulos da categoria Crime.', 'CRIM', 1, '2020-03-25');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (7, 'Documentário', 'Títulos da categoria Documentário.', 'DOCU', 1, '2020-04-09');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (8, 'Drama', 'Títulos da categoria Drama.', 'DRAM', 1, '2020-04-24');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (9, 'Fantasia', 'Títulos da categoria Fantasia.', 'FANT', 1, '2020-05-09');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (10, 'Ficção Científica', 'Títulos da categoria Ficção Científica.', 'FICC', 1, '2020-05-24');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (11, 'Terror', 'Títulos da categoria Terror.', 'TERR', 1, '2020-06-08');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (12, 'Suspense', 'Títulos da categoria Suspense.', 'SUSP', 1, '2020-06-23');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (13, 'Romance', 'Títulos da categoria Romance.', 'ROMA', 1, '2020-07-08');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (14, 'Musical', 'Títulos da categoria Musical.', 'MUSI', 1, '2020-07-23');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (15, 'Família', 'Títulos da categoria Família.', 'FAMI', 1, '2020-08-07');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (16, 'Infantil', 'Títulos da categoria Infantil.', 'INFA', 1, '2020-08-22');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (17, 'Guerra', 'Títulos da categoria Guerra.', 'GUER', 1, '2020-09-06');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (18, 'Biografia', 'Títulos da categoria Biografia.', 'BIOG', 1, '2020-09-21');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (19, 'Esporte', 'Títulos da categoria Esporte.', 'ESPO', 1, '2020-10-06');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (20, 'Mistério', 'Títulos da categoria Mistério.', 'MIST', 1, '2020-10-21');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (21, 'Policial', 'Títulos da categoria Policial.', 'POLI', 1, '2020-11-05');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (22, 'Histórico', 'Títulos da categoria Histórico.', 'HIST', 1, '2020-11-20');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (23, 'Natureza', 'Títulos da categoria Natureza.', 'NATU', 1, '2020-12-05');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (24, 'Culinária', 'Títulos da categoria Culinária.', 'CULI', 1, '2020-12-20');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (25, 'Stand-up', 'Títulos da categoria Stand-up.', 'STAN', 1, '2021-01-04');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (26, 'Adolescente', 'Títulos da categoria Adolescente.', 'ADOL', 1, '2021-01-19');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (27, 'Reality Show', 'Títulos da categoria Reality Show.', 'REAL', 1, '2021-02-03');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (28, 'Anime', 'Títulos da categoria Anime.', 'ANME', 0, '2021-02-18');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (29, 'Religioso', 'Títulos da categoria Religioso.', 'RELI', 0, '2021-03-05');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (30, 'Faroeste', 'Títulos da categoria Faroeste.', 'FARO', 0, '2021-03-20');

-- ----------------------------------------------------------
-- PESSOA (30)
-- Pessoas que não participam de nenhum título (sem correspondência): 1, 3 a 5, 10, 12, 16 e 17, 21, 25, 27 a 30.
-- ----------------------------------------------------------
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (1, 'Diego Duarte', NULL, '1959-03-18', 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (2, 'Tiago Moreira', NULL, '1999-02-23', 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (3, 'Zeca Oliveira', NULL, '1971-07-12', 'Brasileira', 'Zeca Oliveira atua na indústria audiovisual há mais de 8 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (4, 'Diego Ramos', NULL, '1993-12-26', 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (5, 'Gabriela Martins', NULL, NULL, 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (6, 'Mariana Barbosa', NULL, '1958-01-17', 'Brasileira', 'Mariana Barbosa atua na indústria audiovisual há mais de 21 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (7, 'João Santos', 'João Brasil', '1983-02-03', 'Brasileira', 'João Santos atua na indústria audiovisual há mais de 30 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (8, 'Carla Martins', NULL, '1960-06-12', 'Brasileira', 'Carla Martins atua na indústria audiovisual há mais de 34 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (9, 'Isabela Pereira', NULL, NULL, 'Brasileira', 'Isabela Pereira atua na indústria audiovisual há mais de 4 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (10, 'Sofia Prado', NULL, '1996-12-09', 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (11, 'Diego Moreira', NULL, '1970-07-16', 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (12, 'Diego Santos', NULL, '1998-12-14', 'Brasileira', 'Diego Santos atua na indústria audiovisual há mais de 28 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (13, 'Vitor Ramos', NULL, '1992-12-18', 'Brasileira', NULL, 0);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (14, 'Mariana Pereira', 'Mariana Brasil', '1963-06-12', 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (15, 'Tiago Santos', NULL, NULL, 'Brasileira', 'Tiago Santos atua na indústria audiovisual há mais de 15 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (16, 'Isabela Oliveira', NULL, '1994-08-08', 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (17, 'Rafael Lima', NULL, '1958-10-29', 'Brasileira', 'Rafael Lima atua na indústria audiovisual há mais de 35 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (18, 'Isabela Santos', NULL, '1988-03-13', 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (19, 'Pedro Mendes', NULL, NULL, 'Brasileira', 'Pedro Mendes atua na indústria audiovisual há mais de 15 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (20, 'Yasmin Pereira', 'Yasmin Star', '1990-06-25', 'Brasileira', 'Yasmin Pereira atua na indústria audiovisual há mais de 8 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (21, 'Tiago Nunes', 'Tiago Star', '1974-02-03', 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (22, 'Úrsula Ferreira', 'Úrsula Brasil', '2001-07-10', 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (23, 'Pedro Alves', NULL, '1961-10-09', 'Portuguesa', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (24, 'Wesley Barbosa', NULL, '1964-05-13', 'Argentina', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (25, 'Sofia Ramos', NULL, '1963-04-30', 'Americana', 'Sofia Ramos atua na indústria audiovisual há mais de 15 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (26, 'Mariana Souza', NULL, '1956-08-03', 'Mexicana', 'Mariana Souza atua na indústria audiovisual há mais de 25 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (27, 'Zeca Souza', 'Zeca Luz', '1977-03-30', 'Espanhola', 'Zeca Souza atua na indústria audiovisual há mais de 10 anos.', 0);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (28, 'Pedro Santos', NULL, '1963-10-22', 'Britânica', 'Pedro Santos atua na indústria audiovisual há mais de 16 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (29, 'Nicolas Moreira', NULL, '1956-03-27', 'Colombiana', 'Nicolas Moreira atua na indústria audiovisual há mais de 5 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (30, 'Gabriela Costa', 'Gabriela Star', '1966-11-30', 'Francesa', 'Gabriela Costa atua na indústria audiovisual há mais de 4 anos.', 1);

-- ----------------------------------------------------------
-- TITULO (30)
-- Títulos 1 a 10: séries. 11 a 22: filmes. 23 a 26: documentários. 27 a 30: stand-ups.
-- Títulos nunca assistidos (sem correspondência): 1, 8 e 9, 11 e 12, 17, 25 a 30.
-- Séries não têm duração total (duracao_minutos = NULL); a duração fica nos episódios.
-- ----------------------------------------------------------
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (1, 'Sombras da Capital', 'Uma jornalista investiga um esquema de corrupção em Brasília.', 'Serie', 2016, '18', NULL, 'Português', '2024-12-10', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (2, 'O Último Verão', 'Amigos de infância se reencontram numa cidade litorânea.', 'Serie', 2026, '16', NULL, 'Português', '2026-03-12', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (3, 'Código Zero', 'Uma equipe de hackers tenta impedir um ataque global.', 'Serie', 2024, '10', NULL, 'Português', '2026-03-09', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (4, 'Ilha dos Esquecidos', 'Sobreviventes de um naufrágio descobrem uma ilha misteriosa.', 'Serie', 2020, '16', NULL, 'Coreano', '2024-08-23', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (5, 'Herdeiros do Sertão', 'Duas famílias disputam terras no interior do Nordeste.', 'Serie', 2015, '14', NULL, 'Português', '2022-06-02', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (6, 'Linha do Tempo', 'Uma cientista descobre como enviar mensagens ao passado.', 'Serie', 2019, '10', NULL, 'Inglês', '2021-12-15', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (7, 'A Casa Branca', 'Uma família se muda para uma casa com segredos antigos.', 'Serie', 2021, '14', NULL, 'Inglês', '2024-03-24', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (8, 'Noite em Neon', 'Um detetive percorre a vida noturna de uma metrópole.', 'Serie', 2016, '12', NULL, 'Inglês', '2024-10-28', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (9, 'Cidade Submersa', 'Após uma enchente, moradores precisam recomeçar.', 'Serie', 2021, 'L', NULL, 'Coreano', '2024-01-27', 0);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (10, 'Fronteira Sul', 'Policiais enfrentam o crime organizado na divisa do país.', 'Serie', 2015, '10', NULL, 'Português', '2021-08-05', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (11, 'O Mapa de Cinzas', 'Uma caçadora de tesouros segue um mapa deixado pelo avô.', 'Filme', 2015, '14', 127, 'Inglês', '2026-03-29', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (12, 'Entre Duas Marés', 'Um pescador e uma bióloga lutam para salvar uma baía.', 'Filme', 2022, '18', 88, 'Português', '2023-01-09', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (13, 'A Última Missão', 'Um soldado aposentado volta à ativa por uma causa pessoal.', 'Filme', 2016, '12', 158, 'Coreano', '2025-04-20', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (14, 'Café com Fantasmas', 'Um café tem clientes que não são exatamente vivos.', 'Filme', 2022, '10', 164, 'Francês', '2022-08-13', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (15, 'Rumo ao Horizonte', 'Uma viagem de carro muda a vida de uma família.', 'Filme', 2018, '16', 112, 'Espanhol', '2025-05-15', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (16, 'O Segredo do Farol', 'Um faroleiro guarda um segredo há trinta anos.', 'Filme', 2018, '16', 156, 'Português', '2022-01-03', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (17, 'Amor em Lisboa', 'Dois desconhecidos se encontram durante um festival.', 'Filme', 2015, '12', 140, 'Português', '2020-01-30', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (18, 'Operação Aurora', 'Agentes tentam evitar um sequestro internacional.', 'Filme', 2015, '18', 130, 'Francês', '2019-09-05', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (19, 'A Pequena Orquestra', 'Crianças de uma escola pública formam uma orquestra.', 'Filme', 2026, 'L', 149, 'Português', '2026-02-24', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (20, 'Corrida contra o Tempo', 'Uma médica tem poucas horas para entregar um órgão.', 'Filme', 2018, '16', 122, 'Português', '2019-09-19', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (21, 'Voo 902', 'Um piloto precisa pousar em condições extremas.', 'Filme', 2016, '12', 93, 'Português', '2021-11-15', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (22, 'Noite de Estreia', 'Bastidores de uma peça de teatro às vésperas da estreia.', 'Filme', 2020, '12', 86, 'Português', '2024-08-24', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (23, 'Oceanos Profundos', 'As criaturas e os mistérios das fossas oceânicas.', 'Documentario', 2015, '10', 69, 'Português', '2019-04-05', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (24, 'A Vida das Abelhas', 'O papel das abelhas na natureza e na alimentação.', 'Documentario', 2015, '18', 86, 'Coreano', '2025-04-17', 0);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (25, 'Cozinhas do Mundo', 'Chefs mostram receitas tradicionais de vários países.', 'Documentario', 2019, '12', 88, 'Francês', '2024-02-11', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (26, 'História do Futebol', 'Como o esporte conquistou o planeta.', 'Documentario', 2024, '18', 109, 'Inglês', '2024-03-18', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (27, 'Rindo de Mim Mesmo', 'Um humorista fala sobre as próprias trapalhadas.', 'Stand-up', 2019, '14', 69, 'Inglês', '2025-08-30', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (28, 'Piadas de Família', 'Histórias engraçadas sobre almoços de domingo.', 'Stand-up', 2024, '18', 82, 'Espanhol', '2026-02-05', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (29, 'Sem Filtro', 'Humor ácido sobre o dia a dia nas grandes cidades.', 'Stand-up', 2024, '16', 85, 'Coreano', '2025-08-20', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (30, 'O Último Show', 'A despedida de um comediante veterano.', 'Stand-up', 2019, '18', 83, 'Português', '2023-11-24', 1);

-- ----------------------------------------------------------
-- CONTA (32)
-- Senhas são hashes fictícios, apenas ilustrativos.
-- Contas sem perfil: 25 a 32. Contas 7, 16 e 22 estão suspensas; 11 e 24, canceladas.
-- São 32 contas (e não 30) para existirem contas sem dados de cobrança.
-- ----------------------------------------------------------
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (1, 5, 'sofia.alves1@exemplo.com', '$2y$10$a991e84c62a25c5a972f67c47cd81f31063c2dde905a8428977b0', '(61) 98786-7179', 'BR', '2023-05-06 20:42:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (2, 3, 'henrique.alves2@exemplo.com', '$2y$10$02a3e1fc659a693124e09cc25a8b49249e126cbfa0dddf8f45d4d', '(61) 98058-9869', 'BR', '2025-11-01 19:56:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (3, 2, 'isabela.alves3@exemplo.com', '$2y$10$503ae5403efc54b676a4b551f30d9439e42aa4c362e8d21dc37a4', '(61) 98033-5535', 'BR', '2025-01-13 22:26:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (4, 1, 'isabela.duarte4@exemplo.com', '$2y$10$f4f08752af7e13674acd6ec40c91e4eb069e7e0e92cf1af5dc348', '(61) 99283-2465', 'BR', '2026-09-16 12:35:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (5, 4, 'bruno.barbosa5@exemplo.com', '$2y$10$8c55ae6c438eb7bc74c65aa600e4bebc93c61916b9f3eb2977b41', NULL, 'PT', '2023-11-29 17:03:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (6, 2, 'vitor.souza6@exemplo.com', '$2y$10$f1cff19d391ece0c73a5647ecdba9eb87b15c63f7d2b7116bfc77', '(61) 98497-8709', 'BR', '2022-04-30 14:43:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (7, 1, 'quiteria.alves7@exemplo.com', '$2y$10$7c33eef555ebfd3fe805d1e44b058bae852b191939297bffff78f', NULL, 'BR', '2024-03-28 18:50:00', 'Suspensa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (8, 3, 'henrique.cardoso8@exemplo.com', '$2y$10$e842b2b00245276406b4feae75355d1721d92f0269044a58eff81', NULL, 'BR', '2023-12-05 13:23:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (9, 4, 'lucas.santos9@exemplo.com', '$2y$10$b8afb457ed08ad91126d628cafda8f8dfd5d2a0b270fddf3c2553', '(61) 99123-8767', 'BR', '2026-06-04 16:12:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (10, 4, 'felipe.pereira10@exemplo.com', '$2y$10$b8ea280a518d1b835e32564f18846274e2a3ba6fd38d1562647b0', '(61) 99830-1087', 'BR', '2023-12-27 20:50:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (11, 12, 'bruno.costa11@exemplo.com', '$2y$10$922197c7482f2dd40727759f399482b085a3b3ad79c1d61cb6c96', '(61) 98763-9957', 'BR', '2026-02-06 15:08:00', 'Cancelada');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (12, 6, 'wesley.rocha12@exemplo.com', '$2y$10$41d0b37c0667da36948f2822e16ed54692371bb846103968b4bb2', NULL, 'BR', '2022-02-07 13:54:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (13, 1, 'wesley.teixeira13@exemplo.com', '$2y$10$27ad6f0e72ea55c1675a824b48d4558d70d442b37e4d0750fa45c', '(61) 98091-7443', 'BR', '2024-02-19 12:32:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (14, 3, 'diego.mendes14@exemplo.com', '$2y$10$f09ce8610dc3035e35ca718c7c726c55745e70cdef47bcaa0d5b9', '(61) 98797-6465', 'PT', '2025-01-26 15:19:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (15, 3, 'bruno.teixeira15@exemplo.com', '$2y$10$f5b5709027e5e61970411edfd809dd8fddd81049b9d5c5c76e0ca', '(61) 98388-3657', 'BR', '2023-08-23 16:34:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (16, 1, 'joao.ferreira16@exemplo.com', '$2y$10$123a9a40dc88c6079b3b6e7da4ea21383a8b613cde19cbf3cedff', '(61) 98795-4091', 'BR', '2026-03-10 07:54:00', 'Suspensa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (17, 2, 'tiago.oliveira17@exemplo.com', '$2y$10$cc01fd786df85d79703621b3a790cba974e723ca826fb05fb77eb', NULL, 'BR', '2023-12-30 12:46:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (18, 4, 'quiteria.souza18@exemplo.com', '$2y$10$8f842a2a963ef72fdef48cba95ad2136cb87e03e754a9ce2ea0dd', '(61) 99104-3371', 'BR', '2022-12-02 07:56:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (19, 4, 'diego.barbosa19@exemplo.com', '$2y$10$5b2254372b2523e8986c22776dfac4fff8c05c52e80f43dbe41c2', '(61) 99442-1032', 'BR', '2026-09-21 18:04:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (20, 1, 'lucas.ramos20@exemplo.com', '$2y$10$e008472366b06ff86d962f0508480fe71be7353c4a3db727fffdf', '(61) 98315-5065', 'US', '2022-09-17 10:20:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (21, 14, 'pedro.rocha21@exemplo.com', '$2y$10$00bf608f9c22392448839fe055cead3b6080828a0e23e95d4e627', NULL, 'BR', '2026-01-28 09:24:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (22, 10, 'isabela.moreira22@exemplo.com', '$2y$10$d61d04b8f5f09a28f455efd969c5d5eb276f0244dd8c586a00294', '(61) 98240-6698', 'BR', '2024-08-29 22:07:00', 'Suspensa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (23, 3, 'rafael.barbosa23@exemplo.com', '$2y$10$e67545803fb8f380b44b82ed0e7956eea45f5394b62bf28c29dd2', '(61) 98734-8470', 'BR', '2025-04-13 18:05:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (24, 7, 'carla.mendes24@exemplo.com', '$2y$10$539e0ace65086d9e4972ec84f1bef17887b68731c0fd8cdb6504c', NULL, 'BR', '2026-05-13 16:16:00', 'Cancelada');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (25, 1, 'zeca.prado25@exemplo.com', '$2y$10$948ebf753654b62fd699aecc2b41dd4314d8e8387e1448a769497', '(61) 98885-9294', 'BR', '2025-02-24 17:20:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (26, 5, 'yasmin.oliveira26@exemplo.com', '$2y$10$617e99e7702973f0511905516d7c759f8fdf53bfe43ed2d2d0365', '(61) 98361-4219', 'BR', '2026-07-10 21:14:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (27, 5, 'wesley.ferreira27@exemplo.com', '$2y$10$0eabeba7d7156e9b58f601ffe5c6150dacdf800c405fff1c46835', '(61) 98717-7712', 'BR', '2026-08-31 19:13:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (28, 5, 'eduarda.santos28@exemplo.com', '$2y$10$f14fd3be187ef8be5ff4747432d9066fae400078aa4c154c05390', '(61) 99345-3090', 'AR', '2024-06-02 15:21:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (29, 2, 'diego.duarte29@exemplo.com', '$2y$10$251810bee8be997ea26388cdd1f07bd78417d619fe1cb1760ea2e', '(61) 99775-8281', 'BR', '2023-06-24 11:34:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (30, 2, 'ursula.torres30@exemplo.com', '$2y$10$6e44b842580331a004d46410eea0348c3172eadcc144c3d7535e8', '(61) 99991-3350', 'BR', '2025-02-23 10:17:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (31, 4, 'joao.teixeira31@exemplo.com', '$2y$10$63a08d9376745d4086ff0821b18b4b9df7c9f2c8b2f34bc362c7a', '(61) 98821-7544', 'BR', '2022-02-14 17:43:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (32, 4, 'nicolas.duarte32@exemplo.com', '$2y$10$a16063f29bd559e9de012f89811766c96dd58bf17c68fcdf872bb', '(61) 99571-9104', 'BR', '2025-10-20 13:27:00', 'Ativa');

-- ----------------------------------------------------------
-- DADOS_COBRANCA (30)
-- Relacionamento 1:1 com conta. Contas sem dados de cobrança: 5 e 32.
-- Contas suspensas ou canceladas têm cobranca_ativa = 0.
-- ----------------------------------------------------------
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (1, 1, 'Sofia Alves', 'Cartao de Debito', '5414', 2, '2026-12-02', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (2, 2, 'Henrique Alves', 'Pix', NULL, 24, '2026-12-24', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (3, 3, 'Isabela Alves', 'Cartao de Credito', '0172', 9, '2026-12-09', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (4, 4, 'Isabela Duarte', 'Boleto', NULL, 23, '2026-12-23', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (5, 6, 'Vitor Souza', 'Cartao de Debito', '2139', 11, '2026-12-11', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (6, 7, 'Quitéria Alves', 'Boleto', NULL, 21, '2026-12-21', 0);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (7, 8, 'Henrique Cardoso', 'Boleto', NULL, 14, '2026-12-14', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (8, 9, 'Lucas Santos', 'Pix', NULL, 28, '2026-12-28', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (9, 10, 'Felipe Pereira', 'Pix', NULL, 11, '2026-12-11', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (10, 11, 'Bruno Costa', 'Cartao de Credito', '0614', 25, '2026-12-25', 0);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (11, 12, 'Wesley Rocha', 'Cartao de Credito', '1979', 22, '2026-12-22', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (12, 13, 'Wesley Teixeira', 'Cartao de Debito', '5351', 1, '2026-12-01', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (13, 14, 'Diego Mendes', 'Cartao de Credito', '7489', 17, '2026-12-17', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (14, 15, 'Bruno Teixeira', 'Cartao de Debito', '6052', 3, '2026-12-03', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (15, 16, 'João Ferreira', 'Boleto', NULL, 23, '2026-12-23', 0);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (16, 17, 'Tiago Oliveira', 'Cartao de Credito', '8830', 25, '2026-12-25', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (17, 18, 'Quitéria Souza', 'Cartao de Credito', '1566', 5, '2026-12-05', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (18, 19, 'Diego Barbosa', 'Cartao de Debito', '3594', 15, '2026-12-15', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (19, 20, 'Lucas Ramos', 'Cartao de Credito', '9930', 22, '2026-12-22', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (20, 21, 'Pedro Rocha', 'Cartao de Credito', '5069', 3, '2026-12-03', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (21, 22, 'Isabela Moreira', 'Boleto', NULL, 14, '2026-12-14', 0);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (22, 23, 'Rafael Barbosa', 'Boleto', NULL, 22, '2026-12-22', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (23, 24, 'Carla Mendes', 'Boleto', NULL, 18, '2026-12-18', 0);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (24, 25, 'Zeca Prado', 'Cartao de Credito', '1770', 1, '2026-12-01', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (25, 26, 'Yasmin Oliveira', 'Cartao de Debito', '6873', 2, '2026-12-02', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (26, 27, 'Wesley Ferreira', 'Cartao de Credito', '9015', 24, '2026-12-24', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (27, 28, 'Eduarda Santos', 'Boleto', NULL, 8, '2026-12-08', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (28, 29, 'Diego Duarte', 'Pix', NULL, 22, '2026-12-22', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (29, 30, 'Úrsula Torres', 'Cartao de Debito', '5628', 12, '2026-12-12', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (30, 31, 'João Teixeira', 'Cartao de Debito', '9938', 16, '2026-12-16', 1);

-- ----------------------------------------------------------
-- PERFIL (30)
-- As contas 1 a 24 têm perfil; as contas 2, 3, 6, 9 e 12 têm mais de um.
-- O nome do perfil não se repete na mesma conta.
-- ----------------------------------------------------------
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (1, 1, 'Sofia', 'verde', '2023-05-07', 0, '5358');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (2, 2, 'Henrique', 'azul', '2025-11-01', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (3, 2, 'Kids', 'kids', '2025-11-16', 1, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (4, 2, 'Convidado', 'verde', '2025-11-27', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (5, 3, 'Isabela', 'azul', '2025-01-24', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (6, 3, 'Kids', 'kids', '2025-01-21', 1, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (7, 4, 'Isabela', 'vermelho', '2026-09-25', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (8, 5, 'Bruno', 'vermelho', '2023-12-26', 0, '0887');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (9, 6, 'Vitor', 'amarelo', '2022-05-24', 0, '8338');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (10, 6, 'Casal', 'vermelho', '2022-05-19', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (11, 7, 'Quitéria', 'amarelo', '2024-04-16', 0, '8349');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (12, 8, 'Henrique', 'verde', '2023-12-26', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (13, 9, 'Lucas', 'azul', '2026-06-06', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (14, 9, 'Kids', 'kids', '2026-06-21', 1, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (15, 10, 'Felipe', 'azul', '2024-01-20', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (16, 11, 'Bruno', 'amarelo', '2026-03-05', 0, '8650');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (17, 12, 'Wesley', 'padrao', '2022-03-08', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (18, 12, 'Visitante', 'azul', '2022-02-07', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (19, 13, 'Wesley', 'azul', '2024-03-03', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (20, 14, 'Diego', 'amarelo', '2025-01-30', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (21, 15, 'Bruno', 'verde', '2023-09-16', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (22, 16, 'João', 'vermelho', '2026-03-14', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (23, 17, 'Tiago', 'verde', '2024-01-10', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (24, 18, 'Quitéria', 'vermelho', '2022-12-19', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (25, 19, 'Diego', 'amarelo', '2026-09-27', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (26, 20, 'Lucas', 'azul', '2022-10-10', 0, '9032');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (27, 21, 'Pedro', 'padrao', '2026-02-22', 0, '9387');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (28, 22, 'Isabela', 'padrao', '2024-09-06', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (29, 23, 'Rafael', 'azul', '2025-04-17', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (30, 24, 'Carla', 'verde', '2026-05-17', 0, '8852');

-- ----------------------------------------------------------
-- CONFIGURACAO_PERFIL (30)
-- Relacionamento 1:1 com perfil: uma configuração para cada perfil.
-- ----------------------------------------------------------
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (1, 1, 'Ingles', 'Portugues', 0, 1, 'Automatica', '2025-07-10 12:26:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (2, 2, 'Espanhol', 'Espanhol', 1, 0, 'Baixa', '2025-08-15 19:56:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (3, 3, 'Espanhol', 'Portugues', 1, 1, 'Media', '2025-06-08 18:09:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (4, 4, 'Espanhol', 'Portugues', 1, 0, 'Automatica', '2025-04-07 19:37:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (5, 5, 'Portugues', 'Ingles', 0, 0, 'Alta', '2025-07-15 10:27:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (6, 6, 'Ingles', 'Portugues', 0, 0, 'Automatica', '2026-11-09 23:13:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (7, 7, 'Portugues', 'Portugues', 1, 1, 'Media', '2026-04-16 19:45:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (8, 8, 'Portugues', 'Ingles', 1, 1, 'Media', '2026-07-27 23:05:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (9, 9, 'Portugues', 'Portugues', 0, 0, 'Baixa', '2026-09-30 13:07:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (10, 10, 'Portugues', 'Portugues', 1, 1, 'Automatica', '2026-03-15 08:35:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (11, 11, 'Portugues', 'Ingles', 1, 1, 'Baixa', '2026-02-12 08:30:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (12, 12, 'Espanhol', 'Espanhol', 1, 1, 'Media', '2025-05-22 11:50:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (13, 13, 'Portugues', 'Portugues', 1, 1, 'Media', '2026-09-16 09:59:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (14, 14, 'Espanhol', 'Ingles', 1, 1, 'Automatica', '2026-04-18 22:22:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (15, 15, 'Espanhol', 'Portugues', 1, 1, 'Automatica', '2025-03-24 09:04:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (16, 16, 'Espanhol', 'Espanhol', 1, 0, 'Media', '2026-10-23 22:39:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (17, 17, 'Ingles', 'Portugues', 0, 1, 'Automatica', '2025-01-28 11:25:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (18, 18, 'Portugues', 'Portugues', 1, 1, 'Automatica', '2025-02-17 10:48:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (19, 19, 'Espanhol', 'Portugues', 1, 1, 'Automatica', '2025-11-11 23:15:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (20, 20, 'Portugues', 'Espanhol', 1, 0, 'Media', '2025-09-02 18:26:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (21, 21, 'Portugues', 'Espanhol', 0, 1, 'Automatica', '2026-03-26 14:49:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (22, 22, 'Portugues', 'Espanhol', 1, 1, 'Media', '2026-06-27 08:31:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (23, 23, 'Portugues', 'Espanhol', 1, 0, 'Alta', '2026-04-22 12:18:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (24, 24, 'Portugues', 'Ingles', 1, 1, 'Alta', '2025-01-27 19:38:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (25, 25, 'Espanhol', 'Portugues', 1, 0, 'Alta', '2026-01-13 14:37:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (26, 26, 'Portugues', 'Portugues', 1, 1, 'Automatica', '2025-04-19 21:25:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (27, 27, 'Portugues', 'Portugues', 0, 0, 'Baixa', '2025-06-23 16:58:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (28, 28, 'Portugues', 'Portugues', 1, 0, 'Automatica', '2025-08-12 11:57:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (29, 29, 'Ingles', 'Portugues', 1, 1, 'Media', '2026-06-12 09:59:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (30, 30, 'Portugues', 'Espanhol', 0, 1, 'Automatica', '2025-06-22 10:17:00');

-- ----------------------------------------------------------
-- TEMPORADA (30)
-- Somente as séries (títulos 1 a 10) têm temporadas: 3 para cada série.
-- ----------------------------------------------------------
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (1, 1, 1, 'Temporada 1', 2016, '2016-05-20', 'Temporada 1 de Sombras da Capital.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (2, 1, 2, 'Temporada 2', 2017, '2017-08-09', 'Temporada 2 de Sombras da Capital.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (3, 1, 3, 'Temporada 3', 2018, '2018-12-24', 'Temporada 3 de Sombras da Capital.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (4, 2, 1, 'Temporada 1', 2026, '2026-09-21', 'Temporada 1 de O Último Verão.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (5, 2, 2, 'Temporada 2', 2026, '2026-09-08', 'Temporada 2 de O Último Verão.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (6, 2, 3, 'Temporada 3', 2026, '2026-01-18', 'Temporada 3 de O Último Verão.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (7, 3, 1, 'Temporada 1', 2024, '2024-09-13', 'Temporada 1 de Código Zero.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (8, 3, 2, 'Temporada 2', 2025, '2025-04-02', 'Temporada 2 de Código Zero.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (9, 3, 3, 'Temporada 3', 2026, '2026-07-18', 'Temporada 3 de Código Zero.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (10, 4, 1, 'Temporada 1', 2020, '2020-11-20', 'Temporada 1 de Ilha dos Esquecidos.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (11, 4, 2, 'Temporada 2', 2021, '2021-04-06', 'Temporada 2 de Ilha dos Esquecidos.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (12, 4, 3, 'Temporada 3', 2022, '2022-09-25', 'Temporada 3 de Ilha dos Esquecidos.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (13, 5, 1, 'Temporada 1', 2015, '2015-05-21', 'Temporada 1 de Herdeiros do Sertão.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (14, 5, 2, 'Temporada 2', 2016, '2016-08-03', 'Temporada 2 de Herdeiros do Sertão.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (15, 5, 3, 'Temporada 3', 2017, '2017-02-24', 'Temporada 3 de Herdeiros do Sertão.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (16, 6, 1, NULL, 2019, '2019-10-28', 'Temporada 1 de Linha do Tempo.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (17, 6, 2, 'Temporada 2', 2020, '2020-04-27', 'Temporada 2 de Linha do Tempo.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (18, 6, 3, NULL, 2021, '2021-12-05', 'Temporada 3 de Linha do Tempo.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (19, 7, 1, 'Temporada 1', 2021, '2021-06-06', 'Temporada 1 de A Casa Branca.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (20, 7, 2, 'Temporada 2', 2022, '2022-02-05', 'Temporada 2 de A Casa Branca.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (21, 7, 3, 'Temporada 3', 2023, '2023-07-03', 'Temporada 3 de A Casa Branca.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (22, 8, 1, NULL, 2016, '2016-08-21', 'Temporada 1 de Noite em Neon.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (23, 8, 2, 'Temporada 2', 2017, '2017-10-11', 'Temporada 2 de Noite em Neon.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (24, 8, 3, 'Temporada 3', 2018, '2018-06-03', 'Temporada 3 de Noite em Neon.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (25, 9, 1, NULL, 2021, '2021-10-01', 'Temporada 1 de Cidade Submersa.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (26, 9, 2, 'Temporada 2', 2022, '2022-04-04', 'Temporada 2 de Cidade Submersa.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (27, 9, 3, 'Temporada 3', 2023, '2023-04-10', 'Temporada 3 de Cidade Submersa.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (28, 10, 1, 'Temporada 1', 2015, '2015-10-22', 'Temporada 1 de Fronteira Sul.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (29, 10, 2, NULL, 2016, '2016-03-10', 'Temporada 2 de Fronteira Sul.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (30, 10, 3, NULL, 2017, '2017-01-01', 'Temporada 3 de Fronteira Sul.', 1);

-- ----------------------------------------------------------
-- EPISODIO (30)
-- Dois episódios para cada temporada de 1 a 15.
-- Temporadas sem episódios (sem correspondência): 16 a 30.
-- ----------------------------------------------------------
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (1, 1, 1, 'Alianças (1)', 'Episódio 1 da temporada 1.', 61, '2016-05-20', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (2, 1, 2, 'Pontos Cegos (2)', 'Episódio 2 da temporada 1.', 60, '2016-05-27', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (3, 2, 1, 'Recomeço (1)', 'Episódio 1 da temporada 2.', 56, '2017-08-09', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (4, 2, 2, 'Revelações (2)', 'Episódio 2 da temporada 2.', 45, '2017-08-16', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (5, 3, 1, 'O Plano (1)', 'Episódio 1 da temporada 3.', 62, '2018-12-24', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (6, 3, 2, 'Pontos Cegos (2)', 'Episódio 2 da temporada 3.', 57, '2018-12-31', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (7, 4, 1, 'Fuga (1)', 'Episódio 1 da temporada 1.', 59, '2026-09-21', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (8, 4, 2, 'O Plano (2)', 'Episódio 2 da temporada 1.', 41, '2026-09-28', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (9, 5, 1, 'Segredos (1)', 'Episódio 1 da temporada 2.', 42, '2026-09-08', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (10, 5, 2, 'O Começo (2)', 'Episódio 2 da temporada 2.', 57, '2026-09-15', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (11, 6, 1, 'Fuga (1)', 'Episódio 1 da temporada 3.', 47, '2026-01-18', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (12, 6, 2, 'O Preço (2)', 'Episódio 2 da temporada 3.', 51, '2026-01-25', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (13, 7, 1, 'Sombras (1)', 'Episódio 1 da temporada 1.', 38, '2024-09-13', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (14, 7, 2, 'Recomeço (2)', 'Episódio 2 da temporada 1.', 57, '2024-09-20', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (15, 8, 1, 'Ruptura (1)', 'Episódio 1 da temporada 2.', 42, '2025-04-02', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (16, 8, 2, 'A Verdade (2)', 'Episódio 2 da temporada 2.', 58, '2025-04-09', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (17, 9, 1, 'O Começo (1)', 'Episódio 1 da temporada 3.', 52, '2026-07-18', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (18, 9, 2, 'Silêncio (2)', 'Episódio 2 da temporada 3.', 41, '2026-07-25', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (19, 10, 1, 'Revelações (1)', 'Episódio 1 da temporada 1.', 45, '2020-11-20', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (20, 10, 2, 'Alianças (2)', 'Episódio 2 da temporada 1.', 52, '2020-11-27', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (21, 11, 1, 'Segredos (1)', 'Episódio 1 da temporada 2.', 50, '2021-04-06', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (22, 11, 2, 'Sombras (2)', 'Episódio 2 da temporada 2.', 52, '2021-04-13', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (23, 12, 1, 'Recomeço (1)', 'Episódio 1 da temporada 3.', 61, '2022-09-25', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (24, 12, 2, 'Ruptura (2)', 'Episódio 2 da temporada 3.', 46, '2022-10-02', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (25, 13, 1, 'Recomeço (1)', 'Episódio 1 da temporada 1.', 61, '2015-05-21', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (26, 13, 2, 'Clímax (2)', 'Episódio 2 da temporada 1.', 51, '2015-05-28', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (27, 14, 1, 'O Plano (1)', 'Episódio 1 da temporada 2.', 47, '2016-08-03', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (28, 14, 2, 'Alianças (2)', 'Episódio 2 da temporada 2.', 43, '2016-08-10', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (29, 15, 1, 'Revelações (1)', 'Episódio 1 da temporada 3.', 57, '2017-02-24', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (30, 15, 2, 'A Decisão (2)', 'Episódio 2 da temporada 3.', 38, '2017-03-03', 1);

-- ----------------------------------------------------------
-- TITULO_CATEGORIA (30)
-- Relacionamento N:N entre titulo e categoria.
-- Os títulos 1, 2, 3, 11 e 12 têm duas categorias; a primeira é a principal.
-- Títulos sem categoria (sem correspondência): 26 a 30.
-- ----------------------------------------------------------
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (1, 1, 8, 1, 1, '2024-12-10');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (2, 1, 6, 0, 2, '2024-12-10');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (3, 2, 6, 1, 1, '2026-03-12');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (4, 2, 12, 0, 2, '2026-03-12');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (5, 3, 12, 1, 1, '2026-03-09');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (6, 3, 8, 0, 2, '2026-03-09');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (7, 4, 8, 1, 1, '2024-08-23');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (8, 5, 6, 1, 1, '2022-06-02');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (9, 6, 12, 1, 1, '2021-12-15');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (10, 7, 8, 1, 1, '2024-03-24');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (11, 8, 6, 1, 1, '2024-10-28');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (12, 9, 12, 1, 1, '2024-01-27');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (13, 10, 8, 1, 1, '2021-08-05');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (14, 11, 1, 1, 1, '2026-03-29');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (15, 11, 4, 0, 2, '2026-03-29');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (16, 12, 4, 1, 1, '2023-01-09');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (17, 12, 13, 0, 2, '2023-01-09');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (18, 13, 13, 1, 1, '2025-04-20');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (19, 14, 2, 1, 1, '2022-08-13');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (20, 15, 1, 1, 1, '2025-05-15');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (21, 16, 4, 1, 1, '2022-01-03');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (22, 17, 13, 1, 1, '2020-01-30');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (23, 18, 2, 1, 1, '2019-09-05');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (24, 19, 1, 1, 1, '2026-02-24');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (25, 20, 4, 1, 1, '2019-09-19');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (26, 21, 13, 1, 1, '2021-11-15');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (27, 22, 2, 1, 1, '2024-08-24');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (28, 23, 7, 1, 1, '2019-04-05');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (29, 24, 23, 1, 1, '2025-04-17');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (30, 25, 7, 1, 1, '2024-02-11');

-- ----------------------------------------------------------
-- PARTICIPACAO (30)
-- Relacionamento N:N entre pessoa e titulo.
-- No título 1 a mesma pessoa é Diretor e Ator: funções diferentes no mesmo título são permitidas.
-- ----------------------------------------------------------
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (1, 7, 1, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (2, 7, 1, 'Ator', 'Narrador', 1, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (3, 7, 2, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (4, 24, 2, 'Ator', 'Beatriz', 1, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (5, 23, 3, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (6, 26, 3, 'Ator', 'Lívia', 1, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (7, 8, 4, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (8, 24, 4, 'Ator', 'Nina', 1, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (9, 11, 5, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (10, 6, 5, 'Ator', 'Marcos', 1, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (11, 8, 6, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (12, 14, 6, 'Ator', 'Clara', 1, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (13, 20, 7, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (14, 11, 7, 'Ator', 'Nina', 1, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (15, 18, 8, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (16, 13, 8, 'Ator', 'Otávio', 1, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (17, 20, 9, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (18, 18, 9, 'Ator', 'Beatriz', 1, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (19, 18, 10, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (20, 19, 10, 'Ator', 'Lívia', 1, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (21, 23, 11, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (22, 9, 11, 'Ator', 'Rui', 1, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (23, 15, 12, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (24, 8, 12, 'Ator', 'Clara', 1, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (25, 18, 1, 'Roteirista', NULL, 0, 3);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (26, 11, 2, 'Roteirista', NULL, 0, 3);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (27, 2, 3, 'Roteirista', NULL, 0, 3);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (28, 26, 4, 'Roteirista', NULL, 0, 3);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (29, 22, 5, 'Roteirista', NULL, 0, 3);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (30, 7, 6, 'Roteirista', NULL, 0, 3);

-- ----------------------------------------------------------
-- HISTORICO_VISUALIZACAO (30)
-- Relacionamento N:N entre perfil e titulo (um registro por par perfil/título).
-- O minuto_parada nunca passa da duração do título.
-- Perfis que nunca assistiram a nada: 1 a 3, 6, 8, 13, 18, 20, 22 a 24, 26 e 27, 29 e 30.
-- ----------------------------------------------------------
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (1, 10, 6, '2026-10-18 08:55:00', '2026-10-18 11:13:00', 55, 1, 'Notebook');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (2, 21, 16, '2026-08-11 18:32:00', '2026-08-11 23:56:00', 153, 0, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (3, 11, 18, '2026-09-24 05:44:00', '2026-09-24 12:57:00', 130, 1, 'Console');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (4, 21, 18, '2026-11-02 00:01:00', '2026-11-02 05:03:00', 90, 0, 'Celular');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (5, 25, 13, '2026-11-04 17:03:00', '2026-11-04 20:58:00', 158, 1, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (6, 14, 13, '2026-10-06 07:14:00', '2026-10-06 11:33:00', 97, 0, 'Celular');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (7, 28, 24, '2026-08-06 07:18:00', '2026-08-06 09:17:00', 86, 1, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (8, 16, 20, '2026-10-11 15:39:00', '2026-10-11 23:53:00', 21, 0, 'Notebook');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (9, 17, 7, '2026-10-08 02:00:00', '2026-10-08 02:41:00', 7, 0, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (10, 7, 13, '2026-08-23 09:56:00', '2026-08-23 17:54:00', 133, 0, 'Console');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (11, 4, 14, '2026-09-12 18:45:00', '2026-09-13 00:23:00', 164, 1, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (12, 4, 3, '2026-10-02 05:08:00', '2026-10-02 07:52:00', 55, 1, 'Notebook');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (13, 4, 21, '2026-08-20 04:50:00', '2026-08-20 08:15:00', 71, 0, 'Notebook');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (14, 11, 20, '2026-09-02 23:19:00', '2026-09-03 01:36:00', 122, 1, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (15, 5, 15, '2026-10-24 21:07:00', '2026-10-24 22:58:00', 71, 0, 'Notebook');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (16, 25, 5, '2026-08-17 14:18:00', '2026-08-17 14:49:00', 28, 0, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (17, 15, 16, '2026-08-12 04:00:00', '2026-08-12 11:49:00', 156, 1, 'Console');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (18, 4, 2, '2026-10-14 05:03:00', '2026-10-14 08:18:00', 55, 1, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (19, 9, 23, '2026-11-08 05:15:00', '2026-11-08 14:21:00', 69, 1, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (20, 12, 6, '2026-08-02 23:54:00', '2026-08-03 02:29:00', 51, 0, 'Celular');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (21, 9, 14, '2026-08-19 15:06:00', '2026-08-19 19:07:00', 164, 1, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (22, 14, 21, '2026-08-16 01:38:00', '2026-08-16 06:18:00', 93, 1, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (23, 28, 19, '2026-09-26 13:47:00', '2026-09-26 17:56:00', 135, 0, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (24, 17, 14, '2026-09-16 01:37:00', '2026-09-16 02:21:00', 65, 0, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (25, 15, 10, '2026-10-15 06:12:00', '2026-10-15 10:48:00', 55, 1, 'Console');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (26, 19, 15, '2026-08-30 16:04:00', '2026-08-30 22:20:00', 40, 0, 'Celular');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (27, 10, 4, '2026-09-14 22:15:00', '2026-09-14 22:26:00', 39, 0, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (28, 11, 23, '2026-09-27 22:20:00', '2026-09-28 00:35:00', 52, 0, 'Console');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (29, 14, 20, '2026-10-24 01:29:00', '2026-10-24 08:04:00', 48, 0, 'Notebook');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (30, 25, 22, '2026-10-22 10:42:00', '2026-10-22 16:24:00', 46, 0, 'TV');


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
-- Categorias que têm 4 ou mais títulos, da maior para a menor.
-- Tabelas: categoria, titulo_categoria
-- ----------------------------------------------------------
SELECT CA.nome AS categoria, COUNT(*) AS qtd_titulos
FROM categoria CA
INNER JOIN titulo_categoria TC ON TC.id_categoria = CA.id_categoria
GROUP BY CA.id_categoria, CA.nome
HAVING COUNT(*) >= 4
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


-- ==========================================================
-- PARTE 5 - STORED PROCEDURES (scripts adicionais)
-- ----------------------------------------------------------
-- Uma procedure guarda um bloco de comandos no banco para ser
-- executado com CALL.
-- ==========================================================

-- 1) Procedure sem parâmetro - Relatório de contas por plano
DELIMITER //

CREATE PROCEDURE sp_contas_por_plano()
BEGIN

    SELECT P.nome AS plano, COUNT(C.id_conta) AS qtd_contas
    FROM plano P
    LEFT JOIN conta C ON C.id_plano = P.id_plano
    GROUP BY P.id_plano, P.nome
    ORDER BY qtd_contas DESC, P.nome;

END //

DELIMITER ;

-- Execução:
CALL sp_contas_por_plano();

-- 2) Procedure com parâmetro - Buscar títulos por faixa de ano
DELIMITER //

CREATE PROCEDURE sp_titulos_por_ano(IN ano_min SMALLINT, IN ano_max SMALLINT)
BEGIN

    SELECT id_titulo, nome, tipo, ano_lancamento
    FROM titulo
    WHERE ano_lancamento BETWEEN ano_min AND ano_max
    ORDER BY ano_lancamento, nome;

END //

DELIMITER ;

-- Execução:
CALL sp_titulos_por_ano(2020, 2023);

-- 3) Procedure com parâmetro - Alterar o status de uma conta
DELIMITER //

CREATE PROCEDURE sp_alterar_status_conta(IN conta_id INT, IN novo_status VARCHAR(10))
BEGIN

    UPDATE conta
    SET status = novo_status
    WHERE id_conta = conta_id;

END //

DELIMITER ;

-- Execução: a conta 2 é suspensa
CALL sp_alterar_status_conta(2, 'Suspensa');

SELECT id_conta, email, status FROM conta WHERE id_conta = 2;

-- Volta a conta 2 para o estado original
CALL sp_alterar_status_conta(2, 'Ativa');


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


-- ==========================================================
-- PARTE 7 - TRIGGERS
-- ----------------------------------------------------------
-- Estrutura de cada exemplo:
--   1) Comentário explicando a regra e o tipo da trigger
--   2) Criação da trigger
--   3) Comando que faz a trigger ser executada (teste)
--   4) SELECT para conferir o resultado
-- ==========================================================

-- ==========================================================
-- TRIGGER 1
-- Regra:
-- Não permitir registrar visualização com minuto negativo.
-- Se vier um valor negativo, ele é trocado por 0.
--
-- Tipo:
-- BEFORE INSERT
-- ==========================================================
DROP TRIGGER IF EXISTS tg_validar_minuto_parada;

DELIMITER //

CREATE TRIGGER tg_validar_minuto_parada
-- BEFORE executa antes da gravação no banco,
-- permitindo alterar ou validar valores
BEFORE INSERT ON historico_visualizacao
-- Executa para cada registro inserido
FOR EACH ROW
BEGIN

    -- NEW representa o registro que está tentando ser inserido
    IF NEW.minuto_parada < 0 THEN
        -- Altera o valor antes da gravação
        SET NEW.minuto_parada = 0;
    END IF;

END //

DELIMITER ;

-- Comando que dispara a trigger:
-- o perfil 1 começa a assistir ao título 1 com minuto negativo
INSERT INTO historico_visualizacao (id_perfil, id_titulo, minuto_parada, dispositivo)
VALUES (1, 1, -10, 'TV');

-- Conferindo o resultado:
-- o minuto_parada deve aparecer como 0, e não -10
SELECT id_visualizacao, id_perfil, id_titulo, minuto_parada, dispositivo
FROM historico_visualizacao
WHERE id_perfil = 1 AND id_titulo = 1;


-- ==========================================================
-- TRIGGER 2
-- Regra:
-- O dia de vencimento da cobrança vai até o dia 28 (para
-- existir em todos os meses). Se vier um dia maior, ele é
-- trocado por 28.
--
-- Tipo:
-- BEFORE INSERT
-- ==========================================================
DROP TRIGGER IF EXISTS tg_validar_dia_vencimento;

DELIMITER //

CREATE TRIGGER tg_validar_dia_vencimento
BEFORE INSERT ON dados_cobranca
FOR EACH ROW
BEGIN

    IF NEW.dia_vencimento > 28 THEN
        -- Modifica o valor antes de salvar
        SET NEW.dia_vencimento = 28;
    END IF;

END //

DELIMITER ;

-- Comando que dispara a trigger:
-- a conta 5 ainda não tinha cobrança; tentamos o dia 31
INSERT INTO dados_cobranca (id_conta, nome_titular, forma_pagamento, dia_vencimento, data_proxima_cobranca)
VALUES (5, 'Titular de Teste', 'Pix', 31, '2026-12-28');

-- Conferindo o resultado:
-- o dia_vencimento deve aparecer como 28, e não 31
SELECT id_cobranca, id_conta, nome_titular, dia_vencimento
FROM dados_cobranca
WHERE id_conta = 5;


-- ==========================================================
-- TRIGGER 3
-- Regra:
-- O valor mensal de um plano não pode ficar negativo.
-- Se vier um valor negativo, o plano continua com o valor
-- que já tinha.
--
-- Tipo:
-- BEFORE UPDATE
--
-- No UPDATE existem OLD e NEW ao mesmo tempo:
-- OLD é o valor antigo e NEW é o valor novo.
-- ==========================================================
DROP TRIGGER IF EXISTS tg_validar_valor_plano;

DELIMITER //

CREATE TRIGGER tg_validar_valor_plano
BEFORE UPDATE ON plano
-- Executa para cada plano alterado
FOR EACH ROW
BEGIN

    IF NEW.valor_mensal < 0 THEN
        -- Mantém o valor antigo
        SET NEW.valor_mensal = OLD.valor_mensal;
    END IF;

END //

DELIMITER ;

-- Comando que dispara a trigger:
-- tentativa de colocar valor negativo no plano 1
UPDATE plano
SET valor_mensal = -5.00
WHERE id_plano = 1;

-- Conferindo o resultado:
-- o valor_mensal deve continuar 19.90
SELECT id_plano, nome, valor_mensal
FROM plano
WHERE id_plano = 1;


-- ==========================================================
-- PARTE 8 - USUÁRIOS E PERMISSÕES (GRANT E REVOKE)
-- ----------------------------------------------------------
-- Cada usuário tem uma função diferente:
--
-- admin_netflix:  acesso total ao banco
-- analista:       apenas consulta dados (relatórios)
-- atendente:      consulta contas e perfis e altera o status
--                 da conta
-- catalogo:       cadastra e consulta títulos
-- financeiro:     consulta planos e algumas colunas da cobrança
--
-- Observação: senhas de exemplo, apenas para a atividade.
-- ==========================================================

-- Remove os usuários, se já existirem (permite executar o
-- script mais de uma vez)
DROP USER IF EXISTS 'admin_netflix'@'localhost';
DROP USER IF EXISTS 'analista'@'localhost';
DROP USER IF EXISTS 'atendente'@'localhost';
DROP USER IF EXISTS 'catalogo'@'localhost';
DROP USER IF EXISTS 'financeiro'@'localhost';

CREATE USER 'admin_netflix'@'localhost'
IDENTIFIED BY 'Netflix@123';

CREATE USER 'analista'@'localhost'
IDENTIFIED BY 'Netflix@123';

CREATE USER 'atendente'@'localhost'
IDENTIFIED BY 'Netflix@123';

CREATE USER 'catalogo'@'localhost'
IDENTIFIED BY 'Netflix@123';

CREATE USER 'financeiro'@'localhost'
IDENTIFIED BY 'Netflix@123';

-- EXEMPLO 1 - Acesso total ao banco
GRANT ALL PRIVILEGES
ON netflix.*
TO 'admin_netflix'@'localhost';

-- EXEMPLO 2 - Somente consulta no banco inteiro
-- O analista pode visualizar informações, mas não altera nada.
GRANT SELECT
ON netflix.*
TO 'analista'@'localhost';

-- EXEMPLO 3 - Consulta em tabelas específicas
-- O atendente consulta contas e perfis.
GRANT SELECT
ON netflix.conta
TO 'atendente'@'localhost';

GRANT SELECT
ON netflix.perfil
TO 'atendente'@'localhost';

-- EXEMPLO 4 - UPDATE limitado a uma coluna
-- O atendente pode alterar apenas o status da conta
-- (não altera e-mail, senha ou plano).
GRANT UPDATE (status)
ON netflix.conta
TO 'atendente'@'localhost';

-- EXEMPLO 5 - INSERT em uma tabela
-- O setor de catálogo cadastra e consulta títulos.
GRANT INSERT
ON netflix.titulo
TO 'catalogo'@'localhost';

GRANT SELECT
ON netflix.titulo
TO 'catalogo'@'localhost';

-- EXEMPLO 6 - Leitura apenas de algumas colunas
-- O financeiro vê a forma de pagamento e o vencimento,
-- mas não vê os dígitos do cartão.
GRANT SELECT
(
id_cobranca,
id_conta,
forma_pagamento,
dia_vencimento,
data_proxima_cobranca,
cobranca_ativa
)
ON netflix.dados_cobranca
TO 'financeiro'@'localhost';

GRANT SELECT
ON netflix.plano
TO 'financeiro'@'localhost';

-- Conferir permissões dos usuários
SHOW GRANTS FOR 'admin_netflix'@'localhost';
SHOW GRANTS FOR 'analista'@'localhost';
SHOW GRANTS FOR 'atendente'@'localhost';
SHOW GRANTS FOR 'catalogo'@'localhost';
SHOW GRANTS FOR 'financeiro'@'localhost';

-- ----------------------------------------------------------
-- REVOKE - Removendo permissões
-- ----------------------------------------------------------

-- EXEMPLO 7 - Remover uma permissão específica
-- O catálogo não poderá mais inserir títulos,
-- mas continua podendo consultar.
REVOKE INSERT
ON netflix.titulo
FROM 'catalogo'@'localhost';

-- EXEMPLO 8 - Remover acesso a uma coluna específica
-- O atendente deixa de alterar o status da conta.
REVOKE UPDATE (status)
ON netflix.conta
FROM 'atendente'@'localhost';

-- Verificando novamente as permissões
SHOW GRANTS FOR 'catalogo'@'localhost';
SHOW GRANTS FOR 'atendente'@'localhost';


-- ==========================================================
-- PARTE 9 - TRANSAÇÕES (COMMIT, ROLLBACK E SAVEPOINT)
-- ----------------------------------------------------------
-- START TRANSACTION inicia uma transação
-- COMMIT salva definitivamente
-- ROLLBACK desfaz alterações ainda não confirmadas
-- SAVEPOINT permite desfazer apenas uma parte
-- ==========================================================

-- ----------------------------------------------------------
-- Exemplo 1 - COMMIT
-- Cadastro de um novo título junto com a sua categoria.
-- As duas operações devem acontecer juntas.
-- ----------------------------------------------------------
START TRANSACTION;

INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo)
VALUES (31, 'A Estreia da Semana', 'Filme adicionado dentro de uma transação.', 'Filme', 2026, '12', 102, 'Português', '2026-11-16');

INSERT INTO titulo_categoria (id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao)
VALUES (31, 8, 1, 1, '2026-11-16');

-- Visualiza o título antes da confirmação
SELECT id_titulo, nome, tipo FROM titulo WHERE id_titulo = 31;

-- COMMIT confirma a operação
COMMIT;

-- ----------------------------------------------------------
-- Exemplo 2 - ROLLBACK
-- Um reajuste de preço aplicado errado (multiplicou por 10)
-- é desfeito.
-- ----------------------------------------------------------
START TRANSACTION;

UPDATE plano
SET valor_mensal = valor_mensal * 10
WHERE id_plano = 5;

-- Conferindo antes de confirmar: o valor está errado (559.00)
SELECT id_plano, nome, valor_mensal FROM plano WHERE id_plano = 5;

-- ROLLBACK desfaz tudo desde o START TRANSACTION
ROLLBACK;

-- Conferência: o valor voltou para 55.90
SELECT id_plano, nome, valor_mensal FROM plano WHERE id_plano = 5;

-- ----------------------------------------------------------
-- Exemplo 3 - ROLLBACK de uma exclusão
-- A conta 2 é apagada por engano. Por causa do ON DELETE
-- CASCADE, os perfis dela são apagados junto. O ROLLBACK
-- recupera tudo.
-- ----------------------------------------------------------
START TRANSACTION;

DELETE FROM conta
WHERE id_conta = 2;

-- A conta e os perfis sumiram (temporariamente)
SELECT COUNT(*) AS perfis_da_conta_2 FROM perfil WHERE id_conta = 2;

-- Usuário percebeu que apagou a conta errada
ROLLBACK;

-- A conta e os perfis voltam a existir
SELECT COUNT(*) AS perfis_da_conta_2 FROM perfil WHERE id_conta = 2;

-- ----------------------------------------------------------
-- Exemplo 4 - SAVEPOINT
-- Permite desfazer apenas uma parte da transação.
-- ----------------------------------------------------------
START TRANSACTION;

-- Primeira alteração: reajuste de 10% no plano Premium
UPDATE plano
SET valor_mensal = valor_mensal * 1.10
WHERE id_plano = 5;

-- Criando um ponto de retorno
SAVEPOINT ajuste_preco;

-- Segunda alteração: mudança no número de telas
UPDATE plano
SET telas_simultaneas = 1
WHERE id_plano = 5;

-- A alteração de telas estava errada:
-- volta apenas até o SAVEPOINT
ROLLBACK TO ajuste_preco;

-- O reajuste de preço continua mantido
-- A alteração de telas foi desfeita
COMMIT;

-- Conferência: valor reajustado (61.49) e telas = 4
SELECT id_plano, nome, valor_mensal, telas_simultaneas FROM plano WHERE id_plano = 5;
