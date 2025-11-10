-- ================================================================================
-- FUNCIONES 
-- ================================================================================

-- FUNCIÓN 1: Calcular total de factura
-- Retorna el total calculado de una factura específica
CREATE OR REPLACE FUNCTION fn_calcular_total_factura(p_id_factura NUMBER)
RETURN NUMBER
IS
    v_total NUMBER;
BEGIN
    SELECT NVL(SUM(precio * cantidad), 0)
    INTO v_total
    FROM venta
    WHERE id_factura = p_id_factura;
    
    RETURN v_total;
END;
/

-- FUNCIÓN 2: Verificar stock disponible
-- Retorna la cantidad disponible en stock de un producto
CREATE OR REPLACE FUNCTION fn_verificar_stock(p_id_producto NUMBER)
RETURN NUMBER
IS
    v_stock NUMBER;
BEGIN
    SELECT existencias
    INTO v_stock
    FROM producto
    WHERE id_producto = p_id_producto;
    
    RETURN v_stock;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/

-- FUNCIÓN 3: Contar productos por categoría
-- Retorna el número de productos en una categoría
CREATE OR REPLACE FUNCTION fn_contar_productos_categoria(p_id_categoria NUMBER)
RETURN NUMBER
IS
    v_cantidad NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_cantidad
    FROM producto
    WHERE id_categoria = p_id_categoria AND activo = 1;
    
    RETURN v_cantidad;
END;
/

-- FUNCIÓN 4: Obtener precio de producto
-- Retorna el precio actual de un producto
CREATE OR REPLACE FUNCTION fn_obtener_precio_producto(p_id_producto NUMBER)
RETURN NUMBER
IS
    v_precio NUMBER;
BEGIN
    SELECT precio
    INTO v_precio
    FROM producto
    WHERE id_producto = p_id_producto;
    
    RETURN v_precio;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/

-- FUNCIÓN 5: Validar credenciales de usuario
-- Verifica si existe un usuario con username y password dados
CREATE OR REPLACE FUNCTION fn_validar_credenciales(
    p_username VARCHAR2,
    p_password VARCHAR2
)
RETURN NUMBER
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM usuario
    WHERE username = p_username 
    AND password = p_password 
    AND activo = 1;
    
    RETURN v_count;
END;
/

-- FUNCIÓN 6: Calcular subtotal de venta
-- Calcula el subtotal de una línea de venta específica
CREATE OR REPLACE FUNCTION fn_calcular_subtotal_venta(p_id_venta NUMBER)
RETURN NUMBER
IS
    v_subtotal NUMBER;
BEGIN
    SELECT precio * cantidad
    INTO v_subtotal
    FROM venta
    WHERE id_venta = p_id_venta;
    
    RETURN v_subtotal;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/

-- FUNCIÓN 7: Verificar si usuario es admin
-- Retorna 1 si el usuario tiene rol de administrador, 0 si no
CREATE OR REPLACE FUNCTION fn_es_admin(p_id_usuario NUMBER)
RETURN NUMBER
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM rol
    WHERE id_usuario = p_id_usuario 
    AND nombre = 'ROLE_ADMIN';
    
    RETURN CASE WHEN v_count > 0 THEN 1 ELSE 0 END;
END;
/

-- FUNCIÓN 8: Obtener nombre completo de usuario
-- Retorna el nombre completo concatenado del usuario
CREATE OR REPLACE FUNCTION fn_nombre_completo_usuario(p_id_usuario NUMBER)
RETURN VARCHAR2
IS
    v_nombre_completo VARCHAR2(100);
BEGIN
    SELECT nombre || ' ' || apellidos
    INTO v_nombre_completo
    FROM usuario
    WHERE id_usuario = p_id_usuario;
    
    RETURN v_nombre_completo;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Usuario no encontrado';
END;
/

-- FUNCIÓN 9: Calcular IVA
-- Calcula el IVA (13%) de un monto dado
CREATE OR REPLACE FUNCTION fn_calcular_iva(p_monto NUMBER)
RETURN NUMBER
IS
BEGIN
    RETURN ROUND(p_monto * 0.13, 2);
END;
/

-- FUNCIÓN 10: Validar email
-- Verifica si un email tiene formato válido (básico)
CREATE OR REPLACE FUNCTION fn_validar_email(p_email VARCHAR2)
RETURN NUMBER
IS
BEGIN
    IF REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END;
/

-- FUNCIÓN 11: Contar ventas por periodo
-- Cuenta las ventas realizadas en un rango de fechas
CREATE OR REPLACE FUNCTION fn_contar_ventas_periodo(
    p_fecha_inicio DATE,
    p_fecha_fin DATE
)
RETURN NUMBER
IS
    v_cantidad NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_cantidad
    FROM venta v
    INNER JOIN factura f ON v.id_factura = f.id_factura
    WHERE f.fecha BETWEEN p_fecha_inicio AND p_fecha_fin;
    
    RETURN v_cantidad;
END;
/

-- FUNCIÓN 12: Obtener stock actual total
-- Suma el stock total de todos los productos activos
CREATE OR REPLACE FUNCTION fn_stock_total
RETURN NUMBER
IS
    v_stock_total NUMBER;
BEGIN
    SELECT NVL(SUM(existencias), 0)
    INTO v_stock_total
    FROM producto
    WHERE activo = 1;
    
    RETURN v_stock_total;
END;
/

-- FUNCIÓN 13: Calcular descuento
-- Calcula un porcentaje de descuento sobre un monto
CREATE OR REPLACE FUNCTION fn_calcular_descuento(
    p_monto NUMBER,
    p_porcentaje NUMBER
)
RETURN NUMBER
IS
BEGIN
    RETURN ROUND(p_monto * (p_porcentaje / 100), 2);
END;
/

-- FUNCIÓN 14: Verificar producto activo
-- Verifica si un producto está activo
CREATE OR REPLACE FUNCTION fn_producto_activo(p_id_producto NUMBER)
RETURN NUMBER
IS
    v_activo NUMBER;
BEGIN
    SELECT activo
    INTO v_activo
    FROM producto
    WHERE id_producto = p_id_producto;
    
    RETURN v_activo;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/

-- FUNCIÓN 15: Obtener último ID insertado de una tabla
-- Retorna el último valor usado de una secuencia
CREATE OR REPLACE FUNCTION fn_ultimo_id_producto
RETURN NUMBER
IS
    v_ultimo_id NUMBER;
BEGIN
    SELECT seq_producto.CURRVAL INTO v_ultimo_id FROM DUAL;
    RETURN v_ultimo_id;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END;
/
