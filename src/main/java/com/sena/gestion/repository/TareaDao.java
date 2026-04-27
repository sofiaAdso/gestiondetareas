package com.sena.gestion.repository;

import com.sena.gestion.model.Tarea;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TareaDao {

    private static final Logger LOGGER = Logger.getLogger(TareaDao.class.getName());

    // --- MÉTODOS DE LECTURA (SELECT) ---

    public List<Tarea> listar() {
        List<Tarea> lista = new ArrayList<>();
        String sql = "SELECT t.id, t.titulo, t.descripcion, t.prioridad, t.estado, t.fecha_inicio, " +
                "t.fecha_vencimiento, t.actividad_id, t.usuario_id, t.categoria_id, " +
                "a.titulo AS nombre_act, u.username AS nombre_usuario, c.nombre AS nombre_cat " +
                "FROM tareas t " +
                "INNER JOIN actividades a ON t.actividad_id = a.id " +
                "INNER JOIN usuarios u ON t.usuario_id = u.id " +
                "LEFT JOIN categorias c ON t.categoria_id = c.id " +
                "ORDER BY t.id DESC";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Tarea t = mapearTarea(rs);
                t.setNombreActividad(rs.getString("nombre_act"));
                t.setNombreUsuario(rs.getString("nombre_usuario"));
                t.setNombreCategoria(rs.getString("nombre_cat") != null ? rs.getString("nombre_cat") : "Sin Categoría");
                lista.add(t);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar todas las tareas", e);
        }
        return lista;
    }

    public List<Tarea> listarPorUsuario(int idUsuario) {
        List<Tarea> lista = new ArrayList<>();
        String sql = "SELECT t.id, t.titulo, t.descripcion, t.prioridad, t.estado, t.fecha_inicio, " +
                "t.fecha_vencimiento, t.actividad_id, t.usuario_id, t.categoria_id, " +
                "a.titulo AS nombre_act, c.nombre AS nombre_cat " +
                "FROM tareas t " +
                "INNER JOIN actividades a ON t.actividad_id = a.id " +
                "LEFT JOIN categorias c ON t.categoria_id = c.id " +
                "WHERE t.usuario_id = ? " +
                "ORDER BY t.id DESC";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tarea t = mapearTarea(rs);
                    t.setNombreActividad(rs.getString("nombre_act"));
                    t.setNombreCategoria(rs.getString("nombre_cat") != null ? rs.getString("nombre_cat") : "Sin Categoría");
                    lista.add(t);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar tareas del usuario: " + idUsuario, e);
        }
        return lista;
    }

    public List<Tarea> listarPorActividad(int actividadId) {
        List<Tarea> lista = new ArrayList<>();
        String sql = "SELECT t.id, t.titulo, t.descripcion, t.prioridad, t.estado, t.fecha_inicio, " +
                "t.fecha_vencimiento, t.actividad_id, t.usuario_id, t.categoria_id, " +
                "a.titulo AS nombre_act, c.nombre AS nombre_cat " +
                "FROM tareas t " +
                "INNER JOIN actividades a ON t.actividad_id = a.id " +
                "LEFT JOIN categorias c ON t.categoria_id = c.id " +
                "WHERE t.actividad_id = ? " +
                "ORDER BY t.id DESC";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, actividadId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tarea t = mapearTarea(rs);
                    t.setNombreActividad(rs.getString("nombre_act"));
                    t.setNombreCategoria(rs.getString("nombre_cat") != null ? rs.getString("nombre_cat") : "Sin Categoría");
                    lista.add(t);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar tareas por actividad: " + actividadId, e);
        }
        return lista;
    }

    public Tarea obtenerPorId(int id) {
        String sql = "SELECT id, titulo, descripcion, prioridad, estado, fecha_inicio, " +
                "fecha_vencimiento, actividad_id, usuario_id, categoria_id " +
                "FROM tareas WHERE id = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearTarea(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al obtener tarea por ID: " + id, e);
        }
        return null;
    }

    // --- MÉTODOS DE ESCRITURA (CUD) ---

    /**
     * MODO NUEVO: Método específico para el botón de cambio de estado rápido.
     */
    public boolean actualizarEstado(int id, String nuevoEstado) {
        String sql = "UPDATE tareas SET estado = ? WHERE id = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nuevoEstado);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al actualizar solo el estado de la tarea ID: " + id, e);
            return false;
        }
    }

    public boolean registrar(Tarea t) {
        String sql = "INSERT INTO tareas (titulo, descripcion, prioridad, estado, fecha_inicio, " +
                "fecha_vencimiento, actividad_id, usuario_id, categoria_id) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, t.getTitulo());
            ps.setString(2, t.getDescripcion());
            ps.setString(3, t.getPrioridad());
            ps.setString(4, t.getEstado());
            ps.setDate(5, t.getFecha_inicio());
            ps.setDate(6, t.getFecha_vencimiento());
            ps.setInt(7, t.getActividad_id());
            ps.setInt(8, t.getUsuario_id());

            if (t.getCategoria_id() > 0) ps.setInt(9, t.getCategoria_id());
            else ps.setNull(9, Types.INTEGER);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al registrar nueva tarea", e);
            return false;
        }
    }

    public boolean actualizar(Tarea t) {
        String sql = "UPDATE tareas SET titulo=?, descripcion=?, prioridad=?, estado=?, fecha_inicio=?, " +
                "fecha_vencimiento=?, actividad_id=?, usuario_id=?, categoria_id=? " +
                "WHERE id=?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, t.getTitulo());
            ps.setString(2, t.getDescripcion());
            ps.setString(3, t.getPrioridad());
            ps.setString(4, t.getEstado());
            ps.setDate(5, t.getFecha_inicio());
            ps.setDate(6, t.getFecha_vencimiento());
            ps.setInt(7, t.getActividad_id());
            ps.setInt(8, t.getUsuario_id());

            if (t.getCategoria_id() > 0) ps.setInt(9, t.getCategoria_id());
            else ps.setNull(9, Types.INTEGER);

            ps.setInt(10, t.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al actualizar tarea ID: " + t.getId(), e);
            return false;
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM tareas WHERE id = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al eliminar tarea ID: " + id, e);
            return false;
        }
    }

    // --- UTILIDADES ---

    private Tarea mapearTarea(ResultSet rs) throws SQLException {
        Tarea t = new Tarea();
        t.setId(rs.getInt("id"));
        t.setTitulo(rs.getString("titulo"));
        t.setDescripcion(rs.getString("descripcion"));
        t.setPrioridad(rs.getString("prioridad"));
        t.setEstado(rs.getString("estado"));
        t.setFecha_inicio(rs.getDate("fecha_inicio"));
        t.setFecha_vencimiento(rs.getDate("fecha_vencimiento"));
        t.setActividad_id(rs.getInt("actividad_id"));
        t.setUsuario_id(rs.getInt("usuario_id"));
        t.setCategoria_id(rs.getInt("categoria_id"));

        return t;
    }
}