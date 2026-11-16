# Padrões dos scripts da professora (estilo a seguir)

- Cabeçalho de comentário com `-- ====...` explicando o objetivo do bloco.
- Recriação limpa: `DROP DATABASE IF EXISTS`, `CREATE DATABASE ... DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci`, `USE`.
- `CREATE TABLE IF NOT EXISTS`, PK com `AUTO_INCREMENT`, `NOT NULL`, `DEFAULT`, `UNIQUE`, `ENUM`, `FOREIGN KEY (...) REFERENCES ...`.
- Comentários `-- MELHORIA: ...` onde algo poderia ser melhor.
- Tabela mãe primeiro, filha depois (nos inserts também).
- Inserts de apoio planejados para cobrir os casos de LEFT/RIGHT JOIN (cliente sem pedido, produto nunca vendido etc.).
- Cada exemplo de trigger: 1) comentário com a regra e o tipo, 2) criação, 3) comando de teste, 4) SELECT de conferência.
- Triggers e procedures usam `DELIMITER //` ... `END //` e `DELIMITER ;`.
- Usuários: `CREATE USER 'nome'@'localhost' IDENTIFIED BY '123';` seguido de `GRANT` / `REVOKE` por papel (gerente, vendedor, financeiro, estoque, auditor).
- Transações: `START TRANSACTION;` → comandos → `COMMIT;` ou `ROLLBACK;`, com `SELECT` antes/depois para mostrar o efeito.
- Ordem de execução de uma consulta (de `sql.jpeg`): FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT.
