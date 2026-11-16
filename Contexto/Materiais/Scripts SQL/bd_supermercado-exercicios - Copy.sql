-- =========================================
-- LISTA DE EXERCÍCIOS — BANCO SUPERMERCADO
-- =========================================

-- =====================
-- PARTE 1 — SELECT
-- =====================

-- 1. Liste todos os dados da tabela PESSOA.

-- 2. Liste apenas o nome e o email das pessoas.

-- 3. Liste todos os produtos cadastrados.


-- =====================
-- PARTE 2 — DISTINCT
-- =====================

-- 4. Liste todas as cidades cadastradas, sem repetição.

-- 5. Liste os estados (UF) onde há pessoas cadastradas, sem duplicidade.


-- =====================
-- PARTE 3 — LIMIT
-- =====================

-- 6. Liste os 5 primeiros registros da tabela PESSOA.

-- 7. Liste os 3 produtos mais baratos.

-- 8. Liste os 5 produtos mais caros.


-- =====================
-- PARTE 4 — WHERE
-- =====================

-- 9. Liste todas as pessoas que moram em Brasília.

-- 10. Liste os produtos com preço maior que 10.

-- 11. Liste os pedidos que ainda NÃO foram confirmados.


-- =====================
-- PARTE 5 — OPERADORES LÓGICOS
-- =====================

-- 12. Liste pessoas que moram em São Paulo E possuem CEP cadastrado.

-- 13. Liste produtos com preço menor que 5 OU estoque maior que 200.


-- =====================
-- PARTE 6 — IN
-- =====================

-- 14. Liste pessoas que moram em Brasília, Goiânia ou Curitiba.


-- =====================
-- PARTE 7 — BETWEEN
-- =====================

-- 15. Liste produtos com preço entre 5 e 20.


-- =====================
-- PARTE 8 — LIKE (BÁSICO + AVANÇADO)
-- =====================

-- 16. Liste pessoas cujo nome começa com 'A'.

-- 17. Liste pessoas cujo nome contém 'a'.

-- 18. Liste emails que terminam com 'email.com'.

-- 19. Liste pessoas cujo nome tenha exatamente 5 letras.

-- 20. Liste pessoas cujo nome tenha 'a' como segunda letra.

-- 21. Liste pessoas cujo nome termina com 'a'.

-- 22. Liste pessoas cujo nome NÃO começa com 'A'.


-- =====================
-- PARTE 9 — NULL / NOT
-- =====================

-- 23. Liste pessoas que NÃO possuem CEP cadastrado.

-- 24. Liste pedidos que ainda não possuem valor total.

-- 25. Liste produtos que NÃO possuem descrição.


-- =====================
-- PARTE 10 — ORDER BY
-- =====================

-- 26. Liste os produtos ordenados por preço crescente.

-- 27. Liste as pessoas ordenadas por nome em ordem decrescente.


-- =====================
-- PARTE 11 — INNER JOIN
-- =====================

-- 28. Liste o nome do cliente e a data dos pedidos.

-- 29. Liste o nome do vendedor e o valor dos pedidos realizados por ele.



-- =====================
-- PARTE 12 — LEFT JOIN
-- =====================

-- 30. Liste todas as pessoas e seus respectivos logins (se tiverem).

-- 31. Liste todos os clientes e seus pedidos, incluindo clientes sem pedidos.

-- 32. Liste as pessoas que NÃO possuem login.

-- 33. Liste os clientes que ainda NÃO fizeram pedidos.


-- =====================
-- PARTE 13 — MULTI JOIN
-- =====================

-- 34. Liste: nome do cliente, nome do produto e quantidade comprada.

-- 35. Liste: nome do cliente, data do pedido e quantidade total de itens no pedido.

-- 36. Liste: nome do vendedor, nome do cliente e valor do pedido.

-- 37. Liste: nome do produto, quantidade vendida e nome do cliente.

-- =====================
-- ESPECIALIZAÇÃO (HERANÇA)
-- =====================

-- 56.
-- Liste todas as pessoas indicando se são clientes.
-- (Dica: usar LEFT JOIN)

-- 57.
-- Liste todas as pessoas indicando se são vendedores.

-- 58.
-- Liste as pessoas que são clientes E vendedores ao mesmo tempo.

-- 59.
-- Liste as pessoas que NÃO são nem clientes nem vendedores.


-- =====================
-- PARTE 14 — FUNÇÕES (CÁLCULO)
-- =====================

-- 38. Liste cada item de pedido mostrando:
-- quantidade, preço unitário e o subtotal calculado.

-- 39. Liste cada item de pedido mostrando:
-- subtotal armazenado e subtotal calculado para comparação.

-- 40. Liste cada pedido mostrando:
-- valor total armazenado e o valor total calculado com base nos itens.


-- =====================
-- PARTE 15 — FUNÇÕES PRONTAS
-- =====================

-- 41. Liste o nome das pessoas em letras maiúsculas
-- e o email em letras minúsculas.

-- 42. Liste os pedidos mostrando:
-- código, data formatada (DD/MM/AAAA) e ano do pedido.


-- =====================
-- PARTE 16 — GROUP BY
-- =====================

-- 43. Conte quantas pessoas existem por cidade.

-- 44. Calcule o total de estoque de produtos.

-- 45. Calcule a quantidade total de itens por pedido.

-- 46. Conte quantos pedidos cada cliente realizou.

-- 47. Calcule o valor total vendido por vendedor.


-- =====================
-- PARTE 17 — HAVING
-- =====================

-- 48. Liste clientes que fizeram mais de 1 pedido.

-- 49. Liste vendedores cujo total de vendas ultrapassa 100.

-- 50. Liste pedidos que possuem mais de 1 item.


-- =====================
-- PARTE 18 — CONSULTAS COMPLETAS
-- =====================

-- 51. Liste os produtos mais vendidos (somando quantidades).

-- 52. Liste pedidos com seus clientes, vendedores e valor total.

-- 53. Liste clientes que nunca fizeram pedidos.


-- =====================
-- DESAFIO
-- =====================

-- 54. Para cada cliente, mostrar:
-- nome, quantidade de pedidos e valor total gasto.

-- 55. Liste os 3 produtos mais vendidos.