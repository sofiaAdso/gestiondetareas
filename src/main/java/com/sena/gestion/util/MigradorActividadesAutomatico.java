package com.sena.gestion.util;

import com.sena.gestion.model.Actividad;
import com.sena.gestion.model.Tarea;
import com.sena.gestion.repository.Conexion;

import java.sql.*;
import java.util.*;

/**
 * Utilidad para migrar tareas existentes creando actividades automáticamente.
 * Agrupa las tareas por usuario y categoría, creando una actividad por cada grupo.
 */
public class MigradorActividadesAutomatico {


    /**
     * Clase interna para agrupar información de tareas
     */
    private static class GrupoTareas {
        int usuarioId;
        String usuarioNombre;
        int cantidadTareas;
        java.sql.Date fechaInicio;
        java.sql.Date fechaFin;
        List<Integer> idsTareas = new ArrayList<>();

        @Override
        public String toString() {
            return String.format("Usuario: %s, Tareas: %d",
                    usuarioNombre, cantidadTareas);
        }
    }

    /**
     * Ejecuta la migración completa
     */
    public MigracionResultado ejecutarMigracion() {
        MigracionResultado resultado = new MigracionResultado();
        System.out.println("=== INICIANDO MIGRACIÓN DE TAREAS A ACTIVIDADES ===");

        try {
            // 1. Obtener tareas sin actividad
            List<Tarea> tareasSinActividad = obtenerTareasSinActividad();
            resultado.totalTareasAnalizadas = tareasSinActividad.size();
            System.out.println("Tareas sin actividad encontradas: " + tareasSinActividad.size());

            if (tareasSinActividad.isEmpty()) {
                resultado.mensaje = "No hay tareas sin actividad para migrar";
                resultado.exitoso = true;
                return resultado;
            }

            // 2. Agrupar tareas por usuario y categoría
            List<GrupoTareas> grupos = agruparTareas(tareasSinActividad);
            System.out.println("Grupos de tareas creados: " + grupos.size());

            // 3. Crear actividades y asignar tareas
            for (GrupoTareas grupo : grupos) {
                try {
                    // Crear actividad
                    Actividad actividad = crearActividadParaGrupo(grupo);
                    int actividadId = crearActividad(actividad);

                    if (actividadId > 0) {
                        // Asignar tareas a la actividad
                        int tareasAsignadas = asignarTareasAActividad(grupo.idsTareas, actividadId);
                        resultado.actividadesCreadas++;
                        resultado.tareasAsignadas += tareasAsignadas;

                        System.out.println(String.format(
                                "✓ Actividad creada (ID: %d) - %s - %d tareas asignadas",
                                actividadId, grupo, tareasAsignadas));
                    } else {
                        resultado.errores++;
                        System.err.println("✗ Error al crear actividad para: " + grupo);
                    }
                } catch (Exception e) {
                    resultado.errores++;
                    System.err.println("✗ Error procesando grupo: " + grupo + " - " + e.getMessage());
                }
            }

            resultado.exitoso = resultado.errores == 0;
            resultado.mensaje = generarMensajeResultado(resultado);

        } catch (Exception e) {
            resultado.exitoso = false;
            resultado.mensaje = "Error en la migración: " + e.getMessage();
            e.printStackTrace();
        }

        System.out.println("\n=== MIGRACIÓN COMPLETADA ===");
        System.out.println(resultado.mensaje);
        return resultado;
    }

    /**
     * Obtiene todas las tareas que no tienen actividad asignada
     */
    private List<Tarea> obtenerTareasSinActividad() {
        List<Tarea> tareas = new ArrayList<>();
        String sql = "SELECT t.id, t.titulo, t.descripcion, t.fecha_inicio, t.fecha_vencimiento, t.actividad_id " +
                "FROM tareas t " +
                "WHERE t.actividad_id IS NULL OR t.actividad_id = 0 " +
                "ORDER BY t.fecha_inicio";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Tarea tarea = new Tarea();
                tarea.setId(rs.getInt("id"));
                tarea.setTitulo(rs.getString("titulo"));
                tarea.setDescripcion(rs.getString("descripcion"));
                tarea.setFecha_inicio(rs.getDate("fecha_inicio"));
                tarea.setFecha_vencimiento(rs.getDate("fecha_vencimiento"));
                tareas.add(tarea);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener tareas sin actividad: " + e.getMessage());
            e.printStackTrace();
        }

        return tareas;
    }

    /**
     * Agrupa las tareas - En este caso, como necesitamos el usuario_id para crear actividades,
     * obtenemos el usuario de cada actividad relacionada o asumimos un usuario por defecto.
     * NOTA: Este migrador ya no es tan útil con la nueva estructura donde las tareas
     * deben pertenecer a actividades desde el inicio.
     */
    private List<GrupoTareas> agruparTareas(List<Tarea> tareas) {
        // Crear un único grupo para todas las tareas sin actividad
        // Necesitamos obtener el usuario_id de las actividades existentes
        GrupoTareas grupo = new GrupoTareas();
        grupo.usuarioId = 1; // Usuario por defecto - deberá ajustarse
        grupo.usuarioNombre = "Usuario por defecto";
        grupo.cantidadTareas = tareas.size();

        java.sql.Date fechaMin = null;
        java.sql.Date fechaMax = null;

        for (Tarea tarea : tareas) {
            grupo.idsTareas.add(tarea.getId());

            // Calcular fechas mínima y máxima
            if (tarea.getFecha_inicio() != null) {
                if (fechaMin == null || tarea.getFecha_inicio().before(fechaMin)) {
                    fechaMin = tarea.getFecha_inicio();
                }
            }
            if (tarea.getFecha_vencimiento() != null) {
                if (fechaMax == null || tarea.getFecha_vencimiento().after(fechaMax)) {
                    fechaMax = tarea.getFecha_vencimiento();
                }
            }
        }

        grupo.fechaInicio = fechaMin;
        grupo.fechaFin = fechaMax;

        List<GrupoTareas> grupos = new ArrayList<>();
        if (!grupo.idsTareas.isEmpty()) {
            grupos.add(grupo);
        }
        return grupos;
    }

    /**
     * Crea un objeto Actividad a partir de un grupo de tareas
     */
    private Actividad crearActividadParaGrupo(GrupoTareas grupo) {
        Actividad actividad = new Actividad();
        actividad.setTitulo("Actividad - Tareas Migradas");
        actividad.setDescripcion(String.format(
                "Actividad creada automáticamente para agrupar %d tarea(s) sin actividad asignada",
                grupo.cantidadTareas));
        actividad.setUsuario_id(grupo.usuarioId);

        // Fechas
        java.sql.Date hoy = new java.sql.Date(System.currentTimeMillis());
        actividad.setFecha_inicio(grupo.fechaInicio != null ? grupo.fechaInicio : hoy);

        // Calcular fecha fin: 30 días desde la fecha de inicio o la fecha máxima de las tareas
        if (grupo.fechaFin != null) {
            actividad.setFecha_fin(grupo.fechaFin);
        } else {
            Calendar cal = Calendar.getInstance();
            cal.setTime(actividad.getFecha_inicio());
            cal.add(Calendar.DAY_OF_MONTH, 30);
            actividad.setFecha_fin(new java.sql.Date(cal.getTimeInMillis()));
        }

        actividad.setPrioridad("Media");
        actividad.setEstado("En Progreso");
        actividad.setColor("#3498db"); // Azul por defecto

        return actividad;
    }


    /**
     * Crea una actividad en la base de datos
     */
    private int crearActividad(Actividad actividad) {
        String sql = "INSERT INTO actividades (titulo, descripcion, usuario_id, fecha_inicio, fecha_fin, prioridad, estado, color) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?) RETURNING id";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, actividad.getTitulo());
            ps.setString(2, actividad.getDescripcion());
            ps.setInt(3, actividad.getUsuario_id());
            ps.setDate(4, actividad.getFecha_inicio());
            ps.setDate(5, actividad.getFecha_fin());
            ps.setString(6, actividad.getPrioridad());
            ps.setString(7, actividad.getEstado());
            ps.setString(8, actividad.getColor());

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error al crear actividad: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Asigna múltiples tareas a una actividad
     */
    private int asignarTareasAActividad(List<Integer> idsTareas, int actividadId) {
        if (idsTareas.isEmpty()) return 0;

        StringBuilder sql = new StringBuilder("UPDATE tareas SET actividad_id = ? WHERE id IN (");
        for (int i = 0; i < idsTareas.size(); i++) {
            sql.append(i == 0 ? "?" : ", ?");
        }
        sql.append(")");

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            ps.setInt(1, actividadId);
            for (int i = 0; i < idsTareas.size(); i++) {
                ps.setInt(i + 2, idsTareas.get(i));
            }

            return ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error al asignar tareas a actividad: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Genera un mensaje de resultado
     */
    private String generarMensajeResultado(MigracionResultado resultado) {
        return String.format(
                "Migración %s:\n" +
                        "- Tareas analizadas: %d\n" +
                        "- Actividades creadas: %d\n" +
                        "- Tareas asignadas: %d\n" +
                        "- Errores: %d",
                resultado.exitoso ? "EXITOSA" : "CON ERRORES",
                resultado.totalTareasAnalizadas,
                resultado.actividadesCreadas,
                resultado.tareasAsignadas,
                resultado.errores
        );
    }

    /**
     * Clase para encapsular el resultado de la migración
     */
    public static class MigracionResultado {
        public boolean exitoso = false;
        public int totalTareasAnalizadas = 0;
        public int actividadesCreadas = 0;
        public int tareasAsignadas = 0;
        public int errores = 0;
        public String mensaje = "";

        @Override
        public String toString() {
            return mensaje;
        }
    }

    /**
     * Método principal para ejecutar desde consola
     */
    public static void main(String[] args) {
        System.out.println("╔════════════════════════════════════════════════════════════╗");
        System.out.println("║  MIGRADOR AUTOMÁTICO DE TAREAS A ACTIVIDADES              ║");
        System.out.println("║  Sistema de Gestión de Tareas - SENA                      ║");
        System.out.println("╚════════════════════════════════════════════════════════════╝\n");

        MigradorActividadesAutomatico migrador = new MigradorActividadesAutomatico();
        MigracionResultado resultado = migrador.ejecutarMigracion();

        System.out.println("\n" + (resultado.exitoso ? "✓" : "✗") + " " + resultado.mensaje);
        System.exit(resultado.exitoso ? 0 : 1);
    }
}



