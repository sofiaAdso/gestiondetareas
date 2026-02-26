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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/Reportesservlet")
public class Reportesservlet extends HttpServlet {

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

        try {
            List<Actividad> listaActividades;
            if ("Administrador".equals(user.getRol())) {
                listaActividades = actividadDao.listarTodas();
            } else {
                listaActividades = actividadDao.listarPorUsuario(user.getId());
            }

            if (listaActividades == null) {
                listaActividades = new ArrayList<>();
            }

            // --- LO QUE HACÍA FALTA: FILTRADO ROBUSTO (TRIM Y CASE INSENSITIVE) ---

            long completadas = listaActividades.stream()
                    .filter(a -> a.getEstado() != null && a.getEstado().trim().equalsIgnoreCase("Completada"))
                    .count();

            long enProceso = listaActividades.stream()
                    .filter(a -> a.getEstado() != null &&
                            (a.getEstado().trim().equalsIgnoreCase("En Proceso") ||
                                    a.getEstado().trim().equalsIgnoreCase("En curso") ||
                                    a.getEstado().trim().equalsIgnoreCase("Proceso")))
                    .count();

            // Calculamos las pendientes como el resto de la lista para asegurar cuadre total
            long pendientes = listaActividades.size() - (completadas + enProceso);
            if(pendientes < 0) pendientes = 0; // Validación de seguridad

            // --- PASAR ATRIBUTOS EXACTOS ---
            request.setAttribute("totalActividades", listaActividades.size());
            request.setAttribute("actividadesCompletadas", (int) completadas);
            request.setAttribute("actividadesEnProceso", (int) enProceso);
            request.setAttribute("actividadesPendientes", (int) pendientes);
            request.setAttribute("listaActividades", listaActividades);

            // --- RECUERDA: Si tu dashboard está en dashboard.jsp, cámbialo aquí si es necesario ---
            // Si quieres que el Dashboard se actualice al entrar, usa "dashboard.jsp"
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error en Reportesservlet (Actividades): " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=reporte_fallido");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}