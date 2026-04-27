package com.sena.gestion.repository;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.concurrent.Executors;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Conexion {

    private static final Logger LOGGER = Logger.getLogger(Conexion.class.getName());

    private static final String DB_DRIVER   = "org.postgresql.Driver";
    // ✅ CORRECCIÓN: nombre de BD en minúsculas (PostgreSQL es case-sensitive)
    private static final String DB_URL      = "jdbc:postgresql://localhost:5432/Gestiondetareas";
    private static final String DB_USER     = "postgres";
    private static final String DB_PASSWORD = "Mia1924.";

    private static final int LOGIN_TIMEOUT      = 5;
    private static final int CONNECTION_TIMEOUT = 10;

    public static Connection getConexion() {
        try {
            Class.forName(DB_DRIVER);
            DriverManager.setLoginTimeout(LOGIN_TIMEOUT);

            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            if (con == null || con.isClosed()) {
                LOGGER.severe("La conexión es nula o está cerrada.");
                return null;
            }

            con.setAutoCommit(true);

            // ✅ CORRECCIÓN: setNetworkTimeout requiere un Executor, no null
            con.setNetworkTimeout(Executors.newSingleThreadExecutor(), CONNECTION_TIMEOUT * 1000);

            if (!con.isValid(CONNECTION_TIMEOUT)) {
                LOGGER.severe("La conexión no pasó la validación isValid().");
                cerrarConexionSegura(con);
                return null;
            }

            System.out.println("✅ Conexión exitosa a la BD.");
            return con;

        } catch (ClassNotFoundException e) {
            LOGGER.severe("Driver PostgreSQL no encontrado. Agregue el JAR al classpath.");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error SQL al conectar: " + e.getMessage(), e);
            System.err.println("Código SQL: " + e.getErrorCode() + " | Estado: " + e.getSQLState());

            if (e.getMessage().contains("Connection refused")) {
                System.err.println(">> PostgreSQL no está corriendo o el puerto 5432 está bloqueado.");
            } else if (e.getMessage().contains("authentication failed")) {
                System.err.println(">> Usuario o contraseña de BD incorrectos.");
            } else if (e.getMessage().contains("does not exist")) {
                System.err.println(">> La base de datos 'gestiondetareas' no existe. Verifique el nombre exacto.");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error inesperado al conectar.", e);
        }
        return null;
    }

    private static void cerrarConexionSegura(Connection con) {
        if (con != null) {
            try {
                if (!con.isClosed()) con.close();
            } catch (SQLException e) {
                LOGGER.warning("Error al cerrar conexión: " + e.getMessage());
            }
        }
    }
}