-- ==========================================================
-- BANCO DE DADOS NETFLIX - ARQUIVO 07 DE 09
-- Critério da atividade: Recursos adicionais do banco
-- Pré-requisito: executar antes os arquivos 01 a 06, nesta ordem.
-- ==========================================================

USE NETFLIX;

-- ==========================================================
-- PARTE 7 - TRIGGERS
-- ----------------------------------------------------------
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
BEFORE INSERT ON historico_visualizacao
FOR EACH ROW
BEGIN
    IF NEW.minuto_parada < 0 THEN
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
-- ==========================================================
DROP TRIGGER IF EXISTS tg_validar_valor_plano;

DELIMITER //
CREATE TRIGGER tg_validar_valor_plano
BEFORE UPDATE ON plano
FOR EACH ROW
BEGIN
    IF NEW.valor_mensal < 0 THEN
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
