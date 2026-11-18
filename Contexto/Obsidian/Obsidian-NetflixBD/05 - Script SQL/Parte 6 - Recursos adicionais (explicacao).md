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

### Trigger 1 - `tg_validar_renovacao` (BEFORE UPDATE em `dados_cobranca`)

**Renovar a assinatura** é avançar a `data_proxima_cobranca` da conta. Antes de gravar a nova data, a trigger valida:

| Regra | O que faz | Resultado do teste |
|---|---|---|
| a) A conta precisa estar **Ativa** | Recusa (`SIGNAL`) | Conta 7, suspensa: erro 1644 "Conta suspensa ou cancelada nao pode renovar..." |
| b) A nova data precisa ser **posterior** à atual | Recusa (`SIGNAL`) | Conta 2 voltando para 24/11/2026: erro 1644 "A nova data de cobranca deve ser posterior..." |
| c) A data precisa cair no **dia de vencimento** do cliente | Recusa (`SIGNAL`) | Conta 2 (dia 24) com data dia 10: erro 1644 "A cobranca deve cair no dia de vencimento: dia 24." |

Caso permitido: conta 2 renovada de 24/12/2026 para **24/01/2027**.

Conceitos usados, todos de `bd_supermercado-trigger`:
- `DECLARE` cria variáveis locais; `SELECT ... INTO` guarda o status da conta numa variável (Trigger 5 da professora).
- `SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '...'` **cancela** a operação com uma mensagem (Trigger 5). A mensagem da regra (c) é montada com `CONCAT` numa variável, igual à da professora.
- `OLD` e `NEW` juntos, para comparar a data antiga com a nova (Triggers 1 e 8 da professora).
- `IF NEW.data <> OLD.data`: a trigger só valida quando a data foi alterada. Um `UPDATE` de outro campo (como `cobranca_ativa`) passa direto.
- `DAY(data)` devolve o dia do mês. Função básica, da mesma família do `YEAR()` e `DATE_FORMAT()` dos materiais.
- `BEFORE` é obrigatório: só antes de gravar dá para recusar a renovação.

Os três casos bloqueados estão **comentados** no script (geram erro de propósito, como a professora faz). Para demonstrar, tira-se o `-- ` e executa-se só aquele `UPDATE`.

### Trigger 2 - `tg_criar_configuracao_perfil` (AFTER INSERT em `perfil`)

Todo perfil novo ganha sua configuração sozinho (relacionamento **1:1** entre `perfil` e `configuracao_perfil`):

| Perfil | O que a trigger grava | Resultado do teste |
|---|---|---|
| Comum | Configuração padrão da tabela (os `DEFAULT`) | Perfil "Principal": reprodução automática 1, qualidade Automatica |
| Infantil | Reprodução automática **desligada** e qualidade **Media** | Perfil "Kids": reprodução automática 0, qualidade Media |

Teste: a conta 25 não tinha perfis; inseri "Principal" e "Kids" e cada um já apareceu com a sua configuração, sem nenhum `INSERT` em `configuracao_perfil`.

- **AFTER** porque o `id_perfil` (AUTO_INCREMENT) só existe depois que o perfil é gravado, e a configuração precisa dele.
- **Dispara em `perfil` e grava em outra tabela** (`configuracao_perfil`): mesmo padrão da Trigger 6 da professora (item do pedido que altera estoque e pedido).
- `IF ... ELSE` com `NEW.perfil_infantil` decide qual configuração criar. `NEW` é o perfil que acabou de ser inserido.
- **Assunto diferente da Trigger 1:** a 1 protege a cobrança (BEFORE, recusa); a 2 automatiza o cadastro de perfil (AFTER, cria dados).
- Uma trigger não pode alterar a **própria** tabela que a disparou (erro 1442); por isso o `INSERT` é na tabela de configuração.

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
6. **O que a trigger 1 impede?** Renovar assinatura de conta suspensa ou cancelada, voltar a data de cobrança no tempo e cobrar fora do dia de vencimento combinado.
7. **Por que a trigger 2 é AFTER?** Ela altera outra tabela, o que só faz sentido depois que a conta foi atualizada com sucesso.
8. **Por que as triggers não usam tabela de log?** Para manter exatamente as 13 tabelas do modelo aprovado.
9. **Diferença entre GRANT e REVOKE?** GRANT dá permissão; REVOKE tira.
10. **Dá para limitar permissão a uma coluna?** Sim: `GRANT UPDATE (status)`.
11. **Diferença entre COMMIT e ROLLBACK?** COMMIT confirma; ROLLBACK desfaz o que ainda não foi confirmado.
