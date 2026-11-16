# Partes 6 a 9 - Views, triggers, usuários e transações (explicação para apresentar)

Arquivo: `sql/netflix_bd.sql` · Critério: **Recursos adicionais do banco (3 pts)**: "views, triggers, usuários, permissões e comandos de transação".
Tudo foi testado: os resultados abaixo são os que o banco devolveu.

## Parte 6 - Views

**O que é:** uma tabela virtual. Guarda um `SELECT` com um nome; os dados continuam nas tabelas originais.
**Fonte:** PDF *06 - DDL* ("uma VIEW é uma tabela virtual... resultado de uma consulta (SELECT)"). Forma usada: `CREATE VIEW nome AS SELECT ...`.

| View | O que mostra | Detalhe para explicar |
|---|---|---|
| `vw_contas_ativas` | Contas ativas com o plano | **Não inclui `senha_hash`**: view também serve para esconder colunas |
| `vw_catalogo` | Títulos disponíveis com a categoria principal | `LEFT JOIN`, para os títulos sem categoria também aparecerem |
| `vw_ranking_titulos` | Quantas visualizações cada título tem | `GROUP BY` dentro da view |

Uso: `SELECT * FROM vw_contas_ativas;` (como se fosse uma tabela).

## Parte 7 - Triggers

**O que é:** uma ação que o banco executa sozinho quando acontece um `INSERT`, `UPDATE` ou `DELETE`.
**Fonte:** `bd_supermercado-trigger - Copy.sql` e PDF *11 - Triggers*. Segui a estrutura dela: regra, criação, comando de teste, SELECT de conferência.

| Trigger | Tipo | Regra | Modelo da professora | Resultado do teste |
|---|---|---|---|---|
| `tg_validar_minuto_parada` | BEFORE INSERT em historico_visualizacao | Minuto negativo vira 0 | `tg_validar_estoque` | Inseri -10, gravou **0** |
| `tg_validar_perfil` | BEFORE INSERT em perfil | Não cria perfil em conta cancelada (`SIGNAL`) | `tg_validar_item_pedido` | Conta 1 (ativa): criou. Conta 11 (cancelada): **erro 1644** |
| `tg_status_conta_cobranca` | AFTER UPDATE em conta | Status da conta muda → `cobranca_ativa` acompanha | `tg_historico_salario` + trigger que altera outra tabela | Suspendi a conta 3: cobrança foi a **0**. Reativei: voltou a **1** |

- **BEFORE**: roda antes de gravar; pode **corrigir** o dado (`SET NEW.campo = ...`) ou **recusar** (`SIGNAL`).
- **AFTER**: roda depois de gravar; usada para refletir a mudança em outra tabela.
- **NEW / OLD**: `NEW` é o valor novo, `OLD` o valor antes do `UPDATE`.
- **`FOR EACH ROW`**: executa uma vez para cada linha afetada.
- **`SIGNAL SQLSTATE '45000'`**: gera um erro definido pelo programador e cancela a operação.
- O caso que dá erro está **comentado** no script, como a professora faz, para não interromper a execução.

**Sem tabela nova:** a professora cria uma `LOG_SISTEMA` para um dos exemplos. Preferi triggers que usam só as 13 tabelas do modelo aprovado, para não fugir da modelagem (e porque a rubrica pede 30 inserts em **todas** as tabelas).

## Parte 8 - Usuários e permissões

**Fonte:** `bd_supermercado-grantrevoke.sql` e PDF *13 - DCL*.

| Usuário | Pode | Comando-chave |
|---|---|---|
| `admin_netflix` | Tudo no banco | `GRANT ALL PRIVILEGES ON netflix.*` |
| `analista` | Só consultar | `GRANT SELECT ON netflix.*` |
| `atendente` | Consultar conta e perfil; alterar **só o status** da conta | `GRANT UPDATE (status) ON netflix.conta` |
| `catalogo` | Cadastrar e consultar títulos | `GRANT INSERT ON netflix.titulo` |
| `financeiro` | Ver planos e **algumas colunas** da cobrança (sem os dígitos do cartão) | `GRANT SELECT (colunas) ON netflix.dados_cobranca` |

Depois, dois `REVOKE`: o catálogo perde o `INSERT` e o atendente perde o `UPDATE (status)`. `SHOW GRANTS` mostra antes e depois.

**Testei entrando com cada usuário:** o atendente não conseguiu ler `titulo`; o financeiro não conseguiu ler `ultimos_quatro_digitos`; o analista não conseguiu apagar; o catálogo não conseguiu inserir depois do `REVOKE`. Todos receberam "command denied".

- **Princípio:** cada usuário recebe só o que precisa para o trabalho dele.
- **`DROP USER IF EXISTS`** no começo: permite rodar o script mais de uma vez (a professora usa `DROP USER` no fim do dela; aqui é o mesmo padrão `IF EXISTS` do `DROP DATABASE`/`DROP TRIGGER`).
- A senha `Netflix@123` é só de exemplo.

## Parte 9 - Transações

**Fonte:** `bd_supermercado-commit.sql` e PDF *12 - TCL*.

| Exemplo | O que mostra | Resultado do teste |
|---|---|---|
| 1 - COMMIT | Cadastra um título e a categoria dele juntos | Título 41 gravado |
| 2 - ROLLBACK | Reajuste errado (x10) desfeito | Valor foi a 559,00 e **voltou a 55,90** |
| 3 - ROLLBACK de exclusão | Conta 2 apagada por engano; o CASCADE levou os perfis | Perfis: 4 → **0** → **4** de volta |
| 4 - SAVEPOINT | Desfaz só a segunda alteração | Preço reajustado (61,49) mantido; telas continuaram 4 |

- **`START TRANSACTION`** abre a transação; **`COMMIT`** grava de vez; **`ROLLBACK`** desfaz tudo desde o início; **`SAVEPOINT`** + **`ROLLBACK TO`** desfaz só até o ponto marcado.
- **Atomicidade:** tudo acontece ou nada acontece (título e categoria entram juntos).
- O exemplo 3 liga duas partes do trabalho: o `ON DELETE CASCADE` da Parte 1 e o `ROLLBACK` daqui.

## Perguntas prováveis

1. **View guarda dados?** Não. Guarda a consulta; os dados vêm das tabelas na hora.
2. **Para que serve uma view?** Simplificar consultas repetidas e esconder colunas (ex.: a senha).
3. **Diferença entre BEFORE e AFTER?** BEFORE roda antes de gravar e pode corrigir ou barrar; AFTER roda depois.
4. **O que são NEW e OLD?** Os valores novos e os antigos da linha que disparou a trigger.
5. **O que o SIGNAL faz?** Gera um erro e cancela o comando.
6. **Diferença entre GRANT e REVOKE?** GRANT dá permissão; REVOKE tira.
7. **Dá para limitar permissão a uma coluna?** Sim: `GRANT UPDATE (status)` e `GRANT SELECT (colunas)`.
8. **Diferença entre COMMIT e ROLLBACK?** COMMIT confirma; ROLLBACK desfaz o que ainda não foi confirmado.
9. **Para que serve o SAVEPOINT?** Desfazer só uma parte da transação.
10. **Por que não criou tabela de log para as triggers?** Para manter exatamente as 13 tabelas do modelo aprovado.
