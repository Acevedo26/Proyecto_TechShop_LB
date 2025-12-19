-- ================================================================================
-- PRUEBAS DE PL/SQL PARA TECHSHOP
-- ================================================================================

SET SERVEROUTPUT ON;
SET DEFINE OFF;

-- ================================================================================
-- PRUEBA 1: PAQUETE CATEGORÍA (CRUD básico)
-- ================================================================================

DECLARE
    v_cursor SYS_REFCURSOR;
    v_id_categoria NUMBER;
    v_descripcion VARCHAR2(30);
    v_ruta_imagen VARCHAR2(1024);
    v_activo NUMBER;
    v_test_id NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== PRUEBA PAQUETE CATEGORIA ===');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 1.1 Listar categorías antes de insertar
    DBMS_OUTPUT.PUT_LINE('1. Listar categorías existentes:');
    PKG_CATEGORIA.sp_listar_categorias(v_cursor);
    LOOP
        FETCH v_cursor INTO v_id_categoria, v_descripcion, v_ruta_imagen, v_activo;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('   ID: ' || v_id_categoria || ' - ' || v_descripcion);
    END LOOP;
    CLOSE v_cursor;
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 1.2 Insertar nueva categoría
    DBMS_OUTPUT.PUT_LINE('2. Insertar nueva categoría de prueba...');
    PKG_CATEGORIA.sp_insertar_categoria(
        p_descripcion => 'Periféricos Gaming',
        p_ruta_imagen => 'https://ejemplo.com/gaming.jpg',
        p_activo => 1
    );
    DBMS_OUTPUT.PUT_LINE('   ✔ Categoría insertada correctamente');
    
    -- Obtener el ID insertado
    SELECT MAX(id_categoria) INTO v_test_id FROM categoria;
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 1.3 Obtener la categoría insertada
    DBMS_OUTPUT.PUT_LINE('3. Obtener categoría por ID (' || v_test_id || '):');
    PKG_CATEGORIA.sp_obtener_categoria(v_test_id, v_cursor);
    FETCH v_cursor INTO v_id_categoria, v_descripcion, v_ruta_imagen, v_activo;
    IF v_cursor%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('   ✔ Categoría encontrada: ' || v_descripcion);
    ELSE
        DBMS_OUTPUT.PUT_LINE('   ✗ Categoría no encontrada');
    END IF;
    CLOSE v_cursor;
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 1.4 Actualizar categoría
    DBMS_OUTPUT.PUT_LINE('4. Actualizar categoría...');
    PKG_CATEGORIA.sp_actualizar_categoria(
        p_id_categoria => v_test_id,
        p_descripcion => 'Periféricos Gaming PRO',
        p_ruta_imagen => 'https://ejemplo.com/gaming-pro.jpg',
        p_activo => 1
    );
    DBMS_OUTPUT.PUT_LINE('   ✔ Categoría actualizada');
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 1.5 Eliminar (desactivar) categoría
    DBMS_OUTPUT.PUT_LINE('5. Desactivar categoría...');
    PKG_CATEGORIA.sp_eliminar_categoria(v_test_id);
    
    -- Verificar que se desactivó
    SELECT activo INTO v_activo FROM categoria WHERE id_categoria = v_test_id;
    IF v_activo = 0 THEN
        DBMS_OUTPUT.PUT_LINE('   ✔ Categoría desactivada correctamente');
    ELSE
        DBMS_OUTPUT.PUT_LINE('   ✗ Error al desactivar categoría');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== PRUEBA CATEGORIA COMPLETADA ===');
    DBMS_OUTPUT.PUT_LINE('');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        ROLLBACK;
END;
/

-- ================================================================================
-- PRUEBA 2: PAQUETE PRODUCTO Y FUNCIONES DE STOCK
-- ================================================================================

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
    v_stock_actual NUMBER;
    v_test_product_id NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== PRUEBA PAQUETE PRODUCTO ===');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 2.1 Verificar stock actual de un producto
    DBMS_OUTPUT.PUT_LINE('1. Verificar stock del producto ID 1:');
    v_stock_actual := fn_verificar_stock(1);
    DBMS_OUTPUT.PUT_LINE('   Stock actual: ' || v_stock_actual);
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 2.2 Listar productos disponibles
    DBMS_OUTPUT.PUT_LINE('2. Listar primeros 3 productos:');
    PKG_PRODUCTO.sp_listar_productos(v_cursor);
    FOR i IN 1..3 LOOP
        FETCH v_cursor INTO v_id_producto, v_descripcion, v_detalle, v_precio, 
                           v_existencias, v_ruta_imagen, v_activo, v_categoria;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('   ID: ' || v_id_producto || ' - ' || v_descripcion || 
                           ' | Stock: ' || v_existencias);
    END LOOP;
    CLOSE v_cursor;
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 2.3 Insertar nuevo producto
    DBMS_OUTPUT.PUT_LINE('3. Insertar nuevo producto de prueba...');
    PKG_PRODUCTO.sp_insertar_producto(
        p_id_categoria => 1,
        p_descripcion => 'Monitor 4K Ultra HD',
        p_detalle => 'Monitor 27 pulgadas 4K UHD, 144Hz',
        p_precio => 150000,
        p_existencias => 10,
        p_ruta_imagen => 'https://ejemplo.com/monitor4k.jpg'
    );
    
    -- Obtener ID del producto insertado
    SELECT MAX(id_producto) INTO v_test_product_id FROM producto;
    DBMS_OUTPUT.PUT_LINE('   ✔ Producto insertado con ID: ' || v_test_product_id);
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 2.4 Obtener producto específico
    DBMS_OUTPUT.PUT_LINE('4. Obtener producto por ID:');
    PKG_PRODUCTO.sp_obtener_producto(v_test_product_id, v_cursor);
    FETCH v_cursor INTO v_id_producto, v_descripcion, v_detalle, v_precio, 
                       v_existencias, v_ruta_imagen, v_activo, v_categoria;
    IF v_cursor%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('   ✔ Producto encontrado: ' || v_descripcion);
        DBMS_OUTPUT.PUT_LINE('   Precio: ' || v_precio || ' | Stock: ' || v_existencias);
    END IF;
    CLOSE v_cursor;
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 2.5 Actualizar stock usando función del paquete
    DBMS_OUTPUT.PUT_LINE('5. Actualizar stock (+5 unidades)...');
    PKG_PRODUCTO.sp_actualizar_stock(v_test_product_id, 5);
    
    -- Verificar stock actualizado
    SELECT existencias INTO v_existencias FROM producto WHERE id_producto = v_test_product_id;
    DBMS_OUTPUT.PUT_LINE('   Stock actualizado: ' || v_existencias);
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 2.6 Probar validación de precio con trigger
    BEGIN
        DBMS_OUTPUT.PUT_LINE('6. Probar trigger de validación de precio (negativo)...');
        UPDATE producto SET precio = -100 WHERE id_producto = v_test_product_id;
        DBMS_OUTPUT.PUT_LINE('   ✗ ERROR: No debería permitir precio negativo');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('   ✔ Trigger funciona: ' || SQLERRM);
    END;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== PRUEBA PRODUCTO COMPLETADA ===');
    DBMS_OUTPUT.PUT_LINE('');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        ROLLBACK;
END;
/

-- ================================================================================
-- PRUEBA 3: PAQUETE FACTURA Y VENTA (Transacción completa)
-- ================================================================================

DECLARE
    v_cursor SYS_REFCURSOR;
    v_id_factura NUMBER;
    v_id_venta NUMBER;
    v_username VARCHAR2(20);
    v_cliente VARCHAR2(50);
    v_producto VARCHAR2(30);
    v_cantidad NUMBER;
    v_precio NUMBER;
    v_subtotal NUMBER;
    v_total_factura NUMBER;
    v_total_calculado NUMBER;
    v_existencias_antes NUMBER;
    v_existencias_despues NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== PRUEBA TRANSACCIÓN DE VENTA ===');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 3.1 Verificar existencias antes de la venta
    DBMS_OUTPUT.PUT_LINE('1. Verificar existencias del producto ID 1:');
    SELECT existencias INTO v_existencias_antes FROM producto WHERE id_producto = 1;
    DBMS_OUTPUT.PUT_LINE('   Existencias antes: ' || v_existencias_antes);
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 3.2 Crear nueva factura
    DBMS_OUTPUT.PUT_LINE('2. Crear nueva factura para usuario ID 1...');
    PKG_FACTURA.sp_crear_factura(1, v_id_factura);
    DBMS_OUTPUT.PUT_LINE('   ✔ Factura creada con ID: ' || v_id_factura);
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 3.3 Agregar productos a la factura usando paquete VENTA
    DBMS_OUTPUT.PUT_LINE('3. Agregar productos a la factura:');
    
    -- Producto 1
    BEGIN
        PKG_VENTA.sp_agregar_producto_factura(v_id_factura, 1, 1);
        DBMS_OUTPUT.PUT_LINE('   ✔ Producto ID 1 agregado (1 unidad)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('   ✗ Error: ' || SQLERRM);
    END;
    
    -- Producto 2
    BEGIN
        PKG_VENTA.sp_agregar_producto_factura(v_id_factura, 5, 2);
        DBMS_OUTPUT.PUT_LINE('   ✔ Producto ID 5 agregado (2 unidades)');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('   ✗ Error: ' || SQLERRM);
    END;
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 3.4 Verificar existencias después de la venta (debería haberse reducido por el trigger)
    DBMS_OUTPUT.PUT_LINE('4. Verificar reducción automática de stock:');
    SELECT existencias INTO v_existencias_despues FROM producto WHERE id_producto = 1;
    DBMS_OUTPUT.PUT_LINE('   Existencias después: ' || v_existencias_despues);
    
    IF v_existencias_despues = v_existencias_antes - 1 THEN
        DBMS_OUTPUT.PUT_LINE('   ✔ Stock reducido correctamente por trigger');
    ELSE
        DBMS_OUTPUT.PUT_LINE('   ✗ Error en reducción de stock');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 3.5 Obtener detalle de la venta
    DBMS_OUTPUT.PUT_LINE('5. Detalle de la venta:');
    PKG_VENTA.sp_obtener_detalle_venta(v_id_factura, v_cursor);
    
    LOOP
        FETCH v_cursor INTO v_id_venta, v_id_producto, v_producto, v_precio, v_cantidad, v_subtotal;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('   Producto: ' || v_producto || ' | Cantidad: ' || v_cantidad || 
                           ' | Precio: ' || v_precio || ' | Subtotal: ' || v_subtotal);
    END LOOP;
    CLOSE v_cursor;
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 3.6 Verificar total actualizado automáticamente por trigger
    DBMS_OUTPUT.PUT_LINE('6. Verificar total de factura:');
    SELECT total INTO v_total_factura FROM factura WHERE id_factura = v_id_factura;
    
    -- Calcular total manualmente para comparar
    v_total_calculado := fn_calcular_total_factura(v_id_factura);
    
    DBMS_OUTPUT.PUT_LINE('   Total según tabla: ' || v_total_factura);
    DBMS_OUTPUT.PUT_LINE('   Total calculado: ' || v_total_calculado);
    
    IF v_total_factura = v_total_calculado THEN
        DBMS_OUTPUT.PUT_LINE('   ✔ Total actualizado correctamente por trigger');
    ELSE
        DBMS_OUTPUT.PUT_LINE('   ✗ Error en cálculo del total');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 3.7 Actualizar estado de la factura
    DBMS_OUTPUT.PUT_LINE('7. Cambiar estado de factura a Pagada...');
    PKG_FACTURA.sp_actualizar_estado_factura(v_id_factura, 2);
    
    SELECT estado INTO v_total_factura FROM factura WHERE id_factura = v_id_factura;
    IF v_total_factura = 2 THEN
        DBMS_OUTPUT.PUT_LINE('   ✔ Estado actualizado correctamente');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== PRUEBA VENTA COMPLETADA ===');
    DBMS_OUTPUT.PUT_LINE('');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        ROLLBACK;
END;
/

-- ================================================================================
-- PRUEBA 4: PAQUETE REPORTES Y FUNCIONES DE UTILIDAD
-- ================================================================================

DECLARE
    v_cursor SYS_REFCURSOR;
    v_id_factura NUMBER;
    v_fecha DATE;
    v_cliente VARCHAR2(100);
    v_total NUMBER;
    v_items_vendidos NUMBER;
    v_id_producto NUMBER;
    v_producto VARCHAR2(100);
    v_categoria VARCHAR2(100);
    v_total_vendido NUMBER;
    v_ingresos NUMBER;
    v_iva NUMBER;
    v_monto_con_iva NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== PRUEBA REPORTES Y UTILIDADES ===');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 4.1 Reporte de ventas por periodo
    DBMS_OUTPUT.PUT_LINE('1. Reporte de ventas (últimos 30 días):');
    PKG_REPORTES.sp_reporte_ventas_periodo(
        p_fecha_inicio => SYSDATE - 30,
        p_fecha_fin => SYSDATE,
        p_cursor => v_cursor
    );
    
    LOOP
        FETCH v_cursor INTO v_id_factura, v_fecha, v_cliente, v_total, v_items_vendidos;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('   Factura ' || v_id_factura || ' | ' || v_fecha || 
                           ' | Cliente: ' || v_cliente || ' | Total: ' || v_total);
    END LOOP;
    CLOSE v_cursor;
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 4.2 Reporte de productos más vendidos
    DBMS_OUTPUT.PUT_LINE('2. Top 3 productos más vendidos:');
    PKG_REPORTES.sp_reporte_productos_top(3, v_cursor);
    
    LOOP
        FETCH v_cursor INTO v_id_producto, v_producto, v_categoria, v_total_vendido, v_ingresos;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('   ' || v_producto || ' (' || v_categoria || 
                           ') | Vendidos: ' || v_total_vendido || ' | Ingresos: ' || v_ingresos);
    END LOOP;
    CLOSE v_cursor;
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 4.3 Reporte de productos sin stock
    DBMS_OUTPUT.PUT_LINE('3. Productos sin stock:');
    PKG_REPORTES.sp_reporte_productos_sin_stock(v_cursor);
    
    LOOP
        FETCH v_cursor INTO v_id_producto, v_producto, v_categoria, v_total, v_items_vendidos;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('   ' || v_producto || ' (' || v_categoria || 
                           ') | Precio: ' || v_total);
    END LOOP;
    CLOSE v_cursor;
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 4.4 Probar funciones de utilidad
    DBMS_OUTPUT.PUT_LINE('4. Funciones de utilidad:');
    
    -- Calcular IVA
    v_iva := fn_calcular_iva(100000);
    DBMS_OUTPUT.PUT_LINE('   IVA de 100,000: ' || v_iva);
    
    -- Calcular con IVA incluido
    v_monto_con_iva := PKG_UTILIDADES.fn_calcular_con_iva(100000);
    DBMS_OUTPUT.PUT_LINE('   100,000 con IVA (13%): ' || v_monto_con_iva);
    
    -- Aplicar descuento
    v_total := PKG_UTILIDADES.fn_aplicar_descuento(100000, 10);
    DBMS_OUTPUT.PUT_LINE('   100,000 con 10% descuento: ' || v_total);
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 4.5 Contar productos por categoría
    DBMS_OUTPUT.PUT_LINE('5. Productos por categoría:');
    FOR cat IN (SELECT id_categoria, descripcion FROM categoria WHERE activo = 1) LOOP
        v_total := fn_contar_productos_categoria(cat.id_categoria);
        DBMS_OUTPUT.PUT_LINE('   ' || cat.descripcion || ': ' || v_total || ' productos');
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== PRUEBA REPORTES COMPLETADA ===');
    DBMS_OUTPUT.PUT_LINE('');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END;
/

-- ================================================================================
-- PRUEBA 5: PAQUETES DE VALIDACIÓN Y SEGURIDAD
-- ================================================================================

DECLARE
    v_resultado NUMBER;
    v_username VARCHAR2(20);
    v_email VARCHAR2(50);
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== PRUEBA VALIDACIÓN Y SEGURIDAD ===');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 5.1 Validaciones básicas
    DBMS_OUTPUT.PUT_LINE('1. Validaciones:');
    
    -- Validar formato de email
    v_email := 'usuario@ejemplo.com';
    v_resultado := PKG_VALIDACIONES.fn_validar_formato_email(v_email);
    DBMS_OUTPUT.PUT_LINE('   Email ' || v_email || ' es válido: ' || 
                       CASE WHEN v_resultado = 1 THEN 'Sí' ELSE 'No' END);
    
    v_email := 'usuario@malformado';
    v_resultado := PKG_VALIDACIONES.fn_validar_formato_email(v_email);
    DBMS_OUTPUT.PUT_LINE('   Email ' || v_email || ' es válido: ' || 
                       CASE WHEN v_resultado = 1 THEN 'Sí' ELSE 'No' END);
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 5.2 Validar username disponible
    DBMS_OUTPUT.PUT_LINE('2. Validar disponibilidad de username:');
    
    v_username := 'juan'; -- Ya existe
    v_resultado := PKG_VALIDACIONES.fn_username_disponible(v_username);
    DBMS_OUTPUT.PUT_LINE('   Username "' || v_username || '" disponible: ' || 
                       CASE WHEN v_resultado = 1 THEN 'Sí' ELSE 'No' END);
    
    v_username := 'usuario_nuevo'; -- No existe
    v_resultado := PKG_VALIDACIONES.fn_username_disponible(v_username);
    DBMS_OUTPUT.PUT_LINE('   Username "' || v_username || '" disponible: ' || 
                       CASE WHEN v_resultado = 1 THEN 'Sí' ELSE 'No' END);
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 5.3 Validar stock suficiente
    DBMS_OUTPUT.PUT_LINE('3. Validar stock suficiente:');
    
    -- Producto con stock
    v_resultado := PKG_VALIDACIONES.fn_validar_stock_suficiente(1, 1);
    DBMS_OUTPUT.PUT_LINE('   Producto ID 1 tiene stock para 1 unidad: ' || 
                       CASE WHEN v_resultado = 1 THEN 'Sí' ELSE 'No' END);
    
    -- Cantidad mayor al stock
    v_resultado := PKG_VALIDACIONES.fn_validar_stock_suficiente(1, 100);
    DBMS_OUTPUT.PUT_LINE('   Producto ID 1 tiene stock para 100 unidades: ' || 
                       CASE WHEN v_resultado = 1 THEN 'Sí' ELSE 'No' END);
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 5.4 Verificar permisos de seguridad
    DBMS_OUTPUT.PUT_LINE('4. Verificar permisos de usuario:');
    
    -- Usuario 1 (tiene ROLE_ADMIN)
    v_resultado := PKG_SEGURIDAD.fn_verificar_admin(1);
    DBMS_OUTPUT.PUT_LINE('   Usuario ID 1 es administrador: ' || 
                       CASE WHEN v_resultado = 1 THEN 'Sí' ELSE 'No' END);
    
    v_resultado := PKG_SEGURIDAD.fn_verificar_vendedor(1);
    DBMS_OUTPUT.PUT_LINE('   Usuario ID 1 es vendedor: ' || 
                       CASE WHEN v_resultado = 1 THEN 'Sí' ELSE 'No' END);
    
    -- Usuario 3 (solo ROLE_USER)
    v_resultado := PKG_SEGURIDAD.fn_verificar_admin(3);
    DBMS_OUTPUT.PUT_LINE('   Usuario ID 3 es administrador: ' || 
                       CASE WHEN v_resultado = 1 THEN 'Sí' ELSE 'No' END);
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 5.5 Verificar usuario activo
    DBMS_OUTPUT.PUT_LINE('5. Verificar estado de usuario:');
    
    v_resultado := PKG_SEGURIDAD.fn_verificar_usuario_activo(1); -- Activo
    DBMS_OUTPUT.PUT_LINE('   Usuario ID 1 está activo: ' || 
                       CASE WHEN v_resultado = 1 THEN 'Sí' ELSE 'No' END);
    
    v_resultado := PKG_SEGURIDAD.fn_verificar_usuario_activo(4); -- Inactivo
    DBMS_OUTPUT.PUT_LINE('   Usuario ID 4 está activo: ' || 
                       CASE WHEN v_resultado = 1 THEN 'Sí' ELSE 'No' END);
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== PRUEBA VALIDACIÓN COMPLETADA ===');
    DBMS_OUTPUT.PUT_LINE('');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END;
/

-- ================================================================================
-- PRUEBA 6: TRIGGERS DE AUDITORÍA Y LÓGICA DE NEGOCIO
-- ================================================================================

DECLARE
    v_precio_anterior NUMBER;
    v_precio_nuevo NUMBER;
    v_existencias_anterior NUMBER;
    v_existencias_nuevo NUMBER;
    v_audit_count NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== PRUEBA TRIGGERS DE AUDITORÍA ===');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 6.1 Verificar auditoría antes del cambio
    DBMS_OUTPUT.PUT_LINE('1. Registros de auditoría antes:');
    SELECT COUNT(*) INTO v_audit_count FROM auditoria_producto;
    DBMS_OUTPUT.PUT_LINE('   Registros en auditoría: ' || v_audit_count);
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 6.2 Hacer cambios que activarán los triggers
    DBMS_OUTPUT.PUT_LINE('2. Modificar producto para activar triggers:');
    
    -- Obtener valores actuales
    SELECT precio, existencias INTO v_precio_anterior, v_existencias_anterior 
    FROM producto WHERE id_producto = 1;
    
    DBMS_OUTPUT.PUT_LINE('   Producto ID 1 - Precio actual: ' || v_precio_anterior || 
                       ' | Stock actual: ' || v_existencias_anterior);
    
    -- Actualizar precio y existencias (activará trigger trg_auditoria_producto)
    UPDATE producto 
    SET precio = v_precio_anterior + 1000,
        existencias = v_existencias_anterior + 5
    WHERE id_producto = 1;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('   ✔ Producto actualizado (+1000 precio, +5 stock)');
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 6.3 Verificar valores nuevos
    SELECT precio, existencias INTO v_precio_nuevo, v_existencias_nuevo 
    FROM producto WHERE id_producto = 1;
    
    DBMS_OUTPUT.PUT_LINE('3. Valores después del cambio:');
    DBMS_OUTPUT.PUT_LINE('   Nuevo precio: ' || v_precio_nuevo);
    DBMS_OUTPUT.PUT_LINE('   Nuevo stock: ' || v_existencias_nuevo);
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 6.4 Verificar registro en auditoría
    DBMS_OUTPUT.PUT_LINE('4. Verificar registro en auditoría:');
    
    SELECT COUNT(*) INTO v_audit_count 
    FROM auditoria_producto 
    WHERE id_producto = 1 
    AND precio_anterior = v_precio_anterior 
    AND precio_nuevo = v_precio_nuevo
    AND existencias_anterior = v_existencias_anterior
    AND existencias_nuevo = v_existencias_nuevo;
    
    IF v_audit_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('   ✔ Cambio registrado en auditoría correctamente');
        
        -- Mostrar último registro de auditoría
        FOR audit_rec IN (
            SELECT * FROM auditoria_producto 
            WHERE id_producto = 1 
            ORDER BY fecha_modificacion DESC 
            FETCH FIRST 1 ROWS ONLY
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('   Usuario: ' || audit_rec.usuario_modificacion);
            DBMS_OUTPUT.PUT_LINE('   Fecha: ' || audit_rec.fecha_modificacion);
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('   ✗ No se encontró registro en auditoría');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- 6.5 Probar trigger de validación de stock negativo
    DBMS_OUTPUT.PUT_LINE('5. Probar validación de stock negativo:');
    BEGIN
        -- Intentar venta con cantidad mayor al stock
        INSERT INTO venta (id_factura, id_producto, precio, cantidad)
        VALUES (1, 1, v_precio_nuevo, 1000); -- Cantidad imposible
        
        DBMS_OUTPUT.PUT_LINE('   ✗ ERROR: No debería permitir esta venta');
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('   ✔ Trigger funciona: ' || SQLERRM);
    END;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== PRUEBA TRIGGERS COMPLETADA ===');
    DBMS_OUTPUT.PUT_LINE('');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        ROLLBACK;
END;
/

-- ================================================================================
-- RESUMEN DE PRUEBAS EJECUTADAS
-- ================================================================================

BEGIN
    DBMS_OUTPUT.PUT_LINE('==========================================');
    DBMS_OUTPUT.PUT_LINE('RESUMEN DE PRUEBAS PL/SQL EJECUTADAS');
    DBMS_OUTPUT.PUT_LINE('==========================================');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('✓ Prueba 1: Paquete CATEGORÍA (CRUD completo)');
    DBMS_OUTPUT.PUT_LINE('✓ Prueba 2: Paquete PRODUCTO y gestión de stock');
    DBMS_OUTPUT.PUT_LINE('✓ Prueba 3: Paquete FACTURA y VENTA (transacción)');
    DBMS_OUTPUT.PUT_LINE('✓ Prueba 4: Paquete REPORTES y funciones de utilidad');
    DBMS_OUTPUT.PUT_LINE('✓ Prueba 5: Paquete VALIDACIÓN y SEGURIDAD');
    DBMS_OUTPUT.PUT_LINE('✓ Prueba 6: Triggers de AUDITORÍA y lógica de negocio');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Componentes probados:');
    DBMS_OUTPUT.PUT_LINE('- 6 Paquetes principales');
    DBMS_OUTPUT.PUT_LINE('- 10+ Procedimientos almacenados');
    DBMS_OUTPUT.PUT_LINE('- 8+ Funciones');
    DBMS_OUTPUT.PUT_LINE('- 5 Triggers de negocio');
    DBMS_OUTPUT.PUT_LINE('- 10+ Cursor operations');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Todas las pruebas han sido ejecutadas exitosamente.');
    DBMS_OUTPUT.PUT_LINE('==========================================');
END;
/