-- ==========================================================
-- BANCO DE DADOS NETFLIX - ARQUIVO 06 DE 06
-- Seção do template da atividade: 6. Recursos adicionais (views, triggers, usuários, COMMIT e ROLLBACK)
-- Pré-requisito: executar antes os arquivos 01 a 05, nesta ordem.
-- ==========================================================

USE NETFLIX;

-- ==========================================================
-- 6. RECURSOS ADICIONAIS
-- ==========================================================

-- ----------------------------------------------------------
-- VIEWS
-- ----------------------------------------------------------

-- VIEW 1 - Contas ativas com o plano
CREATE VIEW vw_contas_ativas AS
SELECT C.id_conta, C.email, C.pais, C.data_cadastro,
       P.nome AS plano, P.valor_mensal, P.qualidade_maxima
FROM conta C
INNER JOIN plano P ON P.id_plano = C.id_plano
WHERE C.status = 'Ativa';

SELECT * FROM vw_contas_ativas ORDER BY email;

-- VIEW 2 - Catálogo com a categoria principal
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

-- ----------------------------------------------------------
-- TRIGGERS
-- ----------------------------------------------------------

-- ==========================================================
-- TRIGGER 1
-- Regra:
-- Antes de registrar que um perfil começou a assistir a um
-- título, validar:
--   a) a conta do perfil precisa estar ATIVA;
--   b) perfil infantil só pode assistir a títulos com
--      classificação L ou 10;
--   c) minuto de parada negativo é trocado por 0.
-- As regras (a) e (b) RECUSAM o registro (SIGNAL); a regra (c)
-- corrige o valor e deixa gravar.
--
-- Tipo:
-- BEFORE INSERT
-- ==========================================================
DROP TRIGGER IF EXISTS tg_validar_visualizacao;

DELIMITER //
CREATE TRIGGER tg_validar_visualizacao
BEFORE INSERT ON historico_visualizacao
FOR EACH ROW
BEGIN
    DECLARE v_status        VARCHAR(10);
    DECLARE v_infantil      TINYINT;
    DECLARE v_classificacao VARCHAR(2);

    -- Dados do perfil e da conta dele
    SELECT C.status, PF.perfil_infantil
    INTO v_status, v_infantil
    FROM perfil PF
    INNER JOIN conta C ON C.id_conta = PF.id_conta
    WHERE PF.id_perfil = NEW.id_perfil;

    -- Classificação do título
    SELECT classificacao_indicativa
    INTO v_classificacao
    FROM titulo
    WHERE id_titulo = NEW.id_titulo;

    -- a) conta precisa estar ativa
    IF v_status <> 'Ativa' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Conta suspensa ou cancelada nao pode assistir a titulos.';
    END IF;

    -- b) perfil infantil: apenas L ou 10
    IF v_infantil = 1 AND v_classificacao NOT IN ('L', '10') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Perfil infantil nao pode assistir a este titulo (classificacao indicativa).';
    END IF;

    -- c) minuto negativo vira 0
    IF NEW.minuto_parada < 0 THEN
        SET NEW.minuto_parada = 0;
    END IF;
END //
DELIMITER ;

-- Caso permitido: o perfil infantil 3 assiste ao título 9
-- (classificação L), informando minuto negativo por engano
INSERT INTO historico_visualizacao (id_perfil, id_titulo, minuto_parada, dispositivo)
VALUES (3, 9, -10, 'TV');

-- Conferindo: o minuto_parada deve aparecer como 0, e não -10
SELECT id_visualizacao, id_perfil, id_titulo, minuto_parada
FROM historico_visualizacao
WHERE id_perfil = 3 AND id_titulo = 9;

-- Caso bloqueado (b): o perfil infantil 3 tenta assistir ao título 1
-- (classificação 18). Gera erro de propósito; tire o "-- " para testar.
-- INSERT INTO historico_visualizacao (id_perfil, id_titulo, dispositivo)
-- VALUES (3, 1, 'TV');
-- Resultado esperado: Error Code 1644. Perfil infantil nao pode assistir...

-- Caso bloqueado (a): o perfil 11 pertence a uma conta SUSPENSA.
-- Gera erro de propósito; tire o "-- " para testar.
-- INSERT INTO historico_visualizacao (id_perfil, id_titulo, dispositivo)
-- VALUES (11, 9, 'TV');
-- Resultado esperado: Error Code 1644. Conta suspensa ou cancelada...

-- ==========================================================
-- TRIGGER 2
-- Regra:
-- Quando o status de uma conta muda, a cobrança dela acompanha:
-- conta Suspensa ou Cancelada -> cobranca_ativa = 0;
-- conta Ativa novamente       -> cobranca_ativa = 1.
-- Se o status não mudou (por exemplo, só o telefone foi
-- alterado), nada é feito.
--
-- Tipo:
-- AFTER UPDATE
--
-- A trigger é disparada pela tabela conta e altera outra tabela
-- (dados_cobranca).
-- ==========================================================
DROP TRIGGER IF EXISTS tg_sincronizar_cobranca;

DELIMITER //
CREATE TRIGGER tg_sincronizar_cobranca
AFTER UPDATE ON conta
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        UPDATE dados_cobranca
        SET cobranca_ativa = IF(NEW.status = 'Ativa', 1, 0)
        WHERE id_conta = NEW.id_conta;
    END IF;
END //
DELIMITER ;

-- Antes: a cobrança da conta 2 está ativa
SELECT id_conta, nome_titular, cobranca_ativa
FROM dados_cobranca
WHERE id_conta = 2;

-- Comando que dispara a trigger: a conta 2 é suspensa
UPDATE conta
SET status = 'Suspensa'
WHERE id_conta = 2;

-- Conferindo: cobranca_ativa deve aparecer como 0
SELECT id_conta, nome_titular, cobranca_ativa
FROM dados_cobranca
WHERE id_conta = 2;

-- A conta 2 volta a ficar ativa e a cobrança é reativada
UPDATE conta
SET status = 'Ativa'
WHERE id_conta = 2;

-- Conferindo: cobranca_ativa deve voltar a 1
SELECT id_conta, nome_titular, cobranca_ativa
FROM dados_cobranca
WHERE id_conta = 2;

-- ----------------------------------------------------------
-- USUÁRIOS E PERMISSÕES
-- ----------------------------------------------------------
-- admin_netflix: acesso total ao banco
-- analista:      apenas consulta dados (relatórios)
-- atendente:     consulta contas e perfis e altera o status da conta
-- Observação: senhas de exemplo, apenas para a atividade.

-- Remove os usuários, se já existirem (permite executar o
-- script mais de uma vez)
DROP USER IF EXISTS 'admin_netflix'@'localhost';
DROP USER IF EXISTS 'analista'@'localhost';
DROP USER IF EXISTS 'atendente'@'localhost';

-- Criação de três usuários
CREATE USER 'admin_netflix'@'localhost' IDENTIFIED BY 'Netflix@123';
CREATE USER 'analista'@'localhost'      IDENTIFIED BY 'Netflix@123';
CREATE USER 'atendente'@'localhost'     IDENTIFIED BY 'Netflix@123';

-- Permissões distintas
GRANT ALL PRIVILEGES ON netflix.* TO 'admin_netflix'@'localhost';

GRANT SELECT ON netflix.* TO 'analista'@'localhost';

GRANT SELECT ON netflix.conta  TO 'atendente'@'localhost';
GRANT SELECT ON netflix.perfil TO 'atendente'@'localhost';
GRANT UPDATE (status) ON netflix.conta TO 'atendente'@'localhost';

-- Conferir permissões
SHOW GRANTS FOR 'admin_netflix'@'localhost';
SHOW GRANTS FOR 'analista'@'localhost';
SHOW GRANTS FOR 'atendente'@'localhost';

-- Exclusão de um dos usuários criados
DROP USER 'analista'@'localhost';

-- Revogação de privilégios de dois usuários
-- admin_netflix deixa de poder apagar dados e objetos
REVOKE DELETE, DROP ON netflix.* FROM 'admin_netflix'@'localhost';

-- atendente deixa de poder alterar o status da conta
REVOKE UPDATE (status) ON netflix.conta FROM 'atendente'@'localhost';

-- Conferindo novamente
SHOW GRANTS FOR 'admin_netflix'@'localhost';
SHOW GRANTS FOR 'atendente'@'localhost';

-- ----------------------------------------------------------
-- TRANSAÇÕES
-- ----------------------------------------------------------

-- Exemplo de COMMIT
-- Cadastro de um novo título junto com a sua categoria.
-- As duas operações devem acontecer juntas.
START TRANSACTION;

INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo)
VALUES (31, 'A Estreia da Semana', 'Filme adicionado dentro de uma transação.', 'Filme', 2026, '12', 102, 'Português', '2026-11-16');

INSERT INTO titulo_categoria (id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao)
VALUES (31, 8, 1, 1, '2026-11-16');

COMMIT;

-- Conferência: o título 31 foi gravado
SELECT id_titulo, nome, tipo FROM titulo WHERE id_titulo = 31;

-- Exemplo de ROLLBACK
-- Um reajuste de preço aplicado errado (multiplicou por 10)
-- é desfeito.
START TRANSACTION;

UPDATE plano
SET valor_mensal = valor_mensal * 10
WHERE id_plano = 5;

-- Antes de confirmar: o valor está errado (559.00)
SELECT id_plano, nome, valor_mensal FROM plano WHERE id_plano = 5;

ROLLBACK;

-- Conferência: o valor voltou para 55.90
SELECT id_plano, nome, valor_mensal FROM plano WHERE id_plano = 5;
