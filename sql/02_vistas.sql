-- ================================================================================
-- VISTAS 
-- ================================================================================

-- VISTA 1: Productos con información de categoría
-- Muestra todos los productos con el nombre de su categoría
CREATE OR REPLACE VIEW v_productos_con_categoria AS
SELECT 
    p.id_producto,
    p.descripcion AS producto,
    p.detalle,
    p.precio,
    p.existencias,
    c.descripcion AS categoria,
    p.ruta_imagen,
    p.activo
FROM producto p
INNER JOIN categoria c ON p.id_categoria = c.id_categoria;

-- VISTA 2: Detalle completo de ventas
-- Muestra información detallada de todas las ventas
CREATE OR REPLACE VIEW v_detalle_ventas AS
SELECT 
    v.id_venta,
    f.id_factura,
    f.fecha,
    u.username,
    u.nombre || ' ' || u.apellidos AS cliente,
    p.descripcion AS producto,
    v.cantidad,
    v.precio,
    v.cantidad * v.precio AS subtotal
FROM venta v
INNER JOIN factura f ON v.id_factura = f.id_factura
INNER JOIN usuario u ON f.id_usuario = u.id_usuario
INNER JOIN producto p ON v.id_producto = p.id_producto;

-- VISTA 3: Usuarios con sus roles
-- Lista usuarios y todos sus roles asignados
CREATE OR REPLACE VIEW v_usuarios_roles AS
SELECT 
    u.id_usuario,
    u.username,
    u.nombre,
    u.apellidos,
    u.correo,
    r.nombre AS rol,
    u.activo
FROM usuario u
LEFT JOIN rol r ON u.id_usuario = r.id_usuario;

-- VISTA 4: Facturas completas con cliente
-- Muestra todas las facturas con información del cliente
CREATE OR REPLACE VIEW v_facturas_completas AS
SELECT 
    f.id_factura,
    f.fecha,
    u.username,
    u.nombre || ' ' || u.apellidos AS cliente,
    u.correo,
    u.telefono,
    f.total,
    CASE f.estado
        WHEN 1 THEN 'Pendiente'
        WHEN 2 THEN 'Pagada'
        WHEN 3 THEN 'Cancelada'
        ELSE 'Desconocido'
    END AS estado_texto
FROM factura f
INNER JOIN usuario u ON f.id_usuario = u.id_usuario;

-- VISTA 5: Productos activos en stock
-- Lista solo productos activos con existencias disponibles
CREATE OR REPLACE VIEW v_productos_disponibles AS
SELECT 
    p.id_producto,
    p.descripcion,
    p.detalle,
    p.precio,
    p.existencias,
    c.descripcion AS categoria
FROM producto p
INNER JOIN categoria c ON p.id_categoria = c.id_categoria
WHERE p.activo = 1 AND p.existencias > 0;

-- VISTA 6: Ventas por usuario
-- Resumen de ventas totales por cada usuario
CREATE OR REPLACE VIEW v_ventas_por_usuario AS
SELECT 
    u.id_usuario,
    u.username,
    u.nombre || ' ' || u.apellidos AS cliente,
    COUNT(DISTINCT f.id_factura) AS total_facturas,
    SUM(f.total) AS monto_total
FROM usuario u
INNER JOIN factura f ON u.id_usuario = f.id_usuario
GROUP BY u.id_usuario, u.username, u.nombre, u.apellidos;

-- VISTA 7: Ingresos por categoría
-- Calcula los ingresos totales generados por cada categoría
CREATE OR REPLACE VIEW v_ingresos_por_categoria AS
SELECT 
    c.id_categoria,
    c.descripcion AS categoria,
    COUNT(DISTINCT v.id_venta) AS total_ventas,
    SUM(v.cantidad * v.precio) AS ingresos_totales
FROM categoria c
INNER JOIN producto p ON c.id_categoria = p.id_categoria
INNER JOIN venta v ON p.id_producto = v.id_producto
GROUP BY c.id_categoria, c.descripcion;

-- VISTA 8: Productos más vendidos
-- Ranking de productos por cantidad vendida
CREATE OR REPLACE VIEW v_productos_mas_vendidos AS
SELECT 
    p.id_producto,
    p.descripcion AS producto,
    c.descripcion AS categoria,
    SUM(v.cantidad) AS cantidad_vendida,
    SUM(v.cantidad * v.precio) AS ingresos_generados
FROM producto p
INNER JOIN categoria c ON p.id_categoria = c.id_categoria
INNER JOIN venta v ON p.id_producto = v.id_producto
GROUP BY p.id_producto, p.descripcion, c.descripcion
ORDER BY cantidad_vendida DESC;

-- VISTA 9: Clientes activos
-- Lista de clientes con cuenta activa
CREATE OR REPLACE VIEW v_clientes_activos AS
SELECT 
    u.id_usuario,
    u.username,
    u.nombre,
    u.apellidos,
    u.correo,
    u.telefono,
    COUNT(r.id_rol) AS cantidad_roles
FROM usuario u
LEFT JOIN rol r ON u.id_usuario = r.id_usuario
WHERE u.activo = 1
GROUP BY u.id_usuario, u.username, u.nombre, u.apellidos, u.correo, u.telefono;

-- VISTA 10: Facturas pendientes
-- Muestra facturas que aún no han sido pagadas
CREATE OR REPLACE VIEW v_facturas_pendientes AS
SELECT 
    f.id_factura,
    f.fecha,
    u.username,
    u.nombre || ' ' || u.apellidos AS cliente,
    f.total,
    TRUNC(SYSDATE - f.fecha) AS dias_pendiente
FROM factura f
INNER JOIN usuario u ON f.id_usuario = u.id_usuario
WHERE f.estado = 1;