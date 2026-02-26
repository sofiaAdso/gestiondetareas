package com.sena.gestion.repository;

import com.sena.gestion.model.Subtarea;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para gestionar las operaciones CRUD de Subtareas
 */
public class SubtareaDao {

    /**
     * Crea una nueva subtarea en la base de datos
     * @param subtarea Objeto Subtarea a crear
     * @return true si se creó exitosamente, false en caso contrario
     */
    public boolean crear(Subtarea subtarea) {
        String sql = "INSERT INTO subtareas (tarea_id, titulo, descripcion, completada) VALUES (?, ?, ?, ?)";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, subtarea.getTarea_id());
            ps.setString(2, subtarea.getTitulo());
            ps.setString(3, subtarea.getDescripcion());
            ps.setBoolean(4, subtarea.isCompletada());

            int resultado = ps.executeUpdate();
            System.out.println("Subtarea creada: " + (resultado > 0 ? "Éxito" : "Fallo"));
            return resultado > 0;

        } catch (SQLException e) {
            System.err.println("Error al crear subtarea: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lista todas las subtareas de una tarea específica
     * @param tareaId ID de la tarea padre
     * @return Lista de subtareas
     */
    public List<Subtarea> listarPorTarea(int tareaId) {
        List<Subtarea> lista = new ArrayList<>();
        String sql = "SELECT * FROM subtareas WHERE tarea_id = ? ORDER BY fecha_creacion ASC";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tareaId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Subtarea s = new Subtarea();
                s.setId(rs.getInt("id"));
                s.setTarea_id(rs.getInt("tarea_id"));
                s.setTitulo(rs.getString("titulo"));
                s.setDescripcion(rs.getString("descripcion"));
                s.setCompletada(rs.getBoolean("completada"));
                s.setFecha_creacion(rs.getTimestamp("fecha_creacion"));
                lista.add(s);
            }

            System.out.println("Subtareas encontradas para tarea " + tareaId + ": " + lista.size());

        } catch (SQLException e) {
            System.err.println("Error al listar subtareas: " + e.getMessage());
            e.printStackTrace();
        }

        return lista;
    }

    /**
     * Obtiene una subtarea por su ID
     * @param id ID de la subtarea
     * @return Objeto Subtarea o null si no se encuentra
     */
    public Subtarea obtenerPorId(int id) {
        String sql = "SELECT * FROM subtareas WHERE id = ?";
        Subtarea subtarea = null;

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                subtarea = new Subtarea();
                subtarea.setId(rs.getInt("id"));
                subtarea.setTarea_id(rs.getInt("tarea_id"));
                subtarea.setTitulo(rs.getString("titulo"));
                subtarea.setDescripcion(rs.getString("descripcion"));
                subtarea.setCompletada(rs.getBoolean("completada"));
                subtarea.setFecha_creacion(rs.getTimestamp("fecha_creacion"));
            }

        } catch (SQLException e) {
            System.err.println("Error al obtener subtarea: " + e.getMessage());
            e.printStackTrace();
        }

        return subtarea;
    }

    /**
     * Marca una subtarea como completada o no completada
     * @param id ID de la subtarea
     * @param completada Estado de completitud
     * @return true si se actualizó exitosamente
     */
    public boolean marcarCompletada(int id, boolean completada) {
        String sql = "UPDATE subtareas SET completada = ? WHERE id = ?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, completada);
            ps.setInt(2, id);

            int resultado = ps.executeUpdate();
            System.out.println("Subtarea " + id + " marcada como " + (completada ? "completada" : "pendiente"));
            return resultado > 0;

        } catch (SQLException e) {
            System.err.println("Error al marcar subtarea como completada: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Actualiza una subtarea existente
     * @param subtarea Objeto Subtarea con los datos actualizados
     * @return true si se actualizó exitosamente
     */
    public boolean actualizar(Subtarea subtarea) {
        String sql = "UPDATE subtareas SET titulo = ?, descripcion = ?, completada = ? WHERE id = ?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, subtarea.getTitulo());
            ps.setString(2, subtarea.getDescripcion());
            ps.setBoolean(3, subtarea.isCompletada());
            ps.setInt(4, subtarea.getId());

            int resultado = ps.executeUpdate();
            System.out.println("Subtarea actualizada: " + (resultado > 0 ? "Éxito" : "Fallo"));
            return resultado > 0;

        } catch (SQLException e) {
            System.err.println("Error al actualizar subtarea: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Elimina una subtarea de la base de datos
     * @param id ID de la subtarea a eliminar
     * @return true si se eliminó exitosamente
     */
    public boolean eliminar(int id) {
        String sql = "DELETE FROM subtareas WHERE id = ?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            int resultado = ps.executeUpdate();
            System.out.println("Subtarea eliminada: " + (resultado > 0 ? "Éxito" : "Fallo"));
            return resultado > 0;

        } catch (SQLException e) {
            System.err.println("Error al eliminar subtarea: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cuenta el número de subtareas completadas de una tarea
     * @param tareaId ID de la tarea padre
     * @return Número de subtareas completadas
     */
    public int contarCompletadas(int tareaId) {
        String sql = "SELECT COUNT(*) as total FROM subtareas WHERE tarea_id = ? AND completada = true";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tareaId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException e) {
            System.err.println("Error al contar subtareas completadas: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Cuenta el total de subtareas de una tarea
     * @param tareaId ID de la tarea padre
     * @return Número total de subtareas
     */
    public int contarTotal(int tareaId) {
        String sql = "SELECT COUNT(*) as total FROM subtareas WHERE tarea_id = ?";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, tareaId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException e) {
            System.err.println("Error al contar subtareas: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }
}

