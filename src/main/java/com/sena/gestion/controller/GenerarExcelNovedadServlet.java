package com.sena.gestion.controller;

import com.sena.gestion.model.Novedad;
import com.sena.gestion.repository.NovedadDao;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/GenerarExcelNovedad")
public class GenerarExcelNovedadServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(GenerarExcelNovedadServlet.class.getName());
    private final NovedadDao novedadDao = new NovedadDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session.getAttribute("usuario") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("NovedadServlet?accion=listar&error=sinId");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("NovedadServlet?accion=listar&error=idInvalido");
            return;
        }

        Novedad n = novedadDao.obtenerPorId(id);
        if (n == null) {
            response.sendRedirect("NovedadServlet?accion=listar&error=noEncontrado");
            return;
        }

        InputStream plantillaStream = getServletContext()
                .getResourceAsStream("/WEB-INF/plantillas/GFPI-F-021.xlsx");

        if (plantillaStream == null) {
            LOGGER.severe("No se encontró la plantilla en /WEB-INF/plantillas/GFPI-F-021.xlsx");
            response.sendRedirect("NovedadServlet?accion=listar&error=plantilla");
            return;
        }

        try (Workbook wb = new XSSFWorkbook(plantillaStream)) {
            Sheet sheet = wb.getSheetAt(0);

            setCellValue(sheet, 3, 4,  val(n.getRegional()));
            setCellValue(sheet, 3, 11, val(n.getCentroFormacion()));
            setCellValue(sheet, 4, 4,  val(n.getProgramaFormacion()));
            setCellValue(sheet, 4, 11, val(n.getCodigoPrograma()));
            setCellValue(sheet, 5, 8,  val(n.getAmbiente()));
            setCellValue(sheet, 5, 13, val(n.getLocalizacion()));
            setCellValue(sheet, 6, 13, val(n.getDenominacion()));

            if ("Interno".equalsIgnoreCase(n.getTipoAmbiente())) {
                setCellValue(sheet, 7, 8,  "✓ Interno");
                setCellValue(sheet, 7, 12, "Externo");
            } else {
                setCellValue(sheet, 7, 8,  "Interno");
                setCellValue(sheet, 7, 12, "✓ Externo");
            }

            String detalle = val(n.getDetalleNovedad());
            String tipo    = val(n.getTipoNovedad());

            if ("Ambiente".equalsIgnoreCase(tipo)) {
                setCellValue(sheet, 10, 6, detalle);
            } else if ("Equipos".equalsIgnoreCase(tipo)) {
                setCellValue(sheet, 11, 6, detalle);
            } else if ("Materiales".equalsIgnoreCase(tipo)) {
                setCellValue(sheet, 12, 6, detalle);
            } else if ("Biblioteca".equalsIgnoreCase(tipo)) {
                setCellValue(sheet, 13, 6, detalle);
            } else {
                setCellValue(sheet, 10, 6, detalle);
            }

            String viabilidad = val(n.getViabilidad());
            String textoViab;
            if ("Apto".equalsIgnoreCase(viabilidad)) {
                textoViab = "DECISION SOBRE LA VIABILIDAD DE USO DEL AMBIENTE:   ✓ APTO                                     NO APTO";
            } else {
                textoViab = "DECISION SOBRE LA VIABILIDAD DE USO DEL AMBIENTE:   APTO                                     ✓ NO APTO";
            }
            setCellValue(sheet, 14, 0, textoViab);

            String fecha = "";
            if (n.getFechaReporte() != null) {
                fecha = new SimpleDateFormat("dd/MM/yyyy").format(n.getFechaReporte());
            }

            setCellValue(sheet, 17, 3,  fecha);
            setCellValue(sheet, 17, 10, val(n.getNombreInstructor()));
            setCellValue(sheet, 18, 3,  fecha);
            setCellValue(sheet, 18, 10, val(n.getNombreCoordinador()));

            String nombreArchivo = "GFPI-F-021_Novedad_" + id + ".xlsx";
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + nombreArchivo + "\"");

            wb.write(response.getOutputStream());
            response.getOutputStream().flush();

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al generar Excel de novedad", e);
            response.sendRedirect("NovedadServlet?accion=listar&error=excel");
        }
    }

    private void setCellValue(Sheet sheet, int rowIdx, int colIdx, String value) {
        Row row = sheet.getRow(rowIdx);
        if (row == null) row = sheet.createRow(rowIdx);
        Cell cell = row.getCell(colIdx);
        if (cell == null) cell = row.createCell(colIdx);
        cell.setCellValue(value);
    }

    private String val(String s) {
        return s != null ? s : "";
    }
}