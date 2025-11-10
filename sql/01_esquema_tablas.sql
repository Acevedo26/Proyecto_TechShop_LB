-- ================================================================================
-- TABLAS DEL SISTEMA
-- ================================================================================

-- Tabla: CATEGORIA
-- Almacena las categorías de productos disponibles en la tienda
CREATE TABLE categoria (
    id_categoria NUMBER PRIMARY KEY,
    descripcion VARCHAR2(30) NOT NULL,
    ruta_imagen VARCHAR2(1024),
    activo NUMBER(1) DEFAULT 1 NOT NULL,
    CONSTRAINT ck_categoria_activo CHECK (activo IN (0,1))
);

-- Tabla: USUARIO
-- Almacena la información de los usuarios del sistema
CREATE TABLE usuario (
    id_usuario NUMBER PRIMARY KEY,
    username VARCHAR2(20) NOT NULL,
    password VARCHAR2(512) NOT NULL,
    nombre VARCHAR2(20) NOT NULL,
    apellidos VARCHAR2(30) NOT NULL,
    correo VARCHAR2(50),
    telefono VARCHAR2(15),
    ruta_imagen VARCHAR2(1024),
    activo NUMBER(1) DEFAULT 1 NOT NULL,
    CONSTRAINT ck_usuario_activo CHECK (activo IN (0,1)),
    CONSTRAINT uq_usuario_username UNIQUE (username)
);

-- Tabla: PRODUCTO
-- Almacena los productos disponibles para venta
CREATE TABLE producto (
    id_producto NUMBER PRIMARY KEY,
    id_categoria NUMBER NOT NULL,
    descripcion VARCHAR2(30) NOT NULL,
    detalle VARCHAR2(1600) NOT NULL,
    precio NUMBER NOT NULL,
    existencias NUMBER NOT NULL,
    ruta_imagen VARCHAR2(1024),
    activo NUMBER(1) DEFAULT 1 NOT NULL,
    CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
    CONSTRAINT ck_producto_activo CHECK (activo IN (0,1)),
    CONSTRAINT ck_producto_precio CHECK (precio >= 0),
    CONSTRAINT ck_producto_existencias CHECK (existencias >= 0)
);

-- Tabla: ROL
-- Define los roles y permisos de los usuarios
CREATE TABLE rol (
    id_rol NUMBER PRIMARY KEY,
    nombre VARCHAR2(20) NOT NULL,
    id_usuario NUMBER,
    CONSTRAINT fk_rol_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- Tabla: FACTURA
-- Registra las facturas de compra
CREATE TABLE factura (
    id_factura NUMBER PRIMARY KEY,
    id_usuario NUMBER NOT NULL,
    fecha DATE DEFAULT SYSDATE,
    total NUMBER DEFAULT 0,
    estado NUMBER DEFAULT 1,
    CONSTRAINT fk_factura_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- Tabla: VENTA
-- Detalle de productos vendidos en cada factura
CREATE TABLE venta (
    id_venta NUMBER PRIMARY KEY,
    id_factura NUMBER NOT NULL,
    id_producto NUMBER NOT NULL,
    precio NUMBER NOT NULL,
    cantidad NUMBER NOT NULL,
    CONSTRAINT fk_venta_factura FOREIGN KEY (id_factura) REFERENCES factura(id_factura),
    CONSTRAINT fk_venta_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    CONSTRAINT ck_venta_cantidad CHECK (cantidad > 0)
);

-- Tabla: AUDITORIA_PRODUCTO
-- Registra cambios en productos para auditoría
CREATE TABLE auditoria_producto (
    id_auditoria NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_producto NUMBER,
    accion VARCHAR2(10),
    precio_anterior NUMBER,
    precio_nuevo NUMBER,
    existencias_anterior NUMBER,
    existencias_nuevo NUMBER,
    usuario_modificacion VARCHAR2(50),
    fecha_modificacion DATE DEFAULT SYSDATE
);
