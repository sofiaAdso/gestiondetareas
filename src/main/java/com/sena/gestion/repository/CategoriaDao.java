package com.sena.gestion.repository;

import com.sena.gestion.model.Categoria;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoriaDao {

    // 1. LISTAR TODAS LAS CATEGORÍAS
    public List<Categoria> listar() {
        List<Categoria> lista = new ArrayList<>();
        String sql = "SELECT id, nombre, descripcion FROM categorias ORDER BY id DESC";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Categoria c = new Categoria();
                c.setId(rs.getInt("id"));
                c.setNombre(rs.getString("nombre"));
                c.setDescripcion(rs.getString("descripcion"));
                lista.add(c);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar categorías: " + e.getMessage());
        }
        return lista;
    }

    // ✅ CORREGIDO: antes retornaba List.of() (vacía), ahora llama a listar()
    public List<Categoria> listarTodas() {
        return listar();
    }

    // 2. REGISTRAR UNA NUEVA CATEGORÍA
    public boolean registrar(Categoria c) {
        String sql = "INSERT INTO categorias (nombre, descripcion) VALUES (?, ?)";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getNombre());
            ps.setString(2, c.getDescripcion());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al registrar categoría: " + e.getMessage());
            return false;
        }
    }

    // 3. OBTENER UNA CATEGORÍA POR ID
    public Categoria obtenerPorId(int id) {
        String sql = "SELECT id, nombre, descripcion FROM categorias WHERE id = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Categoria c = new Categoria();
                    c.setId(rs.getInt("id"));
                    c.setNombre(rs.getString("nombre"));
                    c.setDescripcion(rs.getString("descripcion"));
                    return c;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener categoría: " + e.getMessage());
        }
        return null;
    }

    // 4. ACTUALIZAR UNA CATEGORÍA
    public boolean actualizar(Categoria c) {
        String sql = "UPDATE categorias SET nombre = ?, descripcion = ? WHERE id = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getNombre());
            ps.setString(2, c.getDescripcion());
            ps.setInt(3, c.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar categoría: " + e.getMessage());
            return false;
        }
    }

    // 5. ELIMINAR UNA CATEGORÍA
    public boolean eliminar(int id) {
        String sql = "DELETE FROM categorias WHERE id = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al eliminar categoría: " + e.getMessage());
            return false;
        }
    }

    // 6. VERIFICAR SI UNA CATEGORÍA TIENE TAREAS ASIGNADAS
    public boolean tieneTareasAsignadas(int idCategoria) {
        String sql = "SELECT COUNT(*) AS total FROM tareas WHERE categoria_id = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCategoria);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("total") > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error al verificar tareas: " + e.getMessage());
        }
        return false;
    }
}