package com.tienda;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PruebaOracleUsuarios {
    
    public static void main(String[] args) {
        System.out.println("=== PRUEBA ORACLE - DOMINIO USUARIOS ===");
        
        // Probar conexión
        probarConexion();
        
        // Probar operaciones CRUD
        probarConsultaUsuarios();
        probarInsertarUsuario();
        probarActualizarUsuario();
        probarConsultarPorUsername();
    }
    
    private static void probarConexion() {
        System.out.println("\n1. Probando conexión a Oracle...");
        try (Connection conn = ConexionTechShop.obtenerConexion()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("✓ Conexión exitosa a Oracle");
                System.out.println("  - URL: " + conn.getMetaData().getURL());
                System.out.println("  - Usuario: " + conn.getMetaData().getUserName());
            }
        } catch (SQLException e) {
            System.err.println("✗ Error de conexión: " + e.getMessage());
        }
    }
    
    private static void probarConsultaUsuarios() {
        System.out.println("\n2. Consultando usuarios existentes...");
        String sql = "SELECT id_usuario, username, nombre, apmellidos, correo, activo FROM usuario ORDER BY id_usuario";
        
        try (Connection conn = ConexionTechShop.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            System.out.println("Usuarios encontrados:");
            System.out.println("ID | Username | Nombre | Apellidos | Correo | Activo");
            System.out.println("---|----------|--------|-----------|--------|-------");
            
            boolean hayUsuarios = false;
            while (rs.next()) {
                hayUsuarios = true;
                System.out.printf("%d | %s | %s | %s | %s | %s%n",
                    rs.getLong("id_usuario"),
                    rs.getString("username"),
                    rs.getString("nombre"),
                    rs.getString("apellidos"),
                    rs.getString("correo"),
                    rs.getBoolean("activo") ? "Sí" : "No"
                );
            }
            
            if (!hayUsuarios) {
                System.out.println("No hay usuarios en la base de datos");
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al consultar usuarios: " + e.getMessage());
        }
    }
    
    private static void probarInsertarUsuario() {
        System.out.println("\n3. Insertando usuario de prueba...");
        String sql = "INSERT INTO usuario (id_usuario, username, password, nombre, apellidos, correo, telefono, activo) " +
                    "VALUES (SEQ_USUARIO.NEXTVAL, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = ConexionTechShop.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "test_user_" + System.currentTimeMillis());
            stmt.setString(2, "password123");
            stmt.setString(3, "Usuario");
            stmt.setString(4, "De Prueba");
            stmt.setString(5, "test" + System.currentTimeMillis() + "@test.com");
            stmt.setString(6, "1234567890");
            stmt.setBoolean(7, true);
            
            int filasAfectadas = stmt.executeUpdate();
            if (filasAfectadas > 0) {
                System.out.println("✓ Usuario insertado correctamente");
                conn.commit();
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al insertar usuario: " + e.getMessage());
        }
    }
    
    private static void probarActualizarUsuario() {
        System.out.println("\n4. Actualizando último usuario...");
        String sqlSelect = "SELECT id_usuario FROM usuario WHERE ROWNUM = 1 ORDER BY id_usuario DESC";
        String sqlUpdate = "UPDATE usuario SET telefono = ? WHERE id_usuario = ?";
        
        try (Connection conn = ConexionTechShop.obtenerConexion()) {
            
            // Obtener el último usuario
            Long ultimoId = null;
            try (PreparedStatement stmt = conn.prepareStatement(sqlSelect);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ultimoId = rs.getLong("id_usuario");
                }
            }
            
            if (ultimoId != null) {
                // Actualizar el teléfono
                try (PreparedStatement stmt = conn.prepareStatement(sqlUpdate)) {
                    stmt.setString(1, "9999999999");
                    stmt.setLong(2, ultimoId);
                    
                    int filasAfectadas = stmt.executeUpdate();
                    if (filasAfectadas > 0) {
                        System.out.println("✓ Usuario actualizado correctamente (ID: " + ultimoId + ")");
                        conn.commit();
                    }
                }
            } else {
                System.out.println("No hay usuarios para actualizar");
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al actualizar usuario: " + e.getMessage());
        }
    }
    
    private static void probarConsultarPorUsername() {
        System.out.println("\n5. Consultando usuario por username...");
        String sql = "SELECT * FROM usuario WHERE username = ?";
        
        try (Connection conn = ConexionTechShop.obtenerConexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "admin");
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    System.out.println("✓ Usuario encontrado:");
                    System.out.println("  - ID: " + rs.getLong("id_usuario"));
                    System.out.println("  - Username: " + rs.getString("username"));
                    System.out.println("  - Nombre: " + rs.getString("nombre"));
                    System.out.println("  - Correo: " + rs.getString("correo"));
                } else {
                    System.out.println("Usuario 'admin' no encontrado");
                }
            }
            
        } catch (SQLException e) {
            System.err.println("✗ Error al consultar por username: " + e.getMessage());
        }
    }
}