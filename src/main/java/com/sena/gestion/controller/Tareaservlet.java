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

@WebServlet("/Tareaservlet")
public class Tareaservlet extends HttpServlet {

    private final TareaDao tareaDao = new TareaDao();
    private final UsuarioDao usuarioDao = new UsuarioDao();
    private final CategoriaDao categoriaDao = new CategoriaDao();
    private final SubtareaDao subtareaDao = new SubtareaDao();
    private final ActividadDao actividadDao = new ActividadDao();

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

        // Cargar catálogos para los formularios
        request.setAttribute("listaCategorias", categoriaDao.listar());
        if ("Administrador".equals(user.getRol())) {
            request.setAttribute("listaUsuarios", usuarioDao.listarTodos());
        }

        switch (accion) {
            case "listar":
                listarTareas(request, response, user);
                break;

            case "nuevo":
                cargarActividadesSegunRol(request, user);
                String idActPre = request.getParameter("actividad_id");
                if (idActPre != null && !idActPre.isEmpty()) {
                    request.setAttribute("idActividadPre", idActPre);
                }
                request.getRequestDispatcher("formulario-tarea.jsp").forward(request, response);
                break;

            case "editar":
                String idEd = request.getParameter("id");
                if (idEd != null && !idEd.trim().isEmpty()) {
                    int tareaId = Integer.parseInt(idEd.trim());
                    Tarea tareaExistente = tareaDao.obtenerPorId(tareaId);
                    request.setAttribute("tarea", tareaExistente);
                    request.setAttribute("listaSubtareas", subtareaDao.listarPorTarea(tareaId));
                }
                cargarActividadesSegunRol(request, user);
                request.getRequestDispatcher("formulario-tarea.jsp").forward(request, response);
                break;

            case "eliminar":
                eliminarTarea(request, response);
                break;

            case "listarPorActividad":
                listarTareasPorActividad(request, response);
                break;

            default:
                listarTareas(request, response, user);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");

        if (user == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String accion = request.getParameter("accion");

        if ("registrar".equals(accion) || "actualizar".equals(accion)) {
            Tarea t = new Tarea();
            try {
                if ("actualizar".equals(accion)) {
                    t.setId(Integer.parseInt(request.getParameter("txtid")));
                }

                t.setTitulo(request.getParameter("txttitulo"));
                t.setDescripcion(request.getParameter("txtdescripcion"));
                t.setPrioridad(request.getParameter("txtprioridad"));
                t.setEstado(request.getParameter("txtestado") != null ? request.getParameter("txtestado") : "Pendiente");
                t.setCompletada("Completada".equals(t.getEstado()));
                t.setFecha_inicio(parseDateParam(request.getParameter("txtfecha_inicio")));
                t.setFecha_vencimiento(parseDateParam(request.getParameter("txtfecha_vencimiento")));
                t.setNotas(request.getParameter("txtnotas"));

                // Prioridad de ID de actividad: 1. Select del form, 2. Hidden de origen
                String actIdStr = request.getParameter("txtactividad");
                if (actIdStr == null || actIdStr.isEmpty()) {
                    actIdStr = request.getParameter("idActividadOrigen");
                }
                t.setActividad_id(actIdStr != null ? Integer.parseInt(actIdStr) : 0);

                String idU = request.getParameter("txtusuario");
                t.setUsuario_id(idU != null ? Integer.parseInt(idU) : user.getId());

                String catId = request.getParameter("txtcategoria");
                if (catId != null && !catId.isEmpty()) {
                    t.setCategoria_id(Integer.parseInt(catId));
                }

                boolean exito = "actualizar".equals(accion) ? tareaDao.actualizar(t) : tareaDao.registrar(t);

                // Redirección inteligente
                if (t.getActividad_id() > 0) {
                    response.sendRedirect("Tareaservlet?accion=listarPorActividad&idActividad=" + t.getActividad_id() + (exito ? "&msg=ok" : "&error=1"));
                } else {
                    response.sendRedirect("Tareaservlet?accion=listar" + (exito ? "&msg=ok" : "&error=1"));
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("Tareaservlet?accion=listar&error=1");
            }
        }
    }

    // --- MÉTODOS DE APOYO PARA LIMPIAR EL SWITCH ---

    private void listarTareas(HttpServletRequest request, HttpServletResponse response, Usuario user)
            throws IOException, ServletException {
        List<Tarea> lista = "Administrador".equals(user.getRol()) ? tareaDao.listar() : tareaDao.listarPorUsuario(user.getId());
        request.setAttribute("listaTareas", lista);
        request.getRequestDispatcher("listar-tareas.jsp").forward(request, response);
    }

    private void listarTareasPorActividad(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String idActStr = request.getParameter("idActividad");
        if (idActStr != null) {
            int idAct = Integer.parseInt(idActStr);
            request.setAttribute("actividad", actividadDao.obtenerPorId(idAct));
            request.setAttribute("listaTareas", tareaDao.listarPorActividad(idAct));
            request.setAttribute("idActividadActual", idAct);
            request.getRequestDispatcher("ver-actividad.jsp").forward(request, response);
        } else {
            response.sendRedirect("ActividadServlet?accion=listar");
        }
    }

    private void eliminarTarea(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int idEliminar = Integer.parseInt(request.getParameter("id"));
            String idActVolver = request.getParameter("idActividad");
            tareaDao.eliminar(idEliminar);
            if (idActVolver != null) {
                response.sendRedirect("Tareaservlet?accion=listarPorActividad&idActividad=" + idActVolver + "&msg=eliminado");
            } else {
                response.sendRedirect("Tareaservlet?accion=listar&msg=eliminado");
            }
        } catch (Exception e) {
            response.sendRedirect("Tareaservlet?accion=listar&error=1");
        }
    }

    private void cargarActividadesSegunRol(HttpServletRequest request, Usuario user) {
        List<Actividad> actividades = "Administrador".equals(user.getRol())
                ? actividadDao.listarTodas()
                : actividadDao.listarPorUsuario(user.getId());
        request.setAttribute("listaActividades", actividades);
    }

    private Date parseDateParam(String value) {
        if (value == null || value.trim().isEmpty()) return new Date(System.currentTimeMillis());
        try { return Date.valueOf(value); } catch (Exception e) { return new Date(System.currentTimeMillis()); }
    }
}