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
            // 1. Leer application.properties (para LOCAL)
            Properties props = new Properties();
            InputStream propsStream = getClass().getClassLoader()
                    .getResourceAsStream("application.properties");

            if (propsStream == null) {
                log.warning("⚠️ No se encontró application.properties (puede ser Railway)");
            } else {
                props.load(propsStream);
            }

            String url;
            String user;
            String pass;
            String driver;

            // 🔥 Detectar entorno Railway
            String databaseUrl = System.getenv("DATABASE_URL");

            if (databaseUrl != null) {
                log.info("🌍 Detectado entorno Railway");

                if (databaseUrl.startsWith("postgres://")) {
                    databaseUrl = databaseUrl.replace("postgres://", "jdbc:postgresql://");
                }

                url = databaseUrl;
                user = null;
                pass = null;
                driver = "org.postgresql.Driver";

            } else {
                log.info("💻 Usando configuración LOCAL");

                url    = props.getProperty("db.url");
                user   = props.getProperty("db.user");
                pass   = props.getProperty("db.pass");
                driver = props.getProperty("db.driver");
            }

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

            // 3. Parsear sentencias
            List<String> sentencias = parsearSQL(sqlCompleto);

            // 4. Conexión dinámica
            Connection conn;

            if (user == null) {
                conn = DriverManager.getConnection(url);
            } else {
                conn = DriverManager.getConnection(url, user, pass);
            }

            try (conn; Statement stmt = conn.createStatement()) {

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

    private List<String> parsearSQL(String sql) {
        List<String> resultado = new ArrayList<>();
        StringBuilder actual = new StringBuilder();

        String[] lineas = sql.split("\n");
        for (String linea : lineas) {
            String lineaTrim = linea.trim();

            if (lineaTrim.isEmpty() || lineaTrim.startsWith("--")) {
                continue;
            }

            int comentario = lineaTrim.indexOf("--");
            if (comentario > 0) {
                lineaTrim = lineaTrim.substring(0, comentario).trim();
            }

            actual.append(lineaTrim).append(" ");

            if (lineaTrim.endsWith(";")) {
                String sentencia = actual.toString().trim();
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