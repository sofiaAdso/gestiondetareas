package com.sena.gestion.repository;

import com.sena.gestion.model.Tarea;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TareaDao {

    private static final Logger LOGGER = Logger.getLogger(TareaDao.class.getName());

    // --- MÉTODOS DE LECTURA (SELECT) ---

    public List<Tarea> listar() {
        List<Tarea> lista = new ArrayList<>();
        // Se agregaron nombres de Actividad, Usuario y Categoría
        String sql = "SELECT t.*, a.titulo AS nombre_act, u.username AS nombre_usuario, c.nombre AS nombre_cat " +
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
                t.setNombreCategoria(rs.getString("nombre_cat"));
                lista.add(t);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar todas las tareas", e);
        }
        return lista;
    }

    public List<Tarea> listarPorUsuario(int idUsuario) {
        List<Tarea> lista = new ArrayList<>();
        String sql = "SELECT t.*, a.titulo AS nombre_act, c.nombre AS nombre_cat " +
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
                    t.setNombreCategoria(rs.getString("nombre_cat"));
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
        String sql = "SELECT t.*, a.titulo AS nombre_act, c.nombre AS nombre_cat " +
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
                    t.setNombreCategoria(rs.getString("nombre_cat"));
                    lista.add(t);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar tareas por actividad: " + actividadId, e);
        }
        return lista;
    }

    public Tarea obtenerPorId(int id) {
        String sql = "SELECT * FROM tareas WHERE id = ?";
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

    public boolean registrar(Tarea t) {
        String sql = "INSERT INTO tareas (titulo, descripcion, prioridad, estado, fecha_inicio, " +
                "fecha_vencimiento, actividad_id, usuario_id, categoria_id, completada, notas) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        // Log para que verifiques en la consola de NetBeans/IntelliJ si los IDs llegan bien
        System.out.println("DAO: Registrando Tarea -> Actividad: " + t.getActividad_id() + ", Usuario: " + t.getUsuario_id());

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

            ps.setBoolean(10, t.isCompletada());
            ps.setString(11, t.getNotas());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al registrar nueva tarea en DB", e);
            return false;
        }
    }

    public boolean actualizar(Tarea t) {
        String sql = "UPDATE tareas SET titulo=?, descripcion=?, prioridad=?, estado=?, fecha_inicio=?, " +
                "fecha_vencimiento=?, actividad_id=?, usuario_id=?, categoria_id=?, completada=?, notas=? " +
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

            ps.setBoolean(10, t.isCompletada());
            ps.setString(11, t.getNotas());
            ps.setInt(12, t.getId());

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
        t.setCompletada(rs.getBoolean("completada"));
        t.setNotas(rs.getString("notas"));
        t.setFecha_creacion(rs.getTimestamp("fecha_creacion"));
        return t;
    }
}