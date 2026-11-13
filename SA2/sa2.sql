/* SA2 - Implementação e manipulação do banco de embalagens
   Aluno(a): [SEU NOME AQUI]
   Antes: execute o embalagens-base-sa2.sql. */
USE embalagens;

-- ============================================================================
-- ETAPA 1: dados de teste (INSERT e UPDATE)
-- ============================================================================

-- 3. Escreva um INSERT com as 5 ordens do Quadro 1
INSERT INTO ordem_producao (data_ordem, qtd_planejada, qtd_boa, qtd_refugo, consumo_kg, unidade_codigo, produto_codigo) VALUES
  ('2026-11-03', 5000, 4800, 200, 60, 1, 1),
  ('2026-11-03', 5000, 4950, 50, 25, 1, 2),
  ('2026-11-04', 8000, 7650, 350, 160, 2, 3),
  ('2026-11-05', 3000, 2880, 120, 18, 3, 2),
  ('2026-11-05', 4000, 3900, 100, 48, 1, 1);

-- 4. Escreva os INSERTs das 2 expedições do Quadro 2 e dos seus 3 itens
INSERT INTO expedicao (numero, data_saida, unidade_codigo, cliente_cnpj) VALUES
  (1, '2026-11-06', 1, '11.111.111/0001-11'),
  (2, '2026-11-06', 2, '22.222.222/0001-22');

INSERT INTO item_expedicao (expedicao_numero, produto_codigo, quantidade, preco_cobrado) VALUES
  (1, 1, 2000, 0.45),
  (1, 2, 2000, 0.12),
  (2, 3, 5000, 0.65);

-- 5. Escreva um UPDATE: o preço de tabela do Pote 500 ml (código 1) passa para 0,48
UPDATE produto
SET preco_tabela = 0.48
WHERE codigo = 1;


-- ============================================================================
-- ETAPA 2: consultas 1 a 5
-- ============================================================================

-- 6. Consulta 1: ordens com refugo acima de 100, do maior para o menor refugo
SELECT *
FROM ordem_producao
WHERE qtd_refugo > 100
ORDER BY qtd_refugo DESC;

-- 7. Consulta 2: total de refugo por produto, do maior para o menor
SELECT p.nome, SUM(o.qtd_refugo) AS total_refugo
FROM ordem_producao o
JOIN produto p ON o.produto_codigo = p.codigo
GROUP BY p.codigo, p.nome
ORDER BY total_refugo DESC;

-- 8. Consulta 3: unidades com mais de 5000 peças boas no total
SELECT u.nome, SUM(o.qtd_boa) AS total_pecas_boas
FROM ordem_producao o
JOIN unidade u ON o.unidade_codigo = u.codigo
GROUP BY u.codigo, u.nome
HAVING SUM(o.qtd_boa) > 5000
ORDER BY total_pecas_boas DESC;

-- 9. Consulta 4: cliente, unidade, produto, quantidade e valor (quantidade x preço cobrado) de cada item expedido
SELECT c.razao_social AS cliente,
       u.nome AS unidade,
       p.nome AS produto,
       i.quantidade,
       (i.quantidade * i.preco_cobrado) AS valor
FROM item_expedicao i
JOIN expedicao e ON i.expedicao_numero = e.numero
JOIN cliente c ON e.cliente_cnpj = c.cnpj
JOIN unidade u ON e.unidade_codigo = u.codigo
JOIN produto p ON i.produto_codigo = p.codigo;

-- 10. Consulta 5: clientes sem nenhuma expedição
SELECT c.*
FROM cliente c
LEFT JOIN expedicao e ON c.cnpj = e.cliente_cnpj
WHERE e.numero IS NULL;


-- ============================================================================
-- ETAPA 3: view, procedure e trigger
-- ============================================================================

-- 12 e 20. View que exibe o total de refugo acumulado por produto em ordem decrescente
CREATE VIEW vw_refugo_produto AS
SELECT p.nome, SUM(o.qtd_refugo) AS total_refugo
FROM ordem_producao o
JOIN produto p ON o.produto_codigo = p.codigo
GROUP BY p.codigo, p.nome
ORDER BY total_refugo DESC;

-- 13, 14 e 20. Procedure que busca o preço de tabela atual do produto e insere o item na expedição
DELIMITER //
CREATE PROCEDURE sp_registrar_item(
  IN p_expedicao INT,
  IN p_produto INT,
  IN p_quantidade INT
)
BEGIN
  DECLARE v_preco DECIMAL(8,2);

  SELECT preco_tabela INTO v_preco
  FROM produto
  WHERE codigo = p_produto;

  INSERT INTO item_expedicao (expedicao_numero, produto_codigo, quantidade, preco_cobrado)
  VALUES (p_expedicao, p_produto, p_quantidade, v_preco);
END //
DELIMITER ;

-- 15. Teste da procedure: insere 5000 unidades do produto 4 (Tampa 28 mm, preço 0.08) na expedição 2
CALL sp_registrar_item(2, 4, 5000);
SELECT * FROM item_expedicao WHERE expedicao_numero = 2 AND produto_codigo = 4;

-- 16, 17 e 20. Trigger que desconta automaticamente o consumo_kg do estoque da resina correspondente na unidade da ordem
DELIMITER //
CREATE TRIGGER tg_ordem_baixa_resina
AFTER INSERT ON ordem_producao
FOR EACH ROW
BEGIN
  DECLARE v_resina INT;

  SELECT resina_codigo INTO v_resina
  FROM produto
  WHERE codigo = NEW.produto_codigo;

  UPDATE estoque_resina
  SET quantidade_kg = quantidade_kg - NEW.consumo_kg
  WHERE unidade_codigo = NEW.unidade_codigo
    AND resina_codigo = v_resina;
END //
DELIMITER ;

-- 18 e 19. Teste da trigger e conferência do estoque da resina 3 na unidade 2 (de 900.00 para 880.00)
INSERT INTO ordem_producao (data_ordem, qtd_planejada, qtd_boa, qtd_refugo, consumo_kg, unidade_codigo, produto_codigo)
VALUES ('2026-11-09', 1000, 950, 50, 20, 2, 3);

SELECT * FROM estoque_resina WHERE unidade_codigo = 2 AND resina_codigo = 3;


-- ============================================================================
-- ETAPA 4: privilégios dos perfis e SHOW GRANTS
-- ============================================================================

-- 23. Privilégios mínimos conforme Quadro 4 (execute usuarios-local.sql antes)
GRANT SELECT, INSERT ON embalagens.ordem_producao TO 'emb_operador'@'localhost';
GRANT SELECT ON embalagens.produto TO 'emb_operador'@'localhost';

GRANT SELECT ON embalagens.* TO 'emb_gerente'@'localhost';
GRANT INSERT, UPDATE, DELETE ON embalagens.produto TO 'emb_gerente'@'localhost';

FLUSH PRIVILEGES;

SHOW GRANTS FOR 'emb_operador'@'localhost';
SHOW GRANTS FOR 'emb_gerente'@'localhost';
