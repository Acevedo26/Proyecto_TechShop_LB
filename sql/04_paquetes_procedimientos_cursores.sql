-- ==============================================================================
-- Paquetes 
-- Procedimientos
-- Cursores
-- ===============================================================================


-- ================================================================================
-- PAQUETE 1 - PKG_CATEGORIA (CRUD + Utilidades)
-- ================================================================================

-- Especificación del paquete CATEGORIA
CREATE OR REPLACE PACKAGE PKG_CATEGORIA AS
    -- Procedimiento para insertar categoría
    PROCEDURE sp_insertar_categoria(
        p_descripcion VARCHAR2,
        p_ruta_imagen VARCHAR2,
        p_activo NUMBER DEFAULT 1
    );
    
    -- Procedimiento para actualizar categoría
    PROCEDURE sp_actualizar_categoria(
        p_id_categoria NUMBER,
        p_descripcion VARCHAR2,
        p_ruta_imagen VARCHAR2,
        p_activo NUMBER
    );
    
    -- Procedimiento para eliminar categoría (lógico)
    PROCEDURE sp_eliminar_categoria(p_id_categoria NUMBER);
    
    -- Procedimiento para obtener categoría por ID (usando cursor)
    PROCEDURE sp_obtener_categoria(
        p_id_categoria NUMBER,
        p_cursor OUT SYS_REFCURSOR
    );
    
    -- Procedimiento para listar todas las categorías (usando cursor)
    PROCEDURE sp_listar_categorias(p_cursor OUT SYS_REFCURSOR);
END PKG_CATEGORIA;
/

-- Cuerpo del paquete CATEGORIA
CREATE OR REPLACE PACKAGE BODY PKG_CATEGORIA AS
    
    -- PROCEDIMIENTO 1: Insertar categoría
    PROCEDURE sp_insertar_categoria(
        p_descripcion VARCHAR2,
        p_ruta_imagen VARCHAR2,
        p_activo NUMBER DEFAULT 1
    ) IS
    BEGIN
        INSERT INTO categoria (descripcion, ruta_imagen, activo)
        VALUES (p_descripcion, p_ruta_imagen, p_activo);
        COMMIT;
    END;
    
    -- PROCEDIMIENTO 2: Actualizar categoría
    PROCEDURE sp_actualizar_categoria(
        p_id_categoria NUMBER,
        p_descripcion VARCHAR2,
        p_ruta_imagen VARCHAR2,
        p_activo NUMBER
    ) IS
    BEGIN
        UPDATE categoria
        SET descripcion = p_descripcion,
            ruta_imagen = p_ruta_imagen,
            activo = p_activo
        WHERE id_categoria = p_id_categoria;
        COMMIT;
    END;
    
    -- PROCEDIMIENTO 3: Eliminar categoría (borrado lógico)
    PROCEDURE sp_eliminar_categoria(p_id_categoria NUMBER) IS
    BEGIN
        UPDATE categoria
        SET activo = 0
        WHERE id_categoria = p_id_categoria;
        COMMIT;
    END;
    
    -- PROCEDIMIENTO 4: Obtener categoría por ID
    -- CURSOR 1: Retorna una categoría específica
    PROCEDURE sp_obtener_categoria(
        p_id_categoria NUMBER,
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
        SELECT id_categoria, descripcion, ruta_imagen, activo
        FROM categoria
        WHERE id_categoria = p_id_categoria;
    END;
    
    -- PROCEDIMIENTO 5: Listar todas las categorías
    -- CURSOR 2: Retorna todas las categorías
    PROCEDURE sp_listar_categorias(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR
        SELECT id_categoria, descripcion, ruta_imagen, activo
        FROM categoria
        ORDER BY id_categoria;
    END;
    
END PKG_CATEGORIA;
/

-- ================================================================================
-- PAQUETE 2 - PKG_USUARIO (CRUD + Autenticación)
-- ================================================================================

-- Especificación del paquete USUARIO
CREATE OR REPLACE PACKAGE PKG_USUARIO AS
    -- Procedimiento para registrar usuario
    PROCEDURE sp_registrar_usuario(
        p_username VARCHAR2,
        p_password VARCHAR2,
        p_nombre VARCHAR2,
        p_apellidos VARCHAR2,
        p_correo VARCHAR2,
        p_telefono VARCHAR2,
        p_ruta_imagen VARCHAR2
    );
    
    -- Procedimiento para actualizar usuario
    PROCEDURE sp_actualizar_usuario(
        p_id_usuario NUMBER,
        p_nombre VARCHAR2,
        p_apellidos VARCHAR2,
        p_correo VARCHAR2,
        p_telefono VARCHAR2,
        p_ruta_imagen VARCHAR2
    );
    
    -- Procedimiento para desactivar usuario
    PROCEDURE sp_desactivar_usuario(p_id_usuario NUMBER);
    
    -- Procedimiento para obtener usuario por ID
    PROCEDURE sp_obtener_usuario(
        p_id_usuario NUMBER,
        p_cursor OUT SYS_REFCURSOR
    );
    
    -- Procedimiento para listar todos los usuarios
    PROCEDURE sp_listar_usuarios(p_cursor OUT SYS_REFCURSOR);
    
    -- Procedimiento para autenticar usuario
    PROCEDURE sp_autenticar_usuario(
        p_username VARCHAR2,
        p_password VARCHAR2,
        p_cursor OUT SYS_REFCURSOR
    );
END PKG_USUARIO;
/

-- Cuerpo del paquete USUARIO
CREATE OR REPLACE PACKAGE BODY PKG_USUARIO AS
    
    -- PROCEDIMIENTO 6: Registrar usuario
    PROCEDURE sp_registrar_usuario(
        p_username VARCHAR2,
        p_password VARCHAR2,
        p_nombre VARCHAR2,
        p_apellidos VARCHAR2,
        p_correo VARCHAR2,
        p_telefono VARCHAR2,
        p_ruta_imagen VARCHAR2
    ) IS
    BEGIN
        INSERT INTO usuario (username, password, nombre, apellidos, correo, telefono, ruta_imagen, activo)
        VALUES (p_username, p_password, p_nombre, p_apellidos, p_correo, p_telefono, p_ruta_imagen, 1);
        COMMIT;
    END;
    
    -- PROCEDIMIENTO 7: Actualizar usuario
    PROCEDURE sp_actualizar_usuario(
        p_id_usuario NUMBER,
        p_nombre VARCHAR2,
        p_apellidos VARCHAR2,
        p_correo VARCHAR2,
        p_telefono VARCHAR2,
        p_ruta_imagen VARCHAR2
    ) IS
    BEGIN
        UPDATE usuario
        SET nombre = p_nombre,
            apellidos = p_apellidos,
            correo = p_correo,
            telefono = p_telefono,
            ruta_imagen = p_ruta_imagen
        WHERE id_usuario = p_id_usuario;
        COMMIT;
    END;
    
    -- PROCEDIMIENTO 8: Desactivar usuario
    PROCEDURE sp_desactivar_usuario(p_id_usuario NUMBER) IS
    BEGIN
        UPDATE usuario
        SET activo = 0
        WHERE id_usuario = p_id_usuario;
        COMMIT;
    END;
    
    -- PROCEDIMIENTO 9: Obtener usuario por ID
    -- CURSOR 3: Retorna un usuario específico
    PROCEDURE sp_obtener_usuario(
        p_id_usuario NUMBER,
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
        SELECT id_usuario, username, nombre, apellidos, correo, telefono, ruta_imagen, activo
        FROM usuario
        WHERE id_usuario = p_id_usuario;
    END;
    
    -- PROCEDIMIENTO 10: Listar todos los usuarios
    -- CURSOR 4: Retorna todos los usuarios
    PROCEDURE sp_listar_usuarios(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR
        SELECT id_usuario, username, nombre, apellidos, correo, telefono, ruta_imagen, activo
        FROM usuario
        ORDER BY id_usuario;
    END;
    
    -- PROCEDIMIENTO 11: Autenticar usuario
    -- CURSOR 5: Retorna datos del usuario si las credenciales son correctas
    PROCEDURE sp_autenticar_usuario(
        p_username VARCHAR2,
        p_password VARCHAR2,
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
        SELECT id_usuario, username, nombre, apellidos, correo, activo
        FROM usuario
        WHERE username = p_username 
        AND password = p_password
        AND activo = 1;
    END;
    
END PKG_USUARIO;
/

-- ================================================================================
-- PAQUETE 3 - PKG_PRODUCTO (CRUD + Gestión Stock)
-- ================================================================================

-- Especificación del paquete PRODUCTO
CREATE OR REPLACE PACKAGE PKG_PRODUCTO AS
    -- Procedimiento para insertar producto
    PROCEDURE sp_insertar_producto(
        p_id_categoria NUMBER,
        p_descripcion VARCHAR2,
        p_detalle VARCHAR2,
        p_precio NUMBER,
        p_existencias NUMBER,
        p_ruta_imagen VARCHAR2
    );
    
    -- Procedimiento para actualizar producto
    PROCEDURE sp_actualizar_producto(
        p_id_producto NUMBER,
        p_id_categoria NUMBER,
        p_descripcion VARCHAR2,
        p_detalle VARCHAR2,
        p_precio NUMBER,
        p_existencias NUMBER,
        p_ruta_imagen VARCHAR2
    );
    
    -- Procedimiento para eliminar producto (lógico)
    PROCEDURE sp_eliminar_producto(p_id_producto NUMBER);
    
    -- Procedimiento para obtener producto por ID
    PROCEDURE sp_obtener_producto(
        p_id_producto NUMBER,
        p_cursor OUT SYS_REFCURSOR
    );
    
    -- Procedimiento para listar productos
    PROCEDURE sp_listar_productos(p_cursor OUT SYS_REFCURSOR);
    
    -- Procedimiento para actualizar stock
    PROCEDURE sp_actualizar_stock(
        p_id_producto NUMBER,
        p_cantidad NUMBER
    );
END PKG_PRODUCTO;
/

-- Cuerpo del paquete PRODUCTO
CREATE OR REPLACE PACKAGE BODY PKG_PRODUCTO AS
    
    -- PROCEDIMIENTO 12: Insertar producto
    PROCEDURE sp_insertar_producto(
        p_id_categoria NUMBER,
        p_descripcion VARCHAR2,
        p_detalle VARCHAR2,
        p_precio NUMBER,
        p_existencias NUMBER,
        p_ruta_imagen VARCHAR2
    ) IS
    BEGIN
        INSERT INTO producto (id_categoria, descripcion, detalle, precio, existencias, ruta_imagen, activo)
        VALUES (p_id_categoria, p_descripcion, p_detalle, p_precio, p_existencias, p_ruta_imagen, 1);
        COMMIT;
    END;
    
    -- PROCEDIMIENTO 13: Actualizar producto
    PROCEDURE sp_actualizar_producto(
        p_id_producto NUMBER,
        p_id_categoria NUMBER,
        p_descripcion VARCHAR2,
        p_detalle VARCHAR2,
        p_precio NUMBER,
        p_existencias NUMBER,
        p_ruta_imagen VARCHAR2
    ) IS
    BEGIN
        UPDATE producto
        SET id_categoria = p_id_categoria,
            descripcion = p_descripcion,
            detalle = p_detalle,
            precio = p_precio,
            existencias = p_existencias,
            ruta_imagen = p_ruta_imagen
        WHERE id_producto = p_id_producto;
        COMMIT;
    END;
    
    -- PROCEDIMIENTO 14: Eliminar producto (borrado lógico)
    PROCEDURE sp_eliminar_producto(p_id_producto NUMBER) IS
    BEGIN
        UPDATE producto
        SET activo = 0
        WHERE id_producto = p_id_producto;
        COMMIT;
    END;
    
    -- PROCEDIMIENTO 15: Obtener producto por ID
    -- CURSOR 6: Retorna un producto específico con su categoría
    PROCEDURE sp_obtener_producto(
        p_id_producto NUMBER,
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
        SELECT p.id_producto, p.descripcion, p.detalle, p.precio, 
               p.existencias, p.ruta_imagen, p.activo,
               c.descripcion AS categoria
        FROM producto p
        INNER JOIN categoria c ON p.id_categoria = c.id_categoria
        WHERE p.id_producto = p_id_producto;
    END;
    
    -- PROCEDIMIENTO 16: Listar todos los productos
    -- CURSOR 7: Retorna todos los productos con su categoría
    PROCEDURE sp_listar_productos(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR
        SELECT p.id_producto, p.descripcion, p.detalle, p.precio, 
               p.existencias, p.ruta_imagen, p.activo,
               c.descripcion AS categoria
        FROM producto p
        INNER JOIN categoria c ON p.id_categoria = c.id_categoria
        ORDER BY p.id_producto;
    END;
    
    -- PROCEDIMIENTO 17: Actualizar stock de producto
    PROCEDURE sp_actualizar_stock(
        p_id_producto NUMBER,
        p_cantidad NUMBER
    ) IS
    BEGIN
        UPDATE producto
        SET existencias = existencias + p_cantidad
        WHERE id_producto = p_id_producto;
        COMMIT;
    END;
    
END PKG_PRODUCTO;
/

-- ================================================================================
-- PAQUETE 4 - PKG_ROL (Gestión de Roles)
-- ================================================================================

-- Especificación del paquete ROL
CREATE OR REPLACE PACKAGE PKG_ROL AS
    -- Procedimiento para asignar rol a usuario
    PROCEDURE sp_asignar_rol(
        p_nombre_rol VARCHAR2,
        p_id_usuario NUMBER
    );
    
    -- Procedimiento para remover rol de usuario
    PROCEDURE sp_remover_rol(p_id_rol NUMBER);
    
    -- Procedimiento para listar roles de un usuario
    PROCEDURE sp_listar_roles_usuario(
        p_id_usuario NUMBER,
        p_cursor OUT SYS_REFCURSOR
    );
    
    -- Procedimiento para listar todos los roles
    PROCEDURE sp_listar_roles(p_cursor OUT SYS_REFCURSOR);
END PKG_ROL;
/

-- Cuerpo del paquete ROL
CREATE OR REPLACE PACKAGE BODY PKG_ROL AS
    
    -- PROCEDIMIENTO 18: Asignar rol a usuario
    PROCEDURE sp_asignar_rol(
        p_nombre_rol VARCHAR2,
        p_id_usuario NUMBER
    ) IS
    BEGIN
        INSERT INTO rol (nombre, id_usuario)
        VALUES (p_nombre_rol, p_id_usuario);
        COMMIT;
    END;
    
    -- PROCEDIMIENTO 19: Remover rol de usuario
    PROCEDURE sp_remover_rol(p_id_rol NUMBER) IS
    BEGIN
        DELETE FROM rol
        WHERE id_rol = p_id_rol;
        COMMIT;
    END;
    
    -- PROCEDIMIENTO 20: Listar roles de un usuario
    -- CURSOR 8: Retorna todos los roles de un usuario específico
    PROCEDURE sp_listar_roles_usuario(
        p_id_usuario NUMBER,
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
        SELECT id_rol, nombre
        FROM rol
        WHERE id_usuario = p_id_usuario;
    END;
    
    -- PROCEDIMIENTO 21: Listar todos los roles
    -- CURSOR 9: Retorna todos los roles del sistema
    PROCEDURE sp_listar_roles(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR
        SELECT r.id_rol, r.nombre, r.id_usuario,
               u.username, u.nombre || ' ' || u.apellidos AS usuario_completo
        FROM rol r
        LEFT JOIN usuario u ON r.id_usuario = u.id_usuario
        ORDER BY r.id_rol;
    END;
    
END PKG_ROL;
/

-- ================================================================================
-- PAQUETE 5 - PKG_FACTURA (CRUD + Cálculos)
-- ================================================================================

-- Especificación del paquete FACTURA
CREATE OR REPLACE PACKAGE PKG_FACTURA AS
    -- Procedimiento para crear factura
    PROCEDURE sp_crear_factura(
        p_id_usuario NUMBER,
        p_id_factura OUT NUMBER
    );
    
    -- Procedimiento para actualizar estado de factura
    PROCEDURE sp_actualizar_estado_factura(
        p_id_factura NUMBER,
        p_estado NUMBER
    );
    
    -- Procedimiento para obtener factura
    PROCEDURE sp_obtener_factura(
        p_id_factura NUMBER,
        p_cursor OUT SYS_REFCURSOR
    );
    
    -- Procedimiento para listar facturas
    PROCEDURE sp_listar_facturas(p_cursor OUT SYS_REFCURSOR);
    
    -- Procedimiento para listar facturas por usuario
    PROCEDURE sp_listar_facturas_usuario(
        p_id_usuario NUMBER,
        p_cursor OUT SYS_REFCURSOR
    );
END PKG_FACTURA;
/

-- Cuerpo del paquete FACTURA
CREATE OR REPLACE PACKAGE BODY PKG_FACTURA AS
    
    -- PROCEDIMIENTO 22: Crear factura
    PROCEDURE sp_crear_factura(
        p_id_usuario NUMBER,
        p_id_factura OUT NUMBER
    ) IS
    BEGIN
        INSERT INTO factura (id_usuario, fecha, total, estado)
        VALUES (p_id_usuario, SYSDATE, 0, 1)
        RETURNING id_factura INTO p_id_factura;
        COMMIT;
    END;
    
    -- PROCEDIMIENTO 23: Actualizar estado de factura
    PROCEDURE sp_actualizar_estado_factura(
        p_id_factura NUMBER,
        p_estado NUMBER
    ) IS
    BEGIN
        UPDATE factura
        SET estado = p_estado
        WHERE id_factura = p_id_factura;
        COMMIT;
    END;
    
    -- PROCEDIMIENTO 24: Obtener factura por ID
    -- CURSOR 10: Retorna una factura específica con datos del cliente
    PROCEDURE sp_obtener_factura(
        p_id_factura NUMBER,
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
        SELECT f.id_factura, f.fecha, f.total, f.estado,
               u.username, u.nombre, u.apellidos, u.correo
        FROM factura f
        INNER JOIN usuario u ON f.id_usuario = u.id_usuario
        WHERE f.id_factura = p_id_factura;
    END;
    
    -- PROCEDIMIENTO 25: Listar todas las facturas
    -- CURSOR 11: Retorna todas las facturas con datos del cliente
    PROCEDURE sp_listar_facturas(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR
        SELECT f.id_factura, f.fecha, f.total, f.estado,
               u.username, u.nombre || ' ' || u.apellidos AS cliente
        FROM factura f
        INNER JOIN usuario u ON f.id_usuario = u.id_usuario
        ORDER BY f.fecha DESC;
    END;
    
    -- Procedimiento adicional: Listar facturas por usuario
    -- CURSOR 12: Retorna todas las facturas de un usuario específico
    PROCEDURE sp_listar_facturas_usuario(
        p_id_usuario NUMBER,
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
        SELECT id_factura, fecha, total, estado
        FROM factura
        WHERE id_usuario = p_id_usuario
        ORDER BY fecha DESC;
    END;
    
END PKG_FACTURA;
/

-- ================================================================================
-- PAQUETE 6 - PKG_VENTA (CRUD + Procesamiento)
-- ================================================================================

-- Especificación del paquete VENTA
CREATE OR REPLACE PACKAGE PKG_VENTA AS
    -- Procedimiento para agregar producto a factura
    PROCEDURE sp_agregar_producto_factura(
        p_id_factura NUMBER,
        p_id_producto NUMBER,
        p_cantidad NUMBER
    );
    
    -- Procedimiento para obtener detalle de venta
    PROCEDURE sp_obtener_detalle_venta(
        p_id_factura NUMBER,
        p_cursor OUT SYS_REFCURSOR
    );
    
    -- Procedimiento para eliminar item de venta
    PROCEDURE sp_eliminar_item_venta(p_id_venta NUMBER);
    
    -- Procedimiento para procesar venta completa
    PROCEDURE sp_procesar_venta_completa(
        p_id_usuario NUMBER,
        p_id_factura OUT NUMBER
    );
END PKG_VENTA;
/

-- Cuerpo del paquete VENTA
CREATE OR REPLACE PACKAGE BODY PKG_VENTA AS
    
    -- Procedimiento interno: Agregar producto a factura
    PROCEDURE sp_agregar_producto_factura(
        p_id_factura NUMBER,
        p_id_producto NUMBER,
        p_cantidad NUMBER
    ) IS
        v_precio NUMBER;
    BEGIN
        -- Obtener precio actual del producto
        SELECT precio INTO v_precio
        FROM producto
        WHERE id_producto = p_id_producto;
        
        -- Insertar detalle de venta
        INSERT INTO venta (id_factura, id_producto, precio, cantidad)
        VALUES (p_id_factura, p_id_producto, v_precio, p_cantidad);
        
        COMMIT;
    END;
    
    -- Procedimiento interno: Obtener detalle de venta
    -- CURSOR 13: Retorna el detalle completo de una factura
    PROCEDURE sp_obtener_detalle_venta(
        p_id_factura NUMBER,
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
        SELECT v.id_venta, v.id_producto, p.descripcion AS producto,
               v.precio, v.cantidad, (v.precio * v.cantidad) AS subtotal
        FROM venta v
        INNER JOIN producto p ON v.id_producto = p.id_producto
        WHERE v.id_factura = p_id_factura;
    END;
    
    -- Procedimiento interno: Eliminar item de venta
    PROCEDURE sp_eliminar_item_venta(p_id_venta NUMBER) IS
        v_id_producto NUMBER;
        v_cantidad NUMBER;
    BEGIN
        -- Obtener datos de la venta para devolver stock
        SELECT id_producto, cantidad 
        INTO v_id_producto, v_cantidad
        FROM venta
        WHERE id_venta = p_id_venta;
        
        -- Devolver stock al producto
        UPDATE producto
        SET existencias = existencias + v_cantidad
        WHERE id_producto = v_id_producto;
        
        -- Eliminar el registro de venta
        DELETE FROM venta
        WHERE id_venta = p_id_venta;
        
        COMMIT;
    END;
    
    -- Procedimiento interno: Procesar venta completa
    PROCEDURE sp_procesar_venta_completa(
        p_id_usuario NUMBER,
        p_id_factura OUT NUMBER
    ) IS
    BEGIN
        -- Crear nueva factura
        PKG_FACTURA.sp_crear_factura(p_id_usuario, p_id_factura);
        
        -- El resto de items se agregarán con sp_agregar_producto_factura
        -- y los triggers actualizarán automáticamente el total
    END;
    
END PKG_VENTA;
/

-- ================================================================================
-- PAQUETE 7 - PKG_REPORTES (Funciones de Reportería)
-- ================================================================================

-- Especificación del paquete REPORTES
CREATE OR REPLACE PACKAGE PKG_REPORTES AS
    -- Procedimiento para reporte de ventas por periodo
    PROCEDURE sp_reporte_ventas_periodo(
        p_fecha_inicio DATE,
        p_fecha_fin DATE,
        p_cursor OUT SYS_REFCURSOR
    );
    
    -- Procedimiento para reporte de productos más vendidos
    PROCEDURE sp_reporte_productos_top(
        p_limite NUMBER,
        p_cursor OUT SYS_REFCURSOR
    );
    
    -- Procedimiento para reporte de productos sin stock
    PROCEDURE sp_reporte_productos_sin_stock(p_cursor OUT SYS_REFCURSOR);
    
    -- Procedimiento para reporte de clientes frecuentes
    PROCEDURE sp_reporte_clientes_frecuentes(p_cursor OUT SYS_REFCURSOR);
END PKG_REPORTES;
/

-- Cuerpo del paquete REPORTES
CREATE OR REPLACE PACKAGE BODY PKG_REPORTES AS
    
    -- Procedimiento: Reporte de ventas por periodo
    -- CURSOR 14: Retorna ventas realizadas en un rango de fechas
    PROCEDURE sp_reporte_ventas_periodo(
        p_fecha_inicio DATE,
        p_fecha_fin DATE,
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
        SELECT f.id_factura, f.fecha, 
               u.nombre || ' ' || u.apellidos AS cliente,
               f.total,
               COUNT(v.id_venta) AS items_vendidos
        FROM factura f
        INNER JOIN usuario u ON f.id_usuario = u.id_usuario
        LEFT JOIN venta v ON f.id_factura = v.id_factura
        WHERE f.fecha BETWEEN p_fecha_inicio AND p_fecha_fin
        GROUP BY f.id_factura, f.fecha, u.nombre, u.apellidos, f.total
        ORDER BY f.fecha DESC;
    END;
    
    -- Procedimiento: Reporte de productos más vendidos
    -- CURSOR 15: Retorna los N productos más vendidos
    PROCEDURE sp_reporte_productos_top(
        p_limite NUMBER,
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
        SELECT p.id_producto, p.descripcion AS producto,
               c.descripcion AS categoria,
               SUM(v.cantidad) AS total_vendido,
               SUM(v.cantidad * v.precio) AS ingresos
        FROM producto p
        INNER JOIN categoria c ON p.id_categoria = c.id_categoria
        INNER JOIN venta v ON p.id_producto = v.id_producto
        GROUP BY p.id_producto, p.descripcion, c.descripcion
        ORDER BY total_vendido DESC
        FETCH FIRST p_limite ROWS ONLY;
    END;
    
    -- Procedimiento: Reporte de productos sin stock
    PROCEDURE sp_reporte_productos_sin_stock(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR
        SELECT p.id_producto, p.descripcion, c.descripcion AS categoria,
               p.precio, p.existencias
        FROM producto p
        INNER JOIN categoria c ON p.id_categoria = c.id_categoria
        WHERE p.existencias = 0 AND p.activo = 1
        ORDER BY p.descripcion;
    END;
    
    -- Procedimiento: Reporte de clientes frecuentes
    PROCEDURE sp_reporte_clientes_frecuentes(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR
        SELECT u.id_usuario, u.username,
               u.nombre || ' ' || u.apellidos AS cliente,
               COUNT(f.id_factura) AS total_compras,
               SUM(f.total) AS monto_total
        FROM usuario u
        INNER JOIN factura f ON u.id_usuario = f.id_usuario
        GROUP BY u.id_usuario, u.username, u.nombre, u.apellidos
        HAVING COUNT(f.id_factura) > 1
        ORDER BY total_compras DESC;
    END;
    
END PKG_REPORTES;
/

-- ================================================================================
-- PAQUETE 8 - PKG_VALIDACIONES (Validaciones Comunes)
-- ================================================================================

-- Especificación del paquete VALIDACIONES
CREATE OR REPLACE PACKAGE PKG_VALIDACIONES AS
    -- Función para validar formato de email
    FUNCTION fn_validar_formato_email(p_email VARCHAR2) RETURN NUMBER;
    
    -- Función para validar username disponible
    FUNCTION fn_username_disponible(p_username VARCHAR2) RETURN NUMBER;
    
    -- Función para validar stock suficiente
    FUNCTION fn_validar_stock_suficiente(
        p_id_producto NUMBER,
        p_cantidad NUMBER
    ) RETURN NUMBER;
    
    -- Función para validar precio válido
    FUNCTION fn_validar_precio(p_precio NUMBER) RETURN NUMBER;
END PKG_VALIDACIONES;
/

-- Cuerpo del paquete VALIDACIONES
CREATE OR REPLACE PACKAGE BODY PKG_VALIDACIONES AS
    
    -- Función: Validar formato de email
    FUNCTION fn_validar_formato_email(p_email VARCHAR2) RETURN NUMBER IS
    BEGIN
      IF REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
         RETURN 1;
      ELSE
        RETURN 0;
      END IF;
    END;
    
    -- Función: Validar username disponible
    FUNCTION fn_username_disponible(p_username VARCHAR2) RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM usuario
        WHERE username = p_username;
        
        RETURN CASE WHEN v_count = 0 THEN 1 ELSE 0 END;
    END;
    
    -- Función: Validar stock suficiente
    FUNCTION fn_validar_stock_suficiente(
        p_id_producto NUMBER,
        p_cantidad NUMBER
    ) RETURN NUMBER IS
        v_stock NUMBER;
    BEGIN
        SELECT existencias INTO v_stock
        FROM producto
        WHERE id_producto = p_id_producto;
        
        RETURN CASE WHEN v_stock >= p_cantidad THEN 1 ELSE 0 END;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
    END;
    
    -- Función: Validar precio válido
    FUNCTION fn_validar_precio(p_precio NUMBER) RETURN NUMBER IS
    BEGIN
        RETURN CASE WHEN p_precio > 0 THEN 1 ELSE 0 END;
    END;
    
END PKG_VALIDACIONES;
/

-- ================================================================================
-- PAQUETE 9 - PKG_SEGURIDAD (Funciones de Seguridad)
-- ================================================================================

-- Especificación del paquete SEGURIDAD
CREATE OR REPLACE PACKAGE PKG_SEGURIDAD AS
    -- Función para verificar permisos de administrador
    FUNCTION fn_verificar_admin(p_id_usuario NUMBER) RETURN NUMBER;
    
    -- Función para verificar permisos de vendedor
    FUNCTION fn_verificar_vendedor(p_id_usuario NUMBER) RETURN NUMBER;
    
    -- Función para verificar usuario activo
    FUNCTION fn_verificar_usuario_activo(p_id_usuario NUMBER) RETURN NUMBER;
    
    -- Procedimiento para cambiar contraseña
    PROCEDURE sp_cambiar_password(
        p_id_usuario NUMBER,
        p_password_nuevo VARCHAR2
    );
END PKG_SEGURIDAD;
/

-- Cuerpo del paquete SEGURIDAD
CREATE OR REPLACE PACKAGE BODY PKG_SEGURIDAD AS
    
    -- Función: Verificar si usuario es administrador
    FUNCTION fn_verificar_admin(p_id_usuario NUMBER) RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM rol
        WHERE id_usuario = p_id_usuario 
        AND nombre = 'ROLE_ADMIN';
        
        RETURN CASE WHEN v_count > 0 THEN 1 ELSE 0 END;
    END;
    
    -- Función: Verificar si usuario es vendedor
    FUNCTION fn_verificar_vendedor(p_id_usuario NUMBER) RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM rol
        WHERE id_usuario = p_id_usuario 
        AND nombre IN ('ROLE_VENDEDOR', 'ROLE_ADMIN');
        
        RETURN CASE WHEN v_count > 0 THEN 1 ELSE 0 END;
    END;
    
    -- Función: Verificar si usuario está activo
    FUNCTION fn_verificar_usuario_activo(p_id_usuario NUMBER) RETURN NUMBER IS
        v_activo NUMBER;
    BEGIN
        SELECT activo INTO v_activo
        FROM usuario
        WHERE id_usuario = p_id_usuario;
        
        RETURN v_activo;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
    END;
    
    -- Procedimiento: Cambiar contraseña de usuario
    PROCEDURE sp_cambiar_password(
        p_id_usuario NUMBER,
        p_password_nuevo VARCHAR2
    ) IS
    BEGIN
        UPDATE usuario
        SET password = p_password_nuevo
        WHERE id_usuario = p_id_usuario;
        COMMIT;
    END;
    
END PKG_SEGURIDAD;
/

-- ================================================================================
-- PAQUETE 10 - PKG_UTILIDADES (Funciones Generales)
-- ================================================================================

-- Especificación del paquete UTILIDADES
CREATE OR REPLACE PACKAGE PKG_UTILIDADES AS
    -- Función para calcular total con IVA
    FUNCTION fn_calcular_con_iva(p_monto NUMBER) RETURN NUMBER;
    
    -- Función para aplicar descuento
    FUNCTION fn_aplicar_descuento(
        p_monto NUMBER,
        p_porcentaje NUMBER
    ) RETURN NUMBER;
    
    -- Función para contar registros activos de una tabla
    FUNCTION fn_contar_categorias_activas RETURN NUMBER;
    FUNCTION fn_contar_productos_activos RETURN NUMBER;
    FUNCTION fn_contar_usuarios_activos RETURN NUMBER;
    
    -- Procedimiento para limpiar datos de prueba
    PROCEDURE sp_limpiar_datos_prueba;
END PKG_UTILIDADES;
/

-- Cuerpo del paquete UTILIDADES
CREATE OR REPLACE PACKAGE BODY PKG_UTILIDADES AS
    
    -- Función: Calcular monto con IVA incluido
    FUNCTION fn_calcular_con_iva(p_monto NUMBER) RETURN NUMBER IS
    BEGIN
        RETURN ROUND(p_monto * 1.13, 2); -- IVA 13%
    END;
    
    -- Función: Aplicar porcentaje de descuento
    FUNCTION fn_aplicar_descuento(
        p_monto NUMBER,
        p_porcentaje NUMBER
    ) RETURN NUMBER IS
    BEGIN
        RETURN ROUND(p_monto * (1 - p_porcentaje/100), 2);
    END;
    
    -- Función: Contar categorías activas
    FUNCTION fn_contar_categorias_activas RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM categoria
        WHERE activo = 1;
        RETURN v_count;
    END;
    
    -- Función: Contar productos activos
    FUNCTION fn_contar_productos_activos RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM producto
        WHERE activo = 1;
        RETURN v_count;
    END;
    
    -- Función: Contar usuarios activos
    FUNCTION fn_contar_usuarios_activos RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM usuario
        WHERE activo = 1;
        RETURN v_count;
    END;
    
    -- Procedimiento: Limpiar datos de prueba (NO ejecutar en producción)
    PROCEDURE sp_limpiar_datos_prueba IS
    BEGIN
        DELETE FROM venta;
        DELETE FROM factura;
        DELETE FROM rol;
        DELETE FROM producto;
        DELETE FROM usuario;
        DELETE FROM categoria;
        COMMIT;
    END;
    
END PKG_UTILIDADES;
/
