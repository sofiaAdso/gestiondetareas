package com.sena.gestion.controller;

import com.sena.gestion.model.Usuario;
import com.sena.gestion.repository.UsuarioDao;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private UsuarioDao usuarioDao = new UsuarioDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        // Lógica para cargar datos en el formulario de edición
        if ("editar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Usuario u = usuarioDao.obtenerPorId(id);
            request.setAttribute("usuario", u); // Esto llena los campos en formulario_usuario.jsp
            request.getRequestDispatcher("formulario_usuario.jsp").forward(request, response);
        } else {
            response.sendRedirect("index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        if ("registrar".equals(accion) || "actualizar".equals(accion)) {
            procesarUsuario(request, response, accion);
        } else {
            validarLogin(request, response);
        }
    }

    private void validarLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String user = request.getParameter("txtuser");
        String pass = request.getParameter("txtpass");

        // Debug
        System.out.println("Usuario: " + user + " | Contraseña: " + (pass != null ? "***" : "null"));

        if (user == null || user.trim().isEmpty() || pass == null || pass.trim().isEmpty()) {
            System.out.println("Campos vacíos");
            request.setAttribute("error", "Por favor ingresa usuario y contraseña.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        Usuario usuario = usuarioDao.validar(user, pass);

        if (usuario != null) {
            System.out.println("Usuario " + user + " autenticado correctamente");
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);
            response.sendRedirect("dashboard.jsp"); // Redirigir a la pantalla de bienvenida
        } else {
            System.out.println("Credenciales inválidas para usuario: " + user);
            request.setAttribute("error", "Usuario o contraseña incorrectos. Por favor verifica tus credenciales.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    private void procesarUsuario(HttpServletRequest request, HttpServletResponse response, String accion)
            throws ServletException, IOException {
        try {
            Usuario usu = new Usuario();
            String idStr = request.getParameter("txtId");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    usu.setId(Integer.parseInt(idStr.trim()));
                } catch (NumberFormatException e) {
                    System.err.println("Error: ID de usuario inválido - " + idStr);
                    request.setAttribute("error", "ID de usuario inválido");
                    request.getRequestDispatcher("registro_usuario.jsp").forward(request, response);
                    return;
                }
            }

            usu.setUsername(request.getParameter("txtusuario"));
            usu.setPassword(request.getParameter("txtpassword"));
            usu.setRol(request.getParameter("txtrol"));

            String fInicioStr = request.getParameter("txtfecha_inicio");
            String fVencimientoStr = request.getParameter("txtfecha_vencimiento");

            if (fInicioStr != null && !fInicioStr.isEmpty()) {
                usu.setFecha_inicio(Date.valueOf(fInicioStr));
            }
            if (fVencimientoStr != null && !fVencimientoStr.isEmpty()) {
                usu.setFecha_vencimiento(Date.valueOf(fVencimientoStr));
            }

            // CORRECCIÓN LÍNEA 79: Cambiamos 'int' por 'boolean'
            boolean resultado;
            if ("actualizar".equals(accion)) {
                resultado = usuarioDao.actualizar(usu);
            } else {
                resultado = usuarioDao.registrar(usu);
            }

            if (resultado) {
                // Si el DAO devolvió true, la operación fue exitosa
                if ("actualizar".equals(accion)) {
                    response.sendRedirect("Usuarioservlet?accion=listar&msg=exito");
                } else {
                    response.sendRedirect("index.jsp?msg=exito");
                }
            } else {
                request.setAttribute("error", "No se pudo procesar el usuario.");
                request.getRequestDispatcher("formulario_usuario.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.out.println("Error en Servlet Usuario: " + e.getMessage());
            response.sendRedirect("formulario_usuario.jsp?error=datos_invalidos");
        }
    }
}