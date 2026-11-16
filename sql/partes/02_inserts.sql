-- ==========================================================
-- BANCO DE DADOS NETFLIX - ARQUIVO 02 DE 09
-- Inserção de dados (mínimo de 30 INSERT por tabela)
-- Critério da atividade: Inserção de dados
--
-- Pré-requisito: executar antes os arquivos 01 a 01, nesta ordem.
-- Este arquivo é a PARTE 2 do script completo (sql/netflix_bd.sql),
-- separada para facilitar a leitura e a apresentação.
-- ==========================================================

USE NETFLIX;

-- ==========================================================
-- PARTE 2 - INSERÇÃO DE DADOS
-- ----------------------------------------------------------
-- Dados fictícios, criados apenas para demonstração
-- (nomes, e-mails e hashes de senha não são reais).
--
-- Cada tabela tem no mínimo 30 comandos INSERT (um por linha).
-- Os ids são informados de propósito, para deixar as chaves
-- estrangeiras fáceis de conferir. Como o banco é recriado do
-- zero no início do script, os ids sempre começam em 1.
--
-- A ordem segue a das tabelas: primeiro as tabelas "mãe",
-- depois as que têm chave estrangeira.
--
-- Os dados foram pensados para que as consultas (JOINs) tenham
-- casos "sem correspondência", como no exemplo da professora:
--   * Planos sem contas: 8 e 9, 16 a 30
--   * Contas sem perfil: 39 e 40
--   * Contas sem dados de cobrança: 5, 12, 23, 39 e 40
--   * Categorias sem títulos: 3, 11, 15 a 17, 26 a 30
--   * Títulos sem categoria: 39 e 40
--   * Pessoas sem participação: 37 a 40
--   * Títulos nunca assistidos: 2, 5, 14, 33 a 40
--   * Temporadas sem episódios: 21 a 32
-- ==========================================================

SET NAMES utf8mb4;  -- garante que os acentos sejam gravados corretamente

-- ----------------------------------------------------------
-- PLANO (30)
-- Os planos 1 a 5 são os regulares.
-- Planos sem nenhuma conta (sem correspondência no LEFT JOIN): 8 e 9, 16 a 30.
-- ----------------------------------------------------------
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (1, 'Mobile', 'Assista no celular e no tablet. Plano regular.', 19.90, 'SD', 1, 1, '2019-04-01');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (2, 'Básico', 'Uma tela em HD. Plano regular.', 25.90, 'HD', 1, 1, '2019-06-30');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (3, 'Padrão com Anúncios', 'Duas telas em Full HD, com anúncios. Plano regular.', 18.90, 'Full HD', 2, 0, '2019-09-28');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (4, 'Padrão', 'Duas telas em Full HD, sem anúncios. Plano regular.', 39.90, 'Full HD', 2, 1, '2019-12-27');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (5, 'Premium', 'Quatro telas em 4K, sem anúncios. Plano regular.', 55.90, '4K UHD', 4, 1, '2020-03-26');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (6, 'Mobile Estudante', 'Assista no celular e no tablet. Desconto para estudantes.', 9.95, 'SD', 1, 1, '2020-06-24');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (7, 'Básico Estudante', 'Uma tela em HD. Desconto para estudantes.', 12.95, 'HD', 1, 1, '2020-09-22');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (8, 'Padrão com Anúncios Estudante', 'Duas telas em Full HD, com anúncios. Desconto para estudantes.', 9.45, 'Full HD', 2, 0, '2020-12-21');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (9, 'Padrão Estudante', 'Duas telas em Full HD, sem anúncios. Desconto para estudantes.', 19.95, 'Full HD', 2, 1, '2021-03-21');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (10, 'Premium Estudante', 'Quatro telas em 4K, sem anúncios. Desconto para estudantes.', 27.95, '4K UHD', 4, 1, '2021-06-19');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (11, 'Mobile Família', 'Assista no celular e no tablet. Condição especial para famílias.', 27.86, 'SD', 1, 1, '2021-09-17');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (12, 'Básico Família', 'Uma tela em HD. Condição especial para famílias.', 36.26, 'HD', 1, 1, '2021-12-16');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (13, 'Padrão com Anúncios Família', 'Duas telas em Full HD, com anúncios. Condição especial para famílias.', 26.46, 'Full HD', 2, 0, '2022-03-16');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (14, 'Padrão Família', 'Duas telas em Full HD, sem anúncios. Condição especial para famílias.', 55.86, 'Full HD', 2, 1, '2022-06-14');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (15, 'Premium Família', 'Quatro telas em 4K, sem anúncios. Condição especial para famílias.', 78.26, '4K UHD', 4, 1, '2022-09-12');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (16, 'Mobile Promocional', 'Assista no celular e no tablet. Preço promocional por tempo limitado.', 15.92, 'SD', 1, 1, '2022-12-11');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (17, 'Básico Promocional', 'Uma tela em HD. Preço promocional por tempo limitado.', 20.72, 'HD', 1, 1, '2023-03-11');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (18, 'Padrão com Anúncios Promocional', 'Duas telas em Full HD, com anúncios. Preço promocional por tempo limitado.', 15.12, 'Full HD', 2, 0, '2023-06-09');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (19, 'Padrão Promocional', 'Duas telas em Full HD, sem anúncios. Preço promocional por tempo limitado.', 31.92, 'Full HD', 2, 1, '2023-09-07');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (20, 'Premium Promocional', 'Quatro telas em 4K, sem anúncios. Preço promocional por tempo limitado.', 44.72, '4K UHD', 4, 1, '2023-12-06');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (21, 'Mobile Legado', 'Assista no celular e no tablet. Plano antigo mantido para clientes antigos.', 17.91, 'SD', 1, 1, '2024-03-05');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (22, 'Básico Legado', 'Uma tela em HD. Plano antigo mantido para clientes antigos.', 23.31, 'HD', 1, 1, '2024-06-03');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (23, 'Padrão com Anúncios Legado', 'Duas telas em Full HD, com anúncios. Plano antigo mantido para clientes antigos.', 17.01, 'Full HD', 2, 0, '2024-09-01');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (24, 'Padrão Legado', 'Duas telas em Full HD, sem anúncios. Plano antigo mantido para clientes antigos.', 35.91, 'Full HD', 2, 1, '2024-11-30');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (25, 'Premium Legado', 'Quatro telas em 4K, sem anúncios. Plano antigo mantido para clientes antigos.', 50.31, '4K UHD', 4, 1, '2025-02-28');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (26, 'Mobile Corporativo', 'Assista no celular e no tablet. Plano para empresas.', 31.84, 'SD', 1, 1, '2025-05-29');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (27, 'Básico Corporativo', 'Uma tela em HD. Plano para empresas.', 41.44, 'HD', 1, 1, '2025-08-27');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (28, 'Padrão com Anúncios Corporativo', 'Duas telas em Full HD, com anúncios. Plano para empresas.', 30.24, 'Full HD', 2, 0, '2025-11-25');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (29, 'Padrão Corporativo', 'Duas telas em Full HD, sem anúncios. Plano para empresas.', 63.84, 'Full HD', 2, 1, '2026-02-23');
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao) VALUES (30, 'Premium Corporativo', 'Quatro telas em 4K, sem anúncios. Plano para empresas.', 89.44, '4K UHD', 4, 1, '2026-05-24');

-- ----------------------------------------------------------
-- CATEGORIA (30)
-- Categorias sem nenhum título (sem correspondência): 3, 11, 15 a 17, 26 a 30.
-- As categorias 28 a 30 estão inativas (ativa = 0).
-- ----------------------------------------------------------
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (1, 'Ação', 'Títulos da categoria Ação.', 'ACAO', 1, '2020-01-10');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (2, 'Aventura', 'Títulos da categoria Aventura.', 'AVEN', 1, '2020-01-25');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (3, 'Animação', 'Títulos da categoria Animação.', 'ANIM', 1, '2020-02-09');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (4, 'Comédia', 'Títulos da categoria Comédia.', 'COME', 1, '2020-02-24');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (5, 'Comédia Romântica', 'Títulos da categoria Comédia Romântica.', 'CORO', 1, '2020-03-10');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (6, 'Crime', 'Títulos da categoria Crime.', 'CRIM', 1, '2020-03-25');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (7, 'Documentário', 'Títulos da categoria Documentário.', 'DOCU', 1, '2020-04-09');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (8, 'Drama', 'Títulos da categoria Drama.', 'DRAM', 1, '2020-04-24');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (9, 'Fantasia', 'Títulos da categoria Fantasia.', 'FANT', 1, '2020-05-09');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (10, 'Ficção Científica', 'Títulos da categoria Ficção Científica.', 'FICC', 1, '2020-05-24');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (11, 'Terror', 'Títulos da categoria Terror.', 'TERR', 1, '2020-06-08');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (12, 'Suspense', 'Títulos da categoria Suspense.', 'SUSP', 1, '2020-06-23');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (13, 'Romance', 'Títulos da categoria Romance.', 'ROMA', 1, '2020-07-08');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (14, 'Musical', 'Títulos da categoria Musical.', 'MUSI', 1, '2020-07-23');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (15, 'Família', 'Títulos da categoria Família.', 'FAMI', 1, '2020-08-07');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (16, 'Infantil', 'Títulos da categoria Infantil.', 'INFA', 1, '2020-08-22');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (17, 'Guerra', 'Títulos da categoria Guerra.', 'GUER', 1, '2020-09-06');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (18, 'Biografia', 'Títulos da categoria Biografia.', 'BIOG', 1, '2020-09-21');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (19, 'Esporte', 'Títulos da categoria Esporte.', 'ESPO', 1, '2020-10-06');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (20, 'Mistério', 'Títulos da categoria Mistério.', 'MIST', 1, '2020-10-21');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (21, 'Policial', 'Títulos da categoria Policial.', 'POLI', 1, '2020-11-05');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (22, 'Histórico', 'Títulos da categoria Histórico.', 'HIST', 1, '2020-11-20');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (23, 'Natureza', 'Títulos da categoria Natureza.', 'NATU', 1, '2020-12-05');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (24, 'Culinária', 'Títulos da categoria Culinária.', 'CULI', 1, '2020-12-20');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (25, 'Stand-up', 'Títulos da categoria Stand-up.', 'STAN', 1, '2021-01-04');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (26, 'Adolescente', 'Títulos da categoria Adolescente.', 'ADOL', 1, '2021-01-19');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (27, 'Reality Show', 'Títulos da categoria Reality Show.', 'REAL', 1, '2021-02-03');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (28, 'Anime', 'Títulos da categoria Anime.', 'ANME', 0, '2021-02-18');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (29, 'Religioso', 'Títulos da categoria Religioso.', 'RELI', 0, '2021-03-05');
INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, data_criacao) VALUES (30, 'Faroeste', 'Títulos da categoria Faroeste.', 'FARO', 0, '2021-03-20');

-- ----------------------------------------------------------
-- PESSOA (40)
-- Pessoas 37 a 40 não participam de nenhum título (casos sem correspondência).
-- ----------------------------------------------------------
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (1, 'Diego Duarte', NULL, '1959-03-18', 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (2, 'Tiago Moreira', NULL, '1999-02-23', 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (3, 'Zeca Oliveira', NULL, '1971-07-12', 'Brasileira', 'Zeca Oliveira atua na indústria audiovisual há mais de 8 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (4, 'Diego Ramos', NULL, '1993-12-26', 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (5, 'Gabriela Martins', NULL, NULL, 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (6, 'Mariana Barbosa', NULL, '1958-01-17', 'Brasileira', 'Mariana Barbosa atua na indústria audiovisual há mais de 21 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (7, 'João Santos', 'João Brasil', '1983-02-03', 'Brasileira', 'João Santos atua na indústria audiovisual há mais de 30 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (8, 'Carla Martins', NULL, '1960-06-12', 'Brasileira', 'Carla Martins atua na indústria audiovisual há mais de 34 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (9, 'Isabela Pereira', NULL, NULL, 'Brasileira', 'Isabela Pereira atua na indústria audiovisual há mais de 4 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (10, 'Sofia Prado', NULL, '1996-12-09', 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (11, 'Diego Moreira', NULL, '1970-07-16', 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (12, 'Diego Santos', NULL, '1998-12-14', 'Brasileira', 'Diego Santos atua na indústria audiovisual há mais de 28 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (13, 'Vitor Ramos', NULL, '1992-12-18', 'Brasileira', NULL, 0);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (14, 'Mariana Pereira', 'Mariana Brasil', '1963-06-12', 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (15, 'Tiago Santos', NULL, NULL, 'Brasileira', 'Tiago Santos atua na indústria audiovisual há mais de 15 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (16, 'Isabela Oliveira', NULL, '1994-08-08', 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (17, 'Rafael Lima', NULL, '1958-10-29', 'Brasileira', 'Rafael Lima atua na indústria audiovisual há mais de 35 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (18, 'Isabela Santos', NULL, '1988-03-13', 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (19, 'Pedro Mendes', NULL, NULL, 'Brasileira', 'Pedro Mendes atua na indústria audiovisual há mais de 15 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (20, 'Yasmin Pereira', 'Yasmin Star', '1990-06-25', 'Brasileira', 'Yasmin Pereira atua na indústria audiovisual há mais de 8 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (21, 'Tiago Nunes', 'Tiago Star', '1974-02-03', 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (22, 'Úrsula Ferreira', 'Úrsula Brasil', '2001-07-10', 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (23, 'Pedro Alves', NULL, '1961-10-09', 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (24, 'Wesley Barbosa', NULL, '1964-05-13', 'Brasileira', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (25, 'Sofia Ramos', NULL, '1963-04-30', 'Brasileira', 'Sofia Ramos atua na indústria audiovisual há mais de 15 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (26, 'Mariana Souza', NULL, '1956-08-03', 'Brasileira', 'Mariana Souza atua na indústria audiovisual há mais de 25 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (27, 'Zeca Souza', 'Zeca Luz', '1977-03-30', 'Brasileira', 'Zeca Souza atua na indústria audiovisual há mais de 10 anos.', 0);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (28, 'Pedro Santos', NULL, '1963-10-22', 'Brasileira', 'Pedro Santos atua na indústria audiovisual há mais de 16 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (29, 'Nicolas Moreira', NULL, '1956-03-27', 'Portuguesa', 'Nicolas Moreira atua na indústria audiovisual há mais de 5 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (30, 'Gabriela Costa', 'Gabriela Star', '1966-11-30', 'Argentina', 'Gabriela Costa atua na indústria audiovisual há mais de 4 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (31, 'Eduarda Barbosa', 'Eduarda Silva', '1966-09-09', 'Americana', 'Eduarda Barbosa atua na indústria audiovisual há mais de 30 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (32, 'Rafael Pereira', NULL, '1966-10-18', 'Mexicana', 'Rafael Pereira atua na indústria audiovisual há mais de 19 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (33, 'Olívia Oliveira', NULL, '1975-10-23', 'Espanhola', 'Olívia Oliveira atua na indústria audiovisual há mais de 23 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (34, 'Quitéria Oliveira', NULL, '1997-01-27', 'Britânica', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (35, 'Diego Nunes', 'Diego Star', '1979-08-24', 'Colombiana', 'Diego Nunes atua na indústria audiovisual há mais de 14 anos.', 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (36, 'Ana Ferreira', NULL, '2001-05-07', 'Chilena', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (37, 'Gabriela Rocha', NULL, '2000-12-17', 'Francesa', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (38, 'Sofia Torres', NULL, '1973-08-29', 'Italiana', 'Sofia Torres atua na indústria audiovisual há mais de 30 anos.', 0);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (39, 'Felipe Rocha', NULL, '1966-08-23', 'Canadense', NULL, 1);
INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalidade, biografia, em_atividade) VALUES (40, 'Diego Barbosa', NULL, '1955-09-26', 'Uruguaia', 'Diego Barbosa atua na indústria audiovisual há mais de 23 anos.', 1);

-- ----------------------------------------------------------
-- TITULO (40)
-- Títulos 1 a 14: séries. 15 a 28: filmes. 29 a 34: documentários. 35 a 40: stand-ups.
-- Títulos nunca assistidos (sem correspondência): 2, 5, 14, 33 a 40.
-- Séries não têm duração total (duracao_minutos = NULL); a duração fica nos episódios.
-- ----------------------------------------------------------
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (1, 'Sombras da Capital', 'Uma jornalista investiga um esquema de corrupção em Brasília.', 'Serie', 2014, '12', NULL, 'Português', '2021-11-15', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (2, 'O Último Verão', 'Amigos de infância se reencontram numa cidade litorânea.', 'Serie', 2012, '14', NULL, 'Inglês', '2021-11-18', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (3, 'Código Zero', 'Uma equipe de hackers tenta impedir um ataque global.', 'Serie', 2012, 'L', NULL, 'Português', '2020-01-31', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (4, 'Ilha dos Esquecidos', 'Sobreviventes de um naufrágio descobrem uma ilha misteriosa.', 'Serie', 2012, '12', NULL, 'Português', '2020-05-18', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (5, 'Herdeiros do Sertão', 'Duas famílias disputam terras no interior do Nordeste.', 'Serie', 2022, '16', NULL, 'Coreano', '2025-03-26', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (6, 'Linha do Tempo', 'Uma cientista descobre como enviar mensagens ao passado.', 'Serie', 2017, '12', NULL, 'Espanhol', '2024-02-11', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (7, 'A Casa Branca', 'Uma família se muda para uma casa com segredos antigos.', 'Serie', 2022, '18', NULL, 'Espanhol', '2026-01-02', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (8, 'Noite em Neon', 'Um detetive percorre a vida noturna de uma metrópole.', 'Serie', 2012, '14', NULL, 'Espanhol', '2022-07-18', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (9, 'Cidade Submersa', 'Após uma enchente, moradores precisam recomeçar.', 'Serie', 2015, '16', NULL, 'Inglês', '2024-03-10', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (10, 'Os Guardiões do Norte', 'Um grupo protege uma fronteira contra ameaças desconhecidas.', 'Serie', 2022, 'L', NULL, 'Português', '2025-11-06', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (11, 'Quarto 404', 'Hóspedes de um hotel vivem situações inexplicáveis.', 'Serie', 2025, '16', NULL, 'Inglês', '2025-09-15', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (12, 'Rota 66 Brasil', 'Dois irmãos cruzam o país de moto.', 'Serie', 2016, '12', NULL, 'Francês', '2019-08-25', 0);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (13, 'Sinal Perdido', 'Um engenheiro tenta restabelecer a comunicação de uma cidade isolada.', 'Serie', 2023, '14', NULL, 'Português', '2023-02-18', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (14, 'Fronteira Sul', 'Policiais enfrentam o crime organizado na divisa do país.', 'Serie', 2023, '12', NULL, 'Francês', '2024-08-16', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (15, 'O Mapa de Cinzas', 'Uma caçadora de tesouros segue um mapa deixado pelo avô.', 'Filme', 2024, 'L', 138, 'Português', '2025-08-31', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (16, 'Entre Duas Marés', 'Um pescador e uma bióloga lutam para salvar uma baía.', 'Filme', 2021, 'L', 110, 'Espanhol', '2024-11-03', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (17, 'A Última Missão', 'Um soldado aposentado volta à ativa por uma causa pessoal.', 'Filme', 2012, '18', 105, 'Espanhol', '2020-04-06', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (18, 'Café com Fantasmas', 'Um café tem clientes que não são exatamente vivos.', 'Filme', 2013, 'L', 101, 'Espanhol', '2019-06-02', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (19, 'Rumo ao Horizonte', 'Uma viagem de carro muda a vida de uma família.', 'Filme', 2017, '16', 123, 'Português', '2026-04-07', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (20, 'O Segredo do Farol', 'Um faroleiro guarda um segredo há trinta anos.', 'Filme', 2018, '16', 130, 'Inglês', '2020-06-01', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (21, 'Duelo no Deserto', 'Dois pistoleiros se enfrentam em uma cidade esquecida.', 'Filme', 2018, '14', 138, 'Francês', '2021-09-07', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (22, 'Amor em Lisboa', 'Dois desconhecidos se encontram durante um festival.', 'Filme', 2015, '10', 154, 'Português', '2021-01-21', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (23, 'Operação Aurora', 'Agentes tentam evitar um sequestro internacional.', 'Filme', 2022, '18', 156, 'Inglês', '2025-01-13', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (24, 'A Pequena Orquestra', 'Crianças de uma escola pública formam uma orquestra.', 'Filme', 2026, 'L', 114, 'Português', '2026-03-17', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (25, 'Corrida contra o Tempo', 'Uma médica tem poucas horas para entregar um órgão.', 'Filme', 2012, '12', 146, 'Inglês', '2025-01-25', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (26, 'O Jardim Secreto de Ana', 'Uma menina descobre um jardim escondido atrás da escola.', 'Filme', 2016, '12', 165, 'Espanhol', '2020-07-21', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (27, 'Voo 902', 'Um piloto precisa pousar em condições extremas.', 'Filme', 2013, '10', 89, 'Francês', '2025-03-15', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (28, 'Noite de Estreia', 'Bastidores de uma peça de teatro às vésperas da estreia.', 'Filme', 2025, '16', 128, 'Francês', '2025-09-29', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (29, 'Oceanos Profundos', 'As criaturas e os mistérios das fossas oceânicas.', 'Documentario', 2020, '18', 53, 'Francês', '2023-07-24', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (30, 'A Vida das Abelhas', 'O papel das abelhas na natureza e na alimentação.', 'Documentario', 2025, 'L', 65, 'Inglês', '2026-10-05', 0);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (31, 'Cozinhas do Mundo', 'Chefs mostram receitas tradicionais de vários países.', 'Documentario', 2012, '10', 82, 'Coreano', '2026-08-13', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (32, 'Floresta em Perigo', 'Os desafios da preservação de florestas tropicais.', 'Documentario', 2014, '18', 95, 'Português', '2023-06-23', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (33, 'Mentes Brilhantes', 'Perfis de cientistas que mudaram o mundo.', 'Documentario', 2024, '10', 71, 'Coreano', '2025-07-18', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (34, 'História do Futebol', 'Como o esporte conquistou o planeta.', 'Documentario', 2015, '12', 79, 'Francês', '2023-01-10', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (35, 'Rindo de Mim Mesmo', 'Um humorista fala sobre as próprias trapalhadas.', 'Stand-up', 2019, '16', 73, 'Português', '2026-07-21', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (36, 'Piadas de Família', 'Histórias engraçadas sobre almoços de domingo.', 'Stand-up', 2015, '18', 59, 'Inglês', '2023-08-09', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (37, 'Sem Filtro', 'Humor ácido sobre o dia a dia nas grandes cidades.', 'Stand-up', 2026, '16', 77, 'Inglês', '2026-09-25', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (38, 'Humor ao Vivo em Brasília', 'Show gravado ao vivo com plateia lotada.', 'Stand-up', 2024, '18', 57, 'Português', '2024-12-19', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (39, 'Noite de Risadas', 'Vários comediantes se revezam no palco.', 'Stand-up', 2017, '18', 59, 'Francês', '2021-12-21', 1);
INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificacao_indicativa, duracao_minutos, idioma_original, data_adicao_catalogo, disponivel) VALUES (40, 'O Último Show', 'A despedida de um comediante veterano.', 'Stand-up', 2023, '14', 61, 'Coreano', '2025-12-28', 1);

-- ----------------------------------------------------------
-- CONTA (40)
-- Senhas são hashes fictícios, apenas ilustrativos.
-- Contas 39 e 40 não têm perfil. Contas 7, 16, 22, 29 e 35 estão suspensas; 11, 24, 33 e 38, canceladas.
-- ----------------------------------------------------------
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (1, 4, 'rafael.alves1@exemplo.com', '$2y$10$a991e84c62a25c5a972f67c47cd81f31063c2dde905a8428977b0', '(61) 99816-2911', 'BR', '2024-11-20 07:53:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (2, 14, 'lucas.mendes2@exemplo.com', '$2y$10$02a3e1fc659a693124e09cc25a8b49249e126cbfa0dddf8f45d4d', '(61) 98442-9718', 'BR', '2022-11-12 14:08:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (3, 5, 'diego.duarte3@exemplo.com', '$2y$10$503ae5403efc54b676a4b551f30d9439e42aa4c362e8d21dc37a4', '(61) 99789-2198', 'BR', '2024-02-20 15:39:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (4, 3, 'joao.rocha4@exemplo.com', '$2y$10$f4f08752af7e13674acd6ec40c91e4eb069e7e0e92cf1af5dc348', '(61) 99862-9171', 'BR', '2022-09-05 14:53:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (5, 10, 'lucas.santos5@exemplo.com', '$2y$10$8c55ae6c438eb7bc74c65aa600e4bebc93c61916b9f3eb2977b41', NULL, 'PT', '2023-12-08 09:04:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (6, 1, 'zeca.mendes6@exemplo.com', '$2y$10$f1cff19d391ece0c73a5647ecdba9eb87b15c63f7d2b7116bfc77', '(61) 99593-6112', 'BR', '2023-06-28 14:10:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (7, 2, 'karina.pereira7@exemplo.com', '$2y$10$7c33eef555ebfd3fe805d1e44b058bae852b191939297bffff78f', '(61) 98679-6287', 'BR', '2026-01-22 22:25:00', 'Suspensa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (8, 2, 'karina.costa8@exemplo.com', '$2y$10$e842b2b00245276406b4feae75355d1721d92f0269044a58eff81', '(61) 98948-4607', 'BR', '2025-11-12 18:48:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (9, 1, 'lucas.pereira9@exemplo.com', '$2y$10$b8afb457ed08ad91126d628cafda8f8dfd5d2a0b270fddf3c2553', '(61) 99208-7252', 'BR', '2023-03-12 11:28:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (10, 1, 'yasmin.teixeira10@exemplo.com', '$2y$10$b8ea280a518d1b835e32564f18846274e2a3ba6fd38d1562647b0', '(61) 98261-8066', 'BR', '2023-07-03 17:53:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (11, 4, 'isabela.santos11@exemplo.com', '$2y$10$922197c7482f2dd40727759f399482b085a3b3ad79c1d61cb6c96', '(61) 99116-5393', 'BR', '2023-04-25 17:09:00', 'Cancelada');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (12, 3, 'rafael.rocha12@exemplo.com', '$2y$10$41d0b37c0667da36948f2822e16ed54692371bb846103968b4bb2', '(61) 99176-8504', 'BR', '2025-07-20 19:25:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (13, 1, 'ana.cardoso13@exemplo.com', '$2y$10$27ad6f0e72ea55c1675a824b48d4558d70d442b37e4d0750fa45c', '(61) 99380-7711', 'BR', '2023-11-21 10:43:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (14, 3, 'zeca.oliveira14@exemplo.com', '$2y$10$f09ce8610dc3035e35ca718c7c726c55745e70cdef47bcaa0d5b9', NULL, 'PT', '2026-10-02 13:27:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (15, 12, 'lucas.duarte15@exemplo.com', '$2y$10$f5b5709027e5e61970411edfd809dd8fddd81049b9d5c5c76e0ca', '(61) 98818-3833', 'BR', '2022-01-22 15:35:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (16, 2, 'wesley.torres16@exemplo.com', '$2y$10$123a9a40dc88c6079b3b6e7da4ea21383a8b613cde19cbf3cedff', '(61) 99185-7793', 'BR', '2026-09-02 22:54:00', 'Suspensa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (17, 4, 'pedro.duarte17@exemplo.com', '$2y$10$cc01fd786df85d79703621b3a790cba974e723ca826fb05fb77eb', '(61) 99550-4602', 'BR', '2025-07-27 10:42:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (18, 4, 'isabela.duarte18@exemplo.com', '$2y$10$8f842a2a963ef72fdef48cba95ad2136cb87e03e754a9ce2ea0dd', '(61) 98428-8489', 'BR', '2024-11-20 15:39:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (19, 11, 'ursula.ferreira19@exemplo.com', '$2y$10$5b2254372b2523e8986c22776dfac4fff8c05c52e80f43dbe41c2', '(61) 99418-4074', 'BR', '2025-01-08 07:06:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (20, 15, 'eduarda.duarte20@exemplo.com', '$2y$10$e008472366b06ff86d962f0508480fe71be7353c4a3db727fffdf', NULL, 'US', '2024-08-07 13:38:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (21, 13, 'vitor.costa21@exemplo.com', '$2y$10$00bf608f9c22392448839fe055cead3b6080828a0e23e95d4e627', '(61) 98172-7832', 'BR', '2025-12-28 11:06:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (22, 4, 'ana.torres22@exemplo.com', '$2y$10$d61d04b8f5f09a28f455efd969c5d5eb276f0244dd8c586a00294', NULL, 'BR', '2022-04-02 12:35:00', 'Suspensa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (23, 3, 'yasmin.barbosa23@exemplo.com', '$2y$10$e67545803fb8f380b44b82ed0e7956eea45f5394b62bf28c29dd2', NULL, 'BR', '2024-08-22 17:21:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (24, 5, 'tiago.oliveira24@exemplo.com', '$2y$10$539e0ace65086d9e4972ec84f1bef17887b68731c0fd8cdb6504c', '(61) 99808-6358', 'BR', '2026-09-15 15:02:00', 'Cancelada');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (25, 1, 'ursula.oliveira25@exemplo.com', '$2y$10$948ebf753654b62fd699aecc2b41dd4314d8e8387e1448a769497', '(61) 98984-6999', 'BR', '2023-06-04 21:12:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (26, 5, 'lucas.torres26@exemplo.com', '$2y$10$617e99e7702973f0511905516d7c759f8fdf53bfe43ed2d2d0365', '(61) 99499-7552', 'BR', '2023-09-15 13:37:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (27, 2, 'bruno.pereira27@exemplo.com', '$2y$10$0eabeba7d7156e9b58f601ffe5c6150dacdf800c405fff1c46835', NULL, 'BR', '2026-01-26 16:30:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (28, 3, 'tiago.mendes28@exemplo.com', '$2y$10$f14fd3be187ef8be5ff4747432d9066fae400078aa4c154c05390', NULL, 'BR', '2024-12-05 17:31:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (29, 7, 'karina.duarte29@exemplo.com', '$2y$10$251810bee8be997ea26388cdd1f07bd78417d619fe1cb1760ea2e', '(61) 98159-3856', 'BR', '2026-04-05 15:55:00', 'Suspensa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (30, 2, 'quiteria.barbosa30@exemplo.com', '$2y$10$6e44b842580331a004d46410eea0348c3172eadcc144c3d7535e8', NULL, 'BR', '2025-07-15 10:59:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (31, 4, 'tiago.nunes31@exemplo.com', '$2y$10$63a08d9376745d4086ff0821b18b4b9df7c9f2c8b2f34bc362c7a', '(61) 98493-4435', 'AR', '2024-05-28 11:32:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (32, 2, 'gabriela.torres32@exemplo.com', '$2y$10$a16063f29bd559e9de012f89811766c96dd58bf17c68fcdf872bb', '(61) 99467-9004', 'BR', '2022-10-07 17:23:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (33, 1, 'ursula.martins33@exemplo.com', '$2y$10$1e3fd8e0f9b70fb9d4f68967302054f8a066f339f3f8ae961d74b', '(61) 99487-9832', 'BR', '2023-01-23 11:38:00', 'Cancelada');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (34, 1, 'yasmin.alves34@exemplo.com', '$2y$10$ff559802921e5dbddc5420fd1ac9f10b09a928e29506d89454f2f', '(61) 99670-2000', 'BR', '2026-07-01 08:17:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (35, 5, 'joao.costa35@exemplo.com', '$2y$10$fab71204102f0af042d8b5d8d23bd0b8fe5df859b493b433ccb97', '(61) 99972-9852', 'BR', '2025-11-20 18:08:00', 'Suspensa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (36, 2, 'olivia.costa36@exemplo.com', '$2y$10$f26448ed6831363592892ba72bdbe015bfe01c5a81791f5ea350e', '(61) 98109-4041', 'BR', '2025-10-24 11:26:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (37, 5, 'ursula.moreira37@exemplo.com', '$2y$10$3a0f291f6ab114bb66f24d7a729bab433e1ccef5cd4bb35357fb4', '(61) 99118-1475', 'MX', '2023-09-08 14:32:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (38, 6, 'lucas.cardoso38@exemplo.com', '$2y$10$3afa2225b0d0f4709fdfdef8c48ea54eebf307275603e4d04fc2c', '(61) 99393-7664', 'BR', '2022-11-14 17:09:00', 'Cancelada');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (39, 4, 'wesley.barbosa39@exemplo.com', '$2y$10$ee3b99845674bb19df600a96573d6a4496b73b7f4afc47d0a4906', '(61) 98015-1953', 'BR', '2022-07-13 18:37:00', 'Ativa');
INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_cadastro, status) VALUES (40, 4, 'karina.souza40@exemplo.com', '$2y$10$0e983056bfe11feb151d9275eb259b741a0ea4789c6b4a39206f0', '(61) 98391-2475', 'BR', '2024-05-15 20:12:00', 'Ativa');

-- ----------------------------------------------------------
-- DADOS_COBRANCA (35)
-- Relacionamento 1:1 com conta. Contas 5, 12, 23, 39 e 40 não têm dados de cobrança.
-- Contas suspensas ou canceladas têm cobranca_ativa = 0.
-- ----------------------------------------------------------
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (1, 1, 'Rafael Alves', 'Cartao de Credito', '3950', 8, '2026-12-08', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (2, 2, 'Lucas Mendes', 'Pix', NULL, 7, '2026-12-07', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (3, 3, 'Diego Duarte', 'Cartao de Debito', '2597', 18, '2026-12-18', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (4, 4, 'João Rocha', 'Pix', NULL, 24, '2026-12-24', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (5, 6, 'Zeca Mendes', 'Pix', NULL, 15, '2026-12-15', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (6, 7, 'Karina Pereira', 'Cartao de Debito', '3427', 10, '2026-12-10', 0);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (7, 8, 'Karina Costa', 'Pix', NULL, 18, '2026-12-18', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (8, 9, 'Lucas Pereira', 'Boleto', NULL, 16, '2026-12-16', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (9, 10, 'Yasmin Teixeira', 'Cartao de Credito', '3457', 24, '2026-12-24', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (10, 11, 'Isabela Santos', 'Cartao de Credito', '1898', 25, '2026-12-25', 0);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (11, 13, 'Ana Cardoso', 'Cartao de Credito', '5798', 23, '2026-12-23', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (12, 14, 'Zeca Oliveira', 'Boleto', NULL, 23, '2026-12-23', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (13, 15, 'Lucas Duarte', 'Cartao de Credito', '1886', 6, '2026-12-06', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (14, 16, 'Wesley Torres', 'Cartao de Credito', '7103', 7, '2026-12-07', 0);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (15, 17, 'Pedro Duarte', 'Pix', NULL, 1, '2026-12-01', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (16, 18, 'Isabela Duarte', 'Boleto', NULL, 5, '2026-12-05', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (17, 19, 'Úrsula Ferreira', 'Cartao de Debito', '4704', 24, '2026-12-24', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (18, 20, 'Eduarda Duarte', 'Cartao de Debito', '6525', 1, '2026-12-01', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (19, 21, 'Vitor Costa', 'Pix', NULL, 17, '2026-12-17', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (20, 22, 'Ana Torres', 'Pix', NULL, 9, '2026-12-09', 0);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (21, 24, 'Tiago Oliveira', 'Cartao de Debito', '7998', 5, '2026-12-05', 0);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (22, 25, 'Úrsula Oliveira', 'Cartao de Credito', '2359', 18, '2026-12-18', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (23, 26, 'Lucas Torres', 'Cartao de Credito', '5881', 15, '2026-12-15', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (24, 27, 'Bruno Pereira', 'Pix', NULL, 20, '2026-12-20', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (25, 28, 'Tiago Mendes', 'Boleto', NULL, 2, '2026-12-02', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (26, 29, 'Karina Duarte', 'Boleto', NULL, 11, '2026-12-11', 0);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (27, 30, 'Quitéria Barbosa', 'Cartao de Debito', '1291', 15, '2026-12-15', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (28, 31, 'Tiago Nunes', 'Pix', NULL, 12, '2026-12-12', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (29, 32, 'Gabriela Torres', 'Boleto', NULL, 27, '2026-12-27', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (30, 33, 'Úrsula Martins', 'Boleto', NULL, 27, '2026-12-27', 0);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (31, 34, 'Yasmin Alves', 'Boleto', NULL, 4, '2026-12-04', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (32, 35, 'João Costa', 'Cartao de Debito', '4862', 2, '2026-12-02', 0);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (33, 36, 'Olívia Costa', 'Cartao de Credito', '9669', 2, '2026-12-02', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (34, 37, 'Úrsula Moreira', 'Cartao de Credito', '8644', 15, '2026-12-15', 1);
INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento, ultimos_quatro_digitos, dia_vencimento, data_proxima_cobranca, cobranca_ativa) VALUES (35, 38, 'Lucas Cardoso', 'Boleto', NULL, 4, '2026-12-04', 0);

-- ----------------------------------------------------------
-- PERFIL (60)
-- Cada conta de 1 a 38 tem de 1 a 4 perfis. O nome do perfil não se repete na mesma conta.
-- ----------------------------------------------------------
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (1, 1, 'Rafael', 'verde', '2024-12-20', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (2, 2, 'Lucas', 'vermelho', '2022-12-04', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (3, 2, 'Sala', 'amarelo', '2022-12-09', 0, '3906');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (4, 2, 'Kids', 'kids', '2022-12-09', 1, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (5, 2, 'Casal', 'padrao', '2022-11-27', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (6, 3, 'Diego', 'vermelho', '2024-02-26', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (7, 3, 'Kids', 'kids', '2024-03-15', 1, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (8, 4, 'João', 'amarelo', '2022-09-17', 0, '7803');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (9, 5, 'Lucas', 'vermelho', '2024-01-07', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (10, 5, 'Sala', 'amarelo', '2023-12-22', 0, '0557');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (11, 6, 'Zeca', 'amarelo', '2023-07-08', 0, '3949');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (12, 6, 'Avós', 'amarelo', '2023-06-28', 0, '7073');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (13, 7, 'Karina', 'amarelo', '2026-01-27', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (14, 7, 'Casal', 'padrao', '2026-02-09', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (15, 8, 'Karina', 'amarelo', '2025-11-14', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (16, 8, 'Casal', 'vermelho', '2025-11-24', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (17, 9, 'Lucas', 'vermelho', '2023-03-24', 0, '1731');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (18, 9, 'Avós', 'azul', '2023-03-18', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (19, 10, 'Yasmin', 'amarelo', '2023-07-11', 0, '2768');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (20, 10, 'Convidado', 'padrao', '2023-07-11', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (21, 11, 'Isabela', 'padrao', '2023-05-01', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (22, 11, 'Kids', 'kids', '2023-05-17', 1, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (23, 12, 'Rafael', 'amarelo', '2025-07-23', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (24, 13, 'Ana', 'amarelo', '2023-12-12', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (25, 14, 'Zeca', 'amarelo', '2026-10-22', 0, '7650');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (26, 15, 'Lucas', 'azul', '2022-02-11', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (27, 16, 'Wesley', 'vermelho', '2026-09-03', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (28, 17, 'Pedro', 'verde', '2025-08-02', 0, '1073');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (29, 17, 'Casal', 'vermelho', '2025-08-25', 0, '0714');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (30, 18, 'Isabela', 'azul', '2024-12-07', 0, '8954');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (31, 19, 'Úrsula', 'amarelo', '2025-01-25', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (32, 20, 'Eduarda', 'amarelo', '2024-08-18', 0, '0872');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (33, 21, 'Vitor', 'vermelho', '2025-12-30', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (34, 21, 'Kids', 'kids', '2026-01-04', 1, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (35, 22, 'Ana', 'amarelo', '2022-04-04', 0, '6321');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (36, 22, 'Convidado', 'amarelo', '2022-04-07', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (37, 23, 'Yasmin', 'amarelo', '2024-08-28', 0, '2696');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (38, 24, 'Tiago', 'verde', '2026-09-27', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (39, 25, 'Úrsula', 'azul', '2023-06-18', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (40, 25, 'Casal', 'padrao', '2023-06-27', 0, '5641');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (41, 26, 'Lucas', 'amarelo', '2023-10-09', 0, '9287');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (42, 26, 'Avós', 'azul', '2023-10-06', 0, '7771');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (43, 27, 'Bruno', 'azul', '2026-02-10', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (44, 28, 'Tiago', 'azul', '2024-12-05', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (45, 29, 'Karina', 'padrao', '2026-05-05', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (46, 30, 'Quitéria', 'vermelho', '2025-08-05', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (47, 30, 'Visitante', 'amarelo', '2025-08-14', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (48, 31, 'Tiago', 'padrao', '2024-06-17', 0, '9687');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (49, 31, 'Casal', 'vermelho', '2024-06-25', 0, '1893');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (50, 32, 'Gabriela', 'amarelo', '2022-10-28', 0, '4976');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (51, 33, 'Úrsula', 'amarelo', '2023-01-28', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (52, 34, 'Yasmin', 'padrao', '2026-07-01', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (53, 34, 'Casal', 'azul', '2026-07-23', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (54, 35, 'João', 'azul', '2025-12-09', 0, '7724');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (55, 35, 'Sala', 'vermelho', '2025-11-23', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (56, 35, 'Quarto', 'amarelo', '2025-12-06', 0, '0065');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (57, 36, 'Olívia', 'vermelho', '2025-11-23', 0, NULL);
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (58, 37, 'Úrsula', 'verde', '2023-10-08', 0, '9969');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (59, 37, 'Casal', 'vermelho', '2023-09-26', 0, '0082');
INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infantil, pin) VALUES (60, 38, 'Lucas', 'verde', '2022-11-28', 0, '3726');

-- ----------------------------------------------------------
-- CONFIGURACAO_PERFIL (50)
-- Relacionamento 1:1 com perfil. Os perfis 51 a 60 não têm configuração.
-- ----------------------------------------------------------
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (1, 1, 'Portugues', 'Espanhol', 1, 1, 'Media', '2025-11-01 16:28:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (2, 2, 'Espanhol', 'Espanhol', 1, 1, 'Baixa', '2025-06-22 11:39:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (3, 3, 'Espanhol', 'Portugues', 0, 0, 'Baixa', '2026-02-18 15:55:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (4, 4, 'Portugues', 'Portugues', 0, 0, 'Media', '2025-05-12 18:41:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (5, 5, 'Espanhol', 'Espanhol', 0, 1, 'Alta', '2025-11-07 20:44:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (6, 6, 'Portugues', 'Ingles', 1, 0, 'Automatica', '2026-06-05 17:02:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (7, 7, 'Espanhol', 'Portugues', 1, 0, 'Media', '2026-08-18 12:28:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (8, 8, 'Ingles', 'Espanhol', 1, 0, 'Alta', '2025-11-11 09:51:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (9, 9, 'Espanhol', 'Portugues', 1, 1, 'Baixa', '2026-02-28 15:44:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (10, 10, 'Espanhol', 'Portugues', 1, 1, 'Alta', '2026-06-03 19:53:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (11, 11, 'Portugues', 'Espanhol', 1, 0, 'Automatica', '2026-03-08 21:24:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (12, 12, 'Espanhol', 'Ingles', 0, 1, 'Alta', '2026-01-22 19:55:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (13, 13, 'Portugues', 'Portugues', 0, 0, 'Automatica', '2026-05-18 20:30:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (14, 14, 'Portugues', 'Espanhol', 1, 0, 'Baixa', '2025-02-01 10:06:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (15, 15, 'Portugues', 'Portugues', 1, 0, 'Media', '2026-09-08 19:40:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (16, 16, 'Espanhol', 'Portugues', 1, 0, 'Baixa', '2025-11-15 08:06:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (17, 17, 'Portugues', 'Ingles', 1, 0, 'Media', '2026-10-05 21:06:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (18, 18, 'Portugues', 'Portugues', 1, 1, 'Baixa', '2026-09-01 13:07:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (19, 19, 'Portugues', 'Ingles', 0, 0, 'Media', '2026-04-23 11:58:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (20, 20, 'Espanhol', 'Espanhol', 0, 0, 'Automatica', '2026-04-20 21:56:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (21, 21, 'Portugues', 'Espanhol', 1, 0, 'Media', '2026-05-02 19:47:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (22, 22, 'Portugues', 'Portugues', 1, 0, 'Media', '2026-10-18 10:16:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (23, 23, 'Espanhol', 'Portugues', 0, 1, 'Automatica', '2025-12-25 13:00:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (24, 24, 'Portugues', 'Portugues', 1, 1, 'Baixa', '2026-03-22 11:44:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (25, 25, 'Portugues', 'Ingles', 0, 1, 'Automatica', '2026-08-15 16:20:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (26, 26, 'Ingles', 'Portugues', 1, 1, 'Automatica', '2026-09-12 13:33:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (27, 27, 'Ingles', 'Ingles', 0, 1, 'Alta', '2025-09-15 22:18:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (28, 28, 'Ingles', 'Ingles', 0, 1, 'Alta', '2026-03-29 13:22:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (29, 29, 'Espanhol', 'Ingles', 1, 1, 'Automatica', '2026-09-13 15:00:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (30, 30, 'Portugues', 'Portugues', 1, 1, 'Baixa', '2026-10-16 11:42:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (31, 31, 'Portugues', 'Espanhol', 1, 1, 'Alta', '2026-04-18 20:43:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (32, 32, 'Portugues', 'Ingles', 1, 1, 'Media', '2026-08-22 18:36:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (33, 33, 'Ingles', 'Ingles', 0, 1, 'Media', '2025-12-26 16:50:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (34, 34, 'Ingles', 'Portugues', 1, 1, 'Media', '2025-02-15 08:55:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (35, 35, 'Portugues', 'Portugues', 1, 0, 'Automatica', '2025-12-05 21:16:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (36, 36, 'Ingles', 'Ingles', 1, 1, 'Automatica', '2025-07-31 14:03:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (37, 37, 'Portugues', 'Portugues', 0, 0, 'Baixa', '2026-09-26 22:06:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (38, 38, 'Espanhol', 'Portugues', 1, 1, 'Alta', '2025-02-25 17:08:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (39, 39, 'Portugues', 'Espanhol', 0, 0, 'Automatica', '2025-04-18 10:37:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (40, 40, 'Ingles', 'Portugues', 0, 1, 'Alta', '2025-01-25 17:26:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (41, 41, 'Portugues', 'Portugues', 1, 1, 'Automatica', '2025-02-22 21:19:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (42, 42, 'Portugues', 'Ingles', 1, 1, 'Automatica', '2026-09-14 20:45:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (43, 43, 'Portugues', 'Portugues', 1, 1, 'Media', '2026-05-05 22:40:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (44, 44, 'Portugues', 'Portugues', 1, 0, 'Automatica', '2026-03-17 14:17:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (45, 45, 'Ingles', 'Portugues', 1, 0, 'Automatica', '2025-11-26 13:48:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (46, 46, 'Portugues', 'Portugues', 0, 0, 'Media', '2026-01-31 10:23:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (47, 47, 'Ingles', 'Portugues', 0, 1, 'Alta', '2025-04-05 16:35:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (48, 48, 'Portugues', 'Portugues', 1, 1, 'Automatica', '2025-11-07 11:52:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (49, 49, 'Espanhol', 'Portugues', 1, 0, 'Media', '2026-07-26 19:50:00');
INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, idioma_legenda, legendas_ativas, reproducao_automatica, qualidade_preferida, data_atualizacao) VALUES (50, 50, 'Portugues', 'Portugues', 0, 0, 'Alta', '2025-09-16 11:24:00');

-- ----------------------------------------------------------
-- TEMPORADA (32)
-- Somente as séries (títulos 1 a 14) têm temporadas.
-- ----------------------------------------------------------
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (1, 1, 1, 'Temporada 1', 2014, '2014-05-19', 'Temporada 1 de Sombras da Capital.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (2, 1, 2, 'Temporada 2', 2015, '2015-06-07', 'Temporada 2 de Sombras da Capital.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (3, 1, 3, 'Temporada 3', 2016, '2016-03-12', 'Temporada 3 de Sombras da Capital.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (4, 2, 1, 'Temporada 1', 2012, '2012-11-20', 'Temporada 1 de O Último Verão.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (5, 2, 2, NULL, 2013, '2013-05-26', 'Temporada 2 de O Último Verão.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (6, 2, 3, NULL, 2014, '2014-09-02', 'Temporada 3 de O Último Verão.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (7, 3, 1, NULL, 2012, '2012-06-28', 'Temporada 1 de Código Zero.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (8, 3, 2, 'Temporada 2', 2013, '2013-12-09', 'Temporada 2 de Código Zero.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (9, 4, 1, 'Temporada 1', 2012, '2012-01-10', 'Temporada 1 de Ilha dos Esquecidos.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (10, 4, 2, NULL, 2013, '2013-08-13', 'Temporada 2 de Ilha dos Esquecidos.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (11, 5, 1, 'Temporada 1', 2022, '2022-12-04', 'Temporada 1 de Herdeiros do Sertão.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (12, 5, 2, NULL, 2023, '2023-02-09', 'Temporada 2 de Herdeiros do Sertão.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (13, 6, 1, 'Temporada 1', 2017, '2017-07-03', 'Temporada 1 de Linha do Tempo.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (14, 6, 2, 'Temporada 2', 2018, '2018-05-10', 'Temporada 2 de Linha do Tempo.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (15, 6, 3, 'Temporada 3', 2019, '2019-12-27', 'Temporada 3 de Linha do Tempo.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (16, 7, 1, NULL, 2022, '2022-02-10', 'Temporada 1 de A Casa Branca.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (17, 7, 2, 'Temporada 2', 2023, '2023-02-07', 'Temporada 2 de A Casa Branca.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (18, 8, 1, 'Temporada 1', 2012, '2012-09-01', 'Temporada 1 de Noite em Neon.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (19, 8, 2, 'Temporada 2', 2013, '2013-06-07', 'Temporada 2 de Noite em Neon.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (20, 9, 1, 'Temporada 1', 2015, '2015-06-04', 'Temporada 1 de Cidade Submersa.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (21, 9, 2, 'Temporada 2', 2016, '2016-09-27', 'Temporada 2 de Cidade Submersa.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (22, 10, 1, NULL, 2022, '2022-06-18', 'Temporada 1 de Os Guardiões do Norte.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (23, 10, 2, 'Temporada 2', 2023, '2023-04-02', 'Temporada 2 de Os Guardiões do Norte.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (24, 11, 1, NULL, 2025, '2025-11-19', 'Temporada 1 de Quarto 404.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (25, 11, 2, 'Temporada 2', 2026, '2026-11-16', 'Temporada 2 de Quarto 404.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (26, 12, 1, 'Temporada 1', 2016, '2016-01-21', 'Temporada 1 de Rota 66 Brasil.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (27, 12, 2, 'Temporada 2', 2017, '2017-06-07', 'Temporada 2 de Rota 66 Brasil.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (28, 12, 3, 'Temporada 3', 2018, '2018-05-18', 'Temporada 3 de Rota 66 Brasil.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (29, 13, 1, 'Temporada 1', 2023, '2023-06-26', 'Temporada 1 de Sinal Perdido.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (30, 13, 2, 'Temporada 2', 2024, '2024-02-21', 'Temporada 2 de Sinal Perdido.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (31, 14, 1, 'Temporada 1', 2023, '2023-01-14', 'Temporada 1 de Fronteira Sul.', 1);
INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lancamento, data_estreia, sinopse, disponivel) VALUES (32, 14, 2, 'Temporada 2', 2024, '2024-11-02', 'Temporada 2 de Fronteira Sul.', 1);

-- ----------------------------------------------------------
-- EPISODIO (60)
-- Os episódios cobrem as temporadas 1 a 20. As temporadas 21 a 32 ainda não têm episódios.
-- ----------------------------------------------------------
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (1, 1, 1, 'A Chegada (1)', 'Episódio 1 da temporada 1.', 53, '2014-05-19', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (2, 1, 2, 'O Preço (2)', 'Episódio 2 da temporada 1.', 59, '2014-05-26', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (3, 1, 3, 'O Plano (3)', 'Episódio 3 da temporada 1.', 50, '2014-06-02', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (4, 2, 1, 'Revelações (1)', 'Episódio 1 da temporada 2.', 60, '2015-06-07', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (5, 2, 2, 'Ponto de Virada (2)', 'Episódio 2 da temporada 2.', 41, '2015-06-14', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (6, 2, 3, 'Sombras (3)', 'Episódio 3 da temporada 2.', 41, '2015-06-21', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (7, 3, 1, 'A Escolha (1)', 'Episódio 1 da temporada 3.', 51, '2016-03-12', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (8, 3, 2, 'A Escolha (2)', 'Episódio 2 da temporada 3.', 58, '2016-03-19', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (9, 3, 3, 'Reencontro (3)', 'Episódio 3 da temporada 3.', 46, '2016-03-26', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (10, 4, 1, 'Reencontro (1)', 'Episódio 1 da temporada 1.', 52, '2012-11-20', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (11, 4, 2, 'O Começo (2)', 'Episódio 2 da temporada 1.', 41, '2012-11-27', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (12, 4, 3, 'A Chegada (3)', 'Episódio 3 da temporada 1.', 61, '2012-12-04', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (13, 5, 1, 'Fuga (1)', 'Episódio 1 da temporada 2.', 53, '2013-05-26', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (14, 5, 2, 'Ponto de Virada (2)', 'Episódio 2 da temporada 2.', 43, '2013-06-02', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (15, 5, 3, 'A Verdade (3)', 'Episódio 3 da temporada 2.', 58, '2013-06-09', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (16, 6, 1, 'O Preço (1)', 'Episódio 1 da temporada 3.', 44, '2014-09-02', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (17, 6, 2, 'Clímax (2)', 'Episódio 2 da temporada 3.', 47, '2014-09-09', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (18, 6, 3, 'Pontos Cegos (3)', 'Episódio 3 da temporada 3.', 47, '2014-09-16', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (19, 7, 1, 'Despedida (1)', 'Episódio 1 da temporada 1.', 47, '2012-06-28', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (20, 7, 2, 'Despedida (2)', 'Episódio 2 da temporada 1.', 51, '2012-07-05', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (21, 7, 3, 'A Decisão (3)', 'Episódio 3 da temporada 1.', 51, '2012-07-12', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (22, 8, 1, 'Reencontro (1)', 'Episódio 1 da temporada 2.', 40, '2013-12-09', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (23, 8, 2, 'A Verdade (2)', 'Episódio 2 da temporada 2.', 50, '2013-12-16', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (24, 8, 3, 'Ponto de Virada (3)', 'Episódio 3 da temporada 2.', 44, '2013-12-23', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (25, 9, 1, 'Clímax (1)', 'Episódio 1 da temporada 1.', 55, '2012-01-10', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (26, 9, 2, 'Clímax (2)', 'Episódio 2 da temporada 1.', 56, '2012-01-17', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (27, 9, 3, 'O Plano (3)', 'Episódio 3 da temporada 1.', 46, '2012-01-24', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (28, 10, 1, 'Alianças (1)', 'Episódio 1 da temporada 2.', 60, '2013-08-13', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (29, 10, 2, 'A Escolha (2)', 'Episódio 2 da temporada 2.', 61, '2013-08-20', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (30, 10, 3, 'Alianças (3)', 'Episódio 3 da temporada 2.', 55, '2013-08-27', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (31, 11, 1, 'Segredos (1)', 'Episódio 1 da temporada 1.', 44, '2022-12-04', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (32, 11, 2, 'Sombras (2)', 'Episódio 2 da temporada 1.', 43, '2022-12-11', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (33, 11, 3, 'Segredos (3)', 'Episódio 3 da temporada 1.', 52, '2022-12-18', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (34, 12, 1, 'Pontos Cegos (1)', 'Episódio 1 da temporada 2.', 45, '2023-02-09', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (35, 12, 2, 'A Escolha (2)', 'Episódio 2 da temporada 2.', 47, '2023-02-16', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (36, 12, 3, 'Clímax (3)', 'Episódio 3 da temporada 2.', 51, '2023-02-23', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (37, 13, 1, 'Recomeço (1)', 'Episódio 1 da temporada 1.', 52, '2017-07-03', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (38, 13, 2, 'A Chegada (2)', 'Episódio 2 da temporada 1.', 46, '2017-07-10', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (39, 13, 3, 'Ruptura (3)', 'Episódio 3 da temporada 1.', 60, '2017-07-17', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (40, 14, 1, 'Segredos (1)', 'Episódio 1 da temporada 2.', 58, '2018-05-10', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (41, 14, 2, 'A Chegada (2)', 'Episódio 2 da temporada 2.', 46, '2018-05-17', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (42, 14, 3, 'Recomeço (3)', 'Episódio 3 da temporada 2.', 48, '2018-05-24', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (43, 15, 1, 'Segredos (1)', 'Episódio 1 da temporada 3.', 62, '2019-12-27', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (44, 15, 2, 'A Verdade (2)', 'Episódio 2 da temporada 3.', 54, '2020-01-03', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (45, 15, 3, 'Fuga (3)', 'Episódio 3 da temporada 3.', 51, '2020-01-10', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (46, 16, 1, 'Alianças (1)', 'Episódio 1 da temporada 1.', 51, '2022-02-10', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (47, 16, 2, 'Segredos (2)', 'Episódio 2 da temporada 1.', 41, '2022-02-17', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (48, 16, 3, 'Sombras (3)', 'Episódio 3 da temporada 1.', 41, '2022-02-24', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (49, 17, 1, 'A Chegada (1)', 'Episódio 1 da temporada 2.', 54, '2023-02-07', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (50, 17, 2, 'O Preço (2)', 'Episódio 2 da temporada 2.', 45, '2023-02-14', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (51, 17, 3, 'Alianças (3)', 'Episódio 3 da temporada 2.', 56, '2023-02-21', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (52, 18, 1, 'Alianças (1)', 'Episódio 1 da temporada 1.', 45, '2012-09-01', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (53, 18, 2, 'Sombras (2)', 'Episódio 2 da temporada 1.', 57, '2012-09-08', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (54, 18, 3, 'Sombras (3)', 'Episódio 3 da temporada 1.', 38, '2012-09-15', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (55, 19, 1, 'Ruptura (1)', 'Episódio 1 da temporada 2.', 43, '2013-06-07', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (56, 19, 2, 'Silêncio (2)', 'Episódio 2 da temporada 2.', 46, '2013-06-14', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (57, 19, 3, 'O Plano (3)', 'Episódio 3 da temporada 2.', 46, '2013-06-21', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (58, 20, 1, 'Recomeço (1)', 'Episódio 1 da temporada 1.', 54, '2015-06-04', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (59, 20, 2, 'Segredos (2)', 'Episódio 2 da temporada 1.', 62, '2015-06-11', 1);
INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodio, sinopse, duracao_minutos, data_estreia, disponivel) VALUES (60, 20, 3, 'A Decisão (3)', 'Episódio 3 da temporada 1.', 42, '2015-06-18', 1);

-- ----------------------------------------------------------
-- TITULO_CATEGORIA (87)
-- Relacionamento N:N entre titulo e categoria. Os títulos 39 e 40 não têm categoria.
-- A primeira categoria de cada título é a principal.
-- ----------------------------------------------------------
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (1, 1, 20, 1, 1, '2021-11-15');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (2, 1, 13, 0, 2, '2021-11-15');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (3, 2, 22, 1, 1, '2021-11-18');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (4, 2, 6, 0, 2, '2021-11-18');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (5, 3, 10, 1, 1, '2020-01-31');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (6, 3, 22, 0, 2, '2020-01-31');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (7, 3, 8, 0, 3, '2020-01-31');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (8, 4, 13, 1, 1, '2020-05-18');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (9, 4, 21, 0, 2, '2020-05-18');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (10, 5, 22, 1, 1, '2025-03-26');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (11, 5, 9, 0, 2, '2025-03-26');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (12, 6, 6, 1, 1, '2024-02-11');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (13, 6, 9, 0, 2, '2024-02-11');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (14, 6, 13, 0, 3, '2024-02-11');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (15, 7, 8, 1, 1, '2026-01-02');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (16, 7, 6, 0, 2, '2026-01-02');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (17, 8, 6, 1, 1, '2022-07-18');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (18, 8, 13, 0, 2, '2022-07-18');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (19, 9, 21, 1, 1, '2024-03-10');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (20, 9, 10, 0, 2, '2024-03-10');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (21, 9, 6, 0, 3, '2024-03-10');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (22, 10, 6, 1, 1, '2025-11-06');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (23, 10, 2, 0, 2, '2025-11-06');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (24, 11, 6, 1, 1, '2025-09-15');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (25, 11, 13, 0, 2, '2025-09-15');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (26, 12, 13, 1, 1, '2019-08-25');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (27, 12, 8, 0, 2, '2019-08-25');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (28, 12, 2, 0, 3, '2019-08-25');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (29, 13, 6, 1, 1, '2023-02-18');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (30, 13, 12, 0, 2, '2023-02-18');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (31, 14, 13, 1, 1, '2024-08-16');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (32, 14, 10, 0, 2, '2024-08-16');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (33, 15, 13, 1, 1, '2025-08-31');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (34, 15, 5, 0, 2, '2025-08-31');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (35, 15, 20, 0, 3, '2025-08-31');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (36, 16, 1, 1, 1, '2024-11-03');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (37, 16, 9, 0, 2, '2024-11-03');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (38, 17, 13, 1, 1, '2020-04-06');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (39, 17, 1, 0, 2, '2020-04-06');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (40, 18, 5, 1, 1, '2019-06-02');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (41, 18, 1, 0, 2, '2019-06-02');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (42, 18, 8, 0, 3, '2019-06-02');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (43, 19, 14, 1, 1, '2026-04-07');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (44, 19, 22, 0, 2, '2026-04-07');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (45, 20, 13, 1, 1, '2020-06-01');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (46, 20, 22, 0, 2, '2020-06-01');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (47, 21, 18, 1, 1, '2021-09-07');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (48, 21, 14, 0, 2, '2021-09-07');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (49, 21, 22, 0, 3, '2021-09-07');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (50, 22, 19, 1, 1, '2021-01-21');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (51, 22, 2, 0, 2, '2021-01-21');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (52, 23, 22, 1, 1, '2025-01-13');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (53, 23, 12, 0, 2, '2025-01-13');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (54, 24, 18, 1, 1, '2026-03-17');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (55, 24, 12, 0, 2, '2026-03-17');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (56, 24, 2, 0, 3, '2026-03-17');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (57, 25, 22, 1, 1, '2025-01-25');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (58, 25, 2, 0, 2, '2025-01-25');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (59, 26, 8, 1, 1, '2020-07-21');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (60, 26, 12, 0, 2, '2020-07-21');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (61, 27, 5, 1, 1, '2025-03-15');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (62, 27, 9, 0, 2, '2025-03-15');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (63, 27, 2, 0, 3, '2025-03-15');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (64, 28, 2, 1, 1, '2025-09-29');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (65, 28, 1, 0, 2, '2025-09-29');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (66, 29, 23, 1, 1, '2023-07-24');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (67, 29, 7, 0, 2, '2023-07-24');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (68, 30, 23, 1, 1, '2026-10-05');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (69, 30, 22, 0, 2, '2026-10-05');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (70, 30, 7, 0, 3, '2026-10-05');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (71, 31, 7, 1, 1, '2026-08-13');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (72, 31, 24, 0, 2, '2026-08-13');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (73, 32, 7, 1, 1, '2023-06-23');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (74, 32, 23, 0, 2, '2023-06-23');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (75, 33, 7, 1, 1, '2025-07-18');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (76, 33, 22, 0, 2, '2025-07-18');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (77, 33, 23, 0, 3, '2025-07-18');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (78, 34, 23, 1, 1, '2023-01-10');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (79, 34, 18, 0, 2, '2023-01-10');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (80, 35, 25, 1, 1, '2026-07-21');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (81, 35, 4, 0, 2, '2026-07-21');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (82, 36, 25, 1, 1, '2023-08-09');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (83, 36, 4, 0, 2, '2023-08-09');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (84, 37, 4, 1, 1, '2026-09-25');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (85, 37, 25, 0, 2, '2026-09-25');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (86, 38, 4, 1, 1, '2024-12-19');
INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, categoria_principal, ordem_exibicao, data_associacao) VALUES (87, 38, 25, 0, 2, '2024-12-19');

-- ----------------------------------------------------------
-- PARTICIPACAO (128)
-- Relacionamento N:N entre pessoa e titulo. Pessoas 37 a 40 não participam de nenhum título.
-- Uma mesma pessoa pode ter funções diferentes no mesmo título (ex.: Diretor e Ator).
-- ----------------------------------------------------------
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (1, 12, 1, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (2, 3, 1, 'Ator', 'Marcos', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (3, 9, 1, 'Ator', 'Lívia', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (4, 29, 2, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (5, 6, 2, 'Roteirista', NULL, 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (6, 29, 2, 'Ator', 'Caio', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (7, 2, 2, 'Ator', 'Rui', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (8, 32, 3, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (9, 11, 3, 'Ator', 'Otávio', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (10, 33, 3, 'Ator', 'Marcos', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (11, 13, 4, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (12, 4, 4, 'Roteirista', NULL, 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (13, 32, 4, 'Ator', 'Nina', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (14, 7, 4, 'Ator', 'Dora', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (15, 27, 5, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (16, 36, 5, 'Roteirista', NULL, 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (17, 9, 5, 'Ator', 'Saulo', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (18, 7, 5, 'Ator', 'Beatriz', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (19, 32, 6, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (20, 31, 6, 'Ator', 'Rui', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (21, 21, 6, 'Ator', 'Beatriz', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (22, 35, 6, 'Ator', 'Rui', 0, 3);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (23, 4, 7, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (24, 15, 7, 'Roteirista', NULL, 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (25, 7, 7, 'Ator', 'Lívia', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (26, 32, 7, 'Ator', 'Lívia', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (27, 34, 7, 'Ator', 'Clara', 0, 3);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (28, 21, 8, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (29, 13, 8, 'Roteirista', NULL, 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (30, 36, 8, 'Ator', 'Pablo', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (31, 6, 8, 'Ator', 'Clara', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (32, 18, 8, 'Ator', 'Marcos', 0, 3);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (33, 30, 9, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (34, 25, 9, 'Ator', 'Beatriz', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (35, 15, 9, 'Ator', 'Pablo', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (36, 27, 10, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (37, 10, 10, 'Roteirista', NULL, 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (38, 2, 10, 'Ator', 'Nina', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (39, 12, 10, 'Ator', 'Helena', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (40, 34, 11, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (41, 20, 11, 'Ator', 'Clara', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (42, 10, 11, 'Ator', 'Helena', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (43, 19, 12, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (44, 11, 12, 'Roteirista', NULL, 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (45, 30, 12, 'Ator', 'Pablo', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (46, 2, 12, 'Ator', 'Nina', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (47, 24, 13, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (48, 4, 13, 'Roteirista', NULL, 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (49, 35, 13, 'Ator', 'Dora', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (50, 36, 13, 'Ator', 'Caio', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (51, 1, 14, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (52, 21, 14, 'Roteirista', NULL, 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (53, 30, 14, 'Ator', 'Dora', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (54, 4, 14, 'Ator', 'Marcos', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (55, 15, 15, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (56, 10, 15, 'Roteirista', NULL, 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (57, 12, 15, 'Ator', 'Lívia', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (58, 24, 15, 'Ator', 'Pablo', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (59, 28, 15, 'Ator', 'Pablo', 0, 3);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (60, 13, 16, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (61, 34, 16, 'Ator', 'Clara', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (62, 30, 16, 'Ator', 'Lívia', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (63, 3, 16, 'Ator', 'Nina', 0, 3);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (64, 33, 17, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (65, 26, 17, 'Roteirista', NULL, 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (66, 12, 17, 'Ator', 'Marcos', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (67, 13, 17, 'Ator', 'Dora', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (68, 23, 18, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (69, 30, 18, 'Roteirista', NULL, 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (70, 2, 18, 'Ator', 'Clara', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (71, 9, 18, 'Ator', 'Otávio', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (72, 35, 19, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (73, 26, 19, 'Roteirista', NULL, 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (74, 14, 19, 'Ator', 'Beatriz', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (75, 15, 19, 'Ator', 'Clara', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (76, 32, 19, 'Ator', 'Beatriz', 0, 3);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (77, 26, 20, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (78, 3, 20, 'Ator', 'Marcos', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (79, 13, 20, 'Ator', 'Pablo', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (80, 24, 20, 'Ator', 'Marcos', 0, 3);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (81, 4, 21, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (82, 28, 21, 'Ator', 'Otávio', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (83, 32, 21, 'Ator', 'Marcos', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (84, 31, 22, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (85, 8, 22, 'Roteirista', NULL, 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (86, 18, 22, 'Ator', 'Otávio', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (87, 16, 22, 'Ator', 'Nina', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (88, 24, 23, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (89, 22, 23, 'Roteirista', NULL, 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (90, 3, 23, 'Ator', 'Saulo', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (91, 36, 23, 'Ator', 'Nina', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (92, 27, 23, 'Ator', 'Dora', 0, 3);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (93, 2, 24, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (94, 17, 24, 'Ator', 'Otávio', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (95, 7, 24, 'Ator', 'Lívia', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (96, 5, 24, 'Ator', 'Helena', 0, 3);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (97, 13, 25, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (98, 10, 25, 'Ator', 'Clara', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (99, 23, 25, 'Ator', 'Helena', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (100, 11, 26, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (101, 11, 26, 'Roteirista', NULL, 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (102, 24, 26, 'Ator', 'Pablo', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (103, 8, 26, 'Ator', 'Marcos', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (104, 18, 27, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (105, 9, 27, 'Roteirista', NULL, 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (106, 8, 27, 'Ator', 'Dora', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (107, 14, 27, 'Ator', 'Beatriz', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (108, 2, 28, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (109, 14, 28, 'Ator', 'Dora', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (110, 26, 28, 'Ator', 'Pablo', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (111, 5, 29, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (112, 9, 29, 'Ator', 'Pablo', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (113, 8, 29, 'Ator', 'Pablo', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (114, 12, 30, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (115, 14, 30, 'Ator', 'Caio', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (116, 35, 30, 'Ator', 'Caio', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (117, 32, 30, 'Ator', 'Lívia', 0, 3);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (118, 3, 31, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (119, 1, 31, 'Roteirista', NULL, 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (120, 20, 31, 'Ator', 'Clara', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (121, 19, 31, 'Ator', 'Lívia', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (122, 34, 31, 'Ator', 'Pablo', 0, 3);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (123, 21, 32, 'Diretor', NULL, 0, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (124, 10, 32, 'Roteirista', NULL, 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (125, 9, 32, 'Ator', 'Caio', 1, 1);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (126, 28, 32, 'Ator', 'Beatriz', 0, 2);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (127, 5, 32, 'Ator', 'Nina', 0, 3);
INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_personagem, papel_principal, ordem_credito) VALUES (128, 12, 1, 'Ator', 'Narrador', 0, 9);

-- ----------------------------------------------------------
-- HISTORICO_VISUALIZACAO (80)
-- Relacionamento N:N entre perfil e titulo (um registro por par perfil/título).
-- Somente títulos de 1 a 32 foram sorteados; o minuto_parada nunca passa da duração.
-- ----------------------------------------------------------
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (1, 46, 11, '2026-10-29 05:49:00', '2026-10-29 11:16:00', 55, 1, 'Console');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (2, 29, 26, '2026-10-13 00:23:00', '2026-10-13 01:13:00', 165, 1, 'Console');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (3, 30, 6, '2026-09-10 18:17:00', '2026-09-10 22:20:00', 55, 1, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (4, 43, 24, '2026-10-01 23:48:00', '2026-10-02 00:19:00', 114, 1, 'Notebook');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (5, 24, 30, '2026-08-02 22:56:00', '2026-08-03 08:50:00', 65, 1, 'Celular');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (6, 28, 17, '2026-09-10 01:20:00', '2026-09-10 05:23:00', 105, 1, 'Notebook');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (7, 60, 11, '2026-10-10 18:15:00', '2026-10-11 03:41:00', 30, 0, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (8, 1, 26, '2026-09-21 05:08:00', '2026-09-21 09:38:00', 165, 1, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (9, 20, 3, '2026-09-14 10:18:00', '2026-09-14 18:18:00', 55, 1, 'Celular');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (10, 27, 16, '2026-08-24 04:56:00', '2026-08-24 12:16:00', 110, 1, 'Console');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (11, 59, 1, '2026-10-26 21:50:00', '2026-10-27 03:47:00', 55, 1, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (12, 25, 23, '2026-08-15 12:35:00', '2026-08-15 19:43:00', 140, 0, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (13, 32, 12, '2026-08-09 02:20:00', '2026-08-09 06:44:00', 11, 0, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (14, 3, 29, '2026-10-14 14:32:00', '2026-10-15 00:29:00', 53, 1, 'Console');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (15, 59, 32, '2026-08-17 02:23:00', '2026-08-17 04:28:00', 95, 1, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (16, 34, 32, '2026-10-14 04:51:00', '2026-10-14 05:23:00', 95, 1, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (17, 52, 9, '2026-08-31 10:11:00', '2026-08-31 10:33:00', 2, 0, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (18, 41, 28, '2026-08-27 08:33:00', '2026-08-27 17:36:00', 128, 1, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (19, 32, 10, '2026-08-10 07:38:00', '2026-08-10 14:16:00', 52, 0, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (20, 18, 18, '2026-09-09 13:23:00', '2026-09-09 14:37:00', 100, 0, 'Notebook');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (21, 18, 28, '2026-10-10 01:45:00', '2026-10-10 06:32:00', 128, 1, 'Console');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (22, 14, 8, '2026-10-18 14:56:00', '2026-10-18 23:11:00', 29, 0, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (23, 11, 6, '2026-09-22 03:50:00', '2026-09-22 05:33:00', 54, 0, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (24, 55, 19, '2026-09-24 12:21:00', '2026-09-24 20:03:00', 78, 0, 'Console');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (25, 26, 29, '2026-08-25 06:20:00', '2026-08-25 12:29:00', 5, 0, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (26, 59, 3, '2026-09-08 05:34:00', '2026-09-08 09:25:00', 55, 1, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (27, 47, 28, '2026-10-12 02:41:00', '2026-10-12 11:33:00', 128, 1, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (28, 11, 11, '2026-10-24 17:48:00', '2026-10-24 19:29:00', 55, 1, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (29, 50, 8, '2026-09-01 06:59:00', '2026-09-01 16:47:00', 55, 1, 'Notebook');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (30, 6, 24, '2026-08-06 00:07:00', '2026-08-06 02:27:00', 99, 0, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (31, 24, 10, '2026-09-02 22:55:00', '2026-09-03 00:02:00', 11, 0, 'Celular');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (32, 25, 21, '2026-10-30 06:28:00', '2026-10-30 16:20:00', 121, 0, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (33, 32, 26, '2026-09-09 12:47:00', '2026-09-09 18:00:00', 165, 1, 'Notebook');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (34, 56, 3, '2026-10-17 18:27:00', '2026-10-17 23:01:00', 55, 1, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (35, 5, 19, '2026-10-08 05:32:00', '2026-10-08 10:35:00', 123, 1, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (36, 28, 24, '2026-11-06 01:23:00', '2026-11-06 06:24:00', 114, 1, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (37, 2, 30, '2026-09-18 20:44:00', '2026-09-19 05:47:00', 65, 1, 'Celular');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (38, 35, 8, '2026-08-01 03:17:00', '2026-08-01 05:21:00', 55, 1, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (39, 5, 24, '2026-10-18 00:01:00', '2026-10-18 00:54:00', 114, 1, 'Console');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (40, 2, 13, '2026-10-24 12:24:00', '2026-10-24 21:17:00', 5, 0, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (41, 22, 27, '2026-08-12 17:41:00', '2026-08-12 18:06:00', 89, 1, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (42, 37, 22, '2026-09-22 00:16:00', '2026-09-22 04:55:00', 154, 1, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (43, 24, 7, '2026-10-04 14:10:00', '2026-10-04 22:39:00', 55, 1, 'Console');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (44, 16, 9, '2026-08-13 13:49:00', '2026-08-13 14:49:00', 23, 0, 'Celular');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (45, 37, 3, '2026-08-30 21:36:00', '2026-08-30 22:53:00', 33, 0, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (46, 53, 4, '2026-09-21 14:22:00', '2026-09-21 20:11:00', 55, 1, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (47, 51, 20, '2026-09-02 13:43:00', '2026-09-02 17:39:00', 59, 0, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (48, 42, 25, '2026-11-12 02:03:00', '2026-11-12 09:48:00', 25, 0, 'Notebook');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (49, 34, 21, '2026-09-22 12:37:00', '2026-09-22 15:11:00', 138, 1, 'Celular');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (50, 17, 1, '2026-09-30 16:18:00', '2026-09-30 21:01:00', 33, 0, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (51, 47, 25, '2026-10-07 05:28:00', '2026-10-07 11:52:00', 91, 0, 'Notebook');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (52, 48, 9, '2026-09-29 17:00:00', '2026-09-29 20:15:00', 21, 0, 'Notebook');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (53, 5, 27, '2026-09-09 00:32:00', '2026-09-09 05:09:00', 89, 1, 'Celular');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (54, 26, 6, '2026-09-09 09:45:00', '2026-09-09 16:15:00', 24, 0, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (55, 27, 19, '2026-08-29 16:49:00', '2026-08-30 00:03:00', 83, 0, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (56, 42, 20, '2026-09-08 01:23:00', '2026-09-08 05:45:00', 130, 1, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (57, 59, 6, '2026-09-19 18:38:00', '2026-09-19 22:35:00', 32, 0, 'Celular');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (58, 30, 29, '2026-10-20 17:44:00', '2026-10-21 00:29:00', 53, 1, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (59, 34, 26, '2026-11-12 05:20:00', '2026-11-12 06:44:00', 79, 0, 'Console');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (60, 51, 18, '2026-08-14 15:53:00', '2026-08-15 00:55:00', 101, 1, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (61, 59, 15, '2026-09-16 00:45:00', '2026-09-16 01:41:00', 110, 0, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (62, 41, 21, '2026-10-17 01:06:00', '2026-10-17 05:09:00', 138, 1, 'Celular');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (63, 13, 24, '2026-09-20 05:08:00', '2026-09-20 12:10:00', 15, 0, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (64, 4, 29, '2026-10-03 16:46:00', '2026-10-03 23:27:00', 53, 1, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (65, 10, 18, '2026-10-10 14:38:00', '2026-10-10 21:37:00', 101, 1, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (66, 56, 10, '2026-08-03 07:35:00', '2026-08-03 10:54:00', 18, 0, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (67, 22, 9, '2026-09-30 11:10:00', '2026-09-30 20:46:00', 55, 1, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (68, 44, 24, '2026-10-24 19:21:00', '2026-10-25 03:05:00', 107, 0, 'Notebook');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (69, 25, 32, '2026-11-02 03:29:00', '2026-11-02 07:58:00', 76, 0, 'Notebook');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (70, 32, 30, '2026-11-07 11:42:00', '2026-11-07 17:45:00', 65, 1, 'Celular');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (71, 27, 28, '2026-08-03 02:10:00', '2026-08-03 08:41:00', 128, 1, 'Celular');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (72, 42, 13, '2026-10-14 19:27:00', '2026-10-15 03:57:00', 55, 1, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (73, 47, 32, '2026-10-31 10:16:00', '2026-10-31 16:13:00', 95, 1, 'Notebook');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (74, 58, 12, '2026-09-17 13:45:00', '2026-09-17 19:06:00', 30, 0, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (75, 32, 29, '2026-09-17 09:37:00', '2026-09-17 18:40:00', 13, 0, 'Notebook');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (76, 41, 18, '2026-08-08 15:49:00', '2026-08-08 19:23:00', 101, 1, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (77, 37, 6, '2026-10-20 15:20:00', '2026-10-20 18:24:00', 40, 0, 'TV');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (78, 14, 21, '2026-10-23 01:38:00', '2026-10-23 07:36:00', 138, 1, 'Tablet');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (79, 3, 31, '2026-10-29 12:01:00', '2026-10-29 20:09:00', 44, 0, 'Console');
INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_inicio, data_ultima_visualizacao, minuto_parada, concluido, dispositivo) VALUES (80, 20, 23, '2026-10-26 11:23:00', '2026-10-26 13:02:00', 156, 1, 'Notebook');
