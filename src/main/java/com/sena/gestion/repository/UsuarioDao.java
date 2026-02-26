package com.sena.gestion.repository;

import com.sena.gestion.model.Usuario;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UsuarioDao {

    private static final Logger LOGGER = Logger.getLogger(UsuarioDao.class.getName());

    // --- 1. LOGIN (VALIDACIÓN) ---
    public Usuario validar(String user, String pass) {
        Usuario u = null;
        String sql = "SELECT id, username, email, rol FROM usuarios WHERE username = ? AND password = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user);
            ps.setString(2, pass);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    u = new Usuario();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setRol(rs.getString("rol"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en Login DAO: " + e.getMessage());
        }
        return u;
    }

    // --- 2. REGISTRO DE USUARIO ---
    public boolean registrar(Usuario u) {
        String sql = "INSERT INTO usuarios (username, email, password, rol) VALUES (?, ?, ?, ?)";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getRol() != null ? u.getRol() : "Usuario");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al registrar: " + e.getMessage());
            return false;
        }
    }

    // --- 3. ACTUALIZAR DATOS BÁSICOS ---
    public boolean actualizar(Usuario usu) {
        String sql = "UPDATE usuarios SET username=?, email=?, rol=? WHERE id=?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, usu.getUsername());
            ps.setString(2, usu.getEmail());
            ps.setString(3, usu.getRol());
            ps.setInt(4, usu.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar: " + e.getMessage());
            return false;
        }
    }

    // --- 4. CAMBIAR CONTRASEÑA (SEGURIDAD) ---
    public boolean actualizarPassword(int id, String nuevaPass) {
        String sql = "UPDATE usuarios SET password = ? WHERE id = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nuevaPass);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            return false;
        }
    }

    // --- 5. BUSQUEDA POR ID ---
    public Usuario obtenerPorId(int id) {
        Usuario u = null;
        String sql = "SELECT * FROM usuarios WHERE id = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    u = new Usuario();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setRol(rs.getString("rol"));
                }
            }
        } catch (SQLException e) {
            return null;
        }
        return u;
    }

    // --- 6. LISTAR TODOS ---
    public List<Usuario> listarTodos() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT id, username, email, rol FROM usuarios ORDER BY id DESC";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setRol(rs.getString("rol"));
                lista.add(u);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error al listar todos los usuarios", e);
        }
        return lista;
    }

    // --- 7. ELIMINAR ---
    public boolean eliminar(int id) {
        String sql = "DELETE FROM usuarios WHERE id = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            return false;
        }
    }

    // --- 8. VALIDAR SI YA EXISTE (PARA REGISTRO) ---
    public boolean existeUsuario(String username, String email) {
        String sql = "SELECT id FROM usuarios WHERE username = ? OR email = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            return false;
        }
    }

    // --- 9. ESTADÍSTICAS (PARA DASHBOARD) ---
    public int contarUsuarios() {
        String sql = "SELECT COUNT(*) FROM usuarios";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            return 0;
        }
        return 0;
    }
}