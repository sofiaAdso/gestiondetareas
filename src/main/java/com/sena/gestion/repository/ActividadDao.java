package com.sena.gestion.repository;

import com.sena.gestion.model.Actividad;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ActividadDao {

    // 1. LISTAR TODAS
    public List<Actividad> listarTodas() {
        List<Actividad> lista = new ArrayList<>();
        String sql = "SELECT * FROM actividades ORDER BY titulo ASC";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapearActividad(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    // 2. LISTAR POR USUARIO
    public List<Actividad> listarPorUsuario(int usuarioId) {
        List<Actividad> lista = new ArrayList<>();
        String sql = "SELECT * FROM actividades WHERE usuario_id = ? ORDER BY fecha_creacion DESC";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearActividad(rs));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    // 3. OBTENER POR ID
    public Actividad obtenerPorId(int id) {
        String sql = "SELECT * FROM actividades WHERE id = ?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapearActividad(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // 4. ELIMINAR
    public boolean eliminar(int id) {
        String sql = "DELETE FROM actividades WHERE id = ?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 5. ACTUALIZAR
    public boolean actualizar(Actividad a) {
        String sql = "UPDATE actividades SET titulo=?, descripcion=?, fecha_inicio=?, fecha_fin=?, prioridad=?, estado=?, color=? WHERE id=?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, a.getTitulo());
            ps.setString(2, a.getDescripcion());
            ps.setDate(3, a.getFecha_inicio());
            ps.setDate(4, a.getFecha_fin());
            ps.setString(5, a.getPrioridad());
            ps.setString(6, a.getEstado());
            ps.setString(7, a.getColor());
            ps.setInt(8, a.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    // 6. CREAR Y RETORNAR ID
    public int crearYRetornarId(Actividad a) {
        String sql = "INSERT INTO actividades (usuario_id, titulo, descripcion, fecha_inicio, fecha_fin, prioridad, estado, color) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, a.getUsuario_id());
            ps.setString(2, a.getTitulo());
            ps.setString(3, a.getDescripcion());
            ps.setDate(4, a.getFecha_inicio());
            ps.setDate(5, a.getFecha_fin());
            ps.setString(6, a.getPrioridad());
            ps.setString(7, a.getEstado());
            ps.setString(8, a.getColor());

            if (ps.executeUpdate() > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // --- NUEVOS MÉTODOS PARA DASHBOARD Y REPORTES ---

    /**
     * Cuenta el total de actividades registradas.
     */
    public int contarTodas() {
        String sql = "SELECT COUNT(*) FROM actividades";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    /**
     * Cuenta actividades por un estado específico (ej: 'Completada', 'En Proceso').
     */
    public int contarPorEstado(String estado) {
        String sql = "SELECT COUNT(*) FROM actividades WHERE estado = ?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, estado);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    /**
     * Cuenta actividades por prioridad (ej: 'Alta', 'Media', 'Baja').
     */
    public int contarPorPrioridad(String prioridad) {
        String sql = "SELECT COUNT(*) FROM actividades WHERE prioridad = ?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, prioridad);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // Mapeo interno
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
        a.setColor(rs.getString("color"));
        return a;
    }
}

