package com.tienda.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

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

@RestController
@RequestMapping("/api/monitoreo")
public class MonitoreoController {
    
    @Autowired private UsuarioDao usuarioDao;
    @Autowired private RolDao rolDao;
    @Autowired private CategoriaDao categoriaDao;
    @Autowired private ProductoDao productoDao;
    @Autowired private FacturaDao facturaDao;
    @Autowired private VentaDao ventaDao;
    
    // Registro de operaciones ejecutadas
    private static final Map<String, List<Map<String, Object>>> registroOperaciones = new ConcurrentHashMap<>();
    private static final AtomicLong contadorOperaciones = new AtomicLong(0);
    private static final LocalDateTime inicioSistema = LocalDateTime.now();
    
    @GetMapping("/estado-continuo")
    public Map<String, Object> obtenerEstadoContinuo() {
        Map<String, Object> estado = new HashMap<>();
        long inicioTiempo = System.currentTimeMillis();
        
        try {
            // Información del sistema
            estado.put("tiempoActividad", calcularTiempoActividad());
            estado.put("totalOperacionesEjecutadas", contadorOperaciones.get());
            estado.put("timestampConsulta", LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
            
            // Estadísticas en tiempo real
            Map<String, Object> estadisticas = obtenerEstadisticasEnTiempoReal();
            estado.put("estadisticas", estadisticas);
            
            // Métricas de rendimiento
            Map<String, Object> rendimiento = obtenerMetricasRendimiento();
            estado.put("rendimiento", rendimiento);
            
            // Registro de operaciones recientes
            estado.put("operacionesRecientes", obtenerOperacionesRecientes(10));
            
            // Diagnóstico de conectividad
            Map<String, Object> conectividad = diagnosticarConectividad();
            estado.put("conectividad", conectividad);
            
            // Salud del sistema
            Map<String, Object> salud = evaluarSaludSistema();
            estado.put("saludSistema", salud);
            
            long tiempoRespuesta = System.currentTimeMillis() - inicioTiempo;
            estado.put("tiempoRespuesta", tiempoRespuesta + "ms");
            estado.put("status", "OPERATIVO");
            
            // Registrar esta operación
            registrarOperacion("MONITOREO_CONTINUO", "SUCCESS", tiempoRespuesta);
            
        } catch (Exception e) {
            estado.put("status", "ERROR");
            estado.put("error", e.getMessage());
            registrarOperacion("MONITOREO_CONTINUO", "ERROR", 0);
        }
        
        return estado;
    }
    
    @GetMapping("/registros-ejecucion")
    public Map<String, Object> obtenerRegistrosEjecucion() {
        Map<String, Object> registros = new HashMap<>();
        
        try {
            registros.put("totalOperaciones", contadorOperaciones.get());
            registros.put("operacionesPorTipo", contarOperacionesPorTipo());
            registros.put("operacionesExitosas", contarOperacionesExitosas());
            registros.put("operacionesConError", contarOperacionesConError());
            registros.put("historialCompleto", registroOperaciones);
            registros.put("ultimasOperaciones", obtenerOperacionesRecientes(20));
            
            registros.put("status", "SUCCESS");
            registrarOperacion("CONSULTA_REGISTROS", "SUCCESS", 0);
            
        } catch (Exception e) {
            registros.put("status", "ERROR");
            registros.put("error", e.getMessage());
            registrarOperacion("CONSULTA_REGISTROS", "ERROR", 0);
        }
        
        return registros;
    }
    
    @GetMapping("/diagnostico-modulos")
    public Map<String, Object> diagnosticarModulos() {
        Map<String, Object> diagnostico = new HashMap<>();
        long inicioTiempo = System.currentTimeMillis();
        
        try {
            // Diagnóstico de cada módulo
            diagnostico.put("moduloUsuarios", diagnosticarModuloUsuarios());
            diagnostico.put("moduloCategorias", diagnosticarModuloCategorias());
            diagnostico.put("moduloProductos", diagnosticarModuloProductos());
            diagnostico.put("moduloRoles", diagnosticarModuloRoles());
            diagnostico.put("moduloFacturas", diagnosticarModuloFacturas());
            diagnostico.put("moduloVentas", diagnosticarModuloVentas());
            
            // Resumen general
            Map<String, Object> resumen = generarResumenDiagnostico(diagnostico);
            diagnostico.put("resumenGeneral", resumen);
            
            long tiempoTotal = System.currentTimeMillis() - inicioTiempo;
            diagnostico.put("tiempoDiagnostico", tiempoTotal + "ms");
            diagnostico.put("status", "COMPLETADO");
            
            registrarOperacion("DIAGNOSTICO_MODULOS", "SUCCESS", tiempoTotal);
            
        } catch (Exception e) {
            diagnostico.put("status", "ERROR");
            diagnostico.put("error", e.getMessage());
            registrarOperacion("DIAGNOSTICO_MODULOS", "ERROR", 0);
        }
        
        return diagnostico;
    }
    
    @GetMapping("/metricas-rendimiento")
    public Map<String, Object> obtenerMetricasRendimiento() {
        Map<String, Object> metricas = new HashMap<>();
        
        try {
            // Métricas de base de datos
            long inicioConsulta = System.currentTimeMillis();
            long totalRegistros = usuarioDao.count() + categoriaDao.count() + 
                                productoDao.count() + rolDao.count() + 
                                facturaDao.count() + ventaDao.count();
            long tiempoConsulta = System.currentTimeMillis() - inicioConsulta;
            
            metricas.put("totalRegistrosBD", totalRegistros);
            metricas.put("tiempoConsultaBD", tiempoConsulta + "ms");
            metricas.put("rendimientoBD", tiempoConsulta < 1000 ? "EXCELENTE" : 
                                        tiempoConsulta < 3000 ? "BUENO" : "LENTO");
            
            // Métricas de memoria (simuladas)
            Runtime runtime = Runtime.getRuntime();
            long memoriaTotal = runtime.totalMemory();
            long memoriaLibre = runtime.freeMemory();
            long memoriaUsada = memoriaTotal - memoriaLibre;
            
            metricas.put("memoriaTotal", formatearBytes(memoriaTotal));
            metricas.put("memoriaUsada", formatearBytes(memoriaUsada));
            metricas.put("memoriaLibre", formatearBytes(memoriaLibre));
            metricas.put("porcentajeUsoMemoria", (memoriaUsada * 100) / memoriaTotal + "%");
            
            // Métricas de operaciones
            metricas.put("operacionesTotales", contadorOperaciones.get());
            metricas.put("promedioOperacionesPorMinuto", calcularPromedioOperaciones());
            
            metricas.put("status", "SUCCESS");
            registrarOperacion("METRICAS_RENDIMIENTO", "SUCCESS", 0);
            
        } catch (Exception e) {
            metricas.put("status", "ERROR");
            metricas.put("error", e.getMessage());
            registrarOperacion("METRICAS_RENDIMIENTO", "ERROR", 0);
        }
        
        return metricas;
    }
    
    @GetMapping("/limpiar-registros")
    public Map<String, Object> limpiarRegistros() {
        Map<String, Object> resultado = new HashMap<>();
        
        try {
            int operacionesAnteriores = registroOperaciones.size();
            registroOperaciones.clear();
            contadorOperaciones.set(0);
            
            resultado.put("operacionesEliminadas", operacionesAnteriores);
            resultado.put("mensaje", "Registros limpiados exitosamente");
            resultado.put("status", "SUCCESS");
            
            registrarOperacion("LIMPIAR_REGISTROS", "SUCCESS", 0);
            
        } catch (Exception e) {
            resultado.put("status", "ERROR");
            resultado.put("error", e.getMessage());
        }
        
        return resultado;
    }
    
    @GetMapping("/operacion-continua")
    public Map<String, Object> ejecutarOperacionContinua() {
        Map<String, Object> resultado = new HashMap<>();
        long inicioTiempo = System.currentTimeMillis();
        
        try {
            // Ejecutar operaciones de forma continua para validar estabilidad
            List<Map<String, Object>> resultadosOperaciones = new ArrayList<>();
            
            // 1. Verificar conectividad
            Map<String, Object> conectividad = diagnosticarConectividad();
            resultadosOperaciones.add(Map.of("operacion", "CONECTIVIDAD", "resultado", conectividad));
            
            // 2. Obtener estadísticas
            Map<String, Object> estadisticas = obtenerEstadisticasEnTiempoReal();
            resultadosOperaciones.add(Map.of("operacion", "ESTADISTICAS", "resultado", estadisticas));
            
            // 3. Verificar salud del sistema
            Map<String, Object> salud = evaluarSaludSistema();
            resultadosOperaciones.add(Map.of("operacion", "SALUD_SISTEMA", "resultado", salud));
            
            // 4. Métricas de rendimiento
            Map<String, Object> rendimiento = obtenerMetricasRendimiento();
            resultadosOperaciones.add(Map.of("operacion", "RENDIMIENTO", "resultado", rendimiento));
            
            // 5. Diagnóstico de módulos
            Map<String, Object> modulos = diagnosticarModulos();
            resultadosOperaciones.add(Map.of("operacion", "DIAGNOSTICO_MODULOS", "resultado", modulos));
            
            long tiempoTotal = System.currentTimeMillis() - inicioTiempo;
            
            resultado.put("operacionesEjecutadas", resultadosOperaciones);
            resultado.put("totalOperaciones", resultadosOperaciones.size());
            resultado.put("tiempoEjecucion", tiempoTotal + "ms");
            resultado.put("rendimiento", tiempoTotal < 5000 ? "EXCELENTE" : 
                                       tiempoTotal < 10000 ? "BUENO" : "LENTO");
            resultado.put("timestamp", LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
            resultado.put("status", "SUCCESS");
            resultado.put("mensaje", "Operación continua ejecutada exitosamente");
            
            registrarOperacion("OPERACION_CONTINUA", "SUCCESS", tiempoTotal);
            
        } catch (Exception e) {
            resultado.put("status", "ERROR");
            resultado.put("error", e.getMessage());
            resultado.put("mensaje", "Error en operación continua: " + e.getMessage());
            registrarOperacion("OPERACION_CONTINUA", "ERROR", 0);
        }
        
        return resultado;
    }
    
    @GetMapping("/resumen-sistema")
    public Map<String, Object> obtenerResumenSistema() {
        Map<String, Object> resumen = new HashMap<>();
        
        try {
            // Información básica del sistema
            resumen.put("tiempoActividad", calcularTiempoActividad());
            resumen.put("totalOperaciones", contadorOperaciones.get());
            resumen.put("inicioSistema", inicioSistema.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
            resumen.put("timestampActual", LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
            
            // Estadísticas rápidas
            Map<String, Object> estadisticasRapidas = new HashMap<>();
            estadisticasRapidas.put("usuarios", usuarioDao.count());
            estadisticasRapidas.put("productos", productoDao.count());
            estadisticasRapidas.put("categorias", categoriaDao.count());
            estadisticasRapidas.put("facturas", facturaDao.count());
            resumen.put("estadisticas", estadisticasRapidas);
            
            // Estado de conectividad
            Map<String, Object> conectividad = diagnosticarConectividad();
            resumen.put("conectividad", conectividad.get("estadoConexion"));
            
            // Operaciones recientes
            resumen.put("operacionesRecientes", obtenerOperacionesRecientes(5));
            
            // Salud general
            Map<String, Object> salud = evaluarSaludSistema();
            resumen.put("saludGeneral", salud.get("estado"));
            resumen.put("puntuacionSalud", salud.get("puntuacion"));
            
            resumen.put("status", "SUCCESS");
            registrarOperacion("RESUMEN_SISTEMA", "SUCCESS", 0);
            
        } catch (Exception e) {
            resumen.put("status", "ERROR");
            resumen.put("error", e.getMessage());
            registrarOperacion("RESUMEN_SISTEMA", "ERROR", 0);
        }
        
        return resumen;
    }
    
    // Métodos auxiliares
    private void registrarOperacion(String tipo, String estado, long tiempoEjecucion) {
        Map<String, Object> operacion = new HashMap<>();
        operacion.put("id", contadorOperaciones.incrementAndGet());
        operacion.put("tipo", tipo);
        operacion.put("estado", estado);
        operacion.put("timestamp", LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
        operacion.put("tiempoEjecucion", tiempoEjecucion);
        
        registroOperaciones.computeIfAbsent(tipo, k -> new ArrayList<>()).add(operacion);
    }
    
    private String calcularTiempoActividad() {
        LocalDateTime ahora = LocalDateTime.now();
        long minutos = java.time.Duration.between(inicioSistema, ahora).toMinutes();
        long horas = minutos / 60;
        minutos = minutos % 60;
        
        return String.format("%d horas, %d minutos", horas, minutos);
    }
    
    private Map<String, Object> obtenerEstadisticasEnTiempoReal() {
        Map<String, Object> stats = new HashMap<>();
        
        try {
            stats.put("usuarios", usuarioDao.count());
            stats.put("categorias", categoriaDao.count());
            stats.put("productos", productoDao.count());
            stats.put("roles", rolDao.count());
            stats.put("facturas", facturaDao.count());
            stats.put("ventas", ventaDao.count());
            
            // Estadísticas adicionales
            stats.put("usuariosActivos", usuarioDao.findAll().stream().filter(u -> u.isActivo()).count());
            stats.put("categoriasActivas", categoriaDao.findByActivoTrue().size());
            stats.put("productosActivos", productoDao.findByActivoTrue().size());
            
        } catch (Exception e) {
            stats.put("error", "Error obteniendo estadísticas: " + e.getMessage());
        }
        
        return stats;
    }
    
    private List<Map<String, Object>> obtenerOperacionesRecientes(int limite) {
        List<Map<String, Object>> recientes = new ArrayList<>();
        
        registroOperaciones.values().forEach(operaciones -> {
            operaciones.stream()
                .sorted((o1, o2) -> ((String)o2.get("timestamp")).compareTo((String)o1.get("timestamp")))
                .limit(limite)
                .forEach(recientes::add);
        });
        
        return recientes.stream()
            .sorted((o1, o2) -> ((String)o2.get("timestamp")).compareTo((String)o1.get("timestamp")))
            .limit(limite)
            .toList();
    }
    
    private Map<String, Object> diagnosticarConectividad() {
        Map<String, Object> conectividad = new HashMap<>();
        
        try {
            long inicio = System.currentTimeMillis();
            usuarioDao.count(); // Prueba de conectividad
            long tiempoConexion = System.currentTimeMillis() - inicio;
            
            conectividad.put("estadoConexion", "CONECTADO");
            conectividad.put("tiempoRespuesta", tiempoConexion + "ms");
            conectividad.put("calidad", tiempoConexion < 100 ? "EXCELENTE" : 
                                      tiempoConexion < 500 ? "BUENA" : "LENTA");
            
        } catch (Exception e) {
            conectividad.put("estadoConexion", "ERROR");
            conectividad.put("error", e.getMessage());
        }
        
        return conectividad;
    }
    
    private Map<String, Object> evaluarSaludSistema() {
        Map<String, Object> salud = new HashMap<>();
        
        try {
            int puntuacion = 100;
            List<String> problemas = new ArrayList<>();
            
            // Verificar conectividad BD
            try {
                usuarioDao.count();
            } catch (Exception e) {
                puntuacion -= 30;
                problemas.add("Problema de conectividad con base de datos");
            }
            
            // Verificar rendimiento
            long inicio = System.currentTimeMillis();
            obtenerEstadisticasEnTiempoReal();
            long tiempoRespuesta = System.currentTimeMillis() - inicio;
            
            if (tiempoRespuesta > 2000) {
                puntuacion -= 20;
                problemas.add("Rendimiento lento del sistema");
            }
            
            // Verificar memoria
            Runtime runtime = Runtime.getRuntime();
            long memoriaUsada = runtime.totalMemory() - runtime.freeMemory();
            long porcentajeMemoria = (memoriaUsada * 100) / runtime.totalMemory();
            
            if (porcentajeMemoria > 80) {
                puntuacion -= 15;
                problemas.add("Alto uso de memoria");
            }
            
            salud.put("puntuacion", puntuacion);
            salud.put("estado", puntuacion >= 80 ? "SALUDABLE" : 
                              puntuacion >= 60 ? "ADVERTENCIA" : "CRITICO");
            salud.put("problemas", problemas);
            salud.put("recomendaciones", generarRecomendaciones(problemas));
            
        } catch (Exception e) {
            salud.put("estado", "ERROR");
            salud.put("error", e.getMessage());
        }
        
        return salud;
    }
    
    private Map<String, Object> diagnosticarModuloUsuarios() {
        Map<String, Object> diagnostico = new HashMap<>();
        
        try {
            long total = usuarioDao.count();
            long activos = usuarioDao.findAll().stream().filter(u -> u.isActivo()).count();
            
            diagnostico.put("totalUsuarios", total);
            diagnostico.put("usuariosActivos", activos);
            diagnostico.put("usuariosInactivos", total - activos);
            diagnostico.put("estado", total > 0 ? "OPERATIVO" : "SIN_DATOS");
            
        } catch (Exception e) {
            diagnostico.put("estado", "ERROR");
            diagnostico.put("error", e.getMessage());
        }
        
        return diagnostico;
    }
    
    private Map<String, Object> diagnosticarModuloCategorias() {
        Map<String, Object> diagnostico = new HashMap<>();
        
        try {
            long total = categoriaDao.count();
            long activas = categoriaDao.findByActivoTrue().size();
            
            diagnostico.put("totalCategorias", total);
            diagnostico.put("categoriasActivas", activas);
            diagnostico.put("categoriasInactivas", total - activas);
            diagnostico.put("estado", total > 0 ? "OPERATIVO" : "SIN_DATOS");
            
        } catch (Exception e) {
            diagnostico.put("estado", "ERROR");
            diagnostico.put("error", e.getMessage());
        }
        
        return diagnostico;
    }
    
    private Map<String, Object> diagnosticarModuloProductos() {
        Map<String, Object> diagnostico = new HashMap<>();
        
        try {
            long total = productoDao.count();
            long activos = productoDao.findByActivoTrue().size();
            
            diagnostico.put("totalProductos", total);
            diagnostico.put("productosActivos", activos);
            diagnostico.put("productosInactivos", total - activos);
            diagnostico.put("estado", total > 0 ? "OPERATIVO" : "SIN_DATOS");
            
        } catch (Exception e) {
            diagnostico.put("estado", "ERROR");
            diagnostico.put("error", e.getMessage());
        }
        
        return diagnostico;
    }
    
    private Map<String, Object> diagnosticarModuloRoles() {
        Map<String, Object> diagnostico = new HashMap<>();
        
        try {
            long total = rolDao.count();
            
            diagnostico.put("totalRoles", total);
            diagnostico.put("estado", total > 0 ? "OPERATIVO" : "SIN_DATOS");
            
        } catch (Exception e) {
            diagnostico.put("estado", "ERROR");
            diagnostico.put("error", e.getMessage());
        }
        
        return diagnostico;
    }
    
    private Map<String, Object> diagnosticarModuloFacturas() {
        Map<String, Object> diagnostico = new HashMap<>();
        
        try {
            long total = facturaDao.count();
            
            diagnostico.put("totalFacturas", total);
            diagnostico.put("estado", "OPERATIVO");
            
        } catch (Exception e) {
            diagnostico.put("estado", "ERROR");
            diagnostico.put("error", e.getMessage());
        }
        
        return diagnostico;
    }
    
    private Map<String, Object> diagnosticarModuloVentas() {
        Map<String, Object> diagnostico = new HashMap<>();
        
        try {
            long total = ventaDao.count();
            
            diagnostico.put("totalVentas", total);
            diagnostico.put("estado", "OPERATIVO");
            
        } catch (Exception e) {
            diagnostico.put("estado", "ERROR");
            diagnostico.put("error", e.getMessage());
        }
        
        return diagnostico;
    }
    
    private Map<String, Object> generarResumenDiagnostico(Map<String, Object> diagnostico) {
        Map<String, Object> resumen = new HashMap<>();
        
        int modulosOperativos = 0;
        int modulosConError = 0;
        int modulosSinDatos = 0;
        
        for (Object valor : diagnostico.values()) {
            if (valor instanceof Map) {
                @SuppressWarnings("unchecked")
                Map<String, Object> modulo = (Map<String, Object>) valor;
                String estado = (String) modulo.get("estado");
                
                if ("OPERATIVO".equals(estado)) modulosOperativos++;
                else if ("ERROR".equals(estado)) modulosConError++;
                else if ("SIN_DATOS".equals(estado)) modulosSinDatos++;
            }
        }
        
        resumen.put("modulosOperativos", modulosOperativos);
        resumen.put("modulosConError", modulosConError);
        resumen.put("modulosSinDatos", modulosSinDatos);
        resumen.put("estadoGeneral", modulosConError == 0 ? "SALUDABLE" : "CON_PROBLEMAS");
        
        return resumen;
    }
    
    private Map<String, Long> contarOperacionesPorTipo() {
        Map<String, Long> conteos = new HashMap<>();
        
        registroOperaciones.forEach((tipo, operaciones) -> {
            conteos.put(tipo, (long) operaciones.size());
        });
        
        return conteos;
    }
    
    private long contarOperacionesExitosas() {
        return registroOperaciones.values().stream()
            .flatMap(List::stream)
            .mapToLong(op -> "SUCCESS".equals(op.get("estado")) ? 1 : 0)
            .sum();
    }
    
    private long contarOperacionesConError() {
        return registroOperaciones.values().stream()
            .flatMap(List::stream)
            .mapToLong(op -> "ERROR".equals(op.get("estado")) ? 1 : 0)
            .sum();
    }
    
    private double calcularPromedioOperaciones() {
        long minutosActividad = java.time.Duration.between(inicioSistema, LocalDateTime.now()).toMinutes();
        if (minutosActividad == 0) minutosActividad = 1;
        
        return (double) contadorOperaciones.get() / minutosActividad;
    }
    
    private String formatearBytes(long bytes) {
        if (bytes < 1024) return bytes + " B";
        if (bytes < 1024 * 1024) return (bytes / 1024) + " KB";
        if (bytes < 1024 * 1024 * 1024) return (bytes / (1024 * 1024)) + " MB";
        return (bytes / (1024 * 1024 * 1024)) + " GB";
    }
    
    private List<String> generarRecomendaciones(List<String> problemas) {
        List<String> recomendaciones = new ArrayList<>();
        
        for (String problema : problemas) {
            if (problema.contains("conectividad")) {
                recomendaciones.add("Verificar configuración de base de datos");
                recomendaciones.add("Revisar conexiones de red");
            } else if (problema.contains("rendimiento")) {
                recomendaciones.add("Optimizar consultas de base de datos");
                recomendaciones.add("Revisar índices de tablas");
            } else if (problema.contains("memoria")) {
                recomendaciones.add("Aumentar memoria asignada a la aplicación");
                recomendaciones.add("Revisar posibles memory leaks");
            }
        }
        
        if (recomendaciones.isEmpty()) {
            recomendaciones.add("Sistema funcionando correctamente");
        }
        
        return recomendaciones;
    }
}