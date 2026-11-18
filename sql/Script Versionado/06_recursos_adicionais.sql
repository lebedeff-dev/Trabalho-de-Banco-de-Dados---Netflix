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
-- TRIGGER 1 - renovação da assinatura
-- Regra:
-- Renovar é avançar data_proxima_cobranca. Antes de gravar a data
-- nova, a trigger confere:
--   a) a conta está ativa;
--   b) a data nova é posterior à atual;
--   c) a data nova cai no dia de vencimento (dia_vencimento).
-- Se alguma falhar, a renovação é recusada com SIGNAL.
--
-- Tipo:
-- BEFORE UPDATE
-- ==========================================================
DROP TRIGGER IF EXISTS tg_validar_renovacao;

DELIMITER //
CREATE TRIGGER tg_validar_renovacao
BEFORE UPDATE ON dados_cobranca
FOR EACH ROW
BEGIN
    DECLARE v_status   VARCHAR(10);
    DECLARE v_mensagem VARCHAR(200);

    -- Só valida se a data mudou
    IF NEW.data_proxima_cobranca <> OLD.data_proxima_cobranca THEN

        -- Status da conta dessa cobrança
        SELECT status INTO v_status
        FROM conta
        WHERE id_conta = NEW.id_conta;

        -- a) conta ativa
        IF v_status <> 'Ativa' THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Conta suspensa ou cancelada nao pode renovar a assinatura.';
        END IF;

        -- b) a data só avança
        IF NEW.data_proxima_cobranca <= OLD.data_proxima_cobranca THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'A nova data de cobranca deve ser posterior a data atual.';
        END IF;

        -- c) data no dia de vencimento
        IF DAY(NEW.data_proxima_cobranca) <> NEW.dia_vencimento THEN
            SET v_mensagem = CONCAT('A cobranca deve cair no dia de vencimento: dia ',
                                    NEW.dia_vencimento, '.');
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = v_mensagem;
        END IF;
    END IF;
END //
DELIMITER ;

-- Antes: conta 2 (ativa) com próxima cobrança em 24/12/2026
SELECT id_conta, nome_titular, dia_vencimento, data_proxima_cobranca
FROM dados_cobranca
WHERE id_conta = 2;

-- Renovação válida: conta 2 para 24/01/2027
UPDATE dados_cobranca
SET data_proxima_cobranca = '2027-01-24'
WHERE id_conta = 2;

-- Depois: data_proxima_cobranca = 2027-01-24
SELECT id_conta, nome_titular, dia_vencimento, data_proxima_cobranca
FROM dados_cobranca
WHERE id_conta = 2;

-- Casos bloqueados (dão erro de propósito; tire o "-- " para testar).

-- (a) conta 7 suspensa
-- UPDATE dados_cobranca SET data_proxima_cobranca = '2027-01-21' WHERE id_conta = 7;
-- Esperado: erro 1644, conta suspensa ou cancelada.

-- (b) data anterior à atual
-- UPDATE dados_cobranca SET data_proxima_cobranca = '2026-11-24' WHERE id_conta = 2;
-- Esperado: erro 1644, data nova deve ser posterior à atual.

-- (c) fora do dia de vencimento (dia 24)
-- UPDATE dados_cobranca SET data_proxima_cobranca = '2027-02-10' WHERE id_conta = 2;
-- Esperado: erro 1644, cobrança deve cair no dia 24.

-- ==========================================================
-- TRIGGER 2 - disponibilidade do título
-- Regra:
-- Quando o campo disponivel de um título muda, as temporadas e os
-- episódios dele recebem o mesmo valor. Se mudar só o nome, nada
-- acontece.
--
-- Tipo:
-- AFTER UPDATE (dispara em titulo e altera temporada e episodio)
-- ==========================================================
DROP TRIGGER IF EXISTS tg_propagar_disponibilidade;

DELIMITER //
CREATE TRIGGER tg_propagar_disponibilidade
AFTER UPDATE ON titulo
FOR EACH ROW
BEGIN
    IF OLD.disponivel <> NEW.disponivel THEN

        -- Temporadas do título
        UPDATE temporada
        SET disponivel = NEW.disponivel
        WHERE id_titulo = NEW.id_titulo;

        -- Episódios dessas temporadas
        UPDATE episodio
        SET disponivel = NEW.disponivel
        WHERE id_temporada IN (SELECT id_temporada
                               FROM temporada
                               WHERE id_titulo = NEW.id_titulo);
    END IF;
END //
DELIMITER ;

-- Antes: série 1 (Sombras da Capital), 3 temporadas e 6 episódios,
-- tudo disponível
SELECT T.nome, T.disponivel AS titulo, TE.numero_temporada,
       TE.disponivel AS temporada,
       COUNT(E.id_episodio) AS episodios,
       SUM(E.disponivel)    AS episodios_disponiveis
FROM titulo T
INNER JOIN temporada TE ON TE.id_titulo    = T.id_titulo
INNER JOIN episodio  E  ON E.id_temporada  = TE.id_temporada
WHERE T.id_titulo = 1
GROUP BY T.nome, T.disponivel, TE.numero_temporada, TE.disponivel
ORDER BY TE.numero_temporada;

-- Dispara a trigger: a série 1 sai do catálogo
UPDATE titulo
SET disponivel = 0
WHERE id_titulo = 1;

-- Depois: título, temporadas e episódios em 0
SELECT T.nome, T.disponivel AS titulo, TE.numero_temporada,
       TE.disponivel AS temporada,
       COUNT(E.id_episodio) AS episodios,
       SUM(E.disponivel)    AS episodios_disponiveis
FROM titulo T
INNER JOIN temporada TE ON TE.id_titulo    = T.id_titulo
INNER JOIN episodio  E  ON E.id_temporada  = TE.id_temporada
WHERE T.id_titulo = 1
GROUP BY T.nome, T.disponivel, TE.numero_temporada, TE.disponivel
ORDER BY TE.numero_temporada;

-- A série 1 volta ao catálogo
UPDATE titulo
SET disponivel = 1
WHERE id_titulo = 1;

-- Depois: tudo em 1
SELECT T.nome, T.disponivel AS titulo, TE.numero_temporada,
       TE.disponivel AS temporada,
       COUNT(E.id_episodio) AS episodios,
       SUM(E.disponivel)    AS episodios_disponiveis
FROM titulo T
INNER JOIN temporada TE ON TE.id_titulo    = T.id_titulo
INNER JOIN episodio  E  ON E.id_temporada  = TE.id_temporada
WHERE T.id_titulo = 1
GROUP BY T.nome, T.disponivel, TE.numero_temporada, TE.disponivel
ORDER BY TE.numero_temporada;

-- ----------------------------------------------------------
-- USUÁRIOS E PERMISSÕES
-- ----------------------------------------------------------
-- admin_netflix: acesso total ao banco
-- analista:      só consulta
-- atendente:     consulta conta e perfil e altera o status da conta
-- As senhas são de exemplo, só para a atividade.

-- Remove os usuários se já existirem (o script pode rodar mais
-- de uma vez)
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

-- Exclusão de um usuário
DROP USER 'analista'@'localhost';

-- Revogação de privilégios de dois usuários
-- admin_netflix perde DELETE e DROP
REVOKE DELETE, DROP ON netflix.* FROM 'admin_netflix'@'localhost';

-- atendente perde o UPDATE em status
REVOKE UPDATE (status) ON netflix.conta FROM 'atendente'@'localhost';

-- Permissões depois do REVOKE
SHOW GRANTS FOR 'admin_netflix'@'localhost';
SHOW GRANTS FOR 'atendente'@'localhost';

-- ----------------------------------------------------------
-- TRANSAÇÕES
-- ----------------------------------------------------------

-- Exemplo de COMMIT
-- Título novo e a categoria dele, gravados na mesma transação.
START TRANSACTION;

INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo)
VALUES (31, 'A Estreia da Semana', 'Filme adicionado dentro de uma transação.', 'Filme', 2026, '12', 102, 'Português', '2026-11-16');

INSERT INTO titulo_categoria (id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao)
VALUES (31, 8, 1, 1, '2026-11-16');

COMMIT;

-- Título 31 gravado
SELECT id_titulo, nome, tipo FROM titulo WHERE id_titulo = 31;

-- Exemplo de ROLLBACK
-- Reajuste de preço errado (x10), desfeito.
START TRANSACTION;

UPDATE plano
SET valor_mensal = valor_mensal * 10
WHERE id_plano = 5;

-- Antes do ROLLBACK: 559.00
SELECT id_plano, nome, valor_mensal FROM plano WHERE id_plano = 5;

ROLLBACK;

-- Depois do ROLLBACK: 55.90
SELECT id_plano, nome, valor_mensal FROM plano WHERE id_plano = 5;
