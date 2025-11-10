-- ================================================================================
-- TRIGGERS 
-- ================================================================================

-- Trigger: Auto-incremento para CATEGORIA
-- Asigna automáticamente el siguiente ID de la secuencia
CREATE OR REPLACE TRIGGER trg_categoria
BEFORE INSERT ON categoria
FOR EACH ROW
BEGIN
    IF :NEW.id_categoria IS NULL THEN
        SELECT seq_categoria.NEXTVAL INTO :NEW.id_categoria FROM DUAL;
    END IF;
END;
/

-- Trigger: Auto-incremento para USUARIO
-- Asigna automáticamente el siguiente ID de la secuencia
CREATE OR REPLACE TRIGGER trg_usuario
BEFORE INSERT ON usuario
FOR EACH ROW
BEGIN
    IF :NEW.id_usuario IS NULL THEN
        SELECT seq_usuario.NEXTVAL INTO :NEW.id_usuario FROM DUAL;
    END IF;
END;
/

-- Trigger: Auto-incremento para PRODUCTO
-- Asigna automáticamente el siguiente ID de la secuencia
CREATE OR REPLACE TRIGGER trg_producto
BEFORE INSERT ON producto
FOR EACH ROW
BEGIN
    IF :NEW.id_producto IS NULL THEN
        SELECT seq_producto.NEXTVAL INTO :NEW.id_producto FROM DUAL;
    END IF;
END;
/

-- Trigger: Auto-incremento para ROL
-- Asigna automáticamente el siguiente ID de la secuencia
CREATE OR REPLACE TRIGGER trg_rol
BEFORE INSERT ON rol
FOR EACH ROW
BEGIN
    IF :NEW.id_rol IS NULL THEN
        SELECT seq_rol.NEXTVAL INTO :NEW.id_rol FROM DUAL;
    END IF;
END;
/

-- Trigger: Auto-incremento para FACTURA
-- Asigna automáticamente el siguiente ID de la secuencia
CREATE OR REPLACE TRIGGER trg_factura
BEFORE INSERT ON factura
FOR EACH ROW
BEGIN
    IF :NEW.id_factura IS NULL THEN
        SELECT seq_factura.NEXTVAL INTO :NEW.id_factura FROM DUAL;
    END IF;
END;
/

-- Trigger: Auto-incremento para VENTA
-- Asigna automáticamente el siguiente ID de la secuencia
CREATE OR REPLACE TRIGGER trg_venta
BEFORE INSERT ON venta
FOR EACH ROW
BEGIN
    IF :NEW.id_venta IS NULL THEN
        SELECT seq_venta.NEXTVAL INTO :NEW.id_venta FROM DUAL;
    END IF;
END;
/

-- ================================================================================
-- TRIGGERS DE LÓGICA DE NEGOCIO 
-- ================================================================================

-- TRIGGER 1: Actualizar stock al insertar venta
-- Reduce automáticamente las existencias cuando se registra una venta
CREATE OR REPLACE TRIGGER trg_actualizar_stock_venta
AFTER INSERT OR DELETE OR UPDATE ON venta
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        UPDATE producto 
        SET existencias = existencias - :NEW.cantidad
        WHERE id_producto = :NEW.id_producto;
    ELSIF DELETING THEN
        UPDATE producto 
        SET existencias = existencias + :OLD.cantidad
        WHERE id_producto = :OLD.id_producto;
    ELSIF UPDATING THEN
        UPDATE producto 
        SET existencias = existencias + :OLD.cantidad - :NEW.cantidad
        WHERE id_producto = :NEW.id_producto;
    END IF;
END;
/

-- TRIGGER 2: Validar existencias antes de venta
-- Verifica que haya suficiente stock antes de permitir la venta
CREATE OR REPLACE TRIGGER trg_validar_stock_venta
BEFORE INSERT OR UPDATE ON venta
FOR EACH ROW
DECLARE
    v_existencias NUMBER;
BEGIN
    SELECT existencias INTO v_existencias
    FROM producto
    WHERE id_producto = :NEW.id_producto;
    
    IF v_existencias < :NEW.cantidad THEN
        RAISE_APPLICATION_ERROR(-20001, 'Stock insuficiente para el producto ' || :NEW.id_producto || '. Stock actual: ' || v_existencias);
    END IF;
END;
/

-- TRIGGER 3: Actualizar total de factura automáticamente
-- Recalcula el total de la factura cuando se agrega una venta
CREATE OR REPLACE TRIGGER trg_actualizar_total_factura
AFTER INSERT OR DELETE OR UPDATE ON venta
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        UPDATE factura
        SET total = NVL(total, 0) + (:NEW.precio * :NEW.cantidad)
        WHERE id_factura = :NEW.id_factura;
    ELSIF DELETING THEN
        UPDATE factura
        SET total = NVL(total, 0) - (:OLD.precio * :OLD.cantidad)
        WHERE id_factura = :OLD.id_factura;
    ELSIF UPDATING THEN
        UPDATE factura
        SET total = NVL(total, 0) - (:OLD.precio * :OLD.cantidad) + (:NEW.precio * :NEW.cantidad)
        WHERE id_factura = :NEW.id_factura;
    END IF;
END;
/

-- TRIGGER 4: Auditoría de cambios en productos
-- Registra todos los cambios de precio y existencias en productos
CREATE OR REPLACE TRIGGER trg_auditoria_producto
AFTER UPDATE ON producto
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_producto (
        id_producto, accion, precio_anterior, precio_nuevo,
        existencias_anterior, existencias_nuevo, usuario_modificacion
    ) VALUES (
        :NEW.id_producto, 'UPDATE', :OLD.precio, :NEW.precio,
        :OLD.existencias, :NEW.existencias, USER
    );
END;
/

-- TRIGGER 5: Validar precio positivo en productos
-- Asegura que el precio nunca sea negativo
CREATE OR REPLACE TRIGGER trg_validar_precio_producto
BEFORE INSERT OR UPDATE ON producto
FOR EACH ROW
BEGIN
    IF :NEW.precio < 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'El precio no puede ser negativo');
    END IF;
END;
/
