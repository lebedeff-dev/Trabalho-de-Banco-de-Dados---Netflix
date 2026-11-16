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

As três usam **o mesmo molde simples**, o das triggers `tg_validar_estoque` e `tg_validar_pedido` da professora:

```sql
IF NEW.campo <condição> THEN
    SET NEW.campo = <valor corrigido>;
END IF;
```

| Trigger | Tipo | Regra | Resultado do teste |
|---|---|---|---|
| `tg_validar_minuto_parada` | BEFORE INSERT em historico_visualizacao | Minuto negativo vira 0 | Inseri -10, gravou **0** |
| `tg_validar_dia_vencimento` | BEFORE INSERT em dados_cobranca | Dia de vencimento maior que 28 vira 28 | Inseri 31, gravou **28** |
| `tg_validar_valor_plano` | BEFORE UPDATE em plano | Valor negativo é ignorado: o plano fica com o valor antigo | Tentei -5,00, continuou **19,90** |

Como ler uma trigger, linha por linha (usando a primeira):

1. `CREATE TRIGGER tg_validar_minuto_parada` → dá o nome.
2. `BEFORE INSERT ON historico_visualizacao` → **quando** roda: antes de cada inserção nessa tabela.
3. `FOR EACH ROW` → roda uma vez para cada linha inserida.
4. `IF NEW.minuto_parada < 0 THEN` → olha o valor que está chegando.
5. `SET NEW.minuto_parada = 0;` → corrige o valor antes de gravar.

- **BEFORE**: roda antes de gravar, por isso consegue **corrigir** o dado.
- **NEW**: o valor que está chegando. **OLD**: o valor que já estava gravado (só existe no `UPDATE`). A trigger 3 usa os dois: `SET NEW.valor_mensal = OLD.valor_mensal`.
- **`DELIMITER //`**: a trigger tem `;` por dentro; trocar o delimitador evita que o MySQL encerre o comando no meio.
- **Por que dia 28?** Para o vencimento existir em todos os meses (fevereiro tem 28 dias).

**Sem tabela nova:** a professora cria uma `LOG_SISTEMA` para um dos exemplos. Preferi triggers que usam só as 13 tabelas do modelo aprovado, para não fugir da modelagem (e porque a rubrica pede 30 inserts em **todas** as tabelas).

**Versão anterior:** as triggers 2 e 3 eram mais complexas (variável com `DECLARE`, erro com `SIGNAL`, alteração em outra tabela). Foram trocadas por estas, mais fáceis de explicar.

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
| 1 - COMMIT | Cadastra um título e a categoria dele juntos | Título 31 gravado |
| 2 - ROLLBACK | Reajuste errado (x10) desfeito | Valor foi a 559,00 e **voltou a 55,90** |
| 3 - ROLLBACK de exclusão | Conta 2 apagada por engano; o CASCADE levou os perfis | Perfis: 3 → **0** → **3** de volta |
| 4 - SAVEPOINT | Desfaz só a segunda alteração | Preço reajustado (61,49) mantido; telas continuaram 4 |

- **`START TRANSACTION`** abre a transação; **`COMMIT`** grava de vez; **`ROLLBACK`** desfaz tudo desde o início; **`SAVEPOINT`** + **`ROLLBACK TO`** desfaz só até o ponto marcado.
- **Atomicidade:** tudo acontece ou nada acontece (título e categoria entram juntos).
- O exemplo 3 liga duas partes do trabalho: o `ON DELETE CASCADE` da Parte 1 e o `ROLLBACK` daqui.

## Perguntas prováveis

1. **View guarda dados?** Não. Guarda a consulta; os dados vêm das tabelas na hora.
2. **Para que serve uma view?** Simplificar consultas repetidas e esconder colunas (ex.: a senha).
3. **Diferença entre BEFORE e AFTER?** BEFORE roda antes de gravar e pode corrigir o dado; AFTER roda depois de gravar. As três triggers do trabalho são BEFORE.
4. **O que são NEW e OLD?** NEW é o valor que está chegando; OLD é o valor que já estava gravado.
5. **Por que a trigger é BEFORE e não AFTER?** Porque ela corrige o valor, e isso só dá para fazer antes de gravar.
6. **Diferença entre GRANT e REVOKE?** GRANT dá permissão; REVOKE tira.
7. **Dá para limitar permissão a uma coluna?** Sim: `GRANT UPDATE (status)` e `GRANT SELECT (colunas)`.
8. **Diferença entre COMMIT e ROLLBACK?** COMMIT confirma; ROLLBACK desfaz o que ainda não foi confirmado.
9. **Para que serve o SAVEPOINT?** Desfazer só uma parte da transação.
10. **Por que não criou tabela de log para as triggers?** Para manter exatamente as 13 tabelas do modelo aprovado.
