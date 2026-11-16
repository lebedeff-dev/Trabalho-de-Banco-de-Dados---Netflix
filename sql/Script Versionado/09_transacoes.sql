-- ==========================================================
-- BANCO DE DADOS NETFLIX - ARQUIVO 09 DE 09
-- Critério da atividade: Recursos adicionais do banco
-- Pré-requisito: executar antes os arquivos 01 a 08, nesta ordem.
-- ==========================================================

USE NETFLIX;

-- ==========================================================
-- PARTE 9 - TRANSAÇÕES (COMMIT, ROLLBACK E SAVEPOINT)
-- ----------------------------------------------------------
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

SELECT id_titulo, nome, tipo FROM titulo WHERE id_titulo = 31;

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

SELECT COUNT(*) AS perfis_da_conta_2 FROM perfil WHERE id_conta = 2;

ROLLBACK;

SELECT COUNT(*) AS perfis_da_conta_2 FROM perfil WHERE id_conta = 2;

-- ----------------------------------------------------------
-- Exemplo 4 - SAVEPOINT
-- Permite desfazer apenas uma parte da transação.
-- ----------------------------------------------------------
START TRANSACTION;

UPDATE plano
SET valor_mensal = valor_mensal * 1.10
WHERE id_plano = 5;

SAVEPOINT ajuste_preco;

UPDATE plano
SET telas_simultaneas = 1
WHERE id_plano = 5;

ROLLBACK TO ajuste_preco;

COMMIT;

-- Conferência: valor reajustado (61.49) e telas = 4
SELECT id_plano, nome, valor_mensal, telas_simultaneas FROM plano WHERE id_plano = 5;
