
package com.tienda;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PrubaOracle {
    public static void main(String[] args) {
        // SQL para seleccionar todos los usuarios
        String sSQL = "SELECT id_usuario, username, nombre, apellidos, correo, telefono, activo FROM usuario";
        
        try (Connection conexion = ConexionTechShop.obtenerConexion();
             PreparedStatement statement = conexion.prepareStatement(sSQL);
             ResultSet resultSet = statement.executeQuery()) {
            
            System.out.println("=== PRUEBA DE CONEXIÓN - SELECT A TABLA USUARIO ===");
            System.out.println("Conexión exitosa. Datos de la tabla usuario:");
            System.out.println("----------------------------------------------------");
            
            // Verificar si hay resultados
            boolean hayDatos = false;
            
            while (resultSet.next()) {
                hayDatos = true;
                int idUsuario = resultSet.getInt("id_usuario");
                String username = resultSet.getString("username");
                String nombre = resultSet.getString("nombre");
                String apellidos = resultSet.getString("apellidos");
                String correo = resultSet.getString("correo");
                String telefono = resultSet.getString("telefono");
                boolean activo = resultSet.getBoolean("activo");
                
                System.out.printf("ID: %d | Usuario: %s | Nombre: %s %s | Email: %s | Teléfono: %s | Activo: %s%n",
                    idUsuario, username, nombre, apellidos, correo, telefono, activo ? "Sí" : "No");
            }
            
            if (!hayDatos) {
                System.out.println("No se encontraron datos en la tabla usuario.");
            }
            
            System.out.println("----------------------------------------------------");
            System.out.println("Prueba completada exitosamente.");
            
        } catch (SQLException e) {
            System.err.println("Error al ejecutar la consulta: " + e.getMessage());
            e.printStackTrace();
        }
    }
}