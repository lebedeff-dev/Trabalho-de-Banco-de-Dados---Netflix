# Handoff de contexto

Leia isto primeiro se você é uma IA ou pessoa retomando o trabalho.

## Regras definidas pelo dono do trabalho
1. **Só usar o que a professora já mostrou** nos materiais (`Contexto/Materiais/`). Nada de recursos que não aparecem lá.
2. O dono quer **escrever junto** (aprender). Explicar cada passo, propor, deixar ele tentar e corrigir.
3. **Fazer parte a parte**, explicando o que foi feito.
4. **Commits** vão para https://github.com/lebedeff-dev/Trabalho-de-Banco-de-Dados---Netflix.
5. **Nenhuma ferramenta de IA entra como contribuidor**, nem via commit: sem linhas `Co-Authored-By` e sem menção em mensagens de commit. Os commits são só do autor.
6. Organização das pastas inspirada no repositório de exemplo https://github.com/lebedeff-dev/Projeto_Final_POO_Netflix, com o contexto em `Contexto/` na raiz (README, .gitignore).
7. O modelo Netflix **não será alterado**: a professora o aprovou com 12/12 (ver [[Feedback da professora (modelo logico)]]). A implementação segue o modelo à risca ([[Modelo logico Netflix]]).
8. **O script segue o template da professora** ([[Template da professora]], arquivo `Contexto/Proposta/Template - Projeto - Implementacao.sql`) e **não inclui nada que o template não peça**, para facilitar a explicação na apresentação.

## Estado atual (17/11/2026)
O script `sql/netflix_bd.sql` está na estrutura do template (seções 1 a 6) e testado em MySQL 8. Conferência em [[Comparacao com a rubrica]]. Falta: matrícula do Kaio no cabeçalho, rodar no Workbench do dono e enviar no AVA.

Grupo (modelo lógico em PDF): Luis Eduardo de Andrade Neves, Luís Guilherme Lebedeff Rocha Mota e Kaio Ramos Luiz. A professora avisou que **vai cobrar as triggers**: por isso são duas bem elaboradas (BEFORE com `DECLARE`, `SELECT INTO` e `SIGNAL`; AFTER que altera outra tabela). Ver [[Parte 6 - Recursos adicionais (explicacao)]].

Decisões tomadas:
- Triggers usam só as 13 tabelas do modelo (sem tabela de log), para não fugir da modelagem.
- Sem stored procedures, sem SAVEPOINT e sem consultas além das 10 pedidas (o template não pede). Versões anteriores do script tinham isso; foi removido.
- "Scripts adicionais" = a seção 4 do template (seis exemplos comentados de DROP/ALTER/UPDATE/DELETE).
- Um `INSERT` por linha, para cada linha contar como um comando. Inserts no **mínimo**: 30 por tabela (392 no total; `conta` tem 32).
- **Comentários do script: só organização e o essencial para a professora.** Explicação de aula vai para o vault.
- O script existe em duas formas com o **mesmo conteúdo**: `sql/netflix_bd.sql` (completo, para entregar) e `sql/Script Versionado/01` a `06` (um arquivo por seção do template, para apresentar). **Qualquer alteração precisa ser feita nas duas.** Os 6 arquivos rodam em ordem; para repetir, recomeçar do 01.

## Entrega
Um arquivo `.sql` na estrutura do template. Ver [[Rubrica AT1]] e [[Template da professora]].

## Índice e view
Os scripts da professora não têm exemplo de `CREATE INDEX` nem de `CREATE VIEW`, mas o PDF *06 - DDL* **cita os dois**. Como estão nos materiais dela e o template exige, usamos só a forma simples citada no PDF. Ver [[Mapa dos materiais]].
