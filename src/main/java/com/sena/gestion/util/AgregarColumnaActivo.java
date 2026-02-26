package com.sena.gestion.util;

import com.sena.gestion.repository.Conexion;
import java.sql.Connection;
import java.sql.Statement;

/**
 * Clase utilitaria para ejecutar el script de borrado lógico
 * Agrega la columna 'activo' a las tablas tareas y categorias
 */
public class AgregarColumnaActivo {

    public static void main(String[] args) {
        Connection con = null;
        Statement stmt = null;

        try {
            con = Conexion.getConexion();
            stmt = con.createStatement();

            System.out.println("Iniciando actualización de base de datos...");

            // 1. Agregar columna 'activo' a la tabla tareas
            System.out.println("Agregando columna 'activo' a tabla tareas...");
            stmt.execute("ALTER TABLE tareas ADD COLUMN IF NOT EXISTS activo BOOLEAN DEFAULT true NOT NULL");
            stmt.execute("UPDATE tareas SET activo = true WHERE activo IS NULL");
            System.out.println("✓ Columna 'activo' agregada a tabla tareas");

            // 2. Agregar columna 'activo' a la tabla categorias
            System.out.println("Agregando columna 'activo' a tabla categorias...");
            stmt.execute("ALTER TABLE categorias ADD COLUMN IF NOT EXISTS activo BOOLEAN DEFAULT true NOT NULL");
            stmt.execute("UPDATE categorias SET activo = true WHERE activo IS NULL");
            System.out.println("✓ Columna 'activo' agregada a tabla categorias");

            // 3. Crear índices para mejorar el rendimiento
            System.out.println("Creando índices...");
            stmt.execute("CREATE INDEX IF NOT EXISTS idx_tareas_activo ON tareas(activo)");
            stmt.execute("CREATE INDEX IF NOT EXISTS idx_categorias_activo ON categorias(activo)");
            System.out.println("✓ Índices creados");

            System.out.println("\n==============================================");
            System.out.println("¡Base de datos actualizada correctamente!");
            System.out.println("==============================================");

        } catch (Exception e) {
            System.err.println("ERROR al actualizar base de datos: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}

