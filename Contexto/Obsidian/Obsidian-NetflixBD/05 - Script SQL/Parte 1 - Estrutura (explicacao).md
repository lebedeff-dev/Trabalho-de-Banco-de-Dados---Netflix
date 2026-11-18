# Seção 1 - Estrutura (explicação para apresentar)

Arquivo: `sql/netflix_bd.sql` · Critério da rubrica: **Estrutura do banco (3 pts)**.
Testado em MySQL 8: roda sem erro, cria **13 tabelas e 12 FKs**, e pode ser executado várias vezes.

## Como o arquivo começa

```sql
DROP DATABASE IF EXISTS NETFLIX;
CREATE DATABASE IF NOT EXISTS NETFLIX DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;
USE NETFLIX;
```
- `DROP DATABASE IF EXISTS`: apaga o banco se ele já existir, para recriar do zero (útil em testes). O `IF EXISTS` evita erro quando ele ainda não existe.
- `CREATE DATABASE`: cria o banco. `utf8mb4` aceita acentos e qualquer caractere.
- `USE`: diz ao MySQL em qual banco os próximos comandos vão rodar.
- Fonte: igual ao início do `bd_supermercado.sql`.

## Por que essa ordem de criação
Uma FK aponta para uma tabela que **já precisa existir**. Por isso, primeiro as tabelas sem FK, depois as que dependem delas:

| Grupo | Tabelas |
|---|---|
| 1 (sem FK) | plano, categoria, pessoa, titulo |
| 2 | conta (→plano), temporada (→titulo) |
| 3 | dados_cobranca (→conta), perfil (→conta), episodio (→temporada) |
| 4 | configuracao_perfil (→perfil), titulo_categoria (→titulo, categoria), participacao (→pessoa, titulo), historico_visualizacao (→perfil, titulo) |

## Cada recurso usado e onde a professora mostrou

| Recurso | O que faz | Exemplo no nosso script | Fonte da professora |
|---|---|---|---|
| `CREATE TABLE IF NOT EXISTS` | Cria a tabela só se ainda não existir | todas | `bd_supermercado.sql` |
| `PRIMARY KEY` | Identifica cada linha de forma única | `id_plano INT PRIMARY KEY` | `bd_supermercado.sql` |
| `AUTO_INCREMENT` | O banco numera sozinho (1, 2, 3...) | todo `id_...` | `bd_supermercado.sql` |
| `NOT NULL` | O campo é obrigatório | `valor_mensal DECIMAL(6,2) NOT NULL` | `bd_supermercado.sql` |
| `DEFAULT` | Valor padrão quando não informado | `pais CHAR(2) DEFAULT 'BR'` | `bd_supermercado.sql` |
| `UNIQUE` | Proíbe valores repetidos | `email ... UNIQUE` | `bd_supermercado.sql` (CPF, CNPJ) e PDF 07 |
| `ENUM` | O campo só aceita uma lista fixa de valores | `status ENUM('Ativa','Suspensa','Cancelada')` | `bd_supermercado.sql` (FAIXA_COMISSAO) |
| `FOREIGN KEY ... REFERENCES` | Liga uma tabela à outra | `FOREIGN KEY (id_plano) REFERENCES plano (id_plano)` | `bd_supermercado.sql` |
| `ON DELETE / ON UPDATE CASCADE` | Propaga exclusão/alteração aos filhos | quase todas as FKs | tabela `IMAGEM` do `bd_supermercado.sql`, com comentário explicativo |
| `ON DELETE RESTRICT` | Impede excluir o pai se houver filhos | conta→plano, titulo_categoria→categoria | **Não aparece nos scripts dela** (ela só usa CASCADE). Veio do modelo lógico aprovado, que já definia RESTRICT nessas duas FKs |

> **Ponto de honestidade para a apresentação:** o `UNIQUE` **composto** (`UNIQUE (id_perfil, nome)`, dois campos juntos) é o mesmo comando do UNIQUE simples, só com duas colunas. A professora usa chave composta em `PRIMARY KEY (CODIGO_PEDIDO, CODIGO_PRODUTO)`. O modelo aprovado já tinha esses UNIQUE compostos, por isso eles estão no script.

## Os tipos de relacionamento (a professora aprovou 1:1, 1:N e N:N)

- **1:N** (um para muitos): plano→conta, conta→perfil, titulo→temporada, temporada→episodio. A FK fica no lado "N".
- **1:1** (um para um): conta→dados_cobranca e perfil→configuracao_perfil. É uma FK com `UNIQUE`: o `UNIQUE` impede que dois registros apontem para o mesmo pai.
- **N:N** (muitos para muitos): um banco relacional não liga N:N direto. Cria-se uma **tabela associativa** com duas FKs:
  - titulo ↔ categoria → `titulo_categoria`
  - pessoa ↔ titulo → `participacao`
  - perfil ↔ titulo → `historico_visualizacao`

## Regras de integridade (UNIQUE compostos) e por quê

| Tabela | Regra | Significa |
|---|---|---|
| temporada | (id_titulo, numero_temporada) | um título não tem duas "Temporada 1" |
| episodio | (id_temporada, numero_episodio) | uma temporada não tem dois "Episódio 1" |
| perfil | (id_conta, nome) | uma conta não tem dois perfis com o mesmo nome |
| titulo_categoria | (id_titulo, id_categoria) | não repete a categoria no título |
| participacao | (id_pessoa, id_titulo, funcao) | a mesma pessoa pode ser Ator e Diretor do mesmo título, mas não duas vezes na mesma função |
| historico_visualizacao | (id_perfil, id_titulo) | um registro por perfil e título |

## Por que CASCADE e por que RESTRICT

- **CASCADE** onde o filho não faz sentido sem o pai: apagou a conta → somem os perfis, a cobrança e o histórico. Apagou o título → somem temporadas e episódios.
- **RESTRICT** onde apagar o pai seria um erro: não se apaga um **plano** que tem contas, nem uma **categoria** que está em uso.

## Perguntas prováveis (e respostas curtas)

1. **Por que 13 tabelas?** Porque o modelo lógico tem 13 entidades; cada uma virou uma tabela.
2. **O que é uma chave estrangeira?** Um campo que guarda a chave primária de outra tabela e liga as duas.
3. **Por que `perfil` tem `id_conta`?** Porque uma conta tem vários perfis (1:N). A FK fica no lado "muitos".
4. **Como você garantiu o 1:1?** A FK com `UNIQUE`: cada conta pode ter no máximo uma linha em `dados_cobranca`.
5. **O que acontece se eu apagar uma conta?** Os perfis, a cobrança e o histórico dela são apagados em cascata (`ON DELETE CASCADE`).
6. **E se eu tentar apagar um plano em uso?** O banco recusa (`RESTRICT`).
7. **Por que `senha_hash` e não `senha`?** O modelo guarda o hash da senha, não a senha em texto.
8. **Por que tabela associativa?** Banco relacional não representa N:N diretamente.
9. **Para que serve o `AUTO_INCREMENT`?** O banco gera o `id` sozinho, então no `INSERT` não informamos o id.
10. **Por que a ordem importa?** A FK precisa que a tabela referenciada já exista.
