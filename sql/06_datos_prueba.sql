-- ================================================================================
-- PRUEBAS DATOS
-- ================================================================================

-- Insertar Categorías
INSERT INTO categoria (descripcion, ruta_imagen, activo)
VALUES ('Monitores', 'https://d2ulnfq8we0v3.cloudfront.net/cdn/695858/media/catalog/category/MONITORES.jpg', 1);

INSERT INTO categoria (descripcion, ruta_imagen, activo)
VALUES ('Teclados', 'https://cnnespanol.cnn.com/wp-content/uploads/2022/04/teclado-mecanico.jpg', 1);

INSERT INTO categoria (descripcion, ruta_imagen, activo)
VALUES ('Tarjeta Madre', 'https://static-geektopia.com/storage/thumbs/784x311/788/7884251b/98c0f4a5.webp', 1);

INSERT INTO categoria (descripcion, ruta_imagen, activo)
VALUES ('Celulares', 'https://www.monumental.co.cr/wp-content/uploads/2022/03/X4J2Z6XQUZDO7O6QTDF4DIJ3VE.jpeg', 0);

INSERT INTO categoria (descripcion, ruta_imagen, activo)
VALUES ('Cursos de TI', 'https://storage.googleapis.com/techshop/categoria/imgTI.jpg', 1);

-- Insertar Usuarios
INSERT INTO usuario (username, password, nombre, apellidos, correo, telefono, ruta_imagen, activo)
VALUES ('juan', '$2a$10$P1.w58XvnaYQUQgZUCk4aO/RTRl8EValluCqB3S2VMLTbRt.tlre.', 'Juan', 'Castro Mora', 'jcastro@gmail.com', '4556-8978', 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Juan_Diego_Madrigal.jpg/250px-Juan_Diego_Madrigal.jpg', 1);

INSERT INTO usuario (username, password, nombre, apellidos, correo, telefono, ruta_imagen, activo)
VALUES ('rebeca', '$2a$10$GkEj.ZzmQa/aEfDmtLIh3udIH5fMphx/35d0EYeqZL5uzgCJ0lQRi', 'Rebeca', 'Contreras Mora', 'acontreras@gmail.com', '5456-8789', 'https://upload.wikimedia.org/wikipedia/commons/0/06/Photo_of_Rebeca_Arthur.jpg', 1);

INSERT INTO usuario (username, password, nombre, apellidos, correo, telefono, ruta_imagen, activo)
VALUES ('pedro', '$2a$10$koGR7eS22Pv5KdaVJKDcge04ZB53iMiw76.UjHPY.XyVYlYqXnPbO', 'Pedro', 'Mena Loria', 'lmena@gmail.com', '7898-8936', 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/Eduardo_de_Pedro_2019.jpg/480px-Eduardo_de_Pedro_2019.jpg', 1);

INSERT INTO usuario (username, password, nombre, apellidos, correo, telefono, ruta_imagen, activo)
VALUES ('yelkin22222', '$2a$10$UiF8VZEzEfPVdeiLHZK3CuxT9IkCeG3nHYINpwPKHzNlCXILU6PQG', 'Yelkin', 'Aguilar Acosta', 'jafetacosta62@gmail.com', '62033617', 'https://storage.googleapis.com/techshop/usuarios/CR7-YelkinAguilarAcosta.jpg', 0);

-- Insertar Productos
INSERT INTO producto (id_categoria, descripcion, detalle, precio, existencias, ruta_imagen, activo)
VALUES (1, 'Monitor AOC 19', 'Monitor de 19 pulgadas con resolucion HD', 23000, 5, 'https://c.pxhere.com/images/ec/fd/d67b367ed6467eb826842ac81d3b-1453591.jpg', 1);

INSERT INTO producto (id_categoria, descripcion, detalle, precio, existencias, ruta_imagen, activo)
VALUES (1, 'Monitor MAC', 'Monitor Apple de alta calidad', 27000, 2, 'https://c.pxhere.com/photos/17/77/Art_Calendar_Cc0_Creative_Design_High_Resolution_Mac_Stock-1622403.jpg', 1);

INSERT INTO producto (id_categoria, descripcion, detalle, precio, existencias, ruta_imagen, activo)
VALUES (1, 'Monitor Flex 21', 'Monitor flexible de 21 pulgadas', 24000, 5, 'https://www.trustedreviews.com/wp-content/uploads/sites/54/2022/09/LG-OLED-Flex-7-scaled.jpg', 1);

INSERT INTO producto (id_categoria, descripcion, detalle, precio, existencias, ruta_imagen, activo)
VALUES (1, 'Monitor Flex 36', 'Monitor curvo de 36 pulgadas', 27600, 2, 'https://www.lg.com/us/images/tvs/md08003300/gallery/D-01.jpg', 1);

INSERT INTO producto (id_categoria, descripcion, detalle, precio, existencias, ruta_imagen, activo)
VALUES (2, 'Teclado español everex', 'Teclado mecanico en español', 45000, 5, 'https://http2.mlstatic.com/D_NQ_NP_984317-MLA43206062255_082020-O.webp', 1);

INSERT INTO producto (id_categoria, descripcion, detalle, precio, existencias, ruta_imagen, activo)
VALUES (2, 'Teclado fisico gamer', 'Teclado gamer RGB', 57000, 2, 'https://psycatgames.com/magazine/party-games/gaming-trivia/feature-image_hu1c2b511a5a2ca80ffc557d83cb5157c1_380853_1200x1200_fill_q100_box_smart1.jpg', 1);

INSERT INTO producto (id_categoria, descripcion, detalle, precio, existencias, ruta_imagen, activo)
VALUES (2, 'Teclado usb compacto', 'Teclado compacto USB', 25000, 5, 'https://live.staticflickr.com/7010/26783973491_3e2043edda_b.jpg', 1);

INSERT INTO producto (id_categoria, descripcion, detalle, precio, existencias, ruta_imagen, activo)
VALUES (2, 'Teclado Monitor Flex', 'Teclado inalambrico premium', 27600, 2, 'https://hardzone.es/app/uploads-hardzone.es/2020/10/Mejores-KVM.jpg', 1);

INSERT INTO producto (id_categoria, descripcion, detalle, precio, existencias, ruta_imagen, activo)
VALUES (3, 'CPU Intel 7i', 'Procesador Intel Core i7', 15780, 5, 'https://live.staticflickr.com/7391/9662276651_f4aa27d5ca_b.jpg', 1);

INSERT INTO producto (id_categoria, descripcion, detalle, precio, existencias, ruta_imagen, activo)
VALUES (3, 'CPU Intel Core 5i', 'Procesador Intel Core i5', 15000, 2, 'https://live.staticflickr.com/1473/24714440462_31a0fcdfba_b.jpg', 1);

INSERT INTO producto (id_categoria, descripcion, detalle, precio, existencias, ruta_imagen, activo)
VALUES (3, 'AMD 7500', 'Procesador AMD Ryzen 7500', 25400, 5, 'https://upload.wikimedia.org/wikipedia/commons/0/0c/AMD_Ryzen_9_3900X_-_ISO.jpg', 1);

INSERT INTO producto (id_categoria, descripcion, detalle, precio, existencias, ruta_imagen, activo)
VALUES (3, 'AMD 670', 'Procesador AMD 670', 45000, 3, 'https://upload.wikimedia.org/wikipedia/commons/a/a0/AMD_Duron_850_MHz_D850AUT1B.jpg', 1);

INSERT INTO producto (id_categoria, descripcion, detalle, precio, existencias, ruta_imagen, activo)
VALUES (4, 'Samsung S22', 'Smartphone Samsung Galaxy S22', 285000, 0, 'https://www.trustedreviews.com/wp-content/uploads/sites/54/2022/08/S22-app-drawer-scaled.jpg', 1);

INSERT INTO producto (id_categoria, descripcion, detalle, precio, existencias, ruta_imagen, activo)
VALUES (4, 'Motorola X23', 'Smartphone Motorola X23', 154000, 0, 'https://www.trustedreviews.com/wp-content/uploads/sites/54/2021/10/motorola-2.jpg', 1);

INSERT INTO producto (id_categoria, descripcion, detalle, precio, existencias, ruta_imagen, activo)
VALUES (4, 'Nokia 5430', 'Smartphone Nokia 5430', 330000, 0, 'https://www.trustedreviews.com/wp-content/uploads/sites/54/2021/08/nokia-xr20-1.jpg', 1);

INSERT INTO producto (id_categoria, descripcion, detalle, precio, existencias, ruta_imagen, activo)
VALUES (4, 'Xiami x45', 'Smartphone Xiaomi X45', 273000, 0, 'https://www.trustedreviews.com/wp-content/uploads/sites/54/2022/03/20220315_104812-1-scaled.jpg', 1);

INSERT INTO producto (id_categoria, descripcion, detalle, precio, existencias, ruta_imagen, activo)
VALUES (5, 'Curso de Redes', 'Curso completo de certificacion CCNA', 50000, 9, 'https://storage.googleapis.com/techshop/producto/REDES.jpg', 1);

-- Insertar Roles
INSERT INTO rol (nombre, id_usuario) VALUES ('ROLE_ADMIN', 1);
INSERT INTO rol (nombre, id_usuario) VALUES ('ROLE_VENDEDOR', 1);
INSERT INTO rol (nombre, id_usuario) VALUES ('ROLE_USER', 1);
INSERT INTO rol (nombre, id_usuario) VALUES ('ROLE_VENDEDOR', 2);
INSERT INTO rol (nombre, id_usuario) VALUES ('ROLE_USER', 2);
INSERT INTO rol (nombre, id_usuario) VALUES ('ROLE_USER', 3);
INSERT INTO rol (nombre, id_usuario) VALUES ('ROLE_USER', NULL);
INSERT INTO rol (nombre, id_usuario) VALUES ('ROLE_USER', 4);

-- Insertar Facturas
INSERT INTO factura (id_usuario, fecha, total, estado) VALUES (1, DATE '2022-01-05', 211560, 2);
INSERT INTO factura (id_usuario, fecha, total, estado) VALUES (2, DATE '2022-01-07', 554340, 2);
INSERT INTO factura (id_usuario, fecha, total, estado) VALUES (3, DATE '2022-01-07', 871000, 2);
INSERT INTO factura (id_usuario, fecha, total, estado) VALUES (1, DATE '2022-01-15', 244140, 1);
INSERT INTO factura (id_usuario, fecha, total, estado) VALUES (2, DATE '2022-01-17', 414800, 1);
INSERT INTO factura (id_usuario, fecha, total, estado) VALUES (3, DATE '2022-01-21', 420000, 1);

-- Insertar Ventas
-- SOLO estas ventas son válidas (elimina el resto):
INSERT INTO venta (id_factura, id_producto, precio, cantidad) VALUES (1, 5, 45000, 2);
INSERT INTO venta (id_factura, id_producto, precio, cantidad) VALUES (1, 9, 15780, 1);
INSERT INTO venta (id_factura, id_producto, precio, cantidad) VALUES (1, 10, 15000, 2);
INSERT INTO venta (id_factura, id_producto, precio, cantidad) VALUES (2, 5, 45000, 1);
INSERT INTO venta (id_factura, id_producto, precio, cantidad) VALUES (2, 9, 15780, 1);
INSERT INTO venta (id_factura, id_producto, precio, cantidad) VALUES (3, 6, 57000, 1);
INSERT INTO venta (id_factura, id_producto, precio, cantidad) VALUES (1, 6, 57000, 1);
INSERT INTO venta (id_factura, id_producto, precio, cantidad) VALUES (1, 8, 27600, 2);
INSERT INTO venta (id_factura, id_producto, precio, cantidad) VALUES (2, 3, 24000, 1);
INSERT INTO venta (id_factura, id_producto, precio, cantidad) VALUES (3, 12, 45000, 1);

COMMIT;

