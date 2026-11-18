-- ==========================================================
-- BANCO DE DADOS NETFLIX - ARQUIVO 04 DE 06
-- Seção do template da atividade: 4. Scripts adicionais (comentados)
-- Pré-requisito: executar antes os arquivos 01 a 03, nesta ordem.
-- ==========================================================

USE NETFLIX;

-- ==========================================================
-- 4. SCRIPTS ADICIONAIS (comentados)
-- ----------------------------------------------------------
-- Exemplos de domínio técnico. Estão comentados para não
-- alterar o banco; para demonstrar, tire o "-- " do comando.
-- ==========================================================

-- Exclusão do banco de dados
-- DROP DATABASE NETFLIX;

-- Exclusão de uma tabela
-- DROP TABLE configuracao_perfil;

-- Exclusão de uma coluna de uma tabela
-- ALTER TABLE pessoa DROP COLUMN biografia;

-- Adição de uma nova coluna (não prevista na modelagem inicial)
-- ALTER TABLE pessoa ADD COLUMN email_contato VARCHAR(120);

-- Edição de um registro específico
-- UPDATE conta SET telefone = '(61) 99999-0000' WHERE id_conta = 1;

-- Exclusão de um registro específico
-- DELETE FROM participacao WHERE id_participacao = 30;
