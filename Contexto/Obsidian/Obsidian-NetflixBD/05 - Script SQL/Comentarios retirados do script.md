# Comentários retirados do script

O script ficou só com comentários de **organização** (títulos de parte, nome de cada tabela, título e descrição de cada consulta, regra de cada trigger) e os **essenciais para a professora** (a justificativa dos índices, que a rubrica exige).

As explicações que estavam nele **não foram perdidas**: estão todas aqui, na ordem em que apareciam, cada uma ligada ao comando que vinha logo depois dela.

Para estudar, prefira as notas organizadas por assunto, que têm as fontes da professora e as perguntas prováveis:

- [[Parte 1 - Estrutura (explicacao)]]
- [[Parte 2 - Inserts (explicacao)]]
- [[Parte 3 - Consultas (explicacao)]]
- [[Partes 4 e 5 - Indices e procedures (explicacao)]]
- [[Partes 6 a 9 - Views, triggers, usuarios e transacoes (explicacao)]]

Observação: os números de alguns trechos antigos (como a contagem de inserts) são da versão em que o comentário foi escrito. Os números atuais estão nas notas acima.

## Parte 1 - Estrutura

**Antes de** `DROP DATABASE IF EXISTS NETFLIX;`

> SGBD: MySQL 8
> Implementação fiel ao modelo lógico aprovado
> (Banco de dados/netflix.mwb): 13 tabelas e 12 chaves
> estrangeiras.
> Estilo baseado no bd_supermercado.sql da professora.
> Conteúdo deste arquivo, na ordem dos critérios da atividade:
>   Critério "Estrutura do banco de dados"
>     PARTE 1 - Estrutura (banco e 13 tabelas)
>   Critério "Inserção de dados"
>     PARTE 2 - Inserção de dados (mínimo de 30 INSERT por tabela)
>   Critério "Consultas SQL (queries)"
>     PARTE 3 - Consultas (JOINs, filtros, agrupamentos, ordenação)
>   Critério "Scripts adicionais e índices"
>     PARTE 4 - Índices (com justificativa do campo indexado)
>     PARTE 5 - Stored procedures
>   Critério "Recursos adicionais do banco"
>     PARTE 6 - Views
>     PARTE 7 - Triggers
>     PARTE 8 - Usuários e permissões (GRANT e REVOKE)
>     PARTE 9 - Transações (COMMIT, ROLLBACK e SAVEPOINT)
> Como executar: abra este arquivo no MySQL Workbench e execute
> tudo (o script recria o banco do zero a cada execução).
> Garante recriação limpa do banco (útil para testes)

**Antes de** `CREATE DATABASE IF NOT EXISTS NETFLIX`

> Criação com charset UTF-8 moderno (utf8mb4)

**Antes de** `CREATE TABLE IF NOT EXISTS plano (`

> Ordem de criação:
> uma tabela com chave estrangeira só pode ser criada
> DEPOIS da tabela que ela referencia.
>   Grupo 1 (sem chave estrangeira):
>     plano, categoria, pessoa, titulo
>   Grupo 2:
>     conta (-> plano), temporada (-> titulo)
>   Grupo 3:
>     dados_cobranca (-> conta), perfil (-> conta),
>     episodio (-> temporada)
>   Grupo 4:
>     configuracao_perfil (-> perfil),
>     titulo_categoria (-> titulo, categoria),
>     participacao (-> pessoa, titulo),
>     historico_visualizacao (-> perfil, titulo)

**Antes de** `ON UPDATE CASCADE`

> Não permite excluir um plano que ainda tem contas.

**Antes de** `FOREIGN KEY (id_titulo) REFERENCES titulo (id_titulo)`

> Um título não pode ter duas "Temporada 1".

**Antes de** `CREATE TABLE IF NOT EXISTS dados_cobranca (`

> Relacionamento 1:1 -> o UNIQUE em id_conta garante
> no máximo UMA cobrança por conta.

**Antes de** `FOREIGN KEY (id_conta) REFERENCES conta (id_conta)`

> Uma conta não pode ter dois perfis com o mesmo nome.

**Antes de** `CREATE TABLE IF NOT EXISTS configuracao_perfil (`

> Relacionamento 1:1 -> UNIQUE em id_perfil.

**Antes de** `CREATE TABLE IF NOT EXISTS titulo_categoria (`

> Um título tem várias categorias e uma categoria tem vários títulos.

**Antes de** `FOREIGN KEY (id_titulo) REFERENCES titulo (id_titulo)`

> Não repete a mesma categoria no mesmo título.

**Antes de** `ON UPDATE CASCADE`

> Não permite excluir uma categoria que está em uso.

**Antes de** `CREATE TABLE IF NOT EXISTS participacao (`

> Uma pessoa atua/dirige em vários títulos e um título tem várias pessoas.

**Antes de** `FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa)`

> A mesma pessoa pode ser Ator E Diretor do mesmo título,
> mas não duas vezes na mesma função.

**Antes de** `CREATE TABLE IF NOT EXISTS historico_visualizacao (`

> Registra o que cada perfil assistiu.

**Antes de** `FOREIGN KEY (id_perfil) REFERENCES perfil (id_perfil)`

> Um registro por perfil e título.


## Parte 2 - Inserts

**Antes de** `SET NAMES utf8mb4;`

> Dados fictícios, criados apenas para demonstração
> (nomes, e-mails e hashes de senha não são reais).
> Cada tabela tem no mínimo 30 comandos INSERT (um por linha).
> Os ids são informados de propósito, para deixar as chaves
> estrangeiras fáceis de conferir. Como o banco é recriado do
> zero no início do script, os ids sempre começam em 1.
> A ordem segue a das tabelas: primeiro as tabelas "mãe",
> depois as que têm chave estrangeira.
> garante que os acentos sejam gravados corretamente (ao lado do comando)

**Antes de** `INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, te`

> Os planos 1 a 5 são os regulares.
> Planos sem nenhuma conta (sem correspondência no LEFT JOIN): 8 e 9, 11, 13, 15 a 30.

**Antes de** `INSERT INTO categoria (id_categoria, nome, descricao, codigo_interno, ativa, dat`

> Categorias sem nenhum título (sem correspondência): 3, 5, 9 a 11, 14 a 22, 24 a 30.
> As categorias 28 a 30 estão inativas (ativa = 0).

**Antes de** `INSERT INTO pessoa (id_pessoa, nome, nome_artistico, data_nascimento, nacionalid`

> Pessoas que não participam de nenhum título (sem correspondência): 1, 3 a 5, 10, 12, 16 e 17, 21, 25, 27 a 30.

**Antes de** `INSERT INTO titulo (id_titulo, nome, sinopse, tipo, ano_lancamento, classificaca`

> Títulos 1 a 10: séries. 11 a 22: filmes. 23 a 26: documentários. 27 a 30: stand-ups.
> Títulos nunca assistidos (sem correspondência): 1, 8 e 9, 11 e 12, 17, 25 a 30.
> Séries não têm duração total (duracao_minutos = NULL); a duração fica nos episódios.

**Antes de** `INSERT INTO conta (id_conta, id_plano, email, senha_hash, telefone, pais, data_c`

> Senhas são hashes fictícios, apenas ilustrativos.
> Contas sem perfil: 25 a 32. Contas 7, 16 e 22 estão suspensas; 11 e 24, canceladas.
> São 32 contas (e não 30) para existirem contas sem dados de cobrança.

**Antes de** `INSERT INTO dados_cobranca (id_cobranca, id_conta, nome_titular, forma_pagamento`

> Relacionamento 1:1 com conta. Contas sem dados de cobrança: 5 e 32.
> Contas suspensas ou canceladas têm cobranca_ativa = 0.

**Antes de** `INSERT INTO perfil (id_perfil, id_conta, nome, avatar, data_criacao, perfil_infa`

> As contas 1 a 24 têm perfil; as contas 2, 3, 6, 9 e 12 têm mais de um.
> O nome do perfil não se repete na mesma conta.

**Antes de** `INSERT INTO configuracao_perfil (id_configuracao, id_perfil, idioma_interface, i`

> Relacionamento 1:1 com perfil: uma configuração para cada perfil.

**Antes de** `INSERT INTO temporada (id_temporada, id_titulo, numero_temporada, nome, ano_lanc`

> Somente as séries (títulos 1 a 10) têm temporadas: 3 para cada série.

**Antes de** `INSERT INTO episodio (id_episodio, id_temporada, numero_episodio, titulo_episodi`

> Dois episódios para cada temporada de 1 a 15.
> Temporadas sem episódios (sem correspondência): 16 a 30.

**Antes de** `INSERT INTO titulo_categoria (id_titulo_categoria, id_titulo, id_categoria, cate`

> Relacionamento N:N entre titulo e categoria.
> Os títulos 1, 2, 3, 11 e 12 têm duas categorias; a primeira é a principal.
> Títulos sem categoria (sem correspondência): 26 a 30.

**Antes de** `INSERT INTO participacao (id_participacao, id_pessoa, id_titulo, funcao, nome_pe`

> Relacionamento N:N entre pessoa e titulo.
> No título 1 a mesma pessoa é Diretor e Ator: funções diferentes no mesmo título são permitidas.

**Antes de** `INSERT INTO historico_visualizacao (id_visualizacao, id_perfil, id_titulo, data_`

> Relacionamento N:N entre perfil e titulo (um registro por par perfil/título).
> O minuto_parada nunca passa da duração do título.
> Perfis que nunca assistiram a nada: 1 a 3, 6, 8, 13, 18, 20, 22 a 24, 26 e 27, 29 e 30.


## Parte 3 - Consultas

**Antes de** `SELECT C.email, C.pais, P.nome AS plano, P.valor_mensal`

> Seguem os tipos trabalhados nos exercícios da professora:
>   INNER JOIN ........ consultas 01, 02 e 03
>   LEFT JOIN ......... consultas 04 e 05
>   RIGHT JOIN ........ consultas 06 e 07
>   SELF JOIN ......... consulta  08
>   GROUP BY / HAVING . consultas 09, 11 e 12
>   Filtros (WHERE) ... consulta  10
> Tabelas: conta, plano

**Antes de** `SELECT PF.nome AS perfil, C.email, P.nome AS plano, P.telas_simultaneas`

> Tabelas: perfil, conta, plano

**Antes de** `SELECT PF.nome                              AS perfil,`

> Tabelas: historico_visualizacao, perfil, conta, plano,
>          titulo, titulo_categoria, categoria

**Antes de** `SELECT T.id_titulo, T.nome, T.tipo, T.ano_lancamento`

> Comentário: sem o filtro categoria_principal = 1, cada
> visualização apareceria repetida, uma vez por categoria do título.
> O LEFT JOIN mantém todos os títulos; os que não têm histórico
> ficam com NULL, e o WHERE seleciona exatamente esses.
> Tabelas: titulo, historico_visualizacao

**Antes de** `SELECT C.email,`

> Tabelas: conta, plano, perfil

**Antes de** `SELECT TE.id_temporada, TE.numero_temporada, E.numero_episodio, E.titulo_episodi`

> Comentário: COUNT(PF.id_perfil) conta só valores não nulos.
> COUNT(*) daria 1 para as contas sem perfil.
> Tabelas: episodio, temporada (nesta ordem no FROM)

**Antes de** `SELECT PF.nome                         AS perfil,`

> Comentário: temporada está à DIREITA, então todas as temporadas
> são preservadas. É o LEFT JOIN "espelhado".
> Tabelas: historico_visualizacao, perfil, conta

**Antes de** `SELECT A.nome AS titulo_1, B.nome AS titulo_2, A.tipo, A.ano_lancamento`

> Comentário: COALESCE troca o NULL da soma por 0.
> Tabela: titulo (unida com ela mesma)

**Antes de** `SELECT CA.nome AS categoria, COUNT(*) AS qtd_titulos`

> Comentário: A.id_titulo < B.id_titulo evita o título pareado com
> ele mesmo e os pares repetidos invertidos.
> Tabelas: categoria, titulo_categoria

**Antes de** `SELECT id_conta, email, telefone, status`

> Comentário: WHERE filtra linhas antes de agrupar;
> HAVING filtra os grupos depois do agrupamento.
> Tabela: conta

**Antes de** `SELECT T.nome AS titulo, T.tipo, COUNT(*) AS visualizacoes`

> Tabelas: titulo, historico_visualizacao

**Antes de** `SELECT P.nome                AS plano,`

> Tabelas: plano, conta


## Parte 4 - Índices

**Antes de** `CREATE INDEX idx_titulo_nome ON titulo (nome);`

> Um índice funciona como o índice de um livro: o banco
> encontra as linhas sem precisar ler a tabela inteira.
> Observação: as chaves primárias, as chaves estrangeiras e os
> campos UNIQUE já têm índice criado automaticamente pelo
> MySQL. Por isso os índices abaixo foram criados em campos


## Parte 5 - Stored procedures

**Antes de** `DELIMITER //`

> Uma procedure guarda um bloco de comandos no banco para ser
> executado com CALL.


## Parte 6 - Views

**Antes de** `CREATE VIEW vw_contas_ativas AS`

> Uma VIEW é uma tabela virtual: ela guarda uma consulta
> (SELECT) com um nome. Os dados continuam nas tabelas
> originais; a view só mostra o resultado.
> Mostra os dados da conta SEM a senha (senha_hash fica de fora).

**Antes de** `SELECT * FROM vw_contas_ativas ORDER BY email;`

> Usando a view como se fosse uma tabela:

**Antes de** `CREATE VIEW vw_catalogo AS`

> LEFT JOIN para os títulos sem categoria também aparecerem.


## Parte 7 - Triggers

**Antes de** `DROP TRIGGER IF EXISTS tg_validar_minuto_parada;`

> Estrutura de cada exemplo:
>   1) Comentário explicando a regra e o tipo da trigger
>   2) Criação da trigger
>   3) Comando que faz a trigger ser executada (teste)
>   4) SELECT para conferir o resultado

**Antes de** `BEFORE INSERT ON historico_visualizacao`

> BEFORE executa antes da gravação no banco,
> permitindo alterar ou validar valores

**Antes de** `FOR EACH ROW`

> Executa para cada registro inserido

**Antes de** `IF NEW.minuto_parada < 0 THEN`

> NEW representa o registro que está tentando ser inserido

**Antes de** `SET NEW.minuto_parada = 0;`

> Altera o valor antes da gravação

**Antes de** `SET NEW.dia_vencimento = 28;`

> Modifica o valor antes de salvar

**Antes de** `DROP TRIGGER IF EXISTS tg_validar_valor_plano;`

> No UPDATE existem OLD e NEW ao mesmo tempo:
> OLD é o valor antigo e NEW é o valor novo.

**Antes de** `FOR EACH ROW`

> Executa para cada plano alterado

**Antes de** `SET NEW.valor_mensal = OLD.valor_mensal;`

> Mantém o valor antigo


## Parte 8 - Usuários e permissões

**Antes de** `GRANT SELECT`

> O analista pode visualizar informações, mas não altera nada.

**Antes de** `GRANT SELECT`

> O atendente consulta contas e perfis.

**Antes de** `GRANT UPDATE (status)`

> O atendente pode alterar apenas o status da conta
> (não altera e-mail, senha ou plano).

**Antes de** `GRANT INSERT`

> O setor de catálogo cadastra e consulta títulos.

**Antes de** `GRANT SELECT`

> O financeiro vê a forma de pagamento e o vencimento,
> mas não vê os dígitos do cartão.

**Antes de** `REVOKE INSERT`

> O catálogo não poderá mais inserir títulos,
> mas continua podendo consultar.

**Antes de** `REVOKE UPDATE (status)`

> O atendente deixa de alterar o status da conta.


## Parte 9 - Transações

**Antes de** `START TRANSACTION;`

> START TRANSACTION inicia uma transação
> COMMIT salva definitivamente
> ROLLBACK desfaz alterações ainda não confirmadas
> SAVEPOINT permite desfazer apenas uma parte

**Antes de** `SELECT id_titulo, nome, tipo FROM titulo WHERE id_titulo = 31;`

> Visualiza o título antes da confirmação

**Antes de** `COMMIT;`

> COMMIT confirma a operação

**Antes de** `ROLLBACK;`

> ROLLBACK desfaz tudo desde o START TRANSACTION

**Antes de** `SELECT COUNT(*) AS perfis_da_conta_2 FROM perfil WHERE id_conta = 2;`

> A conta e os perfis sumiram (temporariamente)

**Antes de** `ROLLBACK;`

> Usuário percebeu que apagou a conta errada

**Antes de** `SELECT COUNT(*) AS perfis_da_conta_2 FROM perfil WHERE id_conta = 2;`

> A conta e os perfis voltam a existir

**Antes de** `UPDATE plano`

> Primeira alteração: reajuste de 10% no plano Premium

**Antes de** `SAVEPOINT ajuste_preco;`

> Criando um ponto de retorno

**Antes de** `UPDATE plano`

> Segunda alteração: mudança no número de telas

**Antes de** `ROLLBACK TO ajuste_preco;`

> A alteração de telas estava errada:
> volta apenas até o SAVEPOINT

**Antes de** `COMMIT;`

> O reajuste de preço continua mantido
> A alteração de telas foi desfeita
