START TRANSACTION;

UPDATE produto 
SET preco_tabela = preco_tabela * 2 
WHERE codigo = 1;

SELECT nome, preco_tabela FROM produto WHERE codigo = 1;
ROLLBACK;
SELECT nome, preco_tabela FROM produto WHERE codigo = 1;