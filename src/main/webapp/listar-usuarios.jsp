package com.sena.gestion.controller;

import com.sena.gestion.model.Usuario;
import com.sena.gestion.repository.UsuarioDao;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/Usuarioservlet")
public class Usuarioservlet extends HttpServlet {

    private final UsuarioDao usuarioDao = new UsuarioDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario user = (session != null) ? (Usuario) session.getAttribute("usuario") : null;
        if (user == null) { response.sendRedirect("index.jsp"); return; }

        String accion = request.getParameter("accion");
        if (accion == null) accion = "listar";

        switch (accion) {
            case "listar":
                List<Usuario> lista = usuarioDao.listarTodos();
                request.setAttribute("listaUsuarios", lista);
                request.setAttribute("msg", request.getParameter("msg"));
                request.getRequestDispatcher("listar-usuarios.jsp").forward(request, response);
                break;

            case "nuevo":
                request.getRequestDispatcher("listar-usuarios.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect("Usuarioservlet?accion=listar");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Usuario user = (session != null) ? (Usuario) session.getAttribute("usuario") : null;
        if (user == null) { response.sendRedirect("index.jsp"); return; }

        String accion = request.getParameter("accion");

        if ("registrar".equals(accion)) {
            String username = request.getParameter("txtusername");
            String email    = request.getParameter("txtemail");
            String password = request.getParameter("txtpassword");
            String rol      = request.getParameter("txtrol");

            if (username == null || username.trim().isEmpty() ||
                    email == null || email.trim().isEmpty() ||
                    password == null || password.trim().isEmpty()) {
                response.sendRedirect("listar-usuarios.jsp?error=campos");
                return;
            }

            if (usuarioDao.existeUsuario(username, email)) {
                response.sendRedirect("listar-usuarios.jsp?error=existe");
                return;
            }

            Usuario nuevo = new Usuario();
            nuevo.setUsername(username.trim());
            nuevo.setEmail(email.trim());
            nuevo.setPassword(password);
            nuevo.setRol(rol != null ? rol : "Usuario");

            if (usuarioDao.registrar(nuevo)) {
                // ✅ CORREGIDO: redirige a la lista de usuarios con mensaje de éxito
                response.sendRedirect("Usuarioservlet?accion=listar&msg=registro_exitoso");
            } else {
                response.sendRedirect("listar-usuarios.jsp?error=db");
            }

        } else if ("eliminar".equals(accion)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                usuarioDao.eliminar(id);
                response.sendRedirect("Usuarioservlet?accion=listar&msg=eliminado");
            } catch (Exception e) {
                response.sendRedirect("Usuarioservlet?accion=listar&error=eliminar");
            }

        } else {
            response.sendRedirect("Usuarioservlet?accion=listar");
        }
    }
}
