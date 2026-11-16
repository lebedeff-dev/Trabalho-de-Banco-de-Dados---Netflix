# Passo a passo (arquivo `sql/netflix_bd.sql`)

Um arquivo só, na ordem abaixo. Estilo em [[Padroes dos scripts da professora]].

- [ ] **1. Banco**: `DROP DATABASE IF EXISTS`, `CREATE DATABASE` (utf8mb4), `USE`
- [ ] **2. Tabelas**: 13 `CREATE TABLE` na ordem de [[Modelo logico Netflix]]. Escritas à mão no estilo de `bd_supermercado.sql`, **fiéis ao modelo aprovado** (mesmos campos, tipos, PK/FK, UNIQUE e ON DELETE/UPDATE do `.mwb`)
- [ ] **3. Inserts**: 30+ por tabela (13 tabelas, ~400 linhas), mesma ordem do passo 2. Pensar os dados para que LEFT/RIGHT JOIN tenham casos sem correspondência
- [ ] **4. Consultas**: INNER/LEFT/RIGHT/SELF JOIN, WHERE, GROUP BY, HAVING, ORDER BY, LIMIT
- [ ] **5. Índice** + comentário de justificativa (ver lacuna em [[Mapa dos materiais]])
- [ ] **6. Views** (ver lacuna)
- [ ] **7. Triggers**: modelo da professora (log em tabela de histórico, validação)
- [ ] **8. Usuários**: `CREATE USER`, `GRANT`, `REVOKE`
- [ ] **9. Transações**: `START TRANSACTION`, `COMMIT`, `ROLLBACK`, `SAVEPOINT`
- [ ] **10. README** do repositório e commit

Prazo: **18/11/2026 23:59**.
