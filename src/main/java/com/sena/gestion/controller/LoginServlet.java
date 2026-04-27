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

        if ("editar".equals(accion)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Usuario u = usuarioDao.obtenerPorId(id);
                if (u != null) {
                    request.setAttribute("usuario", u);
                    request.getRequestDispatcher("formulario_usuario.jsp").forward(request, response);
                } else {
                    response.sendRedirect("index.jsp?error=usuario_no_encontrado");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("index.jsp");
            }
        } else {
            response.sendRedirect("index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ CORRECCIÓN: encoding siempre al inicio
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");

        if ("registrar".equals(accion) || "actualizar".equals(accion)) {
            procesarUsuario(request, response, accion);
        } else {
            validarLogin(request, response);
        }
    }

    private void validarLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ CORRECCIÓN: trim() para evitar espacios en blanco invisibles
        String user = request.getParameter("txtuser");
        String pass = request.getParameter("txtpass");

        user = (user != null) ? user.trim() : "";
        pass = (pass != null) ? pass.trim() : "";

        System.out.println(">> Login intento - Usuario: [" + user + "] | Pass recibida: " + (pass.isEmpty() ? "VACÍA" : "OK"));

        if (user.isEmpty() || pass.isEmpty()) {
            request.setAttribute("error", "Por favor ingresa usuario y contraseña.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        Usuario usuario = usuarioDao.validar(user, pass);

        if (usuario != null) {
            System.out.println("✅ Login exitoso para: " + user);
            HttpSession session = request.getSession(true);
            session.setAttribute("usuario", usuario);
            session.setMaxInactiveInterval(30 * 60); // 30 minutos
            response.sendRedirect("dashboard.jsp");
        } else {
            System.out.println("❌ Credenciales inválidas para: " + user);
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
                    request.setAttribute("error", "ID de usuario inválido.");
                    request.getRequestDispatcher("registro_usuario.jsp").forward(request, response);
                    return;
                }
            }

            usu.setUsername(request.getParameter("txtusuario"));
            usu.setPassword(request.getParameter("txtpassword"));
            usu.setRol(request.getParameter("txtrol"));

            String fInicioStr      = request.getParameter("txtfecha_inicio");
            String fVencimientoStr = request.getParameter("txtfecha_vencimiento");

            if (fInicioStr != null && !fInicioStr.isEmpty()) {
                usu.setFecha_inicio(Date.valueOf(fInicioStr));
            }
            if (fVencimientoStr != null && !fVencimientoStr.isEmpty()) {
                usu.setFecha_vencimiento(Date.valueOf(fVencimientoStr));
            }

            boolean resultado = "actualizar".equals(accion)
                    ? usuarioDao.actualizar(usu)
                    : usuarioDao.registrar(usu);

            if (resultado) {
                if ("actualizar".equals(accion)) {
                    response.sendRedirect("Usuarioservlet?accion=listar&msg=exito");
                } else {
                    response.sendRedirect("index.jsp?msg=exito");
                }
            } else {
                request.setAttribute("error", "No se pudo procesar el usuario. Verifique los datos.");
                request.getRequestDispatcher("formulario_usuario.jsp").forward(request, response);
            }

        } catch (Exception e) {
            System.err.println("❌ Error en procesarUsuario: " + e.getMessage());
            response.sendRedirect("formulario_usuario.jsp?error=datos_invalidos");
        }
    }
}