package com.sena.gestion.controller;

import com.sena.gestion.model.Subtarea;
import com.sena.gestion.model.Usuario;
import com.sena.gestion.repository.SubtareaDao;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet para gestionar las operaciones CRUD de Subtareas
 */
@WebServlet("/SubtareaServlet")
public class SubtareaServlet extends HttpServlet {

    private final SubtareaDao subtareaDao = new SubtareaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");

        if (user == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String accion = request.getParameter("accion");
        if (accion == null) accion = "listar";

        switch (accion) {
            case "eliminar":
                eliminarSubtarea(request, response);
                break;
            default:
                response.sendRedirect("Tareaservlet?accion=listar");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");

        if (user == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String accion = request.getParameter("accion");

        if (accion == null || accion.isEmpty()) {
            response.sendRedirect("Tareaservlet?accion=listar");
            return;
        }

        switch (accion) {
            case "crear":
                crearSubtarea(request, response);
                break;

            case "completar":
                completarSubtarea(request, response);
                break;

            case "actualizar":
                actualizarSubtarea(request, response);
                break;

            case "eliminar":
                eliminarSubtarea(request, response);
                break;

            default:
                response.sendRedirect("Tareaservlet?accion=listar");
        }
    }

    /**
     * Crea una nueva subtarea
     */
    private void crearSubtarea(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String tareaIdStr = request.getParameter("tarea_id");
            if (tareaIdStr == null || tareaIdStr.trim().isEmpty()) {
                System.err.println("Error: ID de tarea vacío");
                response.sendRedirect("Tareaservlet?accion=listar&error=tarea_id_requerido");
                return;
            }

            int tareaId = Integer.parseInt(tareaIdStr.trim());
            String titulo = request.getParameter("titulo");
            String descripcion = request.getParameter("descripcion");

            if (titulo == null || titulo.trim().isEmpty()) {
                response.sendRedirect("Tareaservlet?accion=editar&id=" + tareaId + "&error=titulo_vacio");
                return;
            }

            Subtarea subtarea = new Subtarea();
            subtarea.setTarea_id(tareaId);
            subtarea.setTitulo(titulo.trim());
            subtarea.setDescripcion(descripcion != null ? descripcion.trim() : "");
            subtarea.setCompletada(false);

            boolean creada = subtareaDao.crear(subtarea);

            if (creada) {
                response.sendRedirect("Tareaservlet?accion=editar&id=" + tareaId + "&msg=subtarea_creada");
            } else {
                response.sendRedirect("Tareaservlet?accion=editar&id=" + tareaId + "&error=crear_subtarea");
            }

        } catch (NumberFormatException e) {
            System.err.println("Error al parsear ID de tarea: " + e.getMessage());
            response.sendRedirect("Tareaservlet?accion=listar&error=parametro_invalido");
        }
    }

    /**
     * Marca una subtarea como completada o pendiente
     */
    private void completarSubtarea(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String idStr = request.getParameter("id");
            String tareaIdStr = request.getParameter("tarea_id");

            if (idStr == null || idStr.trim().isEmpty()) {
                System.err.println("Error: ID de subtarea vacío");
                response.sendRedirect("Tareaservlet?accion=listar&error=subtarea_id_requerido");
                return;
            }

            if (tareaIdStr == null || tareaIdStr.trim().isEmpty()) {
                System.err.println("Error: ID de tarea vacío");
                response.sendRedirect("Tareaservlet?accion=listar&error=tarea_id_requerido");
                return;
            }

            int id = Integer.parseInt(idStr.trim());
            int tareaId = Integer.parseInt(tareaIdStr.trim());
            boolean completada = Boolean.parseBoolean(request.getParameter("completada"));

            boolean actualizada = subtareaDao.marcarCompletada(id, completada);

            if (actualizada) {
                response.sendRedirect("Tareaservlet?accion=editar&id=" + tareaId + "&msg=subtarea_actualizada");
            } else {
                response.sendRedirect("Tareaservlet?accion=editar&id=" + tareaId + "&error=actualizar_subtarea");
            }

        } catch (NumberFormatException e) {
            System.err.println("Error al parsear parámetros: " + e.getMessage());
            response.sendRedirect("Tareaservlet?accion=listar&error=parametro_invalido");
        }
    }

    /**
     * Actualiza los datos de una subtarea
     */
    private void actualizarSubtarea(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String idStr = request.getParameter("id");
            String tareaIdStr = request.getParameter("tarea_id");

            if (idStr == null || idStr.trim().isEmpty()) {
                System.err.println("Error: ID de subtarea vacío");
                response.sendRedirect("Tareaservlet?accion=listar&error=subtarea_id_requerido");
                return;
            }

            if (tareaIdStr == null || tareaIdStr.trim().isEmpty()) {
                System.err.println("Error: ID de tarea vacío");
                response.sendRedirect("Tareaservlet?accion=listar&error=tarea_id_requerido");
                return;
            }

            int id = Integer.parseInt(idStr.trim());
            int tareaId = Integer.parseInt(tareaIdStr.trim());
            String titulo = request.getParameter("titulo");
            String descripcion = request.getParameter("descripcion");
            boolean completada = Boolean.parseBoolean(request.getParameter("completada"));

            if (titulo == null || titulo.trim().isEmpty()) {
                response.sendRedirect("Tareaservlet?accion=editar&id=" + tareaId + "&error=titulo_vacio");
                return;
            }

            Subtarea subtarea = new Subtarea();
            subtarea.setId(id);
            subtarea.setTitulo(titulo.trim());
            subtarea.setDescripcion(descripcion != null ? descripcion.trim() : "");
            subtarea.setCompletada(completada);

            boolean actualizada = subtareaDao.actualizar(subtarea);

            if (actualizada) {
                response.sendRedirect("Tareaservlet?accion=editar&id=" + tareaId + "&msg=subtarea_actualizada");
            } else {
                response.sendRedirect("Tareaservlet?accion=editar&id=" + tareaId + "&error=actualizar_subtarea");
            }

        } catch (NumberFormatException e) {
            System.err.println("Error al parsear parámetros: " + e.getMessage());
            response.sendRedirect("Tareaservlet?accion=listar&error=parametro_invalido");
        }
    }

    /**
     * Elimina una subtarea
     */
    private void eliminarSubtarea(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String idStr = request.getParameter("id");
            String tareaIdStr = request.getParameter("tarea_id");

            if (idStr == null || idStr.trim().isEmpty()) {
                System.err.println("Error: ID de subtarea vacío");
                response.sendRedirect("Tareaservlet?accion=listar&error=subtarea_id_requerido");
                return;
            }

            if (tareaIdStr == null || tareaIdStr.trim().isEmpty()) {
                System.err.println("Error: ID de tarea vacío");
                response.sendRedirect("Tareaservlet?accion=listar&error=tarea_id_requerido");
                return;
            }

            int id = Integer.parseInt(idStr.trim());
            int tareaId = Integer.parseInt(tareaIdStr.trim());

            boolean eliminada = subtareaDao.eliminar(id);

            if (eliminada) {
                response.sendRedirect("Tareaservlet?accion=editar&id=" + tareaId + "&msg=subtarea_eliminada");
            } else {
                response.sendRedirect("Tareaservlet?accion=editar&id=" + tareaId + "&error=eliminar_subtarea");
            }

        } catch (NumberFormatException e) {
            System.err.println("Error al parsear parámetros: " + e.getMessage());
            response.sendRedirect("Tareaservlet?accion=listar&error=parametro_invalido");
        }
    }
}

