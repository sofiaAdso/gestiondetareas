package com.sena.gestion.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    private static final String URL = "jdbc:postgresql://localhost:5432/Gestiondetareas";
    private static final String USER = "postgres";
    private static final String PASS = "Mia1924.";

    public static Connection getConexion() {
        try {
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error de conexión: " + e.getMessage());
            return null;
        }
    }
}