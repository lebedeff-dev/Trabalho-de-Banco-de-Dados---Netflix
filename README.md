# Banco de Dados Netflix

Implementação em **MySQL** do modelo lógico da Netflix.
Atividade AT1 - Projeto - Implementação · Laboratório de Banco de Dados (GPE17M40086) · Católica de Brasília

> Projeto exclusivamente acadêmico e sem fins lucrativos. "Netflix" e demais nomes pertencem aos seus donos e são usados apenas para ilustrar o trabalho. Todos os dados inseridos são fictícios.

## Sumário

1. [O que a atividade pede](#1-o-que-a-atividade-pede)
2. [O que foi entregue](#2-o-que-foi-entregue)
3. [Modelo](#3-modelo)
4. [Como executar](#4-como-executar)
5. [Estrutura do repositório](#5-estrutura-do-repositório)
6. [Autor](#6-autor)

## 1. O que a atividade pede

A rubrica completa está em [`extras/contexto/Proposta`](extras/contexto/Proposta/). São 5 critérios de 3 pontos cada (total 15).

| Critério | Requisito |
|---|---|
| Estrutura do banco | Banco e tabelas conforme a modelagem, com PK, FK e relacionamentos |
| Inserção de dados | No mínimo 30 `INSERT` em cada tabela |
| Consultas SQL | JOINs, filtros, agrupamentos e ordenação |
| Scripts adicionais e índices | Índice com justificativa do campo indexado e scripts adicionais |
| Recursos adicionais | Views, triggers, usuários, permissões e transações |

## 2. O que foi entregue

Tudo está em um único arquivo, [`sql/netflix_bd.sql`](sql/netflix_bd.sql), organizado na ordem dos critérios.

| Critério | Parte do script | Conteúdo |
|---|---|---|
| Estrutura do banco | Parte 1 | Banco `NETFLIX` e 13 tabelas, com 13 chaves primárias, 12 chaves estrangeiras e 12 restrições `UNIQUE` |
| Inserção de dados | Parte 2 | 712 comandos `INSERT` (a menor tabela tem 30 linhas) |
| Consultas SQL | Parte 3 | 12 consultas: `INNER`, `LEFT`, `RIGHT` e `SELF JOIN`, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY` e `LIMIT` |
| Scripts adicionais e índices | Partes 4 e 5 | 2 índices com justificativa e 3 stored procedures |
| Recursos adicionais | Partes 6 a 9 | 3 views, 3 triggers, 5 usuários com `GRANT`/`REVOKE` e 4 exemplos de transação (`COMMIT`, `ROLLBACK`, `SAVEPOINT`) |

O script foi testado em MySQL 8.0 e pode ser executado mais de uma vez, pois recria o banco do zero.

## 3. Modelo

13 tabelas: `plano`, `conta`, `dados_cobranca`, `perfil`, `configuracao_perfil`, `categoria`, `pessoa`, `titulo`, `temporada`, `episodio`, `titulo_categoria`, `participacao` e `historico_visualizacao`.

| Relacionamento | Exemplos |
|---|---|
| 1:1 | conta e dados_cobranca; perfil e configuracao_perfil |
| 1:N | plano e conta; conta e perfil; titulo e temporada; temporada e episodio |
| N:N | titulo e categoria (`titulo_categoria`); pessoa e titulo (`participacao`); perfil e titulo (`historico_visualizacao`) |

O modelo está em [`Banco de dados/netflix.mwb`](Banco%20de%20dados/netflix.mwb) (MySQL Workbench) e em PDF em [`extras/contexto/Banco de Dados`](extras/contexto/Banco%20de%20Dados/).

## 4. Como executar

1. Abra o MySQL Workbench e conecte ao servidor com um usuário administrador (a Parte 8 cria usuários, o que exige essa permissão).
2. Abra o arquivo `sql/netflix_bd.sql` (*File → Open SQL Script*).
3. Execute o script inteiro (ícone do raio ou `Ctrl+Shift+Enter`).

O script apaga e recria o banco `NETFLIX` a cada execução.

## 5. Estrutura do repositório

```
README.md
Banco de dados/          Modelo lógico (.mwb, para o MySQL Workbench)
sql/netflix_bd.sql       Script completo do banco (partes 1 a 9)
extras/
  contexto/
    Proposta/            Rubrica da atividade (PDF)
    Banco de Dados/      Modelo lógico em PDF e arquivos do 1º trabalho
    Materiais/           Materiais da professora (scripts, PDFs e modelagem)
    Obsidian/            Vault de contexto, com a explicação de cada parte
```

O vault em [`extras/contexto/Obsidian`](extras/contexto/Obsidian/) tem uma nota de explicação para cada critério e a conferência do resultado contra a rubrica. Para abrir: Obsidian → *Open folder as vault* → `Obsidian-NetflixBD`.

## 6. Autor

- **LUÍS GUILHERME LEBEDEFF ROCHA MOTA** - [lebedeff-dev](https://github.com/lebedeff-dev)
