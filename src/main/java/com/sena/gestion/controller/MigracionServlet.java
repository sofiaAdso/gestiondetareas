package com.sena.gestion.controller;

import com.sena.gestion.model.Usuario;
import com.sena.gestion.util.MigradorActividadesAutomatico;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet para ejecutar la migración automática de tareas a actividades
 * Solo accesible por administradores
 */
@WebServlet("/MigracionServlet")
public class MigracionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuario");

        // Verificar autenticación
        if (user == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // Verificar que sea administrador
        if (!"Administrador".equals(user.getRol())) {
            response.sendRedirect("dashboard.jsp?error=acceso_denegado");
            return;
        }

        String accion = request.getParameter("accion");
        if (accion == null) accion = "ver";

        switch (accion) {
            case "ver":
                // Mostrar página de confirmación
                request.getRequestDispatcher("migracion-actividades.jsp").forward(request, response);
                break;

            case "ejecutar":
                // Ejecutar la migración
                ejecutarMigracion(request, response);
                break;

            default:
                response.sendRedirect("dashboard.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Ejecuta la migración automática
     */
    private void ejecutarMigracion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        System.out.println("=== MIGRACIÓN INICIADA DESDE WEB ===");
        System.out.println("Usuario: " + ((Usuario) request.getSession().getAttribute("usuario")).getUsername());

        try {
            MigradorActividadesAutomatico migrador = new MigradorActividadesAutomatico();
            MigradorActividadesAutomatico.MigracionResultado resultado = migrador.ejecutarMigracion();

            if (resultado.exitoso) {
                // Redirigir con mensaje de éxito
                response.sendRedirect(String.format(
                        "ActividadServlet?accion=listar&msg=migracion_exitosa&actividades=%d&tareas=%d",
                        resultado.actividadesCreadas,
                        resultado.tareasAsignadas
                ));
            } else {
                // Redirigir con mensaje de error
                response.sendRedirect(
                        "MigracionServlet?accion=ver&error=migracion_fallida&errores=" + resultado.errores
                );
            }

        } catch (Exception e) {
            System.err.println("Error fatal en migración: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("MigracionServlet?accion=ver&error=excepcion");
        }
    }
}

