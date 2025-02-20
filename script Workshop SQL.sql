-- MySQL Script generated by MySQL Workbench
-- Tue Nov 12 14:22:42 2024
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema bebidas
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `bebidas` ;

-- -----------------------------------------------------
-- Schema bebidas
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `bebidas` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `bebidas` ;

-- -----------------------------------------------------
-- Table `bebidas`.`categorias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bebidas`.`categorias` (
  `id_categoria` INT NOT NULL AUTO_INCREMENT,
  `nombre_categoria` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_categoria`))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `nombre_categoria` ON `bebidas`.`categorias` (`nombre_categoria` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `bebidas`.`clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bebidas`.`clientes` (
  `id_cliente` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(150) NOT NULL,
  `telefono` VARCHAR(20) NOT NULL,
  `mail` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_cliente`))
ENGINE = InnoDB
AUTO_INCREMENT = 21
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `nombre` ON `bebidas`.`clientes` (`nombre` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `bebidas`.`productos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bebidas`.`productos` (
  `id_producto` INT NOT NULL AUTO_INCREMENT,
  `nombre_producto` VARCHAR(50) NOT NULL,
  `id_categoria` INT NOT NULL,
  `precio` DECIMAL(10,2) NULL DEFAULT NULL,
  `stock` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id_producto`),
  CONSTRAINT `productos_ibfk_1`
    FOREIGN KEY (`id_categoria`)
    REFERENCES `bebidas`.`categorias` (`id_categoria`))
ENGINE = InnoDB
AUTO_INCREMENT = 37
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `id_categoria` ON `bebidas`.`productos` (`id_categoria` ASC) VISIBLE;

CREATE INDEX `nombre_producto` ON `bebidas`.`productos` (`nombre_producto` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `bebidas`.`proveedores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bebidas`.`proveedores` (
  `id_proveedor` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `telefono` VARCHAR(20) NOT NULL,
  `mail` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_proveedor`))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `nombre` ON `bebidas`.`proveedores` (`nombre` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `bebidas`.`compra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bebidas`.`compra` (
  `id_proveedor` INT NOT NULL,
  `id_producto` INT NOT NULL,
  `fecha` DATETIME NOT NULL,
  `total` DECIMAL(10,2) NULL DEFAULT NULL,
  PRIMARY KEY (`id_proveedor`, `id_producto`, `fecha`),
  CONSTRAINT `compra_ibfk_1`
    FOREIGN KEY (`id_producto`)
    REFERENCES `bebidas`.`productos` (`id_producto`),
  CONSTRAINT `compra_ibfk_2`
    FOREIGN KEY (`id_proveedor`)
    REFERENCES `bebidas`.`proveedores` (`id_proveedor`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `compra_ibfk_1` ON `bebidas`.`compra` (`id_producto` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `bebidas`.`venta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bebidas`.`venta` (
  `id_producto` INT NOT NULL,
  `id_cliente` INT NOT NULL,
  `fecha` DATETIME NOT NULL,
  `total` DECIMAL(10,2) NULL DEFAULT NULL,
  PRIMARY KEY (`id_producto`, `id_cliente`, `fecha`),
  CONSTRAINT `venta_ibfk_1`
    FOREIGN KEY (`id_producto`)
    REFERENCES `bebidas`.`productos` (`id_producto`),
  CONSTRAINT `venta_ibfk_2`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `bebidas`.`clientes` (`id_cliente`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `id_cliente` ON `bebidas`.`venta` (`id_cliente` ASC) VISIBLE;

USE `bebidas` ;

-- -----------------------------------------------------
-- Placeholder table for view `bebidas`.`producto_mas_vendido_vista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bebidas`.`producto_mas_vendido_vista` (`id_producto` INT, `nombre_producto` INT, `total_ventas` INT);

-- -----------------------------------------------------
-- Placeholder table for view `bebidas`.`producto_menos_vendido_vista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bebidas`.`producto_menos_vendido_vista` (`id_producto` INT, `nombre_producto` INT, `total_ventas` INT);

-- -----------------------------------------------------
-- Placeholder table for view `bebidas`.`stock_bebidas_alcoholicasvista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bebidas`.`stock_bebidas_alcoholicasvista` (`id_producto` INT, `nombre_producto` INT, `id_categoria` INT, `precio` INT, `stock` INT);

-- -----------------------------------------------------
-- Placeholder table for view `bebidas`.`suma_total_compra_vista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bebidas`.`suma_total_compra_vista` (`suma_total_compra` INT);

-- -----------------------------------------------------
-- Placeholder table for view `bebidas`.`suma_total_ventas_vista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bebidas`.`suma_total_ventas_vista` (`suma_total_ventas` INT);

-- -----------------------------------------------------
-- function cliente_mas_compras
-- -----------------------------------------------------

DELIMITER $$
USE `bebidas`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `cliente_mas_compras`() RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE cliente_nombre VARCHAR(150);
    DECLARE total_compras DECIMAL(10, 2);

    -- Obtener el cliente con más compras
    SELECT c.nombre, SUM(v.total)
    INTO cliente_nombre, total_compras
    FROM venta v
    JOIN clientes c ON v.id_cliente = c.id_cliente
    GROUP BY v.id_cliente
    ORDER BY total_compras DESC
    LIMIT 1;

    -- Devolver el nombre del cliente con el total de compras
    RETURN CONCAT('Cliente: ', cliente_nombre, ' - Total Compras: ', total_compras);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure listar_clientes_por_ventas
-- -----------------------------------------------------

DELIMITER $$
USE `bebidas`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_clientes_por_ventas`()
BEGIN
    SELECT 
        c.nombre AS cliente,
        COUNT(v.id_cliente) AS cantidad_ventas
    FROM 
        venta v
    JOIN 
        clientes c ON v.id_cliente = c.id_cliente
    GROUP BY 
        v.id_cliente
    ORDER BY 
        cantidad_ventas DESC;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure listar_productos_mas_vendidos
-- -----------------------------------------------------

DELIMITER $$
USE `bebidas`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_productos_mas_vendidos`()
BEGIN
    SELECT 
        p.nombre_producto AS producto,
        COUNT(v.id_producto) AS cantidad_vendida
    FROM 
        venta v
    JOIN 
        productos p ON v.id_producto = p.id_producto
    GROUP BY 
        v.id_producto
    ORDER BY 
        cantidad_vendida DESC;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function proveedor_mas_comprado
-- -----------------------------------------------------

DELIMITER $$
USE `bebidas`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `proveedor_mas_comprado`() RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE proveedor_nombre VARCHAR(255);
    DECLARE total_compras DECIMAL(10, 2);

    -- Calcular el proveedor con más compras
    SELECT p.nombre, SUM(c.total)
    INTO proveedor_nombre, total_compras
    FROM compra c
    JOIN proveedores p ON c.id_proveedor = p.id_proveedor
    GROUP BY c.id_proveedor
    ORDER BY total_compras DESC
    LIMIT 1;

    -- Devolver el nombre del proveedor
    RETURN CONCAT('Proveedor: ', proveedor_nombre, ' - Total Compras: ', total_compras);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `bebidas`.`producto_mas_vendido_vista`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bebidas`.`producto_mas_vendido_vista`;
USE `bebidas`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `bebidas`.`producto_mas_vendido_vista` AS select `p`.`id_producto` AS `id_producto`,`p`.`nombre_producto` AS `nombre_producto`,sum(`v`.`total`) AS `total_ventas` from (`bebidas`.`venta` `v` join `bebidas`.`productos` `p` on((`v`.`id_producto` = `p`.`id_producto`))) group by `p`.`id_producto`,`p`.`nombre_producto` order by `total_ventas` desc limit 1;

-- -----------------------------------------------------
-- View `bebidas`.`producto_menos_vendido_vista`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bebidas`.`producto_menos_vendido_vista`;
USE `bebidas`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `bebidas`.`producto_menos_vendido_vista` AS select `p`.`id_producto` AS `id_producto`,`p`.`nombre_producto` AS `nombre_producto`,sum(`v`.`total`) AS `total_ventas` from (`bebidas`.`venta` `v` join `bebidas`.`productos` `p` on((`v`.`id_producto` = `p`.`id_producto`))) group by `p`.`id_producto`,`p`.`nombre_producto` order by `total_ventas` limit 1;

-- -----------------------------------------------------
-- View `bebidas`.`stock_bebidas_alcoholicasvista`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bebidas`.`stock_bebidas_alcoholicasvista`;
USE `bebidas`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `bebidas`.`stock_bebidas_alcoholicasvista` AS select `bebidas`.`productos`.`id_producto` AS `id_producto`,`bebidas`.`productos`.`nombre_producto` AS `nombre_producto`,`bebidas`.`productos`.`id_categoria` AS `id_categoria`,`bebidas`.`productos`.`precio` AS `precio`,`bebidas`.`productos`.`stock` AS `stock` from `bebidas`.`productos` where (`bebidas`.`productos`.`id_categoria` in (8,9,10));

-- -----------------------------------------------------
-- View `bebidas`.`suma_total_compra_vista`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bebidas`.`suma_total_compra_vista`;
USE `bebidas`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `bebidas`.`suma_total_compra_vista` AS select sum(`bebidas`.`compra`.`total`) AS `suma_total_compra` from `bebidas`.`compra`;

-- -----------------------------------------------------
-- View `bebidas`.`suma_total_ventas_vista`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bebidas`.`suma_total_ventas_vista`;
USE `bebidas`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `bebidas`.`suma_total_ventas_vista` AS select sum(`bebidas`.`venta`.`total`) AS `suma_total_ventas` from `bebidas`.`venta`;
USE `bebidas`;

DELIMITER $$
USE `bebidas`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `bebidas`.`aumentar_stock_producto`
AFTER INSERT ON `bebidas`.`compra`
FOR EACH ROW
BEGIN
    UPDATE productos
    SET stock = stock + NEW.total
    WHERE id_producto = NEW.id_producto;
END$$

USE `bebidas`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `bebidas`.`reducir_stock_en_venta`
BEFORE INSERT ON `bebidas`.`venta`
FOR EACH ROW
BEGIN
    DECLARE stock_actual INT;

    -- Obtener el stock actual del producto
    SELECT stock INTO stock_actual
    FROM productos
    WHERE id_producto = NEW.id_producto;

    -- Verificar si hay suficiente stock para realizar la venta
    IF stock_actual IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Producto no encontrado.';
    ELSEIF stock_actual <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay stock suficiente para este producto.';
    ELSE
        -- Actualizar el stock del producto restando una unidad
        UPDATE productos
        SET stock = stock - 1
        WHERE id_producto = NEW.id_producto;
    END IF;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
