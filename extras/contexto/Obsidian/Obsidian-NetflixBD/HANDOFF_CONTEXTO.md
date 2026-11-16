# Handoff de contexto

Leia isto primeiro se você é uma IA ou pessoa retomando o trabalho.

## Regras definidas pelo dono do trabalho
1. **Só usar o que a professora já mostrou** nos materiais (`extras/contexto/Materiais/`). Nada de recursos que não aparecem lá.
2. **Trabalho individual**, e o dono quer **escrever junto** (aprender). Explicar cada passo, propor, deixar ele tentar e corrigir.
3. **Fazer parte a parte**, explicando o que foi feito.
4. **Commits** vão para https://github.com/lebedeff-dev/Trabalho-de-Banco-de-Dados---Netflix (estava vazio).
5. **Nenhuma ferramenta de IA entra como contribuidor**, nem via commit: sem linhas `Co-Authored-By` e sem menção em mensagens de commit. Os commits são só do autor.
6. Organização das pastas segue o repositório de exemplo https://github.com/lebedeff-dev/Projeto_Final_POO_Netflix (`extras/contexto/...`, README, .gitignore).
7. O modelo Netflix **não será alterado**: a professora o aprovou com 12/12 (ver [[Feedback da professora (modelo logico)]]). A implementação segue o modelo à risca ([[Modelo logico Netflix]]).
8. Qualquer coisa que **não esteja nos materiais da professora é removida/evitada**. Só entra o que está nos scripts ou nos PDFs dela.

## Estado atual (16/11/2026)
O script `sql/netflix_bd.sql` está completo (partes 1 a 9) e testado em MySQL 8. A conferência contra a rubrica está em [[Comparacao com a rubrica]]. Falta só o dono rodar no Workbench dele e enviar no AVA.

Decisões tomadas:
- "Scripts adicionais" da rubrica = stored procedures (a rubrica não especifica; é o que os materiais dela têm).
- Triggers usam só as 13 tabelas do modelo (sem tabela de log), para não fugir da modelagem.
- O dono pediu triggers **simples**: as três seguem o molde `IF NEW.campo ... THEN SET NEW.campo = ...` (sem `DECLARE`, sem `SIGNAL`, sem alterar outra tabela).
- Um `INSERT` por linha, para cada linha contar como um comando.
- O script existe em duas formas com o **mesmo conteúdo**: `sql/netflix_bd.sql` (completo, para entregar) e `sql/partes/01` a `09` (dividido, para apresentar). **Qualquer alteração precisa ser feita nas duas.** Os arquivos de `partes` rodam em ordem; para repetir, recomeçar do 01.

## Entrega
Um arquivo `.sql` com: estrutura, inserts (30+ por tabela), consultas, índice com justificativa, views, triggers, usuários/permissões e transações. Ver [[Rubrica AT1]].

## Índice e view
Os scripts da professora não têm exemplo de `CREATE INDEX` nem de `CREATE VIEW`, mas o PDF *06 - DDL* **cita os dois** (CREATE/ALTER/DROP INDEX; CREATE/DROP VIEW, "tabela virtual, resultado de um SELECT"). Como estão nos materiais dela e a rubrica exige, usamos só a forma simples citada no PDF. Ver [[Mapa dos materiais]].
