package com.sena.gestion.controller;

import com.sena.gestion.model.Actividad;
import com.sena.gestion.model.Tarea;
import com.sena.gestion.model.Usuario;
import com.sena.gestion.repository.ActividadDao;
import com.sena.gestion.repository.TareaDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Servlet para consultar y mostrar datos de las tablas Actividades y Tareas
 */
@WebServlet("/ConsultarDatosServlet")
public class ConsultarDatosServlet extends HttpServlet {

    private final ActividadDao actividadDao = new ActividadDao();
    private final TareaDao tareaDao = new TareaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        // Validar que el usuario esté autenticado
        if (usuario == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String tipo = request.getParameter("tipo");

        try {
            if ("actividades".equalsIgnoreCase(tipo)) {

                // Traer todas las actividades
                consultarActividades(request, response, usuario);
            } else if ("tareas".equalsIgnoreCase(tipo)) {
                // Traer todas las tareas

                consultarTareas(request, response, usuario);
            } else if ("todo".equalsIgnoreCase(tipo) || tipo == null) {
                // Traer actividades y tareas

                consultarTodo(request, response, usuario);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tipo de consulta no válido");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al consultar los datos: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    /**
     * Consulta solo las actividades
     */
    private void consultarActividades(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        List<Actividad> listaActividades;

        // Si es administrador, trae todas; si no, solo las del usuario
        if ("Administrador".equalsIgnoreCase(usuario.getRol())) {
            listaActividades = actividadDao.listarTodas();
        } else {
            listaActividades = actividadDao.listarPorUsuario(usuario.getId());
        }

        // Calcular estadísticas
        int total = listaActividades.size();
        long completadas = listaActividades.stream()
                .filter(a -> a.getEstado() != null && a.getEstado().trim().equalsIgnoreCase("Completada"))
                .count();
        long enProceso = listaActividades.stream()
                .filter(a -> a.getEstado() != null && a.getEstado().trim().equalsIgnoreCase("En Proceso"))
                .count();
        long pendientes = total - completadas - enProceso;
        if (pendientes < 0) pendientes = 0;

        // Enviar datos a la vista
        request.setAttribute("listaActividades", listaActividades);
        request.setAttribute("totalActividades", total);
        request.setAttribute("actividadesCompletadas", completadas);
        request.setAttribute("actividadesEnProceso", enProceso);
        request.setAttribute("actividadesPendientes", pendientes);
        request.setAttribute("tipoConsulta", "actividades");

        request.getRequestDispatcher("consultar_datos.jsp").forward(request, response);
    }

    /**
     * Consulta solo las tareas
     */
    private void consultarTareas(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        List<Tarea> listaTareas;

        // Si es administrador, trae todas; si no, solo las del usuario
        if ("Administrador".equalsIgnoreCase(usuario.getRol())) {
            listaTareas = tareaDao.listar();
        } else {
            listaTareas = tareaDao.listarPorUsuario(usuario.getId());
        }

        // Calcular estadísticas
        int total = listaTareas.size();
        long completadas = listaTareas.stream()
                .filter(t -> t.getEstado() != null && t.getEstado().trim().equalsIgnoreCase("Completada"))
                .count();
        long enProceso = listaTareas.stream()
                .filter(t -> t.getEstado() != null && t.getEstado().trim().equalsIgnoreCase("En Proceso"))
                .count();
        long pendientes = total - completadas - enProceso;
        if (pendientes < 0) pendientes = 0;

        // Enviar datos a la vista
        request.setAttribute("listaTareas", listaTareas);
        request.setAttribute("totalTareas", total);
        request.setAttribute("tareasCompletadas", completadas);
        request.setAttribute("tareasEnProceso", enProceso);
        request.setAttribute("tareasPendientes", pendientes);
        request.setAttribute("tipoConsulta", "tareas");

        request.getRequestDispatcher("consultar_datos.jsp").forward(request, response);
    }

    /**
     * Consulta actividades y tareas
     */
    private void consultarTodo(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {

        List<Actividad> listaActividades;
        List<Tarea> listaTareas;

        // Traer actividades
        if ("Administrador".equalsIgnoreCase(usuario.getRol())) {
            listaActividades = actividadDao.listarTodas();
            listaTareas = tareaDao.listar();
        } else {
            listaActividades = actividadDao.listarPorUsuario(usuario.getId());
            listaTareas = tareaDao.listarPorUsuario(usuario.getId());
        }

        // Estadísticas de actividades
        int totalActividades = listaActividades.size();
        long actividadesCompletadas = listaActividades.stream()
                .filter(a -> a.getEstado() != null && a.getEstado().trim().equalsIgnoreCase("Completada"))
                .count();
        long actividadesEnProceso = listaActividades.stream()
                .filter(a -> a.getEstado() != null && a.getEstado().trim().equalsIgnoreCase("En Proceso"))
                .count();

        // Estadísticas de tareas
        int totalTareas = listaTareas.size();
        long tareasCompletadas = listaTareas.stream()
                .filter(t -> t.getEstado() != null && t.getEstado().trim().equalsIgnoreCase("Completada"))
                .count();
        long tareasEnProceso = listaTareas.stream()
                .filter(t -> t.getEstado() != null && t.getEstado().trim().equalsIgnoreCase("En Proceso"))
                .count();

        // Enviar todos los datos
        request.setAttribute("listaActividades", listaActividades);
        request.setAttribute("totalActividades", totalActividades);
        request.setAttribute("actividadesCompletadas", actividadesCompletadas);
        request.setAttribute("actividadesEnProceso", actividadesEnProceso);

        request.setAttribute("listaTareas", listaTareas);
        request.setAttribute("totalTareas", totalTareas);
        request.setAttribute("tareasCompletadas", tareasCompletadas);
        request.setAttribute("tareasEnProceso", tareasEnProceso);
        request.setAttribute("tipoConsulta", "todo");

        request.getRequestDispatcher("consultar_datos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

