package com.tienda.controller;

import com.tienda.dao.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/diagnostico")
public class DiagnosticoController {
    
    @Autowired private DataSource dataSource;
    @Autowired private UsuarioDao usuarioDao;
    @Autowired private RolDao rolDao;
    @Autowired private CategoriaDao categoriaDao;
    @Autowired private ProductoDao productoDao;
    @Autowired private FacturaDao facturaDao;
    @Autowired private VentaDao ventaDao;
    
    @GetMapping("/conexion-completa")
    public Map<String, Object> diagnosticoCompleto() {
        Map<String, Object> diagnostico = new HashMap<>();
        long inicioTiempo = System.currentTimeMillis();
        
        try {
            // 1. Información de conexión
            diagnostico.put("conexion", verificarConexion());
            
            // 2. Información de tablas
            diagnostico.put("tablas", verificarTablas());
            
            // 3. Conteos de registros
            diagnostico.put("conteos", obtenerConteos());
            
            // 4. Verificar secuencias
            diagnostico.put("secuencias", verificarSecuencias());
            
            // 5. Rendimiento
            long tiempoTotal = System.currentTimeMillis() - inicioTiempo;
            diagnostico.put("rendimiento", Map.of(
                "tiempoRespuesta", tiempoTotal + "ms",
                "estado", tiempoTotal < 5000 ? "BUENO" : "LENTO"
            ));
            
            diagnostico.put("status", "SUCCESS");
            diagnostico.put("timestamp", System.currentTimeMillis());
            
        } catch (Exception e) {
            diagnostico.put("status", "ERROR");
            diagnostico.put("error", e.getMessage());
            diagnostico.put("stackTrace", e.getStackTrace());
        }
        
        return diagnostico;
    }
    
    private Map<String, Object> verificarConexion() {
        Map<String, Object> conexionInfo = new HashMap<>();
        
        try (Connection conn = dataSource.getConnection()) {
            DatabaseMetaData metaData = conn.getMetaData();
            
            conexionInfo.put("url", metaData.getURL());
            conexionInfo.put("usuario", metaData.getUserName());
            conexionInfo.put("driver", metaData.getDriverName());
            conexionInfo.put("version", metaData.getDriverVersion());
            conexionInfo.put("baseDatos", metaData.getDatabaseProductName());
            conexionInfo.put("versionBD", metaData.getDatabaseProductVersion());
            conexionInfo.put("conectado", !conn.isClosed());
            conexionInfo.put("autoCommit", conn.getAutoCommit());
            conexionInfo.put("readOnly", conn.isReadOnly());
            
        } catch (Exception e) {
            conexionInfo.put("error", e.getMessage());
        }
        
        return conexionInfo;
    }
    
    private Map<String, Object> verificarTablas() {
        Map<String, Object> tablasInfo = new HashMap<>();
        List<String> tablasEncontradas = new ArrayList<>();
        List<String> tablasEsperadas = List.of("USUARIO", "ROL", "CATEGORIA", "PRODUCTO", "FACTURA", "VENTA");
        
        try (Connection conn = dataSource.getConnection()) {
            DatabaseMetaData metaData = conn.getMetaData();
            
            for (String tabla : tablasEsperadas) {
                try (ResultSet rs = metaData.getTables(null, null, tabla, new String[]{"TABLE"})) {
                    if (rs.next()) {
                        tablasEncontradas.add(tabla);
                    }
                }
            }
            
            tablasInfo.put("esperadas", tablasEsperadas);
            tablasInfo.put("encontradas", tablasEncontradas);
            tablasInfo.put("faltantes", tablasEsperadas.stream()
                .filter(t -> !tablasEncontradas.contains(t))
                .toList());
            tablasInfo.put("todasPresentes", tablasEncontradas.size() == tablasEsperadas.size());
            
        } catch (Exception e) {
            tablasInfo.put("error", e.getMessage());
        }
        
        return tablasInfo;
    }
    
    private Map<String, Object> obtenerConteos() {
        Map<String, Object> conteos = new HashMap<>();
        
        try {
            conteos.put("usuarios", usuarioDao.count());
            conteos.put("roles", rolDao.count());
            conteos.put("categorias", categoriaDao.count());
            conteos.put("productos", productoDao.count());
            conteos.put("facturas", facturaDao.count());
            conteos.put("ventas", ventaDao.count());
            
            long totalRegistros = (Long) conteos.values().stream()
                .mapToLong(v -> (Long) v)
                .sum();
            conteos.put("totalRegistros", totalRegistros);
            
        } catch (Exception e) {
            conteos.put("error", e.getMessage());
        }
        
        return conteos;
    }
    
    private Map<String, Object> verificarSecuencias() {
        Map<String, Object> secuenciasInfo = new HashMap<>();
        List<String> secuenciasEsperadas = List.of(
            "USUARIO_SEQ", "ROL_SEQ", "CATEGORIA_SEQ", 
            "PRODUCTO_SEQ", "FACTURA_SEQ", "VENTA_SEQ"
        );
        
        try (Connection conn = dataSource.getConnection()) {
            List<String> secuenciasEncontradas = new ArrayList<>();
            
            for (String secuencia : secuenciasEsperadas) {
                try (var stmt = conn.prepareStatement(
                    "SELECT sequence_name FROM user_sequences WHERE sequence_name = ?")) {
                    stmt.setString(1, secuencia);
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            secuenciasEncontradas.add(secuencia);
                        }
                    }
                }
            }
            
            secuenciasInfo.put("esperadas", secuenciasEsperadas);
            secuenciasInfo.put("encontradas", secuenciasEncontradas);
            secuenciasInfo.put("faltantes", secuenciasEsperadas.stream()
                .filter(s -> !secuenciasEncontradas.contains(s))
                .toList());
            
        } catch (Exception e) {
            secuenciasInfo.put("error", e.getMessage());
        }
        
        return secuenciasInfo;
    }
    
    @GetMapping("/rendimiento")
    public Map<String, Object> pruebaRendimiento() {
        Map<String, Object> resultado = new HashMap<>();
        
        // Prueba de velocidad de consultas
        long inicio = System.currentTimeMillis();
        
        try {
            // Consultas simples
            long inicioUsuarios = System.currentTimeMillis();
            long countUsuarios = usuarioDao.count();
            long tiempoUsuarios = System.currentTimeMillis() - inicioUsuarios;
            
            long inicioCategorias = System.currentTimeMillis();
            long countCategorias = categoriaDao.count();
            long tiempoCategorias = System.currentTimeMillis() - inicioCategorias;
            
            long inicioProductos = System.currentTimeMillis();
            long countProductos = productoDao.count();
            long tiempoProductos = System.currentTimeMillis() - inicioProductos;
            
            resultado.put("consultas", Map.of(
                "usuarios", Map.of("count", countUsuarios, "tiempo", tiempoUsuarios + "ms"),
                "categorias", Map.of("count", countCategorias, "tiempo", tiempoCategorias + "ms"),
                "productos", Map.of("count", countProductos, "tiempo", tiempoProductos + "ms")
            ));
            
            long tiempoTotal = System.currentTimeMillis() - inicio;
            resultado.put("tiempoTotal", tiempoTotal + "ms");
            resultado.put("estado", tiempoTotal < 1000 ? "EXCELENTE" : 
                                   tiempoTotal < 3000 ? "BUENO" : "LENTO");
            
        } catch (Exception e) {
            resultado.put("error", e.getMessage());
        }
        
        return resultado;
    }
}