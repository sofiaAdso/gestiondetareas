package com.sena.gestion.repository;

import com.sena.gestion.model.Novedad;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class NovedadDao {

    private static final Logger LOGGER = Logger.getLogger(NovedadDao.class.getName());

    // ── CREATE (Original) ──
    public boolean registrar(Novedad n) {
        String sql = "INSERT INTO novedades (regional, centro_formacion, programa_formacion, " +
                "codigo_programa, ambiente, localizacion, denominacion, tipo_ambiente, " +
                "tipo_novedad, detalle_novedad, viabilidad, nombre_instructor, " +
                "nombre_coordinador, fecha_reporte, usuario_id) " +
                "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1,  n.getRegional());
            ps.setString(2,  n.getCentroFormacion());
            ps.setString(3,  n.getProgramaFormacion());
            ps.setString(4,  n.getCodigoPrograma());
            ps.setString(5,  n.getAmbiente());
            ps.setString(6,  n.getLocalizacion());
            ps.setString(7,  n.getDenominacion());
            ps.setString(8,  n.getTipoAmbiente());
            ps.setString(9,  n.getTipoNovedad());
            ps.setString(10, n.getDetalleNovedad());
            ps.setString(11, n.getViabilidad());
            ps.setString(12, n.getNombreInstructor());
            ps.setString(13, n.getNombreCoordinador());
            ps.setDate(14,   n.getFechaReporte());
            ps.setInt(15,    n.getUsuarioId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al registrar novedad", e);
            return false;
        }
    }

    /**
     * NUEVO MÉTODO: Registra la novedad y retorna el ID generado por la base de datos.
     * Útil para generar el nombre del archivo Excel con el ID correcto.
     */
    public int registrarYRetornarId(Novedad n) {
        String sql = "INSERT INTO novedades (regional, centro_formacion, programa_formacion, " +
                "codigo_programa, ambiente, localizacion, denominacion, tipo_ambiente, " +
                "tipo_novedad, detalle_novedad, viabilidad, nombre_instructor, " +
                "nombre_coordinador, fecha_reporte, usuario_id) " +
                "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) RETURNING id";

        int idGenerado = -1;

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1,  n.getRegional());
            ps.setString(2,  n.getCentroFormacion());
            ps.setString(3,  n.getProgramaFormacion());
            ps.setString(4,  n.getCodigoPrograma());
            ps.setString(5,  n.getAmbiente());
            ps.setString(6,  n.getLocalizacion());
            ps.setString(7,  n.getDenominacion());
            ps.setString(8,  n.getTipoAmbiente());
            ps.setString(9,  n.getTipoNovedad());
            ps.setString(10, n.getDetalleNovedad());
            ps.setString(11, n.getViabilidad());
            ps.setString(12, n.getNombreInstructor());
            ps.setString(13, n.getNombreCoordinador());
            ps.setDate(14,   n.getFechaReporte());
            ps.setInt(15,    n.getUsuarioId());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    idGenerado = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al registrar y retornar ID", e);
        }
        return idGenerado;
    }

    // ── READ ALL ──
    public List<Novedad> listarTodas() {
        List<Novedad> lista = new ArrayList<>();
        String sql = "SELECT * FROM novedades ORDER BY fecha_reporte DESC";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar novedades", e);
        }
        return lista;
    }

    // ── READ BY USER ──
    public List<Novedad> listarPorUsuario(int usuarioId) {
        List<Novedad> lista = new ArrayList<>();
        String sql = "SELECT * FROM novedades WHERE usuario_id = ? ORDER BY fecha_reporte DESC";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar novedades por usuario", e);
        }
        return lista;
    }

    // ── READ ONE ──
    public Novedad obtenerPorId(int id) {
        String sql = "SELECT * FROM novedades WHERE id = ?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al obtener novedad por id", e);
        }
        return null;
    }

    // ── READ LATEST BY USER ──
    public Novedad obtenerUltimaPorUsuario(int usuarioId) {
        String sql = "SELECT * FROM novedades WHERE usuario_id = ? ORDER BY id DESC LIMIT 1";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al obtener última novedad por usuario", e);
        }
        return null;
    }

    // ── DELETE ──
    public boolean eliminar(int id) {
        String sql = "DELETE FROM novedades WHERE id = ?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al eliminar novedad", e);
            return false;
        }
    }

    // ── Mapper ResultSet → Novedad ──
    private Novedad mapear(ResultSet rs) throws SQLException {
        Novedad n = new Novedad();
        n.setId(rs.getInt("id"));
        n.setRegional(rs.getString("regional"));
        n.setCentroFormacion(rs.getString("centro_formacion"));
        n.setProgramaFormacion(rs.getString("programa_formacion"));
        n.setCodigoPrograma(rs.getString("codigo_programa"));
        n.setAmbiente(rs.getString("ambiente"));
        n.setLocalizacion(rs.getString("localizacion"));
        n.setDenominacion(rs.getString("denominacion"));
        n.setTipoAmbiente(rs.getString("tipo_ambiente"));
        n.setTipoNovedad(rs.getString("tipo_novedad"));
        n.setDetalleNovedad(rs.getString("detalle_novedad"));
        n.setViabilidad(rs.getString("viabilidad"));
        n.setNombreInstructor(rs.getString("nombre_instructor"));
        n.setNombreCoordinador(rs.getString("nombre_coordinador"));
        n.setFechaReporte(rs.getDate("fecha_reporte"));
        n.setUsuarioId(rs.getInt("usuario_id"));
        return n;
    }
}