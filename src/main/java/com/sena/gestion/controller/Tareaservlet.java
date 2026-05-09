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
import java.util.ArrayList;
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
                manejarCambioEstado(request, response);
                break;
            case "eliminar":
                manejarEliminacion(request, response);
                break;
            case "listarPorActividad":
                procesarListadoPorActividad(request, response);
                break;
            default:
                response.sendRedirect("ActividadServlet?accion=listar");
                break;
        }
    }

    private void procesarListadoPorActividad(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                int idAct = Integer.parseInt(idStr);
                Actividad act = actividadDao.obtenerPorId(idAct);
                List<Tarea> tareas = tareaDao.listarPorActividad(idAct);
                request.setAttribute("actividad", act);
                request.setAttribute("listaTareas", tareas != null ? tareas : new ArrayList<>());
                request.getRequestDispatcher("ver-tareas.jsp").forward(request, response);
            } else {
                response.sendRedirect("ActividadServlet?accion=listar");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al listar tareas por actividad", e);
            response.sendRedirect("ActividadServlet?accion=listar&error=proceso");
        }
    }

    private void manejarCambioEstado(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int idTarea = Integer.parseInt(request.getParameter("id"));
            String nuevoEstado = request.getParameter("estado");
            String idActVolver = request.getParameter("actividadId");

            if (tareaDao.actualizarEstado(idTarea, nuevoEstado)) {
                if (idActVolver != null && !idActVolver.isEmpty()) {
                    response.sendRedirect("ActividadServlet?accion=ver&id=" + idActVolver + "&msg=ok");
                } else {
                    response.sendRedirect("Tareaservlet?accion=listar&msg=ok");
                }
            } else {
                response.sendRedirect("ActividadServlet?accion=listar&error=actualizar");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al cambiar estado de tarea", e);
            response.sendRedirect("ActividadServlet?accion=listar&error=proceso");
        }
    }

    private void manejarEliminacion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String idActVolver = request.getParameter("actividadId");
            if (tareaDao.eliminar(id)) {
                if (idActVolver != null && !idActVolver.isEmpty()) {
                    response.sendRedirect("ActividadServlet?accion=ver&id=" + idActVolver + "&msg=ok");
                } else {
                    response.sendRedirect("Tareaservlet?accion=listar&msg=ok");
                }
            } else {
                response.sendRedirect("ActividadServlet?accion=listar&error=eliminar");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al eliminar tarea", e);
            response.sendRedirect("ActividadServlet?accion=listar&error=proceso");
        }
    }

    private void procesarListadoGeneral(HttpServletRequest request, HttpServletResponse response, Usuario user)
            throws ServletException, IOException {
        try {
            List<Tarea> lista = "Administrador".equals(user.getRol())
                    ? tareaDao.listar()
                    : tareaDao.listarPorUsuario(user.getId());
            request.setAttribute("listaTareas", lista != null ? lista : new ArrayList<>());
            request.getRequestDispatcher("listar-tareas.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al listar tareas", e);
            request.setAttribute("listaTareas", new ArrayList<>());
            request.getRequestDispatcher("listar-tareas.jsp").forward(request, response);
        }
    }

    private void manejarNuevaTarea(HttpServletRequest request, HttpServletResponse response, Usuario user)
            throws ServletException, IOException {
        try {
            String idActividadParam = request.getParameter("idActividad");

            List<Categoria> listaCategorias = categoriaDao.listarTodas();
            List<Actividad> listaActividades = actividadDao.listarTodas();
            List<Usuario>   listaUsuarios    = usuarioDao.listarTodos();

            request.setAttribute("listaCategorias",  listaCategorias  != null ? listaCategorias  : new ArrayList<>());
            request.setAttribute("listaActividades", listaActividades != null ? listaActividades : new ArrayList<>());
            request.setAttribute("listaUsuarios",    listaUsuarios    != null ? listaUsuarios    : new ArrayList<>());

            if (idActividadParam != null && !idActividadParam.isEmpty()) {
                request.setAttribute("idActividadPre", idActividadParam);
            }

            request.getRequestDispatcher("formulario-tarea.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al abrir formulario de nueva tarea", e);
            // ✅ CORREGIDO: error=proceso en lugar de error=true
            response.sendRedirect("ActividadServlet?accion=listar&error=proceso");
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
            tarea.setTitulo(request.getParameter("txttitulo"));
            tarea.setDescripcion(request.getParameter("txtdescripcion"));

            String idActStr = request.getParameter("txtactividad");
            if (idActStr != null && !idActStr.isEmpty()) {
                tarea.setActividad_id(Integer.parseInt(idActStr));
            }

            String idCatStr = request.getParameter("txtcategoria");
            if (idCatStr != null && !idCatStr.isEmpty()) {
                tarea.setCategoria_id(Integer.parseInt(idCatStr));
            }

            tarea.setPrioridad(request.getParameter("txtprioridad"));

            String fechaInicio = request.getParameter("txtfecha_inicio");
            String fechaVenc   = request.getParameter("txtfecha_vencimiento");
            if (fechaInicio != null && !fechaInicio.isEmpty()) tarea.setFecha_inicio(Date.valueOf(fechaInicio));
            if (fechaVenc   != null && !fechaVenc.isEmpty())   tarea.setFecha_vencimiento(Date.valueOf(fechaVenc));

            String idUsuStr = request.getParameter("txtusuario");
            tarea.setUsuario_id((idUsuStr != null && !idUsuStr.isEmpty())
                    ? Integer.parseInt(idUsuStr) : user.getId());

            tarea.setEstado("Pendiente");

            boolean creada = tareaDao.registrar(tarea);
            if (creada) {
                if (idActStr != null && !idActStr.isEmpty()) {
                    response.sendRedirect("ActividadServlet?accion=ver&id=" + idActStr + "&msg=ok");
                } else {
                    response.sendRedirect("Tareaservlet?accion=listar&msg=ok");
                }
            } else {
                response.sendRedirect("Tareaservlet?accion=listar&error=crear");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al crear tarea", e);
            response.sendRedirect("Tareaservlet?accion=listar&error=proceso");
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
                response.sendRedirect("Tareaservlet?accion=listar&error=no_encontrada");
                return;
            }

            tarea.setTitulo(request.getParameter("txttitulo"));
            tarea.setDescripcion(request.getParameter("txtdescripcion"));

            String idCatStr = request.getParameter("txtcategoria");
            if (idCatStr != null && !idCatStr.isEmpty()) tarea.setCategoria_id(Integer.parseInt(idCatStr));

            tarea.setPrioridad(request.getParameter("txtprioridad"));

            String fechaInicio = request.getParameter("txtfecha_inicio");
            String fechaVenc   = request.getParameter("txtfecha_vencimiento");
            if (fechaInicio != null && !fechaInicio.isEmpty()) tarea.setFecha_inicio(Date.valueOf(fechaInicio));
            if (fechaVenc   != null && !fechaVenc.isEmpty())   tarea.setFecha_vencimiento(Date.valueOf(fechaVenc));

            if (tareaDao.actualizar(tarea)) {
                String idActVolver = request.getParameter("txtactividad");
                if (idActVolver != null && !idActVolver.isEmpty()) {
                    response.sendRedirect("ActividadServlet?accion=ver&id=" + idActVolver + "&msg=ok");
                } else {
                    response.sendRedirect("Tareaservlet?accion=listar&msg=ok");
                }
            } else {
                response.sendRedirect("Tareaservlet?accion=listar&error=actualizar");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al actualizar tarea", e);
            response.sendRedirect("Tareaservlet?accion=listar&error=proceso");
        }
    }
}
