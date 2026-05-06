package com.sena.gestion.config;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.logging.Logger;

@WebListener
public class DatabaseInitializer implements ServletContextListener {

    private static final Logger log = Logger.getLogger(DatabaseInitializer.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        log.info("🚀 Iniciando creación automática de tablas...");

        try {
            // 1. Leer application.properties
            Properties props = new Properties();
            InputStream propsStream = getClass().getClassLoader()
                    .getResourceAsStream("application.properties");

            if (propsStream == null) {
                log.severe("❌ No se encontró application.properties");
                return;
            }
            props.load(propsStream);

            String url    = props.getProperty("db.url");
            String user   = props.getProperty("db.user");
            String pass   = props.getProperty("db.pass");
            String driver = props.getProperty("db.driver");

            log.info("📡 Conectando a: " + url);
            Class.forName(driver);

            // 2. Leer schema.sql
            InputStream sqlStream = getClass().getClassLoader()
                    .getResourceAsStream("sql/schema.sql");

            if (sqlStream == null) {
                log.severe("❌ No se encontró sql/schema.sql");
                return;
            }

            String sqlCompleto = new String(sqlStream.readAllBytes(), StandardCharsets.UTF_8);

            // 3. Parsear sentencias correctamente (ignorar comentarios)
            List<String> sentencias = parsearSQL(sqlCompleto);

            // 4. Ejecutar cada sentencia
            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 Statement stmt = conn.createStatement()) {

                int ejecutadas = 0;
                for (String sentencia : sentencias) {
                    try {
                        stmt.execute(sentencia);
                        ejecutadas++;
                    } catch (Exception e) {
                        log.warning("⚠️ Sentencia omitida: " + e.getMessage());
                    }
                }
                log.info("✅ Tablas creadas/verificadas. Sentencias ejecutadas: " + ejecutadas);
            }

        } catch (Exception e) {
            log.severe("❌ Error al inicializar BD: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Parsea el SQL eliminando comentarios y dividiendo por ";"
     * de forma segura para bloques multilínea.
     */
    private List<String> parsearSQL(String sql) {
        List<String> resultado = new ArrayList<>();
        StringBuilder actual = new StringBuilder();

        String[] lineas = sql.split("\n");
        for (String linea : lineas) {
            String lineaTrim = linea.trim();

            // Ignorar líneas vacías y comentarios completos
            if (lineaTrim.isEmpty() || lineaTrim.startsWith("--")) {
                continue;
            }

            // Eliminar comentario inline al final de la línea
            int comentario = lineaTrim.indexOf("--");
            if (comentario > 0) {
                lineaTrim = lineaTrim.substring(0, comentario).trim();
            }

            actual.append(lineaTrim).append(" ");

            // Si la línea termina con ";" es el fin de una sentencia
            if (lineaTrim.endsWith(";")) {
                String sentencia = actual.toString().trim();
                // Quitar el ";" final porque Statement.execute() no lo necesita
                sentencia = sentencia.substring(0, sentencia.length() - 1).trim();
                if (!sentencia.isEmpty()) {
                    resultado.add(sentencia);
                }
                actual = new StringBuilder();
            }
        }

        return resultado;
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {}
}