package com.sena.gestion.repository;

import com.sena.gestion.model.Categoria;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoriaDao {
    private Connection con;
    private PreparedStatement ps;
    private ResultSet rs;

    // 1. LISTAR TODAS LAS CATEGORÍAS
    public List<Categoria> listar() {
        List<Categoria> lista = new ArrayList<>();
        String sql = "SELECT id, nombre, descripcion FROM categorias ORDER BY id DESC";
        try {
            con = Conexion.getConexion();
            System.out.println("=== DEBUG CategoriaDao.listar() ===");
            System.out.println("Conexión establecida: " + (con != null && !con.isClosed()));
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Categoria c = new Categoria();
                c.setId(rs.getInt("id"));
                c.setNombre(rs.getString("nombre"));
                c.setDescripcion(rs.getString("descripcion"));
                lista.add(c);
            }
            System.out.println("Categorías obtenidas: " + lista.size());
        } catch (SQLException e) {
            System.err.println("Error al listar categorías: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos();
        }
        return lista;
    }

    // 2. REGISTRAR UNA NUEVA CATEGORÍA
    public boolean registrar(Categoria c) {
        String sql = "INSERT INTO categorias (nombre, descripcion) VALUES (?, ?)";
        System.out.println("=== DEBUG CategoriaDao.registrar() ===");
        System.out.println("SQL: " + sql);
        System.out.println("Nombre: " + c.getNombre());
        System.out.println("Descripción: " + c.getDescripcion());

        try {
            con = Conexion.getConexion();
            System.out.println("Conexión establecida: " + (con != null && !con.isClosed()));

            ps = con.prepareStatement(sql);
            ps.setString(1, c.getNombre());
            ps.setString(2, c.getDescripcion());

            int filasAfectadas = ps.executeUpdate();
            System.out.println("Filas afectadas: " + filasAfectadas);

            boolean resultado = filasAfectadas > 0;
            System.out.println("Resultado: " + resultado);

            return resultado;
        } catch (SQLException e) {
            System.err.println("ERROR SQL al registrar categoría: " + e.getMessage());
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("ErrorCode: " + e.getErrorCode());
            e.printStackTrace();
            return false;
        } finally {
            cerrarRecursos();
        }
    }

    // 3. OBTENER UNA CATEGORÍA POR ID
    public Categoria obtenerPorId(int id) {
        Categoria c = null;
        String sql = "SELECT id, nombre, descripcion FROM categorias WHERE id = ?";
        try {
            con = Conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                c = new Categoria();
                c.setId(rs.getInt("id"));
                c.setNombre(rs.getString("nombre"));
                c.setDescripcion(rs.getString("descripcion"));
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener categoría: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }
        return c;
    }

    // 4. ACTUALIZAR UNA CATEGORÍA
    public boolean actualizar(Categoria c) {
        String sql = "UPDATE categorias SET nombre = ?, descripcion = ? WHERE id = ?";
        try {
            con = Conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, c.getNombre());
            ps.setString(2, c.getDescripcion());
            ps.setInt(3, c.getId());
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar categoría: " + e.getMessage());
            return false;
        } finally {
            cerrarRecursos();
        }
    }

    // 5. ELIMINAR UNA CATEGORÍA (BORRADO FÍSICO)
    public boolean eliminar(int id) {
        // Borrado físico ya que no tenemos columna activo
        String sql = "DELETE FROM categorias WHERE id = ?";
        try {
            con = Conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            int filasAfectadas = ps.executeUpdate();
            System.out.println("Categoría eliminada. ID: " + id);
            return filasAfectadas > 0;
        } catch (SQLException e) {
            System.err.println("Error al eliminar categoría: " + e.getMessage());
            return false;
        } finally {
            cerrarRecursos();
        }
    }

    // 6. VERIFICAR SI UNA CATEGORÍA TIENE TAREAS ASIGNADAS
    public boolean tieneTareasAsignadas(int idCategoria) {
        String sql = "SELECT COUNT(*) as total FROM tareas WHERE categoria_id = ?";
        try {
            con = Conexion.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idCategoria);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total") > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error al verificar tareas: " + e.getMessage());
        } finally {
            cerrarRecursos();
        }
        return false;
    }

    // Método privado para cerrar recursos
    private void cerrarRecursos() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            System.err.println("Error al cerrar recursos: " + e.getMessage());
        }
    }

    public List<Categoria> listarTodas() {
        return List.of();
    }
}



