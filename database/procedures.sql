USE BitVerso_BD;

DELIMITER $$

CREATE FUNCTION calcular_total_pedido(p_id_pedido INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT SUM(quantidade * preco_unitario)
    INTO total
    FROM ItensPedidos
    WHERE id_pedido = p_id_pedido;

    RETURN IFNULL(total, 0);
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE atualizar_estoque(
    IN p_id_produto INT,
    IN p_quantidade INT
)
BEGIN
    UPDATE Produtos
    SET estoque = estoque - p_quantidade
    WHERE id_produto = p_id_produto;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE criar_pedido(
    IN p_id_cliente INT,
    IN p_id_produto INT,
    IN p_quantidade INT
)
BEGIN
    DECLARE v_id_pedido INT;
    DECLARE v_preco DECIMAL(10,2);

    START TRANSACTION;

    INSERT INTO Pedidos (status_pedido, id_cliente)
    VALUES ('Em processamento', p_id_cliente);

    SET v_id_pedido = LAST_INSERT_ID();

    SELECT valor_produto INTO v_preco
    FROM Produtos
    WHERE id_produto = p_id_produto;

    INSERT INTO ItensPedidos (id_pedido, id_produto, quantidade, preco_unitario)
    VALUES (v_id_pedido, p_id_produto, p_quantidade, v_preco);

    UPDATE Produtos
    SET estoque = estoque - p_quantidade
    WHERE id_produto = p_id_produto;

    COMMIT;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE relatorio_pedidos_cliente(
    IN p_id_cliente INT
)
BEGIN
    SELECT 
        Pedidos.id_pedido,
        Pedidos.data_pedido,
        calcular_total_pedido(Pedidos.id_pedido) AS total_pedido,
        Pedidos.status_pedido
    FROM Pedidos
    WHERE id_cliente = p_id_cliente;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE aplicar_desconto_produtos_caros(
    IN p_percentual DECIMAL(5,2)
)
BEGIN
    UPDATE Produtos
    SET valor_produto = valor_produto - (valor_produto * p_percentual / 100)
    WHERE valor_produto > 500;
END$$

DELIMITER ;
