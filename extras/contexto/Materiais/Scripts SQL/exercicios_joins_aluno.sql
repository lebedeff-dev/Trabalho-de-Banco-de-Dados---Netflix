-- =====================================================================
-- LISTA DE EXERCÍCIOS — JOINS, UNION e UNION ALL  (versão do aluno)
-- Banco: SUPERMERCADO
-- Pré-requisito: executar bd_supermercado.sql e inserts_supermercado.sql
--
--   INNER JOIN ........ exercícios 01, 02 e 03
--   LEFT JOIN ......... exercícios 04 e 05
--   RIGHT JOIN ........ exercícios 06 e 07
--   SELF JOIN ......... exercício  08
--   UNION ............. exercício  09
--   UNION ALL ......... exercício  10
--
-- Escreva sua consulta abaixo de cada enunciado.
-- =====================================================================

USE SUPERMERCADO;


-- =====================================================================
-- EXERCÍCIO 01 — INNER JOIN — 2 tabelas (básico)
-- =====================================================================
-- Liste o NOME, o CPF, a CIDADE e a UF de todos os clientes cadastrados,
-- em ordem alfabética de nome.
-- Tabelas: PESSOA, CLIENTE
--
-- Sua resposta:




-- =====================================================================
-- EXERCÍCIO 02 — INNER JOIN — 3 tabelas (básico/intermediário)
-- =====================================================================
-- Mostre o código do pedido, a data, o NOME do cliente e o valor total
-- de todos os pedidos CONFIRMADOS, do mais antigo para o mais recente.
-- Tabelas: PEDIDO, CLIENTE, PESSOA
--
-- Sua resposta:




-- =====================================================================
-- EXERCÍCIO 03 — INNER JOIN — o máximo de tabelas do banco (intermediário)
-- =====================================================================
-- Monte um relatório detalhado dos pedidos CONFIRMADOS contendo:
-- código do pedido, nome do cliente, usuário (login) do cliente, nome do
-- vendedor, salário do vendedor após o reajuste, nome do produto,
-- quantidade, subtotal e a URL da imagem PRINCIPAL do produto (NUMERO_IMAGEM = 1).
-- Considere apenas reajustes salariais feitos a partir de 01/06/2026.
-- Ordene por pedido e nome do produto.
-- Tabelas: TODAS as 9 do banco (PESSOA é usada duas vezes, com apelidos
-- diferentes: uma para o cliente e outra para o vendedor).
--
-- Sua resposta:




-- =====================================================================
-- EXERCÍCIO 04 — LEFT JOIN — 2 tabelas (básico)
-- =====================================================================
-- Liste TODOS os produtos (código e nome) com os pedidos em que aparecem e
-- a quantidade vendida. Produtos que nunca foram vendidos também devem
-- aparecer na listagem.
-- Tabelas: PRODUTO, ITEM_PEDIDO
--
-- Sua resposta:




-- =====================================================================
-- EXERCÍCIO 05 — LEFT JOIN — 3 tabelas (intermediário)
-- =====================================================================
-- Para CADA cliente, mostre o nome, a quantidade de pedidos realizados e o
-- total gasto. Clientes que nunca fizeram pedido devem aparecer com 0.
-- Ordene pela quantidade de pedidos (maior primeiro) e depois pelo nome.
-- Tabelas: CLIENTE, PESSOA, PEDIDO
--
-- Sua resposta:




-- =====================================================================
-- EXERCÍCIO 06 — RIGHT JOIN — 2 tabelas (básico)
-- =====================================================================
-- Usando RIGHT JOIN, liste TODOS os produtos com suas imagens (número e URL).
-- Produtos sem imagem também devem aparecer.
-- Tabelas: IMAGEM, PRODUTO (nesta ordem no FROM)
--
-- Sua resposta:




-- =====================================================================
-- EXERCÍCIO 07 — RIGHT JOIN — 3 tabelas (intermediário)
-- =====================================================================
-- Usando RIGHT JOIN, mostre o nome de TODOS os vendedores, a faixa de
-- comissão, a quantidade de pedidos atendidos e o total vendido.
-- Vendedores sem nenhum pedido devem aparecer com 0.
-- Ordene pelo total vendido (maior primeiro).
-- Tabelas: PEDIDO, VENDEDOR, PESSOA (comece o FROM por PEDIDO)
--
-- Sua resposta:




-- =====================================================================
-- EXERCÍCIO 08 — SELF JOIN (básico)
-- =====================================================================
-- Liste os pares de pessoas que moram na MESMA cidade, mostrando o nome das
-- duas pessoas e a cidade. Cada par deve aparecer uma única vez e uma pessoa
-- não pode formar par com ela mesma.
-- Tabela: PESSOA (unida com ela mesma)
--
-- Sua resposta:




-- =====================================================================
-- EXERCÍCIO 09 — UNION (básico)
-- =====================================================================
-- Liste, sem repetição, todas as cidades (e UF) onde existem clientes
-- OU vendedores.
-- Tabelas: CLIENTE, VENDEDOR, PESSOA
--
-- Sua resposta:




-- =====================================================================
-- EXERCÍCIO 10 — UNION ALL (básico)
-- =====================================================================
-- Monte uma lista de contatos com NOME, EMAIL e uma coluna TIPO ('CLIENTE'
-- ou 'VENDEDOR') reunindo clientes e vendedores. Mantenha as repetições.
-- Ordene por nome e tipo.
-- Tabelas: CLIENTE, VENDEDOR, PESSOA
--
-- Sua resposta:



