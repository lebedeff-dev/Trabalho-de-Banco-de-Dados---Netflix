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
-- Conteúdo deste arquivo, em ordem:
--   PARTE 1 - Estrutura (banco e tabelas)
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
