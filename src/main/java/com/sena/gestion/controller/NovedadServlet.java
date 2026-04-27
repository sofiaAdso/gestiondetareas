
package com.sena.gestion.controller;

import com.sena.gestion.model.*;
import com.sena.gestion.repository.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/NovedadServlet")
public class NovedadServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(NovedadServlet.class.getName());
    private final NovedadDao novedadDao = new NovedadDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");
        if (user == null) { response.sendRedirect("index.jsp"); return; }

        String accion = request.getParameter("accion");
        if (accion == null) accion = "listar";

        switch (accion) {

            case "listar":
                listar(request, response, user);
                break;

            case "ver":
                ver(request, response);
                break;

            case "eliminar":
                eliminar(request, response);
                break;

            case "imprimir":
                // Redirige a una vista de impresión (puedes crear imprimir-novedad.jsp)
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    request.setAttribute("novedad", novedadDao.obtenerPorId(Integer.parseInt(idStr)));
                    request.getRequestDispatcher("imprimir-novedad.jsp").forward(request, response);
                } else {
                    response.sendRedirect("NovedadServlet?accion=listar");
                }
                break;

            default:
                listar(request, response, user);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");
        if (user == null) { response.sendRedirect("index.jsp"); return; }

        String accion = request.getParameter("accion");

        if ("registrar".equals(accion)) {
            registrar(request, response, user);
        }
    }

    // ── Listar todas las novedades ──
    private void listar(HttpServletRequest request, HttpServletResponse response, Usuario user)
            throws ServletException, IOException {
        try {
            boolean isAdmin = "Administrador".equals(user.getRol());
            List<Novedad> lista = isAdmin
                    ? novedadDao.listarTodas()
                    : novedadDao.listarPorUsuario(user.getId());
            request.setAttribute("listaNovedades", lista);
            request.getRequestDispatcher("novedades.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al listar novedades", e);
            response.sendRedirect("dashboard.jsp?error=novedades");
        }
    }

    // ── Ver detalle de una novedad ──
    private void ver(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            Novedad n = novedadDao.obtenerPorId(Integer.parseInt(idStr));
            request.setAttribute("novedad", n);
            request.getRequestDispatcher("detalle-novedad.jsp").forward(request, response);
        } else {
            response.sendRedirect("NovedadServlet?accion=listar");
        }
    }

    // ── Registrar una nueva novedad ──
    private void registrar(HttpServletRequest request, HttpServletResponse response, Usuario user)
            throws IOException {
        try {
            Novedad n = new Novedad();
            n.setRegional(request.getParameter("regional"));
            n.setCentroFormacion(request.getParameter("centroFormacion"));
            n.setProgramaFormacion(request.getParameter("programaFormacion"));
            n.setCodigoPrograma(request.getParameter("codigoPrograma"));
            n.setAmbiente(request.getParameter("ambiente"));
            n.setLocalizacion(request.getParameter("localizacion"));
            n.setDenominacion(request.getParameter("denominacion"));
            n.setTipoAmbiente(request.getParameter("tipoAmbiente"));
            n.setTipoNovedad(request.getParameter("tipoNovedad"));
            n.setDetalleNovedad(request.getParameter("detalleNovedad"));
            n.setViabilidad(request.getParameter("viabilidad"));
            n.setNombreInstructor(request.getParameter("nombreInstructor"));
            n.setNombreCoordinador(request.getParameter("nombreCoordinador"));
            n.setUsuarioId(user.getId());

            // Fecha del reporte
            String fechaStr = request.getParameter("fechaReporte");
            if (fechaStr != null && !fechaStr.isEmpty()) {
                n.setFechaReporte(java.sql.Date.valueOf(fechaStr));
            } else {
                n.setFechaReporte(new java.sql.Date(System.currentTimeMillis()));
            }

            // Registrar y obtener el ID generado
            int nuevoId = novedadDao.registrarYRetornarId(n);

            if (nuevoId > 0) {
                // ✅ Redirige automáticamente a generar el PDF
                response.sendRedirect("GenerarPdfNovedad?id=" + nuevoId);
            } else {
                response.sendRedirect("NovedadServlet?accion=listar&error=1");
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al registrar novedad", e);
            response.sendRedirect("NovedadServlet?accion=listar&error=catch");
        }
    }

    // ── Eliminar novedad ──
    private void eliminar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            novedadDao.eliminar(id);
            response.sendRedirect("NovedadServlet?accion=listar&msg=eliminado");
        } catch (Exception e) {
            response.sendRedirect("NovedadServlet?accion=listar&error=eliminar");
        }
    }
}

