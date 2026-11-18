<p align="center">
  <img src="imagens/netflix-logo.png" alt="Netflix" width="300">
</p>

<h1 align="center">Banco de Dados Netflix</h1>

<p align="center">
  Implementação em <b>MySQL</b> do modelo lógico da Netflix, com 13 tabelas.<br>
  Atividade AT1 - Projeto - Implementação · Laboratório de Banco de Dados (GPE17M40086) · Católica de Brasília
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Linguagem-SQL-E48E00?style=flat" alt="SQL">
  <img src="https://img.shields.io/badge/Banco-MySQL%208-00758F?style=flat" alt="MySQL 8">
  <img src="https://img.shields.io/badge/Ferramenta-MySQL%20Workbench-1A7BB8?style=flat" alt="MySQL Workbench">
  <img src="https://img.shields.io/badge/Modelagem-Workbench%20(.mwb)-1A7BB8?style=flat" alt="Modelagem">
  <img src="https://img.shields.io/badge/Versionamento-Git%20%2F%20GitHub-F05032?style=flat" alt="Git e GitHub">
  <img src="https://img.shields.io/badge/Contexto-Obsidian-7C3AED?style=flat" alt="Obsidian">
</p>

> Projeto exclusivamente acadêmico e sem fins lucrativos. "Netflix" e demais nomes pertencem aos seus donos e são usados apenas para ilustrar o trabalho. Todos os dados inseridos são fictícios.

## Sumário

1. [O que a atividade pede](#1-o-que-a-atividade-pede)
2. [O que foi entregue](#2-o-que-foi-entregue)
3. [Modelo](#3-modelo)
4. [Como executar](#4-como-executar)
5. [Estrutura do repositório](#5-estrutura-do-repositório)
6. [Integrantes](#6-integrantes)

## 1. O que a atividade pede

A rubrica completa está em [`Contexto/Proposta`](Contexto/Proposta/). São 5 critérios de 3 pontos cada (total 15).

A professora também enviou um [template do arquivo `.sql`](Contexto/Proposta/Template%20-%20Projeto%20-%20Implementacao.sql), que define o que entregar e em que ordem: estrutura, inserts, índices, scripts adicionais, consultas e recursos adicionais. O script deste repositório segue essa estrutura.

| Critério | Requisito |
|---|---|
| Estrutura do banco | Banco e tabelas conforme a modelagem, com PK, FK e relacionamentos |
| Inserção de dados | No mínimo 30 `INSERT` em cada tabela |
| Consultas SQL | JOINs, filtros, agrupamentos e ordenação |
| Scripts adicionais e índices | Índice com justificativa do campo indexado e scripts adicionais |
| Recursos adicionais | Views, triggers, usuários, permissões e transações |

## 2. O que foi entregue

O script completo está em [`sql/netflix_bd.sql`](sql/netflix_bd.sql), na estrutura do [template da professora](Contexto/Proposta/Template%20-%20Projeto%20-%20Implementacao.sql). O mesmo conteúdo também está dividido em 6 arquivos menores, um por seção do template, em [`sql/Script Versionado`](sql/Script%20Versionado/), para facilitar a leitura e a apresentação.

| Seção do template | Arquivo em `sql/Script Versionado` | Conteúdo |
|---|---|---|
| 1. Banco e estrutura | `01_estrutura.sql` | Banco `NETFLIX` e 13 tabelas, com 13 chaves primárias, 12 chaves estrangeiras e 12 restrições `UNIQUE` |
| 2. Inserção de dados | `02_inserts.sql` | 392 comandos `INSERT`: 30 em cada tabela (a tabela `conta` tem 32) |
| 3. Índices | `03_indices.sql` | 2 índices com justificativa |
| 4. Scripts adicionais | `04_scripts_adicionais.sql` | Exemplos comentados: `DROP DATABASE`, `DROP TABLE`, `DROP COLUMN`, `ADD COLUMN`, `UPDATE` e `DELETE` de um registro |
| 5. Consultas | `05_consultas.sql` | 10 consultas: 2 simples, 4 `INNER JOIN`, 1 `LEFT`, 1 `RIGHT`, 1 com 3 tabelas e 1 com 4 tabelas |
| 6. Recursos adicionais | `06_recursos_adicionais.sql` | 3 views, 2 triggers (`BEFORE` e `AFTER`), 3 usuários (1 excluído, `REVOKE` em 2), `COMMIT` e `ROLLBACK` |

O script foi testado em MySQL 8.0 e pode ser executado mais de uma vez, pois recria o banco do zero.

## 3. Modelo

13 tabelas: `plano`, `conta`, `dados_cobranca`, `perfil`, `configuracao_perfil`, `categoria`, `pessoa`, `titulo`, `temporada`, `episodio`, `titulo_categoria`, `participacao` e `historico_visualizacao`.

| Relacionamento | Exemplos |
|---|---|
| 1:1 | conta e dados_cobranca; perfil e configuracao_perfil |
| 1:N | plano e conta; conta e perfil; titulo e temporada; temporada e episodio |
| N:N | titulo e categoria (`titulo_categoria`); pessoa e titulo (`participacao`); perfil e titulo (`historico_visualizacao`) |

O modelo está em [`Banco de dados/netflix.mwb`](Banco%20de%20dados/netflix.mwb) (MySQL Workbench) e em PDF em [`Contexto/Banco de Dados`](Contexto/Banco%20de%20Dados/).

## 4. Como executar

1. Abra o MySQL Workbench e conecte ao servidor com um usuário administrador (a seção 6 cria usuários, o que exige essa permissão).
2. Abra o arquivo `sql/netflix_bd.sql` (*File → Open SQL Script*).
3. Execute o script inteiro (ícone do raio ou `Ctrl+Shift+Enter`).

O script apaga e recria o banco `NETFLIX` a cada execução.

**Por partes:** também é possível executar os arquivos de [`sql/Script Versionado`](sql/Script%20Versionado/) um de cada vez, **na ordem de 01 a 06**. Cada arquivo depende dos anteriores. Para repetir, comece de novo pelo `01_estrutura.sql`, que recria o banco. O resultado é o mesmo do script completo.

## 5. Estrutura do repositório

```
README.md
imagens/                 Logo usado no README
Banco de dados/          Modelo lógico (.mwb, para o MySQL Workbench)
sql/
  netflix_bd.sql         Script completo do banco (seções 1 a 6)
  Script Versionado/     O mesmo script dividido em 6 arquivos (01 a 06)
Contexto/
  Proposta/              Rubrica da atividade (PDF) e template da professora (.sql)
  Banco de Dados/        Modelo lógico em PDF e arquivos do 1º trabalho
  Materiais/             Materiais da professora (scripts, PDFs e modelagem)
  Obsidian/              Vault de contexto, com a explicação de cada parte
```

O vault em [`Contexto/Obsidian`](Contexto/Obsidian/) tem uma nota de explicação para cada critério e a conferência do resultado contra a rubrica. Para abrir: Obsidian → *Open folder as vault* → `Obsidian-NetflixBD`.

## 6. Integrantes

- LUIS EDUARDO DE ANDRADE NEVES - [duduandradeneves-ui](https://github.com/duduandradeneves-ui)
- **LUÍS GUILHERME LEBEDEFF ROCHA MOTA** - [lebedeff-dev](https://github.com/lebedeff-dev)
- KAIO RAMOS LUIZ - [paladinoknz](https://github.com/Paladinoknz)
