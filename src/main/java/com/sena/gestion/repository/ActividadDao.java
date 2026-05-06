package com.sena.gestion.repository;

import com.sena.gestion.model.Actividad;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ActividadDao {

    private static final Logger LOGGER = Logger.getLogger(ActividadDao.class.getName());

    public List<Actividad> listarPorUsuario(int usuarioId) {
        List<Actividad> lista = new ArrayList<>();
        String sql = "SELECT * FROM actividades WHERE usuario_id = ? ORDER BY id DESC";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) { lista.add(mapearActividad(rs)); }
            }
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, "Error listarPorUsuario", e); }
        return lista;
    }

    public List<Actividad> listarTodas() {
        List<Actividad> lista = new ArrayList<>();
        String sql = "SELECT * FROM actividades ORDER BY id DESC";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) { lista.add(mapearActividad(rs)); }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error listarTodas - Posible causa: tabla no existe", e);
            System.err.println("⚠️ ERROR: Tabla 'actividades' no encontrada. Ejecuta: CREATE TABLE actividades...");
        }
        return lista;
    }

    public Actividad obtenerPorId(int id) {
        String sql = "SELECT * FROM actividades WHERE id = ?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapearActividad(rs);
            }
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, "Error obtenerPorId", e); }
        return null;
    }

    // ── CREAR ──
    public int crearYRetornarId(Actividad a) {
        String sql = "INSERT INTO actividades (usuario_id, titulo, descripcion, fecha_inicio, fecha_fin, prioridad, estado, color) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?) RETURNING id";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, a.getUsuario_id());
            ps.setString(2, a.getTitulo());
            ps.setString(3, a.getDescripcion());
            ps.setDate(4, a.getFecha_inicio() != null ? new java.sql.Date(a.getFecha_inicio().getTime()) : null);
            ps.setDate(5, a.getFecha_fin()    != null ? new java.sql.Date(a.getFecha_fin().getTime())    : null);
            ps.setString(6, a.getPrioridad());
            ps.setString(7, a.getEstado() != null ? a.getEstado() : "En Progreso");
            ps.setString(8, a.getColor());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, "Error crearYRetornarId", e); }
        return -1;
    }

    // ── ACTUALIZAR ──
    public boolean actualizar(Actividad a) {
        String sql = "UPDATE actividades SET titulo=?, descripcion=?, fecha_inicio=?, fecha_fin=?, " +
                "prioridad=?, estado=?, color=?, usuario_id=? WHERE id=?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, a.getTitulo());
            ps.setString(2, a.getDescripcion());
            ps.setDate(3, a.getFecha_inicio() != null ? new java.sql.Date(a.getFecha_inicio().getTime()) : null);
            ps.setDate(4, a.getFecha_fin()    != null ? new java.sql.Date(a.getFecha_fin().getTime())    : null);
            ps.setString(5, a.getPrioridad());
            ps.setString(6, a.getEstado() != null ? a.getEstado() : "En Progreso");
            ps.setString(7, a.getColor());
            ps.setInt(8,    a.getUsuario_id());
            ps.setInt(9,    a.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, "Error actualizar", e); return false; }
    }

    // ── ACTUALIZAR SOLO ESTADO ──
    public boolean actualizarEstado(int id, String estado) {
        String sql = "UPDATE actividades SET estado = ? WHERE id = ?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, estado);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, "Error actualizarEstado", e); return false; }
    }

    // ── ELIMINAR ──
    public boolean eliminar(int id) {
        String sql = "DELETE FROM actividades WHERE id = ?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, "Error eliminar", e); return false; }
    }

    // ── REPORTE ──
    public List<String[]> obtenerReporteActividadesConTareas() {
        List<String[]> reporte = new ArrayList<>();
        String sql = "SELECT a.titulo, t.titulo, t.estado FROM actividades a LEFT JOIN tareas t ON a.id = t.actividad_id";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                reporte.add(new String[]{
                        rs.getString(1),
                        rs.getString(2) != null ? rs.getString(2) : "Sin tareas",
                        rs.getString(3) != null ? rs.getString(3) : "N/A"
                });
            }
        } catch (SQLException e) { LOGGER.log(Level.SEVERE, "Error reporte", e); }
        return reporte;
    }

    // ── MAPPER ──
    private Actividad mapearActividad(ResultSet rs) throws SQLException {
        Actividad a = new Actividad();
        a.setId(rs.getInt("id"));
        a.setUsuario_id(rs.getInt("usuario_id"));
        a.setTitulo(rs.getString("titulo"));
        a.setDescripcion(rs.getString("descripcion"));
        a.setFecha_inicio(rs.getDate("fecha_inicio"));
        a.setFecha_fin(rs.getDate("fecha_fin"));
        a.setPrioridad(rs.getString("prioridad"));
        a.setEstado(rs.getString("estado"));
        try { a.setColor(rs.getString("color")); } catch (SQLException ignored) {}
        return a;
    }
}