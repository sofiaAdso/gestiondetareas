package com.sena.gestion.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/PruebaEvidencia")
@MultipartConfig(maxFileSize = 1024 * 1024 * 10)
public class PruebaEvidenciaServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(PruebaEvidenciaServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html><head><meta charset='UTF-8'><title>Prueba Evidencia</title></head>");
        out.println("<body style='font-family:Arial;margin:20px;'>");
        out.println("<h1>🧪 Prueba de Recepción de Evidencia</h1>");

        try {
            // Obtener parámetros
            String actividadId = request.getParameter("actividadId");
            String tareaId = request.getParameter("tareaId");
            Part filePart = request.getPart("archivo");

            out.println("<h2>Parámetros Recibidos:</h2>");
            out.println("<ul>");
            out.println("<li><strong>actividadId:</strong> " + (actividadId != null ? actividadId : "NULL") + "</li>");
            out.println("<li><strong>tareaId:</strong> " + (tareaId != null ? tareaId : "NULL") + "</li>");

            if (filePart != null) {
                out.println("<li><strong>Archivo (nombre):</strong> " + filePart.getSubmittedFileName() + "</li>");
                out.println("<li><strong>Archivo (tamaño):</strong> " + filePart.getSize() + " bytes</li>");
                out.println("<li><strong>Archivo (type):</strong> " + filePart.getContentType() + "</li>");
            } else {
                out.println("<li><strong>Archivo:</strong> NULL</li>");
            }
            out.println("</ul>");

            out.println("<hr>");
            out.println("<p><a href='ActividadServlet?accion=listar'>← Volver</a></p>");

        } catch (Exception e) {
            out.println("<p>❌ Error: " + e.getMessage() + "</p>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
        }

        out.println("</body></html>");
    }
}

