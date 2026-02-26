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

        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");

        if (user == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String accion = request.getParameter("accion");
        if (accion == null) accion = "listar";

        switch (accion) {
            case "listar":
            case "mis-actividades":
                procesarListado(request, response, user);
                break;
            case "nuevo":
                request.setAttribute("listaUsuarios", usuarioDao.listarTodos());
                request.getRequestDispatcher("formulario-actividad.jsp").forward(request, response);
                break;
            case "editar":
                manejarEdicion(request, response);
                break;
            case "eliminar":
                manejarEliminacion(request, response);
                break;
            case "cambiarEstado":
                manejarCambioEstado(request, response, user);
                break;
            case "ver":
                manejarVerDetalle(request, response);
                break;
        }
    }

    private void procesarListado(HttpServletRequest request, HttpServletResponse response, Usuario user)
            throws IOException {
        try {
            List<Actividad> lista = ("Administrador".equals(user.getRol()))
                    ? actividadDao.listarTodas()
                    : actividadDao.listarPorUsuario(user.getId());

            if (lista == null) lista = new ArrayList<>();

            for (Actividad act : lista) {
                List<Tarea> tareas = tareaDao.listarPorActividad(act.getId());
                act.setTareas(tareas);
                int total = (tareas != null) ? tareas.size() : 0;
                int completadas = 0;
                if (tareas != null) {
                    for (Tarea t : tareas) if ("Completada".equals(t.getEstado())) completadas++;
                }
                act.setTotalTareas(total);
                act.setTareasCompletadas(completadas);
                act.setPorcentajeCompletado(total > 0 ? (completadas * 100.0 / total) : 0);
            }

            // IMPORTANTE: Este nombre debe ser idéntico al del JSP
            request.setAttribute("listaActividades", lista);
            try {
                request.getRequestDispatcher("listar-actividades.jsp").forward(request, response);
            } catch (ServletException e) {
                LOGGER.log(Level.SEVERE, "Error al redirigir a listar-actividades.jsp", e);
                response.sendRedirect("dashboard.jsp?error=listado");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al procesar listado de actividades", e);
            response.sendRedirect("dashboard.jsp?error=listado");
        }
    }

    private void manejarEdicion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            request.setAttribute("actividad", actividadDao.obtenerPorId(id));
            request.setAttribute("listaUsuarios", usuarioDao.listarTodos());
            request.getRequestDispatcher("formulario-actividad.jsp").forward(request, response);
        }
    }

    private void manejarEliminacion(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            actividadDao.eliminar(Integer.parseInt(idStr));
            response.sendRedirect("ActividadServlet?accion=listar&msg=eliminado");
        }
    }

    private void manejarCambioEstado(HttpServletRequest request, HttpServletResponse response, Usuario user) throws IOException {
        // Solo usuarios (no administradores) pueden cambiar el estado
        if ("Administrador".equals(user.getRol())) {
            response.sendRedirect("ActividadServlet?accion=listar&error=sin_permiso");
            return;
        }

        String idStr = request.getParameter("id");
        String nuevoEstado = request.getParameter("estado");

        if (idStr != null && !idStr.isEmpty() && nuevoEstado != null && !nuevoEstado.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                Actividad actividad = actividadDao.obtenerPorId(id);

                if (actividad != null) {
                    // Verificar que la actividad pertenece al usuario
                    if (actividad.getUsuario_id() == user.getId()) {
                        actividad.setEstado(nuevoEstado);
                        boolean actualizado = actividadDao.actualizar(actividad);

                        if (actualizado) {
                            response.sendRedirect("ActividadServlet?accion=listar&msg=estado_actualizado");
                        } else {
                            response.sendRedirect("ActividadServlet?accion=listar&error=actualizar");
                        }
                    } else {
                        response.sendRedirect("ActividadServlet?accion=listar&error=sin_permiso");
                    }
                } else {
                    response.sendRedirect("ActividadServlet?accion=listar&error=no_encontrada");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("ActividadServlet?accion=listar&error=id_invalido");
            }
        } else {
            response.sendRedirect("ActividadServlet?accion=listar&error=datos_invalidos");
        }
    }

    private void manejarVerDetalle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                Actividad actividad = actividadDao.obtenerPorId(id);

                if (actividad != null) {
                    // Obtener las tareas asociadas a esta actividad
                    List<Tarea> tareas = tareaDao.listarPorActividad(id);
                    actividad.setTareas(tareas);

                    // Calcular estadísticas
                    int total = (tareas != null) ? tareas.size() : 0;
                    int completadas = 0;
                    if (tareas != null) {
                        for (Tarea t : tareas) {
                            if ("Completada".equals(t.getEstado())) {
                                completadas++;
                            }
                        }
                    }
                    actividad.setTotalTareas(total);
                    actividad.setTareasCompletadas(completadas);
                    actividad.setPorcentajeCompletado(total > 0 ? (completadas * 100.0 / total) : 0);

                    // Obtener información del usuario asignado
                    Usuario usuarioAsignado = usuarioDao.obtenerPorId(actividad.getUsuario_id());
                    if (usuarioAsignado != null) {
                    actividad.setNombreUsuario(usuarioAsignado.getUsername());
                    }

                    request.setAttribute("actividad", actividad);
                    request.setAttribute("listaTareas", tareas);
                    request.getRequestDispatcher("ver-actividad.jsp").forward(request, response);
                } else {
                    response.sendRedirect("ActividadServlet?accion=listar&error=no_encontrada");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("ActividadServlet?accion=listar&error=id_invalido");
            }
        } else {
            response.sendRedirect("ActividadServlet?accion=listar");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");

        if (user == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String accion = request.getParameter("accion");

        // Si la acción es nula, redirigir
        if (accion == null || accion.isEmpty()) {
            response.sendRedirect("ActividadServlet?accion=listar");
            return;
        }

        if ("crear".equals(accion) || "actualizar".equals(accion)) {
            Actividad actividad;
            String estadoExistente = null;

            if ("actualizar".equals(accion)) {
                // Validación robusta para actualización
                String idStr = request.getParameter("id");
                int id;

                if (idStr != null && !idStr.trim().isEmpty()) {
                    try {
                        id = Integer.parseInt(idStr.trim());
                    } catch (NumberFormatException e) {
                        System.err.println("Error: ID de actividad inválido - " + idStr);
                        response.sendRedirect("ActividadServlet?accion=listar&error=id_invalido");
                        return;
                    }
                } else {
                    System.err.println("Error: ID de actividad vacío en actualizar");
                    response.sendRedirect("ActividadServlet?accion=listar&error=id_requerido");
                    return;
                }

                if (id <= 0) {
                    System.err.println("Error: ID de actividad inválido (debe ser mayor que 0) - " + id);
                    response.sendRedirect("ActividadServlet?accion=listar&error=id_invalido");
                    return;
                }

                // Obtener la actividad existente
                actividad = actividadDao.obtenerPorId(id);
                if (actividad == null) {
                    System.err.println("Error: Actividad no encontrada con ID " + id);
                    response.sendRedirect("ActividadServlet?accion=listar&error=actividad_no_encontrada");
                    return;
                }

                // Preservar el estado existente si el usuario es administrador
                estadoExistente = actividad.getEstado();
            } else {
                actividad = new Actividad();
            }

            // Establecer los datos del formulario
            actividad.setTitulo(request.getParameter("titulo"));
            actividad.setDescripcion(request.getParameter("descripcion"));
            actividad.setPrioridad(request.getParameter("prioridad"));
            actividad.setColor(request.getParameter("color"));

            // Manejo de fechas
            Date fechaInicio = parseDateParam(request.getParameter("fecha_inicio"));
            Date fechaFin = parseDateParam(request.getParameter("fecha_fin"));

            if (fechaInicio == null || fechaFin == null) {
                response.sendRedirect("ActividadServlet?accion=" +
                    ("actualizar".equals(accion) ? "editar&id=" + actividad.getId() : "nuevo") +
                    "&error=fechas_requeridas");
                return;
            }

            actividad.setFecha_inicio(fechaInicio);
            actividad.setFecha_fin(fechaFin);

            // Manejo del ESTADO: Solo usuarios (no admin) pueden modificarlo
            String estadoParam = request.getParameter("estado");
            if ("Administrador".equals(user.getRol())) {
                // El admin NO puede cambiar el estado, se mantiene el existente
                if ("actualizar".equals(accion) && estadoExistente != null) {
                    actividad.setEstado(estadoExistente);
                } else {
                    // En creación, establecer un estado por defecto
                    actividad.setEstado("En Progreso");
                }
            } else {
                // Los usuarios SÍ pueden cambiar el estado
                actividad.setEstado(estadoParam != null ? estadoParam : "En Progreso");
            }

            // Manejo del usuario asignado
            String usuarioIdStr = request.getParameter("usuario_id");
            if (usuarioIdStr != null && !usuarioIdStr.trim().isEmpty()) {
                try {
                    int usuarioId = Integer.parseInt(usuarioIdStr);
                    actividad.setUsuario_id(usuarioId);
                } catch (NumberFormatException ex) {
                    System.err.println("Error: Usuario ID inválido");
                    response.sendRedirect("ActividadServlet?accion=" +
                        ("actualizar".equals(accion) ? "editar&id=" + actividad.getId() : "nuevo") +
                        "&error=usuario_invalido");
                    return;
                }
            } else {
                // Si no viene usuario, usar el usuario actual
                actividad.setUsuario_id(user.getId());
            }

            // Ejecutar la operación
            if ("actualizar".equals(accion)) {
                boolean actualizado = actividadDao.actualizar(actividad);
                if (actualizado) {
                    response.sendRedirect("ActividadServlet?accion=listar&res=ok");
                } else {
                    response.sendRedirect("ActividadServlet?accion=listar&error=update");
                }
            } else {
                // Al crear una actividad, usar crearYRetornarId para obtener el ID
                int nuevoId = actividadDao.crearYRetornarId(actividad);
                System.out.println("=== DEBUG: Después de intentar crear ===");
                System.out.println("ID de actividad creada: " + nuevoId);
                if (nuevoId > 0) {
                    // Redirigir a la vista de detalles de la actividad recién creada
                    response.sendRedirect("ActividadServlet?accion=ver&id=" + nuevoId + "&res=creada");
                } else {
                    response.sendRedirect("ActividadServlet?accion=nuevo&error=crear_actividad");
                }
            }
        }
    }

    /**
     * Convierte un String a java.sql.Date
     */
    private Date parseDateParam(String dateStr) {
        if (dateStr != null && !dateStr.trim().isEmpty()) {
            try {
                return Date.valueOf(dateStr);
            } catch (IllegalArgumentException e) {
                System.err.println("Error al parsear fecha: " + dateStr);
                return null;
            }
        }
        return null;
    }
}