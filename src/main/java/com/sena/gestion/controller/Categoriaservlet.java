package com.sena.gestion.controller;

import com.sena.gestion.model.Categoria;
import com.sena.gestion.model.Usuario;
import com.sena.gestion.repository.CategoriaDao;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/Categoriaservlet")
public class Categoriaservlet extends HttpServlet {
    private CategoriaDao categoriaDao = new CategoriaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verificar que el usuario esté logueado y sea Administrador
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        Usuario user = (Usuario) session.getAttribute("usuario");
        if (!"Administrador".equals(user.getRol())) {
            response.sendRedirect("Tareaservlet?accion=listar");
            return;
        }

        String accion = request.getParameter("accion");

        switch (accion != null ? accion : "listar") {
            case "listar":
                listarCategorias(request, response);
                break;
            case "editar":
                mostrarFormularioEdicion(request, response);
                break;
            case "eliminar":
                eliminarCategoria(request, response);
                break;
            default:
                listarCategorias(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        Usuario user = (Usuario) session.getAttribute("usuario");
        if (!"Administrador".equals(user.getRol())) {
            response.sendRedirect("Tareaservlet?accion=listar");
            return;
        }

        String accion = request.getParameter("accion");

        if ("registrar".equals(accion)) {
            registrarCategoria(request, response);
        } else if ("actualizar".equals(accion)) {
            actualizarCategoria(request, response);
        }
    }

    // Listar todas las categorías
    private void listarCategorias(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Categoria> listaCategorias = categoriaDao.listar();
        System.out.println("=== DEBUG: Categorias obtenidas ===");
        System.out.println("Total categorias: " + (listaCategorias != null ? listaCategorias.size() : "NULL"));
        if (listaCategorias != null && !listaCategorias.isEmpty()) {
            System.out.println("Primera categoria: ID=" + listaCategorias.get(0).getId() +
                             ", Nombre=" + listaCategorias.get(0).getNombre());
        }
        request.setAttribute("listaCategorias", listaCategorias);
        request.getRequestDispatcher("gestion_categorias.jsp").forward(request, response);
    }

    // Registrar una nueva categoría
    private void registrarCategoria(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String nombre = request.getParameter("txtnombre");
            String descripcion = request.getParameter("txtdescripcion");

            System.out.println("=== DEBUG: Registrar Categoría ===");
            System.out.println("Nombre recibido: " + nombre);
            System.out.println("Descripción recibida: " + descripcion);

            // Validar que el nombre no esté vacío
            if (nombre == null || nombre.trim().isEmpty()) {
                System.out.println("ERROR: Nombre vacío");
                response.sendRedirect("Categoriaservlet?accion=listar&error=nombre_vacio");
                return;
            }

            Categoria c = new Categoria();
            c.setNombre(nombre.trim());
            c.setDescripcion(descripcion != null ? descripcion.trim() : "");

            System.out.println("Objeto Categoria creado - Nombre: " + c.getNombre() + ", Desc: " + c.getDescripcion());

            boolean resultado = categoriaDao.registrar(c);

            System.out.println("Resultado del registro: " + resultado);

            if (resultado) {
                System.out.println("✓ Categoría registrada exitosamente");
                response.sendRedirect("Categoriaservlet?accion=listar&res=ok");
            } else {
                System.out.println("✗ Error: No se pudo registrar la categoría");
                response.sendRedirect("Categoriaservlet?accion=listar&error=registro");
            }
        } catch (Exception e) {
            System.err.println("ERROR CRÍTICO al registrar categoría: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("Categoriaservlet?accion=listar&error=sistema");
        }
    }

    // Mostrar formulario de edición
    private void mostrarFormularioEdicion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Categoria c = categoriaDao.obtenerPorId(id);

            if (c != null) {
                List<Categoria> listaCategorias = categoriaDao.listar();
                request.setAttribute("categoriaEditar", c);
                request.setAttribute("listaCategorias", listaCategorias);
                request.getRequestDispatcher("gestion_categorias.jsp").forward(request, response);
            } else {
                response.sendRedirect("Categoriaservlet?accion=listar&error=no_encontrada");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("Categoriaservlet?accion=listar&error=id_invalido");
        }
    }

    // Actualizar una categoría
    private void actualizarCategoria(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("txtid"));
            String nombre = request.getParameter("txtnombre");
            String descripcion = request.getParameter("txtdescripcion");

            // Validar que el nombre no esté vacío
            if (nombre == null || nombre.trim().isEmpty()) {
                response.sendRedirect("Categoriaservlet?accion=listar&error=nombre_vacio");
                return;
            }

            Categoria c = new Categoria();
            c.setId(id);
            c.setNombre(nombre.trim());
            c.setDescripcion(descripcion != null ? descripcion.trim() : "");

            boolean resultado = categoriaDao.actualizar(c);

            if (resultado) {
                response.sendRedirect("Categoriaservlet?accion=listar&res=actualizado");
            } else {
                response.sendRedirect("Categoriaservlet?accion=listar&error=actualizar");
            }
        } catch (Exception e) {
            System.err.println("Error al actualizar categoría: " + e.getMessage());
            response.sendRedirect("Categoriaservlet?accion=listar&error=sistema");
        }
    }

    // Eliminar una categoría
    private void eliminarCategoria(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));

            // Verificar si la categoría tiene tareas asignadas
            if (categoriaDao.tieneTareasAsignadas(id)) {
                response.sendRedirect("Categoriaservlet?accion=listar&error=tiene_tareas");
                return;
            }

            boolean resultado = categoriaDao.eliminar(id);

            if (resultado) {
                response.sendRedirect("Categoriaservlet?accion=listar&res=eliminado");
            } else {
                response.sendRedirect("Categoriaservlet?accion=listar&error=eliminar");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("Categoriaservlet?accion=listar&error=id_invalido");
        } catch (Exception e) {
            System.err.println("Error al eliminar categoría: " + e.getMessage());
            response.sendRedirect("Categoriaservlet?accion=listar&error=sistema");
        }
    }
}

