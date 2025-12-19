package com.tienda;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionTechShop {
    private static final String DRIVER = "oracle.jdbc.driver.OracleDriver";
    private static final String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
    private static final String USUARIO = "system";
    private static final String PASSWORD = "1234";

    public static Connection obtenerConexion() throws SQLException {
        try {
            Class.forName(DRIVER);
            return DriverManager.getConnection(URL, USUARIO, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Error al cargar el driver de Oracle", e);
        }
    }

    public static void main(String[] args) {
        try (Connection conn = obtenerConexion()) {
            if (conn != null) {
                System.out.println("Conexión exitosa a la base de datos TECHSHOP");
            } else {
                System.out.println("No se pudo establecer la conexión");
            }
        } catch (SQLException e) {
            System.err.println("Error de conexión: " + e.getMessage());
        }
    }
}
