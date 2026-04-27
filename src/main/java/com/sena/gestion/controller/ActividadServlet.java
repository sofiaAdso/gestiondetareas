package com.sena.gestion.controller;

import com.sena.gestion.model.*;
import com.sena.gestion.repository.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/ActividadServlet")
public class ActividadServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ActividadServlet.class.getName());
    private final ActividadDao actividadDao = new ActividadDao();
    private final TareaDao tareaDao = new TareaDao();
    private final UsuarioDao usuarioDao = new UsuarioDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario user = (session != null) ? (Usuario) session.getAttribute("usuario") : null;
        if (user == null) { response.sendRedirect("index.jsp"); return; }

        boolean isAdmin = "Administrador".equals(user.getRol());
        String accion = request.getParameter("accion");
        if (accion == null) accion = "listar";

        switch (accion) {
            case "listar":
            case "mis-actividades":
            case "dashboard-admin":
                procesarListado(request, response, user, isAdmin);
                break;

            case "nuevo":
                if (!isAdmin) { response.sendRedirect("ActividadServlet?accion=listar&error=sin_permiso"); return; }
                request.setAttribute("listaUsuarios", usuarioDao.listarTodos());
                request.getRequestDispatcher("formulario-actividad.jsp").forward(request, response);
                break;

            case "editar":
                if (!isAdmin) { response.sendRedirect("ActividadServlet?accion=listar&error=sin_permiso"); return; }
                manejarEdicion(request, response);
                break;

            case "ver":
                manejarVer(request, response);
                break;

            case "eliminar":
                if (!isAdmin) { response.sendRedirect("ActividadServlet?accion=listar&error=sin_permiso"); return; }
                manejarEliminacion(request, response);
                break;

            case "cambiarEstado":
                manejarCambioEstado(request, response, user);
                break;

            case "reporte":
                request.setAttribute("datosReporte", actividadDao.obtenerReporteActividadesConTareas());
                request.getRequestDispatcher("reportes.jsp").forward(request, response);
                break;

            default:
                procesarListado(request, response, user, isAdmin);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Usuario user = (session != null) ? (Usuario) session.getAttribute("usuario") : null;
        if (user == null) { response.sendRedirect("index.jsp"); return; }

        if (!"Administrador".equals(user.getRol())) {
            response.sendRedirect("ActividadServlet?accion=listar&error=sin_permiso");
            return;
        }

        String accion = request.getParameter("accion");

        if ("crear".equals(accion) || "actualizar".equals(accion)) {
            procesarGuardado(request, response, user, accion);
        }
    }

    private void procesarListado(HttpServletRequest request, HttpServletResponse response,
                                 Usuario user, boolean isAdmin)
            throws ServletException, IOException {
        try {
            List<Actividad> lista = isAdmin
                    ? actividadDao.listarTodas()
                    : actividadDao.listarPorUsuario(user.getId());

            if (lista == null) lista = new ArrayList<>();

            for (Actividad act : lista) {
                List<Tarea> tareas = tareaDao.listarPorActividad(act.getId());
                int total = tareas != null ? tareas.size() : 0;
                int completadas = 0;
                if (tareas != null) {
                    for (Tarea t : tareas) {
                        if ("Completada".equals(t.getEstado())) completadas++;
                    }
                }
                act.setTotalTareas(total);
                act.setTareasCompletadas(completadas);
                act.setPorcentajeCompletado(total > 0 ? (completadas * 100.0 / total) : 0);
            }

            request.setAttribute("listaActividades", lista);
            request.getRequestDispatcher("listar-actividades.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al listar actividades", e);
            request.setAttribute("errorMensaje", "Error al cargar las actividades: " + e.getMessage());
            request.setAttribute("listaActividades", new ArrayList<>());
            request.getRequestDispatcher("listar-actividades.jsp").forward(request, response);
        }
    }

    private void manejarVer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Actividad actividad = actividadDao.obtenerPorId(id);
            if (actividad != null) {
                request.setAttribute("actividad", actividad);
                request.setAttribute("listaTareas", tareaDao.listarPorActividad(id));
                request.getRequestDispatcher("ver-actividad.jsp").forward(request, response);
            } else {
                response.sendRedirect("ActividadServlet?accion=listar&error=no_encontrada");
            }
        } catch (Exception e) {
            response.sendRedirect("ActividadServlet?accion=listar&error=datos_invalidos");
        }
    }

    private void manejarEdicion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            request.setAttribute("actividad", actividadDao.obtenerPorId(id));
            request.setAttribute("listaUsuarios", usuarioDao.listarTodos());
            request.getRequestDispatcher("formulario-actividad.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect("ActividadServlet?accion=listar&error=datos_invalidos");
        }
    }

    private void manejarEliminacion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            actividadDao.eliminar(id);
            response.sendRedirect("ActividadServlet?accion=listar&msg=eliminado");
        } catch (Exception e) {
            response.sendRedirect("ActividadServlet?accion=listar&error=eliminar");
        }
    }

    private void manejarCambioEstado(HttpServletRequest request, HttpServletResponse response,
                                     Usuario user) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String estado = request.getParameter("estado");
            actividadDao.actualizarEstado(id, estado);
            response.sendRedirect("ActividadServlet?accion=listar&msg=estado_actualizado");
        } catch (Exception e) {
            response.sendRedirect("ActividadServlet?accion=listar&error=actualizar");
        }
    }

    // ── METODO CORREGIDO PARA FUNCIONAR CON EL NUEVO FORMULARIO ──
    private void procesarGuardado(HttpServletRequest request, HttpServletResponse response,
                                  Usuario user, String accion) throws IOException {
        try {
            Actividad a = new Actividad();

            // 1. Manejo de ID para actualización
            if ("actualizar".equals(accion)) {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isEmpty()) {
                    a.setId(Integer.parseInt(idStr));
                }
            }

            // 2. Captura de campos básicos
            a.setTitulo(request.getParameter("titulo"));
            a.setDescripcion(request.getParameter("descripcion"));
            a.setPrioridad(request.getParameter("prioridad"));

            // 3. Estado: Prioriza el valor del formulario (ej. "Pendiente"), si es nulo usa "Pendiente" por defecto
            String estadoForm = request.getParameter("estado");
            a.setEstado((estadoForm != null && !estadoForm.isEmpty()) ? estadoForm : "Pendiente");

            // 4. Manejo de Fechas (Evita error si el campo llega vacío)
            String fechaIni = request.getParameter("fecha_inicio");
            String fechaFin = request.getParameter("fecha_fin");
            try {
                if (fechaIni != null && !fechaIni.isEmpty()) a.setFecha_inicio(Date.valueOf(fechaIni));
                if (fechaFin != null && !fechaFin.isEmpty()) a.setFecha_fin(Date.valueOf(fechaFin));
            } catch (IllegalArgumentException e) {
                LOGGER.warning("Formato de fecha inválido recibido");
            }

            // 5. Usuario Asignado
            String uIdStr = request.getParameter("usuario_id");
            a.setUsuario_id((uIdStr != null && !uIdStr.isEmpty()) ? Integer.parseInt(uIdStr) : user.getId());

            // 6. Ejecución en DAO
            if ("actualizar".equals(accion)) {
                actividadDao.actualizar(a);
                response.sendRedirect("ActividadServlet?accion=listar&msg=ok");
            } else {
                // Para creación usamos el método que devuelve el ID
                int nuevoId = actividadDao.crearYRetornarId(a);
                if (nuevoId > 0) {
                    response.sendRedirect("ActividadServlet?accion=listar&msg=ok");
                } else {
                    response.sendRedirect("ActividadServlet?accion=nuevo&error=crear_actividad");
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al guardar actividad", e);
            response.sendRedirect("ActividadServlet?accion=listar&error=proceso");
        }
    }
}