package com.sena.gestion.controller;

import com.sena.gestion.model.*;
import com.sena.gestion.repository.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/Tareaservlet")
public class Tareaservlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(Tareaservlet.class.getName());
    private final TareaDao tareaDao = new TareaDao();
    private final UsuarioDao usuarioDao = new UsuarioDao();
    private final CategoriaDao categoriaDao = new CategoriaDao();
    private final ActividadDao actividadDao = new ActividadDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario user = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (user == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String accion = request.getParameter("accion");
        if (accion == null) accion = "listar";

        switch (accion) {
            case "listar":
                procesarListadoGeneral(request, response, user);
                break;

            case "cambiarEstado":
                // Corregido: Ahora maneja la redirección a la actividad origen
                manejarCambioEstado(request, response);
                break;

            case "eliminar":
                manejarEliminacion(request, response);
                break;

            case "listarPorActividad":
                // Esta es la acción que llama el botón "Ver" del ActividadServlet
                procesarListadoPorActividad(request, response);
                break;

            default:
                response.sendRedirect("ActividadServlet?accion=mis-actividades");
                break;
        }
    }

    private void procesarListadoPorActividad(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // El parámetro 'id' viene del botón "Ver"
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int idAct = Integer.parseInt(idStr);
                Actividad act = actividadDao.obtenerPorId(idAct);
                List<Tarea> tareas = tareaDao.listarPorActividad(idAct);

                request.setAttribute("actividad", act);
                request.setAttribute("listaTareas", tareas);

                // Redirige a la vista moderna que creamos
                request.getRequestDispatcher("ver-tareas.jsp").forward(request, response);
            } else {
                response.sendRedirect("ActividadServlet?accion=mis-actividades");
            }
        } catch (Exception e) {
            response.sendRedirect("ActividadServlet?accion=mis-actividades&error=id");
        }
    }

    private void manejarCambioEstado(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int idTarea = Integer.parseInt(request.getParameter("id"));
            String nuevoEstado = request.getParameter("estado");
            // Importante: capturamos el id de la actividad para volver a la misma pantalla
            String idActVolver = request.getParameter("actividadId");

            if (tareaDao.actualizarEstado(idTarea, nuevoEstado)) {
                // Si venimos desde la vista de una actividad, volvemos a ella
                if (idActVolver != null && !idActVolver.isEmpty()) {
                    response.sendRedirect("ActividadServlet?accion=ver&id=" + idActVolver + "&msg=ok");
                } else {
                    response.sendRedirect("Tareaservlet?accion=listar&msg=ok");
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al cambiar estado", e);
            response.sendRedirect("ActividadServlet?accion=mis-actividades&error=true");
        }
    }

    private void manejarEliminacion(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String idActVolver = request.getParameter("actividadId");

            if (tareaDao.eliminar(id)) {
                if (idActVolver != null && !idActVolver.isEmpty()) {
                    response.sendRedirect("ActividadServlet?accion=ver&id=" + idActVolver + "&msg=del");
                } else {
                    response.sendRedirect("Tareaservlet?accion=listar&msg=del");
                }
            }
        } catch (Exception e) {
            response.sendRedirect("ActividadServlet?accion=mis-actividades&error=del");
        }
    }

    private void procesarListadoGeneral(HttpServletRequest request, HttpServletResponse response, Usuario user)
            throws ServletException, IOException {
        List<Tarea> lista = "Administrador".equals(user.getRol())
                ? tareaDao.listar()
                : tareaDao.listarPorUsuario(user.getId());
        request.setAttribute("listaTareas", lista);
        request.getRequestDispatcher("listar-tareas.jsp").forward(request, response);
    }
}