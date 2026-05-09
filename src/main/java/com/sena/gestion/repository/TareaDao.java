package com.sena.gestion.repository;

import com.sena.gestion.model.Tarea;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TareaDao {

    private static final Logger LOGGER = Logger.getLogger(TareaDao.class.getName());

    // ============================
    // LISTAR TODAS LAS TAREAS
    // ============================
    public List<Tarea> listar() {
        List<Tarea> lista = new ArrayList<>();

        // ✅ CORREGIDO: JOIN con categorias para obtener nombre
        String sql = "SELECT t.id, t.titulo, t.descripcion, t.prioridad, t.estado, t.fecha_inicio, " +
                "t.fecha_vencimiento, t.actividad_id, t.usuario_id, t.categoria_id, " +
                "c.nombre AS nombre_categoria " +
                "FROM tareas t " +
                "LEFT JOIN categorias c ON t.categoria_id = c.id " +
                "ORDER BY t.id DESC";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapearTarea(rs));
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar tareas", e);
        }

        return lista;
    }

    // ============================
    // LISTAR POR USUARIO
    // ============================
    public List<Tarea> listarPorUsuario(int idUsuario) {
        List<Tarea> lista = new ArrayList<>();

        // ✅ CORREGIDO: JOIN con categorias
        String sql = "SELECT t.*, c.nombre AS nombre_categoria " +
                "FROM tareas t " +
                "LEFT JOIN categorias c ON t.categoria_id = c.id " +
                "WHERE t.usuario_id = ? ORDER BY t.id DESC";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearTarea(rs));
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar por usuario", e);
        }

        return lista;
    }

    // ============================
    // LISTAR POR ACTIVIDAD
    // ============================
    public List<Tarea> listarPorActividad(int actividadId) {
        List<Tarea> lista = new ArrayList<>();

        // ✅ CORREGIDO: JOIN con categorias para traer nombre_categoria
        String sql = "SELECT t.*, c.nombre AS nombre_categoria " +
                "FROM tareas t " +
                "LEFT JOIN categorias c ON t.categoria_id = c.id " +
                "WHERE t.actividad_id = ? ORDER BY t.id DESC";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, actividadId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearTarea(rs));
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar por actividad", e);
        }

        return lista;
    }

    // ============================
    // OBTENER POR ID
    // ============================
    public Tarea obtenerPorId(int id) {

        // ✅ CORREGIDO: JOIN con categorias
        String sql = "SELECT t.*, c.nombre AS nombre_categoria " +
                "FROM tareas t " +
                "LEFT JOIN categorias c ON t.categoria_id = c.id " +
                "WHERE t.id = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearTarea(rs);
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al obtener tarea", e);
        }

        return null;
    }

    // ============================
    // REGISTRAR
    // ============================
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
            ps.setDate(5, t.getFechaInicio());
            ps.setDate(6, t.getFechaVencimiento());
            ps.setInt(7, t.getActividadId());
            ps.setInt(8, t.getUsuarioId());

            if (t.getCategoriaId() > 0)
                ps.setInt(9, t.getCategoriaId());
            else
                ps.setNull(9, Types.INTEGER);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al registrar tarea", e);
            return false;
        }
    }

    // ============================
    // ACTUALIZAR
    // ============================
    public boolean actualizar(Tarea t) {

        String sql = "UPDATE tareas SET titulo=?, descripcion=?, prioridad=?, estado=?, fecha_inicio=?, " +
                "fecha_vencimiento=?, actividad_id=?, usuario_id=?, categoria_id=? WHERE id=?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, t.getTitulo());
            ps.setString(2, t.getDescripcion());
            ps.setString(3, t.getPrioridad());
            ps.setString(4, t.getEstado());
            ps.setDate(5, t.getFechaInicio());
            ps.setDate(6, t.getFechaVencimiento());
            ps.setInt(7, t.getActividadId());
            ps.setInt(8, t.getUsuarioId());

            if (t.getCategoriaId() > 0)
                ps.setInt(9, t.getCategoriaId());
            else
                ps.setNull(9, Types.INTEGER);

            ps.setInt(10, t.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al actualizar tarea", e);
            return false;
        }
    }

    // ============================
    // ELIMINAR
    // ============================
    public boolean eliminar(int id) {

        String sql = "DELETE FROM tareas WHERE id = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al eliminar tarea", e);
            return false;
        }
    }

    // ============================
    // ACTUALIZAR SOLO ESTADO
    // ============================
    public boolean actualizarEstado(int id, String estado) {

        String sql = "UPDATE tareas SET estado = ? WHERE id = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, estado);
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al actualizar estado", e);
            return false;
        }
    }

    // ============================
    // MAPEO
    // ============================
    private Tarea mapearTarea(ResultSet rs) throws SQLException {

        Tarea t = new Tarea();

        t.setId(rs.getInt("id"));
        t.setTitulo(rs.getString("titulo"));
        t.setDescripcion(rs.getString("descripcion"));
        t.setPrioridad(rs.getString("prioridad"));
        t.setEstado(rs.getString("estado"));
        t.setFechaInicio(rs.getDate("fecha_inicio"));
        t.setFechaVencimiento(rs.getDate("fecha_vencimiento"));
        t.setActividadId(rs.getInt("actividad_id"));
        t.setUsuarioId(rs.getInt("usuario_id"));
        t.setCategoriaId(rs.getInt("categoria_id"));

        // ✅ AGREGADO: mapear nombre de categoría desde el JOIN
        try {
            String nombreCat = rs.getString("nombre_categoria");
            t.setNombreCategoria(nombreCat != null ? nombreCat : "Sin categoría");
        } catch (SQLException ignored) {
            t.setNombreCategoria("Sin categoría");
        }

        return t;
    }
}