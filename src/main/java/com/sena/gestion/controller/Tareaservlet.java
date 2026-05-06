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

            case "nuevo":
                manejarNuevaTarea(request, response, user);
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

    private void manejarNuevaTarea(HttpServletRequest request, HttpServletResponse response, Usuario user)
            throws ServletException, IOException {
        try {
            // Obtener el parámetro idActividad si viene del botón "Agregar Tarea"
            String idActividadParam = request.getParameter("idActividad");

            // Cargar listas necesarias para el formulario
            List<Categoria> listaCategorias = categoriaDao.listarTodas();
            List<Actividad> listaActividades = actividadDao.listarTodas();
            List<Usuario> listaUsuarios = usuarioDao.listarTodos();

            request.setAttribute("listaCategorias", listaCategorias);
            request.setAttribute("listaActividades", listaActividades);
            request.setAttribute("listaUsuarios", listaUsuarios);

            // Si viene de una actividad específica, pasar el ID
            if (idActividadParam != null && !idActividadParam.isEmpty()) {
                request.setAttribute("idActividadPre", idActividadParam);
            }

            // Redirigir al formulario de tarea
            request.getRequestDispatcher("formulario-tarea.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al abrir formulario de nueva tarea", e);
            response.sendRedirect("ActividadServlet?accion=listar&error=true");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Usuario user = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (user == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String accion = request.getParameter("accion");

        if ("registrar".equals(accion)) {
            procesarRegistroTarea(request, response, user);
        } else if ("actualizar".equals(accion)) {
            procesarActualizacionTarea(request, response, user);
        } else {
            response.sendRedirect("Tareaservlet?accion=listar");
        }
    }

    private void procesarRegistroTarea(HttpServletRequest request, HttpServletResponse response, Usuario user)
            throws IOException {
        try {
            Tarea tarea = new Tarea();

            // Capturar datos del formulario
            tarea.setTitulo(request.getParameter("txttitulo"));
            tarea.setDescripcion(request.getParameter("txtdescripcion"));

            // Actividad
            String idActStr = request.getParameter("txtactividad");
            if (idActStr != null && !idActStr.isEmpty()) {
                tarea.setActividad_id(Integer.parseInt(idActStr));
            }

            // Categoría
            String idCatStr = request.getParameter("txtcategoria");
            if (idCatStr != null && !idCatStr.isEmpty()) {
                tarea.setCategoria_id(Integer.parseInt(idCatStr));
            }

            // Prioridad
            tarea.setPrioridad(request.getParameter("txtprioridad"));

            // Fechas
            String fechaInicio = request.getParameter("txtfecha_inicio");
            String fechaVencimiento = request.getParameter("txtfecha_vencimiento");

            if (fechaInicio != null && !fechaInicio.isEmpty()) {
                tarea.setFecha_inicio(Date.valueOf(fechaInicio));
            }
            if (fechaVencimiento != null && !fechaVencimiento.isEmpty()) {
                tarea.setFecha_vencimiento(Date.valueOf(fechaVencimiento));
            }

            // Usuario
            String idUsuStr = request.getParameter("txtusuario");
            if (idUsuStr != null && !idUsuStr.isEmpty()) {
                tarea.setUsuario_id(Integer.parseInt(idUsuStr));
            } else {
                tarea.setUsuario_id(user.getId());
            }

            // Estado por defecto
            tarea.setEstado("Pendiente");

            // Guardar
            boolean creada = tareaDao.registrar(tarea);
            if (creada) {
                String idActVolver = request.getParameter("txtactividad");
                if (idActVolver != null && !idActVolver.isEmpty()) {
                    response.sendRedirect("ActividadServlet?accion=ver&id=" + idActVolver + "&msg=ok");
                } else {
                    response.sendRedirect("Tareaservlet?accion=listar&msg=ok");
                }
            } else {
                response.sendRedirect("Tareaservlet?accion=listar&error=crear");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al crear tarea", e);
            response.sendRedirect("Tareaservlet?accion=listar&error=true");
        }
    }

    private void procesarActualizacionTarea(HttpServletRequest request, HttpServletResponse response, Usuario user)
            throws IOException {
        try {
            String idStr = request.getParameter("txtid");
            if (idStr == null || idStr.isEmpty()) {
                response.sendRedirect("Tareaservlet?accion=listar&error=id");
                return;
            }

            int id = Integer.parseInt(idStr);
            Tarea tarea = tareaDao.obtenerPorId(id);

            if (tarea == null) {
                response.sendRedirect("Tareaservlet?accion=listar&error=notfound");
                return;
            }

            // Actualizar datos
            tarea.setTitulo(request.getParameter("txttitulo"));
            tarea.setDescripcion(request.getParameter("txtdescripcion"));

            String idCatStr = request.getParameter("txtcategoria");
            if (idCatStr != null && !idCatStr.isEmpty()) {
                tarea.setCategoria_id(Integer.parseInt(idCatStr));
            }

            tarea.setPrioridad(request.getParameter("txtprioridad"));

            String fechaInicio = request.getParameter("txtfecha_inicio");
            String fechaVencimiento = request.getParameter("txtfecha_vencimiento");

            if (fechaInicio != null && !fechaInicio.isEmpty()) {
                tarea.setFecha_inicio(Date.valueOf(fechaInicio));
            }
            if (fechaVencimiento != null && !fechaVencimiento.isEmpty()) {
                tarea.setFecha_vencimiento(Date.valueOf(fechaVencimiento));
            }

            // Actualizar
            if (tareaDao.actualizar(tarea)) {
                String idActVolver = request.getParameter("txtactividad");
                if (idActVolver != null && !idActVolver.isEmpty()) {
                    response.sendRedirect("ActividadServlet?accion=ver&id=" + idActVolver + "&msg=ok");
                } else {
                    response.sendRedirect("Tareaservlet?accion=listar&msg=ok");
                }
            } else {
                response.sendRedirect("Tareaservlet?accion=listar&error=update");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al actualizar tarea", e);
            response.sendRedirect("Tareaservlet?accion=listar&error=true");
        }
    }
}