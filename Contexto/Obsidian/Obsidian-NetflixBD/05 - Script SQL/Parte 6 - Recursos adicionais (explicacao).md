# Seção 6 - Recursos adicionais (explicação para apresentar)

Arquivo: `06_recursos_adicionais.sql` · Template: **6. Recursos adicionais** (3 views, 2 triggers, 3 usuários, excluir 1 usuário, revogar de 2, `COMMIT` e `ROLLBACK`). Tudo foi testado; os resultados abaixo são os que o banco devolveu.

## Views (3)

**O que é:** uma tabela virtual. Guarda um `SELECT` com um nome; os dados continuam nas tabelas originais. **Fonte:** PDF *06 - DDL*. Forma: `CREATE VIEW nome AS SELECT ...`.

| View | O que mostra | Detalhe |
|---|---|---|
| `vw_contas_ativas` | Contas ativas com o plano | **Não inclui `senha_hash`**: view também esconde colunas |
| `vw_catalogo` | Títulos disponíveis com a categoria principal | `LEFT JOIN`, para os títulos sem categoria aparecerem |
| `vw_ranking_titulos` | Visualizações de cada título | `GROUP BY` dentro da view |

## Triggers (2): a professora vai cobrar

**O que é:** ação que o banco executa sozinho quando acontece `INSERT`, `UPDATE` ou `DELETE`. **Fonte:** `bd_supermercado-trigger - Copy.sql` e PDF *11 - Triggers*. Usam só as 13 tabelas do modelo (sem tabela de log).

### Trigger 1 - `tg_validar_visualizacao` (BEFORE INSERT em `historico_visualizacao`)

Valida antes de gravar que um perfil começou a assistir a algo:

| Regra | O que faz | Resultado do teste |
|---|---|---|
| a) Conta precisa estar **Ativa** | Recusa com `SIGNAL` | Perfil 11 (conta suspensa): erro 1644 "Conta suspensa ou cancelada..." |
| b) Perfil **infantil** só vê classificação **L ou 10** | Recusa com `SIGNAL` | Perfil 3 (infantil) no título 1 (18 anos): erro 1644 "Perfil infantil nao pode..." |
| c) Minuto negativo vira 0 | Corrige com `SET NEW` | Inseri -10, gravou **0** |

Conceitos usados, todos de `bd_supermercado-trigger`:
- `DECLARE` cria variáveis locais (Trigger 5 da professora).
- `SELECT ... INTO` guarda o resultado de uma consulta na variável (Trigger 5).
- `SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '...'` **cancela** a operação com uma mensagem (Trigger 5). O `SET NEW.campo` (regra c) só **corrige** e deixa gravar (Triggers 3 e 4).
- `BEFORE` é obrigatório aqui: só antes de gravar dá para recusar ou corrigir o dado.

Os dois casos bloqueados estão **comentados** no script (geram erro de propósito, como a professora faz). Para demonstrar, tira-se o `-- ` e executa-se só aquele `INSERT`.

### Trigger 2 - `tg_sincronizar_cobranca` (AFTER UPDATE em `conta`)

Quando o **status** da conta muda, a cobrança acompanha: Suspensa ou Cancelada → `cobranca_ativa = 0`; Ativa → `1`. Se só o telefone mudou, nada acontece (`IF OLD.status <> NEW.status`).

Teste: conta 2 com cobrança ativa (1) → suspensa → cobrança **0** → ativa de novo → cobrança **1**.

- É `AFTER` porque só faz sentido mexer na cobrança depois que a conta foi realmente alterada.
- Dispara em `conta` e altera **outra tabela** (`dados_cobranca`): é o mesmo padrão da Trigger 6 da professora (item do pedido → estoque e pedido).
- `OLD` e `NEW` juntos, só existem no `UPDATE`. É o mesmo uso da Trigger 1 da professora (`IF OLD.SALARIO <> NEW.SALARIO`).
- Uma trigger não pode alterar a **própria** tabela que a disparou (erro 1442); por isso o `UPDATE` é na tabela de cobrança.

Como ler uma trigger: nome → **quando** (`BEFORE/AFTER ... ON tabela`) → `FOR EACH ROW` (uma vez por linha) → corpo. `DELIMITER //` evita que o MySQL encerre o comando no primeiro `;` de dentro.

## Usuários e permissões

**Fonte:** `bd_supermercado-grantrevoke.sql` e PDF *13 - DCL*.

| Usuário | Pode | Comando-chave |
|---|---|---|
| `admin_netflix` | Tudo no banco | `GRANT ALL PRIVILEGES ON netflix.*` |
| `analista` | Só consultar | `GRANT SELECT ON netflix.*` |
| `atendente` | Consultar conta e perfil; alterar **só o status** da conta | `GRANT UPDATE (status) ON netflix.conta` |

Sequência pedida pelo template:
1. Cria os 3 usuários e dá permissões **distintas**; `SHOW GRANTS` confere.
2. **Exclui um usuário:** `DROP USER 'analista'@'localhost';`
3. **Revoga de dois usuários:** `REVOKE DELETE, DROP ON netflix.*` do `admin_netflix` (deixa de apagar dados e objetos) e `REVOKE UPDATE (status)` do `atendente`. `SHOW GRANTS` mostra o antes e o depois.

- Princípio: cada usuário recebe só o que precisa.
- `DROP USER IF EXISTS` no começo do bloco permite rodar o script mais de uma vez.
- A senha `Netflix@123` é só de exemplo.

## Transações (`COMMIT` e `ROLLBACK`)

**Fonte:** `bd_supermercado-commit.sql` e PDF *12 - TCL*.

| Exemplo | O que mostra | Resultado |
|---|---|---|
| COMMIT | Cadastra um título e a categoria dele juntos | Título 31 gravado |
| ROLLBACK | Reajuste errado (x10) desfeito | Valor foi a 559,00 e **voltou a 55,90** |

`START TRANSACTION` abre; `COMMIT` grava de vez; `ROLLBACK` desfaz tudo desde o início. **Atomicidade:** tudo acontece ou nada acontece.

## Perguntas prováveis

1. **View guarda dados?** Não. Guarda a consulta; os dados vêm das tabelas na hora.
2. **Para que serve uma view?** Simplificar consultas repetidas e esconder colunas (ex.: a senha).
3. **Diferença entre BEFORE e AFTER?** BEFORE roda antes de gravar e pode corrigir ou recusar o dado; AFTER roda depois de gravar. O trabalho tem uma de cada.
4. **O que são NEW e OLD?** NEW é o valor que está chegando; OLD é o que já estava gravado. INSERT só tem NEW; UPDATE tem os dois; DELETE só tem OLD.
5. **Para que serve o SIGNAL?** Para cancelar a operação com uma mensagem de erro definida por nós.
6. **Por que a trigger 2 é AFTER?** Ela altera outra tabela, o que só faz sentido depois que a conta foi atualizada com sucesso.
7. **Por que as triggers não usam tabela de log?** Para manter exatamente as 13 tabelas do modelo aprovado.
8. **Diferença entre GRANT e REVOKE?** GRANT dá permissão; REVOKE tira.
9. **Dá para limitar permissão a uma coluna?** Sim: `GRANT UPDATE (status)`.
10. **Diferença entre COMMIT e ROLLBACK?** COMMIT confirma; ROLLBACK desfaz o que ainda não foi confirmado.
