INSERT INTO pedido (data_hora, codigo_cliente, codigo_unidade, codigo_entregador) 
VALUES ('2026-10-03 19:10', 1, 1, 1);

INSERT INTO item_pedido (codigo_pedido, codigo_produto, quantidade, preco_cobrado) VALUES 
(1, 2, 1, 18.00),
(1, 3, 1, 12.00);