# Banco de Dados Netflix

Implementação em **MySQL** do modelo lógico da Netflix.
Atividade AT1 - Projeto - Implementação · Laboratório de Banco de Dados (GPE17M40086) · Católica de Brasília

> Projeto exclusivamente acadêmico e sem fins lucrativos. "Netflix" e demais nomes pertencem aos seus donos e são usados apenas para ilustrar o trabalho.

## O que a atividade pede

| Critério | Requisito |
|---|---|
| Estrutura do banco | Banco e tabelas conforme a modelagem, com PK, FK e relacionamentos |
| Inserção de dados | No mínimo 30 `INSERT` em cada tabela |
| Consultas SQL | JOINs, filtros, agrupamentos e ordenação |
| Scripts adicionais e índices | Índice com justificativa do campo indexado |
| Recursos adicionais | Views, triggers, usuários, permissões e transações |

## Modelo

13 tabelas: `plano`, `conta`, `dados_cobranca`, `perfil`, `configuracao_perfil`, `categoria`, `pessoa`, `titulo`, `temporada`, `episodio`, `titulo_categoria`, `participacao` e `historico_visualizacao`. Relacionamentos 1:1, 1:N e N:N (as N:N resolvidas por tabelas associativas). O modelo está em [`Banco de dados/netflix.mwb`](Banco%20de%20dados/netflix.mwb).

## Estrutura do repositório

```
README.md
Banco de dados/          Modelo lógico (.mwb, para o MySQL Workbench)
sql/                     Script do banco (tabelas, dados, consultas e demais recursos)
extras/
  contexto/
    Proposta/            Rubrica da atividade (PDF)
    Banco de Dados/      Modelo lógico em PDF e arquivos do 1º trabalho
    Materiais/           Materiais da professora (scripts, PDFs e modelagem)
    Obsidian/            Vault de contexto (notas)
```

## Autor

- **LUÍS GUILHERME LEBEDEFF ROCHA MOTA** - [lebedeff-dev](https://github.com/lebedeff-dev)
