# Seção 2 - Inserts (explicação para apresentar)

Arquivo: `sql/netflix_bd.sql` (seção 2) · Critério da rubrica: **Inserção de dados (3 pts)**: "no mínimo 30 comandos INSERT em cada tabela".
Testado em MySQL 8: o arquivo inteiro roda sem erro, inclusive duas vezes seguidas (ele recria o banco).

## Resultado (conferido no banco)

Os dados estão no **mínimo exigido**: 30 comandos INSERT em cada tabela. Só `conta` tem 32.

| Tabela | INSERTs | | Tabela | INSERTs |
|---|---|---|---|---|
| plano | 30 | | temporada | 30 |
| categoria | 30 | | episodio | 30 |
| pessoa | 30 | | titulo_categoria | 30 |
| titulo | 30 | | participacao | 30 |
| conta | **32** | | historico_visualizacao | 30 |
| dados_cobranca | 30 | | perfil | 30 |
| configuracao_perfil | 30 | | **Total** | **392** |

**Por que `conta` tem 32 e não 30?** `dados_cobranca` é 1:1 com `conta`. Com 30 contas e 30 cobranças, toda conta teria cobrança e não sobraria nenhum caso "sem correspondência" (nem conta livre para o teste da trigger 2). Com 32 contas, as contas 5 e 32 ficam sem cobrança.

Para conferir você mesmo: `SELECT COUNT(*) FROM plano;` (e as demais).

**Histórico:** a primeira versão tinha 712 inserts. Foi reduzida ao mínimo a pedido, para o script ficar menor.

## O comando INSERT

```sql
INSERT INTO plano (id_plano, nome, descricao, valor_mensal, qualidade_maxima, telas_simultaneas, permite_download, data_criacao)
VALUES (1, 'Mobile', 'Assista no celular e no tablet. Plano regular.', 19.90, 'SD', 1, 1, '2019-04-01');
```
- `INSERT INTO tabela (colunas)` diz **onde** e **quais campos** serão preenchidos.
- `VALUES (...)` traz os valores **na mesma ordem** das colunas.
- Texto e data entre aspas simples; número sem aspas; `NULL` para campo vazio.
- Fonte: `inserts_supermercado.sql` e PDF *08 - DML*.

## Decisões e o porquê

1. **Um INSERT por linha.** A rubrica fala em "30 comandos INSERT". A professora às vezes junta várias linhas num só `INSERT`, mas assim cada linha conta como um comando, sem dúvida na contagem.
2. **Ids informados na mão** (como a professora faz). As chaves estrangeiras ficam fáceis de conferir: `id_plano = 3` na conta é o plano 3. Funciona porque o script recria o banco do zero, então a numeração sempre começa em 1.
3. **`SET NAMES utf8mb4;`** antes dos inserts, igual ao script dela: garante que os acentos sejam gravados direito.
4. **Mesma ordem das tabelas.** Mãe antes de filha: se inserir uma `conta` antes do `plano` dela, a FK recusa.
5. **Dados fictícios**: nomes, e-mails e hashes de senha não são reais (a professora também usa hash fictício, "apenas ilustrativo").
6. **Como os dados foram gerados:** foram produzidos com um script auxiliar (sorteio com semente fixa), e o resultado foi conferido no banco. O que vale explicar é o conteúdo e as regras que ele respeita.

## Como as regras do modelo moldaram os dados

| Regra | Efeito nos inserts |
|---|---|
| `UNIQUE (id_perfil, id_titulo)` no histórico | 30 pares perfil/título todos diferentes |
| `UNIQUE (id_conta, nome)` no perfil | nenhum perfil repete o nome dentro da mesma conta |
| `UNIQUE (id_pessoa, id_titulo, funcao)` | uma pessoa pode ser Ator e Diretor do mesmo título, mas não duas vezes na mesma função |
| `UNIQUE` em `id_conta` (1:1 cobrança) | no máximo uma cobrança por conta |
| `UNIQUE` em `id_perfil` (1:1 configuração) | no máximo uma configuração por perfil |
| FK `conta → plano` | toda conta aponta para um plano que existe |
| `ENUM` | só valores da lista (`'Ativa'`, `'4K UHD'`, `'Pix'`...) |

Também cuidei da coerência: `minuto_parada` nunca passa da duração do título; séries têm `duracao_minutos = NULL` (a duração fica nos episódios); `data_ultima_visualizacao` nunca é anterior a `data_inicio`.

## Casos "sem correspondência" (de propósito)

A professora planeja os dados para que **LEFT/RIGHT JOIN tenham o que mostrar** (cliente sem pedido, produto nunca vendido). Fiz igual. Os ids exatos estão no comentário no começo da seção 2 do script:

- planos sem nenhuma conta · contas sem perfil · contas sem dados de cobrança
- categorias sem títulos · títulos sem categoria · pessoas sem participação
- títulos nunca assistidos · temporadas sem episódios

**Por que isso importa:** num `INNER JOIN` essas linhas somem; no `LEFT JOIN` elas aparecem com `NULL`. É a diferença que a seção 5 (consultas) vai demonstrar.

## Perguntas prováveis

1. **Por que informou o id no INSERT, se tem AUTO_INCREMENT?** Para as FKs ficarem fáceis de conferir. O AUTO_INCREMENT continua valendo e gera o próximo id nos inserts futuros.
2. **Por que a ordem dos inserts importa?** A FK exige que a linha "mãe" já exista.
3. **O que acontece se eu repetir um par perfil/título no histórico?** O `UNIQUE` recusa (erro de chave duplicada).
4. **Por que tem plano sem conta?** São planos antigos/promocionais; também servem para mostrar o `LEFT JOIN`.
5. **O que é `SET NAMES utf8mb4`?** Define a codificação da conexão, para os acentos entrarem corretos.
6. **Por que um INSERT por linha?** Para cada linha contar como um comando, como pede a rubrica.
7. **Os dados são reais?** Não, são fictícios, só para demonstração.
