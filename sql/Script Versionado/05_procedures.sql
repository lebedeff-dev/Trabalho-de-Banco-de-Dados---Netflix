-- ==========================================================
-- BANCO DE DADOS NETFLIX - ARQUIVO 05 DE 09
-- Critério da atividade: Scripts adicionais e índices
-- Pré-requisito: executar antes os arquivos 01 a 04, nesta ordem.
-- ==========================================================

USE NETFLIX;

-- ==========================================================
-- PARTE 5 - STORED PROCEDURES (scripts adicionais)
-- ----------------------------------------------------------
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
