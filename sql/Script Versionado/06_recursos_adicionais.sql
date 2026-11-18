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
-- Renovar a assinatura é avançar a data_proxima_cobranca da
-- conta. Antes de gravar a nova data, validar:
--   a) a conta precisa estar ATIVA (conta suspensa ou
--      cancelada não renova);
--   b) a nova data precisa ser POSTERIOR à data atual;
--   c) a nova data precisa cair no dia de vencimento
--      combinado com o cliente (dia_vencimento).
-- Se alguma regra falhar, a renovação é recusada (SIGNAL).
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

    -- Só valida quando a data da próxima cobrança foi alterada
    IF NEW.data_proxima_cobranca <> OLD.data_proxima_cobranca THEN

        -- Status atual da conta dona da cobrança
        SELECT status INTO v_status
        FROM conta
        WHERE id_conta = NEW.id_conta;

        -- a) conta precisa estar ativa
        IF v_status <> 'Ativa' THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Conta suspensa ou cancelada nao pode renovar a assinatura.';
        END IF;

        -- b) a data só pode avançar
        IF NEW.data_proxima_cobranca <= OLD.data_proxima_cobranca THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'A nova data de cobranca deve ser posterior a data atual.';
        END IF;

        -- c) a data precisa cair no dia de vencimento
        IF DAY(NEW.data_proxima_cobranca) <> NEW.dia_vencimento THEN
            SET v_mensagem = CONCAT('A cobranca deve cair no dia de vencimento: dia ',
                                    NEW.dia_vencimento, '.');
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = v_mensagem;
        END IF;
    END IF;
END //
DELIMITER ;

-- Antes: a conta 2 (ativa) tem a próxima cobrança em 24/12/2026
SELECT id_conta, nome_titular, dia_vencimento, data_proxima_cobranca
FROM dados_cobranca
WHERE id_conta = 2;

-- Caso permitido: renovação da conta 2 para 24/01/2027
UPDATE dados_cobranca
SET data_proxima_cobranca = '2027-01-24'
WHERE id_conta = 2;

-- Conferindo: a data deve aparecer como 2027-01-24
SELECT id_conta, nome_titular, dia_vencimento, data_proxima_cobranca
FROM dados_cobranca
WHERE id_conta = 2;

-- Casos bloqueados. Geram erro de propósito; tire o "-- " para testar.

-- (a) a conta 7 está SUSPENSA
-- UPDATE dados_cobranca SET data_proxima_cobranca = '2027-01-21' WHERE id_conta = 7;
-- Resultado esperado: Error Code 1644. Conta suspensa ou cancelada...

-- (b) a data volta no tempo
-- UPDATE dados_cobranca SET data_proxima_cobranca = '2026-11-24' WHERE id_conta = 2;
-- Resultado esperado: Error Code 1644. A nova data de cobranca deve ser posterior...

-- (c) a data não cai no dia de vencimento (dia 24)
-- UPDATE dados_cobranca SET data_proxima_cobranca = '2027-02-10' WHERE id_conta = 2;
-- Resultado esperado: Error Code 1644. A cobranca deve cair no dia de vencimento: dia 24.

-- ==========================================================
-- TRIGGER 2
-- Regra:
-- Quando um título é marcado como indisponível (ou volta a ficar
-- disponível), as temporadas e os episódios dele acompanham.
-- Assim, ao tirar uma série do catálogo, nenhuma temporada ou
-- episódio dela continua aparecendo como disponível.
-- Se o campo disponivel não mudou (por exemplo, só o nome foi
-- alterado), nada é feito.
--
-- Tipo:
-- AFTER UPDATE
--
-- A trigger é disparada pela tabela titulo e altera outras duas
-- tabelas (temporada e episodio).
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

        -- Episódios das temporadas desse título
        UPDATE episodio
        SET disponivel = NEW.disponivel
        WHERE id_temporada IN (SELECT id_temporada
                               FROM temporada
                               WHERE id_titulo = NEW.id_titulo);
    END IF;
END //
DELIMITER ;

-- Antes: a série 1 (Sombras da Capital) está disponível, com
-- 3 temporadas e 6 episódios
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

-- Comando que dispara a trigger: a série 1 sai do catálogo
UPDATE titulo
SET disponivel = 0
WHERE id_titulo = 1;

-- Conferindo: título, temporadas e episódios aparecem com 0
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

-- A série 1 volta ao catálogo e tudo volta a ficar disponível
UPDATE titulo
SET disponivel = 1
WHERE id_titulo = 1;

-- Conferindo: tudo volta a 1
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
