package com.sena.gestion.repository;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.concurrent.Executors;
import java.util.logging.Level;
import java.util.logging.Logger;
public class Conexion {
    private static final Logger LOGGER = Logger.getLogger(Conexion.class.getName());
    private static final String DB_DRIVER = "org.postgresql.Driver";

    private static String getUrl() {
        String url = System.getenv("DB_URL");
        return (url != null && !url.isEmpty()) ? url : "jdbc:postgresql://localhost:5432/Gestiondetareas";
    }
    private static String getUser() {
        String user = System.getenv("DB_USER");
        return (user != null && !user.isEmpty()) ? user : "postgres";
    }
    private static String getPassword() {
        String pass = System.getenv("DB_PASSWORD");
        return (pass != null && !pass.isEmpty()) ? pass : "Mia1924.";
    }

    private static final int LOGIN_TIMEOUT      = 5;
    private static final int CONNECTION_TIMEOUT = 10;
    public static Connection getConexion() {
        try {
            Class.forName(DB_DRIVER);
            DriverManager.setLoginTimeout(LOGIN_TIMEOUT);
            Connection con = DriverManager.getConnection(getUrl(), getUser(), getPassword());
            if (con == null || con.isClosed()) {
                LOGGER.severe("La conexión es nula o está cerrada.");
                return null;
            }
            con.setAutoCommit(true);
            con.setNetworkTimeout(Executors.newSingleThreadExecutor(), CONNECTION_TIMEOUT * 1000);
            if (!con.isValid(CONNECTION_TIMEOUT)) {
                LOGGER.severe("La conexión no pasó la validación isValid().");
                cerrarConexionSegura(con);
                return null;
            }
            System.out.println("✅ Conexión exitosa a la BD.");
            return con;
        } catch (ClassNotFoundException e) {
            LOGGER.severe("Driver PostgreSQL no encontrado.");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error SQL al conectar: " + e.getMessage(), e);
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