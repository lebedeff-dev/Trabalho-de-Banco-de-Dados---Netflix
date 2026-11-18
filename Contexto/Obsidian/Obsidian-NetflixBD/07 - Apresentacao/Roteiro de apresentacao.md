# Roteiro de apresentação (12 a 15 minutos)

Segue a ordem do [[Template da professora]]. Use os arquivos de `sql/Script Versionado`, um por aba do Workbench, de 01 a 06.

## Antes de começar
- Abra o Workbench com um usuário administrador (a seção 6 cria usuários).
- Deixe as 6 abas abertas, na ordem, e o modelo lógico numa janela à parte.
- Combinem quem fala em cada parte. Todos precisam saber explicar qualquer uma, e quem faltar fica com nota zero.
- Ensaie uma vez do começo ao fim. Para repetir, recomece do `01`, que recria o banco.

## Passo a passo

| Tempo | Arquivo | O que fazer | O que dizer |
|---|---|---|---|
| 1 min | Modelo lógico | Mostrar o diagrama | "Implementamos o modelo aprovado com 12/12, sem alterar nada. São 13 tabelas e 9 relacionamentos." |
| 2 min | `01_estrutura.sql` | Executar. Abrir a lista de tabelas. Mostrar o `CREATE TABLE conta` | "Criamos na ordem das chaves estrangeiras. Usamos CASCADE onde o filho não existe sem o pai e RESTRICT onde apagar seria um erro." |
| 1 min | `02_inserts.sql` | Executar. Rodar `SELECT COUNT(*) FROM plano;` (30) | "São 30 inserts por tabela, um comando por linha. A conta tem 32 para sobrarem contas sem cobrança. Os dados foram gerados com IA, como o template permite." |
| 1 min | `03_indices.sql` | Ler a justificativa. Executar | "Indexamos campos de busca que não são chave. O MySQL já indexa PK, FK e UNIQUE." |
| 1 min | `04_scripts_adicionais.sql` | Mostrar os 6 comandos comentados. Tirar o `-- ` do UPDATE e do DELETE e executar só esses | "Ficam comentados para não destruir o banco. UPDATE e DELETE sempre com WHERE." |
| 3 min | `05_consultas.sql` | Executar a 03 (INNER), a 07 (LEFT), a 08 (RIGHT) e a 10 (4 tabelas) | "A 07 acha os títulos nunca assistidos com IS NULL. A 08 mostra temporadas sem episódio, com 0. Na 10, o WHERE filtra antes de agrupar e o HAVING filtra os grupos." |
| 5 min | `06_recursos_adicionais.sql` | Ver abaixo | Ver abaixo |
| 30 s | | | "Seguimos o template: 30 inserts por tabela, 10 consultas, 3 views, 2 triggers (BEFORE e AFTER), 3 usuários com exclusão e REVOKE, COMMIT e ROLLBACK." |

## Parte 6, por blocos
Selecione o bloco com o mouse e use `Ctrl+Enter`. Sem seleção, o Workbench executa só a linha do cursor.

**6.1 Views**
- Execute as 3 e mostre o `SELECT` de uma.
- "A view guarda a consulta, não os dados. A `vw_contas_ativas` não traz a senha."

**6.2 Trigger 1 (renovação, BEFORE UPDATE)**
1. Execute o `CREATE TRIGGER`, do `DROP TRIGGER IF EXISTS` até o `DELIMITER ;`.
2. Execute o `SELECT` de antes, o `UPDATE` da conta 2 e o `SELECT` de depois. A data vai de 24/12/2026 para 24/01/2027.
3. Tire o `-- ` do `UPDATE` da conta 7 (suspensa) e execute só ele. Aparece o erro 1644. Comente de novo.
- "É BEFORE porque só antes de gravar dá para recusar. A trigger usa DECLARE, SELECT INTO, SIGNAL, OLD e NEW. Ela bloqueia conta suspensa, data que volta no tempo e data fora do dia de vencimento."

**6.3 Trigger 2 (disponibilidade do título, AFTER UPDATE)**
1. Execute o `CREATE TRIGGER`.
2. Execute o `SELECT` de antes: série 1 com 3 temporadas e 6 episódios, tudo em 1.
3. Execute o `UPDATE titulo SET disponivel = 0 WHERE id_titulo = 1;` e o `SELECT` de depois: tudo em 0.
4. Execute o `UPDATE` que devolve 1 e o último `SELECT`: tudo volta a 1.
- "Foi um único UPDATE em titulo. O banco atualizou temporada e episodio sozinho. É AFTER porque só faz sentido propagar depois que o título foi alterado."

**6.4 Usuários**
1. Execute a criação e os `GRANT`. Mostre o `SHOW GRANTS` dos três.
2. Execute o `DROP USER analista`.
3. Execute os dois `REVOKE` e o `SHOW GRANTS` de novo.
- "O atendente altera só a coluna status. O admin perdeu DELETE e DROP."

**6.5 COMMIT e ROLLBACK**
1. Execute o bloco do COMMIT e confira o título 31.
2. Execute o bloco do ROLLBACK inteiro, de `START TRANSACTION` até o `SELECT` final. O preço vai a 559,00 e volta a 55,90.
- "COMMIT confirma. ROLLBACK desfaz o que ainda não foi confirmado. Ou acontece tudo ou não acontece nada."

## Cuidados
- **Não rode** o `DROP DATABASE` nem o `DROP TABLE` antes de terminar. Se rodar, recomece do `01`.
- A trigger 1 e a trigger 2 podem ser repetidas, porque os testes devolvem os dados ao estado original.
- Se der "already exists", o arquivo já foi executado. Recomece do `01`.
- Se a professora pedir uma consulta nova, use o mesmo molde: JOIN, WHERE, GROUP BY, HAVING, ORDER BY.

## Perguntas que ela pode fazer
Estão em [[Parte 6 - Recursos adicionais (explicacao)]], [[Parte 5 - Consultas (explicacao)]] e [[Partes 3 e 4 - Indices e scripts adicionais (explicacao)]]. As mais prováveis:
1. INNER JOIN x LEFT JOIN.
2. WHERE x HAVING.
3. BEFORE x AFTER.
4. O que são NEW e OLD.
5. Para que serve o SIGNAL.
6. COMMIT x ROLLBACK.
7. Por que 30 planos e 32 contas.
8. Por que os comandos da seção 4 estão comentados.
