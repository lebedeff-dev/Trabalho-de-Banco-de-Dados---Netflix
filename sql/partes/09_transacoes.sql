-- ==========================================================
-- BANCO DE DADOS NETFLIX - ARQUIVO 09 DE 09
-- Transações (COMMIT, ROLLBACK e SAVEPOINT)
-- Critério da atividade: Recursos adicionais do banco
--
-- Pré-requisito: executar antes os arquivos 01 a 08, nesta ordem.
-- Este arquivo é a PARTE 9 do script completo (sql/netflix_bd.sql),
-- separada para facilitar a leitura e a apresentação.
-- ==========================================================

USE NETFLIX;

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
VALUES (41, 'A Estreia da Semana', 'Filme adicionado dentro de uma transação.', 'Filme', 2026, '12', 102, 'Português', '2026-11-16');

INSERT INTO titulo_categoria (id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao)
VALUES (41, 8, 1, 1, '2026-11-16');

-- Visualiza o título antes da confirmação
SELECT id_titulo, nome, tipo FROM titulo WHERE id_titulo = 41;

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
