package com.sena.gestion.controller;

import com.sena.gestion.model.Usuario;
import com.sena.gestion.repository.UsuarioDao;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Usuarioservlet")
public class Usuarioservlet extends HttpServlet {

    private final UsuarioDao usuarioDao = new UsuarioDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        if ("registrar".equals(accion)) {
            // Captura de parámetros (deben coincidir con el 'name' de los inputs en el JSP)
            String username = request.getParameter("txtusername");
            String email = request.getParameter("txtemail");
            String password = request.getParameter("txtpassword");
            String rol = request.getParameter("txtrol");

            // 1. Validar que los campos obligatorios no estén vacíos
            if (username == null || username.trim().isEmpty() ||
                    email == null || email.trim().isEmpty() ||
                    password == null || password.trim().isEmpty()) {

                response.sendRedirect("registro_usuario.jsp?error=campos");
                return;
            }

            // 2. Validar si el usuario o email ya existen para evitar duplicados
            if (usuarioDao.existeUsuario(username, email)) {
                response.sendRedirect("registro_usuario.jsp?error=existe");
                return;
            }

            // 3. Crear el objeto Usuario con todos los datos
            Usuario nuevo = new Usuario();
            nuevo.setUsername(username);
            nuevo.setEmail(email);
            nuevo.setPassword(password);
            nuevo.setRol(rol != null ? rol : "Usuario"); // Asigna 'Usuario' por defecto

            // 4. Ejecutar inserción en la base de datos
            if (usuarioDao.registrar(nuevo)) {
                // Registro exitoso: Redirigimos al dashboard con mensaje de éxito
                response.sendRedirect("Tareaservlet?accion=listar&registro=exito");
            } else {
                // Error técnico en la base de datos
                response.sendRedirect("registro_usuario.jsp?error=db");
            }

        } else {
            // Si la acción no es registrar, enviamos al inicio
            response.sendRedirect("index.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirigir peticiones GET no autorizadas al index
        response.sendRedirect("index.jsp");
    }
}
