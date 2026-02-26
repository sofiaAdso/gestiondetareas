package com.sena.gestion.repository;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Conexion {

    private static final Logger LOGGER = Logger.getLogger(Conexion.class.getName());

    // Constantes para la configuración de conexión
    private static final String DB_DRIVER = "org.postgresql.Driver";
    private static final String DB_URL = "jdbc:postgresql://localhost:5432/Gestiondetareas";
    private static final String DB_USER = "postgres";
    private static final String DB_PASSWORD = "Mia1924.";

    // Configuración de timeouts (en segundos)
    private static final int CONNECTION_TIMEOUT = 10;
    private static final int LOGIN_TIMEOUT = 5;

    public static Connection getConexion() {
        Connection con = null;

        // Validación 1: Verificar que las constantes no sean nulas o vacías
        if (!validarParametrosConexion()) {
            System.err.println("Error: Parámetros de conexión inválidos");
            return null;
        }

        try {
            // Validación 2: Cargar el driver de PostgreSQL
            try {
                Class.forName(DB_DRIVER);
                System.out.println("Driver PostgreSQL cargado correctamente");
            } catch (ClassNotFoundException e) {
                System.err.println("Error: Driver PostgreSQL no encontrado");
                System.err.println("Asegúrese de tener postgresql-*.jar en el classpath");
                throw e;
            }

            // Validación 3: Configurar timeout antes de intentar conectar
            try {
                DriverManager.setLoginTimeout(LOGIN_TIMEOUT);
            } catch (Exception e) {
                System.err.println("Advertencia: No se pudo configurar timeout de login: " + e.getMessage());
            }

            // Validación 4: Intentar establecer la conexión con manejo detallado
            System.out.println("Intentando conectar a la base de datos...");
            con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Validación 5: Verificar que la conexión se estableció correctamente
            if (con == null) {
                System.err.println("Error: La conexión es NULL después de DriverManager.getConnection()");
                return null;
            }

            // Validación 6: Verificar que la conexión no está cerrada
            if (con.isClosed()) {
                System.err.println("Error: La conexión está cerrada inmediatamente después de crearse");
                return null;
            }

            // Validación 7: Configurar propiedades de la conexión
            try {
                // --- CONFIGURACIÓN CRÍTICA PARA EL BOTÓN DE ESTADO ---
                // Asegura que cada UPDATE se guarde permanentemente de inmediato
                con.setAutoCommit(true);

                // Configurar timeout de red
                con.setNetworkTimeout(null, CONNECTION_TIMEOUT * 1000);

                System.out.println("¡Conexión exitosa y AutoCommit activo!");
                System.out.println("Todas las configuraciones aplicadas correctamente");

            } catch (SQLException e) {
                System.err.println("Advertencia: Error al configurar propiedades de conexión: " + e.getMessage());
                // Continuamos aunque falle la configuración de timeout
            }

            // Validación 8: Verificar conectividad con la base de datos
            if (!con.isValid(CONNECTION_TIMEOUT)) {
                System.err.println("Error: La conexión no es válida según isValid()");
                cerrarConexionSegura(con);
                return null;
            }

        } catch (ClassNotFoundException e) {
            System.err.println("Error de driver: " + e.getMessage());
            System.err.println("Verifique que el archivo JAR de PostgreSQL esté en el classpath");
            con = null;

        } catch (SQLException e) {
            System.err.println("Error de conexión SQL: " + e.getMessage());
            System.err.println("Código de error SQL: " + e.getErrorCode());
            System.err.println("Estado SQL: " + e.getSQLState());

            // Mensajes de error específicos según el tipo de problema
            if (e.getMessage().contains("timeout")) {
                System.err.println("CAUSA: Timeout al conectar. Verifique que PostgreSQL esté ejecutándose");
            } else if (e.getMessage().contains("Connection refused")) {
                System.err.println("CAUSA: Conexión rechazada. Verifique host y puerto");
            } else if (e.getMessage().contains("authentication failed")) {
                System.err.println("CAUSA: Autenticación fallida. Verifique usuario y contraseña");
            } else if (e.getMessage().contains("database") && e.getMessage().contains("does not exist")) {
                System.err.println("CAUSA: La base de datos 'Gestiondetareas' no existe");
            }

            cerrarConexionSegura(con);
            con = null;

        } catch (Exception e) {
            System.err.println("Error inesperado: " + e.getClass().getName() + " - " + e.getMessage());
            LOGGER.log(Level.SEVERE, "Error inesperado al establecer conexión con la base de datos", e);
            cerrarConexionSegura(con);
            con = null;
        }

        return con;
    }

    /**
     * Valida que los parámetros de conexión no sean nulos o vacíos
     * @return true si los parámetros son válidos, false en caso contrario
     */
    private static boolean validarParametrosConexion() {
        if (DB_DRIVER == null || DB_DRIVER.trim().isEmpty()) {
            System.err.println("Error: DB_DRIVER está vacío o es nulo");
            return false;
        }
        if (DB_URL == null || DB_URL.trim().isEmpty()) {
            System.err.println("Error: DB_URL está vacío o es nulo");
            return false;
        }
        if (DB_USER == null || DB_USER.trim().isEmpty()) {
            System.err.println("Error: DB_USER está vacío o es nulo");
            return false;
        }
        if (DB_PASSWORD == null) {
            System.err.println("Advertencia: DB_PASSWORD es nulo (puede ser válido si no requiere contraseña)");
        }
        return true;
    }

    /**
     * Cierra una conexión de forma segura sin lanzar excepciones
     * @param con Conexión a cerrar
     */
    private static void cerrarConexionSegura(Connection con) {
        if (con != null) {
            try {
                if (!con.isClosed()) {
                    con.close();
                    System.out.println("Conexión cerrada de forma segura");
                }
            } catch (SQLException e) {
                System.err.println("Error al cerrar: " + e.getMessage());
            }
        }
    }
}