-- ==========================================================
-- BANCO DE DADOS NETFLIX - ARQUIVO 01 DE 06
-- Seção do template da atividade: 1. Criação do banco de dados e estrutura
-- Primeiro arquivo: apaga e recria o banco.
-- ==========================================================

-- ==========================================================
-- 1. CRIAÇÃO DO BANCO DE DADOS E ESTRUTURA
-- ==========================================================

DROP DATABASE IF EXISTS NETFLIX;

CREATE DATABASE IF NOT EXISTS NETFLIX
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_unicode_ci;

USE NETFLIX;


-- ==========================================================
-- GRUPO 1 - TABELAS SEM CHAVE ESTRANGEIRA
-- ==========================================================

-- PLANO: planos de assinatura
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

-- CATEGORIA: gêneros do catálogo
CREATE TABLE IF NOT EXISTS categoria (
    id_categoria    INT PRIMARY KEY AUTO_INCREMENT,
    nome            VARCHAR(50) NOT NULL UNIQUE,
    descricao       TEXT,
    codigo_interno  CHAR(4)     NOT NULL UNIQUE,
    ativa           TINYINT(1)  NOT NULL DEFAULT 1,
    data_criacao    DATE        NOT NULL
);

-- PESSOA: atores, diretores e roteiristas
CREATE TABLE IF NOT EXISTS pessoa (
    id_pessoa       INT PRIMARY KEY AUTO_INCREMENT,
    nome            VARCHAR(100) NOT NULL,
    nome_artistico  VARCHAR(100),
    data_nascimento DATE,
    nacionalidade   VARCHAR(50)  NOT NULL,
    biografia       TEXT,
    em_atividade    TINYINT(1)   NOT NULL DEFAULT 1
);

-- TITULO: filmes, séries, documentários e stand-ups
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

-- CONTA: conta de assinatura, com um plano
-- 1:N com plano
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
    ON UPDATE CASCADE
);

-- TEMPORADA: temporadas de uma série
-- 1:N com titulo
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
    FOREIGN KEY (id_titulo) REFERENCES titulo (id_titulo)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


-- ==========================================================
-- GRUPO 3
-- ==========================================================

-- DADOS_COBRANCA: forma de pagamento da conta
-- 1:1 com conta (UNIQUE em id_conta)
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

-- PERFIL: perfis de uma conta
-- 1:N com conta
CREATE TABLE IF NOT EXISTS perfil (
    id_perfil       INT PRIMARY KEY AUTO_INCREMENT,
    id_conta        INT         NOT NULL,
    nome            VARCHAR(50) NOT NULL,
    avatar          VARCHAR(60) NOT NULL DEFAULT 'padrao',
    data_criacao    DATE        NOT NULL,
    perfil_infantil TINYINT(1)  NOT NULL DEFAULT 0,
    pin             CHAR(4),
    UNIQUE (id_conta, nome),
    FOREIGN KEY (id_conta) REFERENCES conta (id_conta)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- EPISODIO: episódios de uma temporada
-- 1:N com temporada
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
-- 1:1 com perfil (UNIQUE em id_perfil)
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
CREATE TABLE IF NOT EXISTS titulo_categoria (
    id_titulo_categoria INT PRIMARY KEY AUTO_INCREMENT,
    id_titulo           INT        NOT NULL,
    id_categoria        INT        NOT NULL,
    categoria_principal TINYINT(1) NOT NULL DEFAULT 0,
    ordem_exibicao      TINYINT    NOT NULL DEFAULT 1,
    data_associacao     DATE       NOT NULL,
    UNIQUE (id_titulo, id_categoria),
    FOREIGN KEY (id_titulo) REFERENCES titulo (id_titulo)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- PARTICIPACAO: tabela associativa (N:N pessoa x titulo)
CREATE TABLE IF NOT EXISTS participacao (
    id_participacao INT PRIMARY KEY AUTO_INCREMENT,
    id_pessoa       INT        NOT NULL,
    id_titulo       INT        NOT NULL,
    funcao          ENUM('Ator','Diretor','Roteirista','Produtor','Dublador') NOT NULL,
    nome_personagem VARCHAR(80),
    papel_principal TINYINT(1) NOT NULL DEFAULT 0,
    ordem_credito   TINYINT    NOT NULL DEFAULT 1,
    UNIQUE (id_pessoa, id_titulo, funcao),
    FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (id_titulo) REFERENCES titulo (id_titulo)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- HISTORICO_VISUALIZACAO: tabela associativa (N:N perfil x titulo)
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
    FOREIGN KEY (id_perfil) REFERENCES perfil (id_perfil)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (id_titulo) REFERENCES titulo (id_titulo)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
