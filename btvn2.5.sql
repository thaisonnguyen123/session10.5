DROP TABLE IF EXISTS products;

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    stock INT NOT NULL
);



CREATE TABLE cart_items (
    cart_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO products (product_name, stock) VALUES
('iPhone 15', 10),
('MacBook Air', 5),
('Logitech Mouse', 20);

DELIMITER $$

CREATE TRIGGER check_stock_before_insert
BEFORE INSERT ON cart_items
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;

    -- Lấy số lượng tồn kho của sản phẩm
    SELECT stock INTO current_stock
    FROM products
    WHERE id = NEW.product_id;

    -- Kiểm tra tồn kho
    IF NEW.quantity > current_stock THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số lượng yêu cầu vượt quá tồn kho!';
    END IF;
END $$

DELIMITER ;

INSERT INTO cart_items (product_id, quantity)
VALUES (1, 3);

INSERT INTO cart_items (product_id, quantity)
VALUES (1, 20);


