-- ==========================================================
-- BANCO DE DADOS NETFLIX - ARQUIVO 08 DE 09
-- Critério da atividade: Recursos adicionais do banco
-- Pré-requisito: executar antes os arquivos 01 a 07, nesta ordem.
-- ==========================================================

USE NETFLIX;

-- ==========================================================
-- PARTE 8 - USUÁRIOS E PERMISSÕES (GRANT E REVOKE)
-- ----------------------------------------------------------
-- Cada usuário tem uma função diferente:
-- admin_netflix:  acesso total ao banco
-- analista:       apenas consulta dados (relatórios)
-- atendente:      consulta contas e perfis e altera o status
--                 da conta
-- catalogo:       cadastra e consulta títulos
-- financeiro:     consulta planos e algumas colunas da cobrança
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
GRANT SELECT
ON netflix.*
TO 'analista'@'localhost';

-- EXEMPLO 3 - Consulta em tabelas específicas
GRANT SELECT
ON netflix.conta
TO 'atendente'@'localhost';

GRANT SELECT
ON netflix.perfil
TO 'atendente'@'localhost';

-- EXEMPLO 4 - UPDATE limitado a uma coluna
GRANT UPDATE (status)
ON netflix.conta
TO 'atendente'@'localhost';

-- EXEMPLO 5 - INSERT em uma tabela
GRANT INSERT
ON netflix.titulo
TO 'catalogo'@'localhost';

GRANT SELECT
ON netflix.titulo
TO 'catalogo'@'localhost';

-- EXEMPLO 6 - Leitura apenas de algumas colunas
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
REVOKE INSERT
ON netflix.titulo
FROM 'catalogo'@'localhost';

-- EXEMPLO 8 - Remover acesso a uma coluna específica
REVOKE UPDATE (status)
ON netflix.conta
FROM 'atendente'@'localhost';

-- Verificando novamente as permissões
SHOW GRANTS FOR 'catalogo'@'localhost';
SHOW GRANTS FOR 'atendente'@'localhost';
