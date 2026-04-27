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
import java.util.Map;

@WebServlet("/Reportesservlet")
public class Reportesservlet extends HttpServlet {

    private final ActividadDao actividadDao = new ActividadDao();
    private final TareaDao tareaDao = new TareaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");

        if (user == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String vista = request.getParameter("vista");

        try {
            // Si se solicita explícitamente la vista de reportes
            if ("reportes".equals(vista)) {
                // Obtener lista de ACTIVIDADES para mostrar en el reporte
                List<Actividad> listaActividades;
                if ("Administrador".equals(user.getRol())) {
                    listaActividades = actividadDao.listarTodas();
                } else {
                    listaActividades = actividadDao.listarPorUsuario(user.getId());
                }

                if (listaActividades == null) {
                    listaActividades = new ArrayList<>();
                }

                // Calcular estadísticas de ACTIVIDADES
                long totalActividades = listaActividades.size();

                long completadas = listaActividades.stream()
                        .filter(a -> a.getEstado() != null && a.getEstado().trim().equalsIgnoreCase("Completada"))
                        .count();

                long enProceso = listaActividades.stream()
                        .filter(a -> a.getEstado() != null &&
                                (a.getEstado().trim().equalsIgnoreCase("En Progreso") ||
                                 a.getEstado().trim().equalsIgnoreCase("En Proceso") ||
                                 a.getEstado().trim().equalsIgnoreCase("En curso") ||
                                 a.getEstado().trim().equalsIgnoreCase("Proceso")))
                        .count();

                long pendientes = listaActividades.stream()
                        .filter(a -> a.getEstado() != null && a.getEstado().trim().equalsIgnoreCase("Pendiente"))
                        .count();

                // Obtener también las tareas para el detalle
                List<Tarea> listaTareas;
                if ("Administrador".equals(user.getRol())) {
                    listaTareas = tareaDao.listar();
                } else {
                    listaTareas = tareaDao.listarPorUsuario(user.getId());
                }

                // Enviar atributos al JSP de reportes
                request.setAttribute("listaActividades", listaActividades);
                request.setAttribute("listaTareas", listaTareas);
                request.setAttribute("totalActividades", totalActividades);
                request.setAttribute("completadas", completadas);
                request.setAttribute("enProceso", enProceso);
                request.setAttribute("pendientes", pendientes);

                request.getRequestDispatcher("reportes.jsp").forward(request, response);
                return;
            }

            // Vista por defecto: Dashboard con actividades
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
            System.err.println("Error en Reportesservlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=reporte_fallido");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Genera una lista de reporte con actividad, tarea, prioridad y estado
     */
    private List<ItemReporte> generarListaReporte(List<Tarea> listaTareas) {
        List<ItemReporte> listaReporte = new ArrayList<>();
        for (Tarea tarea : listaTareas) {
            ItemReporte item = new ItemReporte();
            item.setActividad(tarea.getNombreActividad() != null ? tarea.getNombreActividad() : "Sin actividad");
            item.setTarea(tarea.getTitulo());
            item.setPrioridad(tarea.getPrioridad());
            item.setEstado(tarea.getEstado());
            listaReporte.add(item);
        }
        return listaReporte;
    }

    /**
     * Clase interna para representar un item del reporte
     */
    public static class ItemReporte {
        private String actividad;
        private String tarea;
        private String prioridad;
        private String estado;

        public String getActividad() { return actividad; }
        public void setActividad(String actividad) { this.actividad = actividad; }
        public String getTarea() { return tarea; }
        public void setTarea(String tarea) { this.tarea = tarea; }
        public String getPrioridad() { return prioridad; }
        public void setPrioridad(String prioridad) { this.prioridad = prioridad; }
        public String getEstado() { return estado; }
        public void setEstado(String estado) { this.estado = estado; }
    }
}