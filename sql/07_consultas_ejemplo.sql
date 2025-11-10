-- ================================================================================
-- PRUEBAS
-- ================================================================================

-- Ejemplo 1: Listar todas las categorías usando el paquete
DECLARE
    v_cursor SYS_REFCURSOR;
    v_id_categoria NUMBER;
    v_descripcion VARCHAR2(30);
    v_ruta_imagen VARCHAR2(1024);
    v_activo NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== LISTADO DE CATEGORIAS ===');
    PKG_CATEGORIA.sp_listar_categorias(v_cursor);
    
    LOOP
        FETCH v_cursor INTO v_id_categoria, v_descripcion, v_ruta_imagen, v_activo;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_categoria || ' - ' || v_descripcion);
    END LOOP;
    CLOSE v_cursor;
END;
/

-- Ejemplo 2: Obtener productos usando el paquete
DECLARE
    v_cursor SYS_REFCURSOR;
    v_id_producto NUMBER;
    v_descripcion VARCHAR2(100);
    v_detalle VARCHAR2(1600);
    v_precio NUMBER;
    v_existencias NUMBER;
    v_ruta_imagen VARCHAR2(1024);
    v_activo NUMBER;
    v_categoria VARCHAR2(100);
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== PRODUCTOS DISPONIBLES ===');
    PKG_PRODUCTO.sp_listar_productos(v_cursor);
    
    LOOP
        FETCH v_cursor INTO v_id_producto, v_descripcion, v_detalle, v_precio, 
                           v_existencias, v_ruta_imagen, v_activo, v_categoria;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_producto || ' | Producto: ' || v_descripcion || 
                           ' | Precio: ' || v_precio || ' | Stock: ' || v_existencias ||
                           ' | Categoria: ' || v_categoria);
    END LOOP;
    CLOSE v_cursor;
END;
/

-- Ejemplo 3: Usar funciones del sistema
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== ESTADISTICAS DEL SISTEMA ===');
    DBMS_OUTPUT.PUT_LINE('Categorias activas: ' || PKG_UTILIDADES.fn_contar_categorias_activas);
    DBMS_OUTPUT.PUT_LINE('Productos activos: ' || PKG_UTILIDADES.fn_contar_productos_activos);
    DBMS_OUTPUT.PUT_LINE('Usuarios activos: ' || PKG_UTILIDADES.fn_contar_usuarios_activos);
    DBMS_OUTPUT.PUT_LINE('Stock total: ' || fn_stock_total);
END;
/

-- Ejemplo 4: Validar credenciales de usuario
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== PRUEBA DE AUTENTICACION ===');
    IF fn_validar_credenciales('juan', '$2a$10$P1.w58XvnaYQUQgZUCk4aO/RTRl8EValluCqB3S2VMLTbRt.tlre.') = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Usuario autenticado correctamente');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Credenciales incorrectas');
    END IF;
END;
/

-- Ejemplo 5: Calcular total de factura con funciones
DECLARE
    v_total NUMBER;
    v_total_iva NUMBER;
BEGIN
    v_total := fn_calcular_total_factura(1);
    v_total_iva := PKG_UTILIDADES.fn_calcular_con_iva(v_total);
    
    DBMS_OUTPUT.PUT_LINE('=== CALCULO DE FACTURA ===');
    DBMS_OUTPUT.PUT_LINE('Total sin IVA: ' || v_total);
    DBMS_OUTPUT.PUT_LINE('IVA (13%): ' || fn_calcular_iva(v_total));
    DBMS_OUTPUT.PUT_LINE('Total con IVA: ' || v_total_iva);
END;
/

-- ================================================================================
-- VERIFICACIÓN FINAL Y RESUMEN
-- ================================================================================

-- Verificar conteo de objetos creados
SELECT 'Tablas creadas' AS tipo, COUNT(*) AS cantidad
FROM user_tables
WHERE table_name IN ('CATEGORIA', 'USUARIO', 'PRODUCTO', 'ROL', 'FACTURA', 'VENTA', 'AUDITORIA_PRODUCTO')
UNION ALL
SELECT 'Secuencias creadas', COUNT(*)
FROM user_sequences
WHERE sequence_name LIKE 'SEQ_%'
UNION ALL
SELECT 'Triggers creados', COUNT(*)
FROM user_triggers
UNION ALL
SELECT 'Vistas creadas', COUNT(*)
FROM user_views
WHERE view_name LIKE 'V_%'
UNION ALL
SELECT 'Paquetes creados', COUNT(*)
FROM user_objects
WHERE object_type = 'PACKAGE' AND object_name LIKE 'PKG_%'
UNION ALL
SELECT 'Funciones creadas', COUNT(*)
FROM user_objects
WHERE object_type = 'FUNCTION' AND object_name LIKE 'FN_%';

-- Mostrar resumen de datos insertados
SELECT 'Categorias' AS tabla, COUNT(*) AS registros FROM categoria
UNION ALL
SELECT 'Usuarios', COUNT(*) FROM usuario
UNION ALL
SELECT 'Productos', COUNT(*) FROM producto
UNION ALL
SELECT 'Roles', COUNT(*) FROM rol
UNION ALL
SELECT 'Facturas', COUNT(*) FROM factura
UNION ALL
SELECT 'Ventas', COUNT(*) FROM venta;

-- Mostrar todas las vistas creadas
SELECT view_name AS nombre_vista, 
       text_length AS tamaño_definicion
FROM user_views
WHERE view_name LIKE 'V_%'
ORDER BY view_name;

-- Listar todos los procedimientos almacenados en paquetes
SELECT object_name AS paquete, 
       object_type AS tipo,
       status AS estado
FROM user_objects
WHERE object_type IN ('PACKAGE', 'PACKAGE BODY')
AND object_name LIKE 'PKG_%'
ORDER BY object_name, object_type;

-- Listar todas las funciones standalone
SELECT object_name AS funcion,
       status AS estado
FROM user_objects
WHERE object_type = 'FUNCTION'
AND object_name LIKE 'FN_%'
ORDER BY object_name;

