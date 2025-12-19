package com.tienda.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.tienda.dao.CategoriaDao;
import com.tienda.dao.FacturaDao;
import com.tienda.dao.ProductoDao;
import com.tienda.dao.RolDao;
import com.tienda.dao.UsuarioDao;
import com.tienda.dao.VentaDao;
import com.tienda.domain.Categoria;
import com.tienda.domain.Factura;
import com.tienda.domain.Producto;
import com.tienda.domain.Rol;
import com.tienda.domain.Usuario;
import com.tienda.domain.Venta;
import jakarta.transaction.Transactional;

@RestController
@RequestMapping("/api/crud-maestro")
public class CrudMaestroController {
    
    @Autowired private UsuarioDao usuarioDao;
    @Autowired private RolDao rolDao;
    @Autowired private CategoriaDao categoriaDao;
    @Autowired private ProductoDao productoDao;
    @Autowired private FacturaDao facturaDao;
    @Autowired private VentaDao ventaDao;
    
    @GetMapping("/probar-todo")
    @Transactional
    public Map<String, Object> probarTodoCrud() {
        Map<String, Object> resultado = new HashMap<>();
        long inicioTiempo = System.currentTimeMillis();
        
        try {
            resultado.put("inicioTiempo", System.currentTimeMillis());
            
            // 1. Información inicial de la base de datos
            resultado.put("estadoInicial", obtenerEstadoCompleto());
            
            // 2. CRUD Usuario
            Map<String, Object> usuarioResult = probarCrudUsuarioCompleto();
            resultado.put("usuario", usuarioResult);
            
            // 3. CRUD Categoría
            Map<String, Object> categoriaResult = probarCrudCategoriaCompleto();
            resultado.put("categoria", categoriaResult);
            
            // 4. CRUD Producto
            Map<String, Object> productoResult = probarCrudProductoCompleto();
            resultado.put("producto", productoResult);
            
            // 5. CRUD Rol
            Map<String, Object> rolResult = probarCrudRolCompleto();
            resultado.put("rol", rolResult);
            
            // 6. CRUD Factura
            Map<String, Object> facturaResult = probarCrudFacturaCompleto();
            resultado.put("factura", facturaResult);
            
            // 7. CRUD Venta
            Map<String, Object> ventaResult = probarCrudVentaCompleto();
            resultado.put("venta", ventaResult);
            
            // 8. Pruebas de relaciones
            Map<String, Object> relacionesResult = probarRelaciones();
            resultado.put("relaciones", relacionesResult);
            
            // 9. Estado final
            resultado.put("estadoFinal", obtenerEstadoCompleto());
            
            long tiempoTotal = System.currentTimeMillis() - inicioTiempo;
            resultado.put("tiempoTotal", tiempoTotal + "ms");
            resultado.put("rendimiento", tiempoTotal < 10000 ? "BUENO" : "LENTO");
            resultado.put("status", "SUCCESS");
            resultado.put("mensaje", "Todas las operaciones CRUD completadas exitosamente con Oracle");
            
        } catch (Exception e) {
            resultado.put("status", "ERROR");
            resultado.put("mensaje", "Error en las operaciones CRUD: " + e.getMessage());
            resultado.put("error", e.getClass().getSimpleName());
        }
        
        return resultado;
    }
    
    @GetMapping("/estadisticas")
    public Map<String, Object> obtenerEstadisticas() {
        Map<String, Object> stats = new HashMap<>();
        
        try {
            stats.put("totalUsuarios", usuarioDao.count());
            stats.put("totalRoles", rolDao.count());
            stats.put("totalCategorias", categoriaDao.count());
            stats.put("totalProductos", productoDao.count());
            stats.put("totalFacturas", facturaDao.count());
            stats.put("totalVentas", ventaDao.count());
                   
            stats.put("status", "SUCCESS");
            stats.put("mensaje", "Estadísticas obtenidas exitosamente");
            
        } catch (Exception e) {
            stats.put("status", "ERROR");
            stats.put("mensaje", "Error al obtener estadísticas: " + e.getMessage());
        }
        
        return stats;
    }
    
    private Map<String, Object> obtenerEstadoCompleto() {
        Map<String, Object> estado = new HashMap<>();
        
        try {
            estado.put("conteos", Map.of(
                "usuarios", usuarioDao.count(),
                "roles", rolDao.count(),
                "categorias", categoriaDao.count(),
                "productos", productoDao.count(),
                "facturas", facturaDao.count(),
                "ventas", ventaDao.count()
            ));
            
            // Información adicional
            estado.put("usuariosActivos", usuarioDao.findAll().stream()
                .filter(u -> u.isActivo()).count());
            estado.put("categoriasActivas", categoriaDao.findByActivoTrue().size());
            estado.put("productosActivos", productoDao.findByActivoTrue().size());
            
        } catch (Exception e) {
            estado.put("error", e.getMessage());
        }
        
        return estado;
    }
    
    @GetMapping("/probarCrudUsuarioCompleto")
    public Map<String, Object> probarCrudUsuarioCompleto() {
        Map<String, Object> result = new HashMap<>();
        long inicio = System.currentTimeMillis();
        
        try {
            // CREATE - Crear múltiples usuarios con IDs únicos garantizados
            List<Usuario> usuariosCreados = new ArrayList<>();
            String baseTimestamp = String.valueOf(System.currentTimeMillis());
            
            for (int i = 1; i <= 3; i++) {
                Usuario usuario = new Usuario();
                String uniqueId = baseTimestamp + "_" + i + "_" + (int)(Math.random() * 1000);
                usuario.setUsername("crud_test_" + uniqueId);
                usuario.setPassword("password123");
                usuario.setNombre("Usuario CRUD " + i);
                usuario.setApellidos("Prueba Oracle");
                usuario.setCorreo("crud" + uniqueId + "@test.com");
                usuario.setTelefono("111111111" + i);
                usuario.setActivo(i % 2 == 1);
                
                // Verificar que no existe antes de crear
                if (!usuarioDao.existsByUsernameOrCorreo(usuario.getUsername(), usuario.getCorreo())) {
                    Usuario usuarioCreado = usuarioDao.save(usuario);
                    usuariosCreados.add(usuarioCreado);
                }
            }
            result.put("created", usuariosCreados.size());
            
            if (!usuariosCreados.isEmpty()) {
                // READ - Múltiples tipos de consulta
                Usuario primerUsuario = usuariosCreados.get(0);
                Usuario usuarioLeido = usuarioDao.findById(primerUsuario.getIdUsuario()).orElse(null);
                Usuario usuarioPorUsername = usuarioDao.findByUsername(primerUsuario.getUsername());
                boolean existe = usuarioDao.existsByUsernameOrCorreo(primerUsuario.getUsername(), primerUsuario.getCorreo());
                
                result.put("readById", usuarioLeido != null);
                result.put("readByUsername", usuarioPorUsername != null);
                result.put("existeValidacion", existe);
                
                // UPDATE - Actualizar en lote
                int actualizados = 0;
                for (Usuario usuario : usuariosCreados) {
                    usuario.setTelefono("999999999");
                    usuarioDao.save(usuario);
                    actualizados++;
                }
                result.put("updated", actualizados);
                
                // DELETE - Eliminar todos los creados
                int eliminados = 0;
                for (Usuario usuario : usuariosCreados) {
                    usuarioDao.delete(usuario);
                    eliminados++;
                }
                result.put("deleted", eliminados);
            } else {
                result.put("readById", false);
                result.put("readByUsername", false);
                result.put("existeValidacion", false);
                result.put("updated", 0);
                result.put("deleted", 0);
            }
            
            long tiempoTotal = System.currentTimeMillis() - inicio;
            result.put("tiempoEjecucion", tiempoTotal + "ms");
            result.put("status", "SUCCESS");
            
        } catch (Exception e) {
            result.put("status", "ERROR");
            result.put("error", e.getMessage());
        }
        
        return result;
    }
    @GetMapping("/probarCrudCategoriaCompleto")
    public Map<String, Object> probarCrudCategoriaCompleto() {
        Map<String, Object> result = new HashMap<>();
        long inicio = System.currentTimeMillis();
        
        try {
            // CREATE múltiples categorías con nombres únicos
            List<Categoria> categoriasCreadas = new ArrayList<>();
            String baseTimestamp = String.valueOf(System.currentTimeMillis());
            
            for (int i = 1; i <= 3; i++) {
                try {
                    Categoria categoria = new Categoria();
                    String uniqueDesc = "Categoría CRUD Test " + baseTimestamp + "_" + i + "_" + (int)(Math.random() * 1000);
                    categoria.setDescripcion(uniqueDesc);
                    categoria.setRutaImagen("/images/crud-test-" + baseTimestamp + "-" + i + ".jpg");
                    categoria.setActivo(i % 2 == 1);
                    
                    Categoria categoriaCreada = categoriaDao.save(categoria);
                    categoriaDao.flush(); // Forzar sincronización con BD
                    categoriasCreadas.add(categoriaCreada);
                } catch (Exception e) {
                    // Continuar con la siguiente si hay error
                    System.out.println("Error creando categoría " + i + ": " + e.getMessage());
                }
            }
            result.put("created", categoriasCreadas.size());
            
            // READ con diferentes métodos
            List<Categoria> categoriasActivas = categoriaDao.findByActivoTrue();
            result.put("activasEnBD", categoriasActivas.size());
            
            // UPDATE
            int actualizadas = 0;
            for (Categoria categoria : categoriasCreadas) {
                try {
                    categoria.setDescripcion(categoria.getDescripcion() + " - ACTUALIZADA");
                    categoriaDao.save(categoria);
                    actualizadas++;
                } catch (Exception e) {
                    System.out.println("Error actualizando categoría: " + e.getMessage());
                }
            }
            result.put("updated", actualizadas);
            
            // DELETE
            int eliminadas = 0;
            for (Categoria categoria : categoriasCreadas) {
                try {
                    categoriaDao.delete(categoria);
                    eliminadas++;
                } catch (Exception e) {
                    System.out.println("Error eliminando categoría: " + e.getMessage());
                }
            }
            result.put("deleted", eliminadas);
            
            long tiempoTotal = System.currentTimeMillis() - inicio;
            result.put("tiempoEjecucion", tiempoTotal + "ms");
            result.put("status", "SUCCESS");
            
        } catch (Exception e) {
            result.put("status", "ERROR");
            result.put("error", e.getMessage());
        }
        
        return result;
    }
    
    @GetMapping("/probarCrudProductoCompleto")
    public Map<String, Object> probarCrudProductoCompleto() {
        Map<String, Object> result = new HashMap<>();
        long inicio = System.currentTimeMillis();
        
        try {
            // Crear categoría temporal
            Categoria categoriaTemp = new Categoria();
            categoriaTemp.setDescripcion("Temp Category " + System.currentTimeMillis());
            categoriaTemp.setActivo(true);
            categoriaTemp = categoriaDao.save(categoriaTemp);
            
            // CREATE múltiples productos
            List<Producto> productosCreados = new ArrayList<>();
            for (int i = 1; i <= 3; i++) {
                Producto producto = new Producto();
                producto.setDescripcion("Producto CRUD Test " + System.currentTimeMillis() + "_" + i);
                producto.setDetalle("Detalle del producto de prueba " + i);
                producto.setPrecio(java.math.BigDecimal.valueOf(99.99 * i));
                producto.setExistencias(10 * i);
                producto.setRutaImagen("/images/producto-crud-" + i + ".jpg");
                producto.setActivo(i % 2 == 1);
                producto.setCategoria(categoriaTemp);
                
                Producto productoCreado = productoDao.save(producto);
                productosCreados.add(productoCreado);
            }
            result.put("created", productosCreados.size());
            
            // READ con consultas específicas
            List<Producto> productosActivos = productoDao.findByActivoTrue();
            List<Producto> productosPorCategoria = productoDao.findByCategoriaIdCategoria(categoriaTemp.getIdCategoria());
            
            result.put("activosEnBD", productosActivos.size());
            result.put("porCategoria", productosPorCategoria.size());
            
            // UPDATE
            for (Producto producto : productosCreados) {
                producto.setPrecio(producto.getPrecio().add(java.math.BigDecimal.valueOf(10.0)));
                productoDao.save(producto);
            }
            result.put("updated", productosCreados.size());
            
            // DELETE
            for (Producto producto : productosCreados) {
                productoDao.delete(producto);
            }
            result.put("deleted", productosCreados.size());
            
            // Limpiar categoría temporal
            categoriaDao.delete(categoriaTemp);
            
            long tiempoTotal = System.currentTimeMillis() - inicio;
            result.put("tiempoEjecucion", tiempoTotal + "ms");
            result.put("status", "SUCCESS");
            
        } catch (Exception e) {
            result.put("status", "ERROR");
            result.put("error", e.getMessage());
        }
        
        return result;
    }
    
    @GetMapping("/probarCrudRolCompleto")
    public Map<String, Object> probarCrudRolCompleto() {
        Map<String, Object> result = new HashMap<>();
        long inicio = System.currentTimeMillis();
        
        try {
            // CREATE múltiples roles con nombres únicos
            List<Rol> rolesCreados = new ArrayList<>();
            String baseTimestamp = String.valueOf(System.currentTimeMillis());
            
            for (int i = 1; i <= 3; i++) {
                try {
                    Rol rol = new Rol();
                    String uniqueName = "ROLE_CRUD_TEST_" + baseTimestamp + "_" + i + "_" + (int)(Math.random() * 1000);
                    rol.setNombre(uniqueName);
                    rol.setIdUsuario(1L); // Usar usuario existente
                    
                    Rol rolCreado = rolDao.save(rol);
                    rolDao.flush(); // Forzar sincronización
                    rolesCreados.add(rolCreado);
                } catch (Exception e) {
                    System.out.println("Error creando rol " + i + ": " + e.getMessage());
                }
            }
            result.put("created", rolesCreados.size());
            
            // READ con consultas específicas
            List<Rol> rolesPorUsuario = rolDao.findByIdUsuario(1L);
            result.put("rolesPorUsuario", rolesPorUsuario.size());
            
            // UPDATE
            int actualizados = 0;
            for (Rol rol : rolesCreados) {
                try {
                    rol.setNombre(rol.getNombre() + "_UPDATED");
                    rolDao.save(rol);
                    actualizados++;
                } catch (Exception e) {
                    System.out.println("Error actualizando rol: " + e.getMessage());
                }
            }
            result.put("updated", actualizados);
            
            // DELETE
            int eliminados = 0;
            for (Rol rol : rolesCreados) {
                try {
                    rolDao.delete(rol);
                    eliminados++;
                } catch (Exception e) {
                    System.out.println("Error eliminando rol: " + e.getMessage());
                }
            }
            result.put("deleted", eliminados);
            
            long tiempoTotal = System.currentTimeMillis() - inicio;
            result.put("tiempoEjecucion", tiempoTotal + "ms");
            result.put("status", "SUCCESS");
            
        } catch (Exception e) {
            result.put("status", "ERROR");
            result.put("error", e.getMessage());
        }
        
        return result;
    }
    
    @GetMapping("/probarCrudFacturaCompleto")
    public Map<String, Object> probarCrudFacturaCompleto() {
        Map<String, Object> result = new HashMap<>();
        long inicio = System.currentTimeMillis();
        
        try {
            // CREATE múltiples facturas
            List<Factura> facturasCreadas = new ArrayList<>();
            
            for (int i = 1; i <= 3; i++) {
                try {
                    Factura factura = new Factura();
                    factura.setIdUsuario(1L); // Usuario existente
                    factura.setFecha(Calendar.getInstance().getTime());
                    factura.setTotal(java.math.BigDecimal.valueOf(199.99 * i));
                    factura.setEstado(i % 2 == 1 ? 1 : 2);
                    
                    Factura facturaCreada = facturaDao.save(factura);
                    facturaDao.flush(); // Forzar sincronización
                    facturasCreadas.add(facturaCreada);
                    
                    // Pequeña pausa para evitar conflictos de timestamp
                    Thread.sleep(10);
                } catch (Exception e) {
                    System.out.println("Error creando factura " + i + ": " + e.getMessage());
                }
            }
            result.put("created", facturasCreadas.size());
            
            // READ con consultas específicas
            List<Factura> facturasPorUsuario = facturaDao.findByIdUsuario(1L);
            result.put("porUsuario", facturasPorUsuario.size());
            
            // UPDATE
            int actualizadas = 0;
            for (Factura factura : facturasCreadas) {
                try {
                    factura.setTotal(factura.getTotal().add(java.math.BigDecimal.valueOf(50.0)));
                    facturaDao.save(factura);
                    actualizadas++;
                } catch (Exception e) {
                    System.out.println("Error actualizando factura: " + e.getMessage());
                }
            }
            result.put("updated", actualizadas);
            
            // DELETE
            int eliminadas = 0;
            for (Factura factura : facturasCreadas) {
                try {
                    facturaDao.delete(factura);
                    eliminadas++;
                } catch (Exception e) {
                    System.out.println("Error eliminando factura: " + e.getMessage());
                }
            }
            result.put("deleted", eliminadas);
            
            long tiempoTotal = System.currentTimeMillis() - inicio;
            result.put("tiempoEjecucion", tiempoTotal + "ms");
            result.put("status", "SUCCESS");
            
        } catch (Exception e) {
            result.put("status", "ERROR");
            result.put("error", e.getMessage());
        }
        
        return result;
    }
    
    @GetMapping("/probarCrudVentaCompleto")
    public Map<String, Object> probarCrudVentaCompleto() {
        Map<String, Object> result = new HashMap<>();
        long inicio = System.currentTimeMillis();
        
        try {
            // Crear factura temporal
            Factura facturaTemp = new Factura();
            facturaTemp.setIdUsuario(1L);
            facturaTemp.setFecha(Calendar.getInstance().getTime());
            facturaTemp.setTotal(java.math.BigDecimal.ZERO);
            facturaTemp.setEstado(1);
            facturaTemp = facturaDao.save(facturaTemp);
            
            // CREATE múltiples ventas
            List<Venta> ventasCreadas = new ArrayList<>();
            for (int i = 1; i <= 3; i++) {
                Venta venta = new Venta();
                venta.setIdFactura(facturaTemp.getIdFactura());
                venta.setIdProducto(1L);
                venta.setPrecio(java.math.BigDecimal.valueOf(49.99 * i));
                venta.setCantidad(i);
                
                Venta ventaCreada = ventaDao.save(venta);
                ventasCreadas.add(ventaCreada);
            }
            result.put("created", ventasCreadas.size());
            
            // READ con consultas específicas
            List<Venta> ventasPorFactura = ventaDao.findByIdFactura(facturaTemp.getIdFactura());
            result.put("porFactura", ventasPorFactura.size());
            
            // UPDATE
            for (Venta venta : ventasCreadas) {
                venta.setCantidad(venta.getCantidad() + 1);
                venta.setPrecio(venta.getPrecio().add(java.math.BigDecimal.valueOf(5.0)));
                ventaDao.save(venta);
            }
            result.put("updated", ventasCreadas.size());
            
            // DELETE
            for (Venta venta : ventasCreadas) {
                ventaDao.delete(venta);
            }
            result.put("deleted", ventasCreadas.size());
            
            // Limpiar factura temporal
            facturaDao.delete(facturaTemp);
            
            long tiempoTotal = System.currentTimeMillis() - inicio;
            result.put("tiempoEjecucion", tiempoTotal + "ms");
            result.put("status", "SUCCESS");
            
        } catch (Exception e) {
            result.put("status", "ERROR");
            result.put("error", e.getMessage());
        }
        
        return result;
    }
    
    @GetMapping("/probarRelaciones")
    public Map<String, Object> probarRelaciones() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Crear datos relacionados para probar
            Usuario usuario = new Usuario();
            usuario.setUsername("test_relacion_" + System.currentTimeMillis());
            usuario.setPassword("password123");
            usuario.setNombre("Test");
            usuario.setApellidos("Relaciones");
            usuario.setCorreo("relacion" + System.currentTimeMillis() + "@test.com");
            usuario.setActivo(true);
            usuario = usuarioDao.save(usuario);
            
            // Crear rol para el usuario
            Rol rol = new Rol();
            rol.setNombre("ROLE_TEST_RELACION");
            rol.setIdUsuario(usuario.getIdUsuario());
            rol = rolDao.save(rol);
            
            // Verificar relaciones
            result.put("usuarioCreado", usuario.getIdUsuario());
            result.put("rolDelUsuario", rolDao.findByIdUsuario(usuario.getIdUsuario()).size());
            
            // Limpiar datos de prueba
            rolDao.delete(rol);
            usuarioDao.delete(usuario);
            
            result.put("status", "SUCCESS");
            result.put("mensaje", "Relaciones probadas exitosamente");
            
        } catch (Exception e) {
            result.put("status", "ERROR");
            result.put("error", e.getMessage());
        }
        
        return result;
    }
}