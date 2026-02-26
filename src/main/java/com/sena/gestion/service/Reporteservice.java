package com.sena.gestion.service;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.sena.gestion.model.Tarea;

import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.List;

public class Reporteservice {

    /**
     * Genera un reporte PDF con las tareas filtradas
     */
    public static void generarReportePDF(List<Tarea> tareas, OutputStream out) throws DocumentException {
        Document document = new Document(PageSize.A4, 50, 50, 50, 50);
        PdfWriter.getInstance(document, out);
        document.open();

        // Título del reporte
        Font tituloFont = new Font(Font.FontFamily.HELVETICA, 20, Font.BOLD, new BaseColor(74, 20, 140));
        Paragraph titulo = new Paragraph("REPORTE DE TAREAS", tituloFont);
        titulo.setAlignment(Element.ALIGN_CENTER);
        document.add(titulo);

        // Fecha y hora del reporte
        Font fechaFont = new Font(Font.FontFamily.HELVETICA, 10, Font.ITALIC, new BaseColor(100, 100, 100));
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        Paragraph fecha = new Paragraph("Generado: " + sdf.format(new java.util.Date()), fechaFont);
        fecha.setAlignment(Element.ALIGN_RIGHT);
        document.add(fecha);

        document.add(new Paragraph("\n"));

        // Tabla de tareas
        PdfPTable tabla = new PdfPTable(5);
        tabla.setWidthPercentage(100);
        tabla.setSpacingBefore(10f);

        // Encabezados
        String[] encabezados = {"ID", "Título", "Prioridad", "Estado", "Vencimiento"};
        for (String encabezado : encabezados) {
            PdfPCell celda = new PdfPCell(new Phrase(encabezado, new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD, BaseColor.WHITE)));
            celda.setBackgroundColor(new BaseColor(74, 20, 140));
            celda.setPadding(8);
            celda.setHorizontalAlignment(Element.ALIGN_CENTER);
            tabla.addCell(celda);
        }

        // Datos de las tareas
        if (tareas != null && !tareas.isEmpty()) {
            for (Tarea t : tareas) {
                agregarFilaTarea(tabla, t);
            }
        } else {
            PdfPCell celdaVacia = new PdfPCell(new Phrase("No hay datos para mostrar", new Font(Font.FontFamily.HELVETICA, 10)));
            celdaVacia.setColspan(5);
            celdaVacia.setHorizontalAlignment(Element.ALIGN_CENTER);
            celdaVacia.setPadding(20);
            tabla.addCell(celdaVacia);
        }

        document.add(tabla);

        // Resumen de estadísticas
        document.add(new Paragraph("\n"));
        agregarResumenEstadisticas(document, tareas);

        document.close();
    }

    /**
     * Agrega una fila de tarea a la tabla PDF
     */
    private static void agregarFilaTarea(PdfPTable tabla, Tarea t) {
        Font contenidoFont = new Font(Font.FontFamily.HELVETICA, 9);

        // ID
        PdfPCell celdaId = new PdfPCell(new Phrase(String.valueOf(t.getId()), contenidoFont));
        celdaId.setHorizontalAlignment(Element.ALIGN_CENTER);
        celdaId.setPadding(5);
        tabla.addCell(celdaId);

        // Título
        PdfPCell celdaTitulo = new PdfPCell(new Phrase(t.getTitulo(), contenidoFont));
        celdaTitulo.setPadding(5);
        tabla.addCell(celdaTitulo);

        // Prioridad con color
        PdfPCell celdaPrioridad = new PdfPCell(new Phrase(t.getPrioridad(), contenidoFont));
        celdaPrioridad.setBackgroundColor(obtenerColorPrioridad(t.getPrioridad()));
        celdaPrioridad.setHorizontalAlignment(Element.ALIGN_CENTER);
        celdaPrioridad.setPadding(5);
        tabla.addCell(celdaPrioridad);

        // Estado con color
        PdfPCell celdaEstado = new PdfPCell(new Phrase(t.getEstado(), contenidoFont));
        celdaEstado.setBackgroundColor(obtenerColorEstado(t.getEstado()));
        celdaEstado.setHorizontalAlignment(Element.ALIGN_CENTER);
        celdaEstado.setPadding(5);
        tabla.addCell(celdaEstado);

        // Vencimiento
        PdfPCell celdaVencimiento = new PdfPCell(new Phrase(t.getFecha_vencimiento() != null ? t.getFecha_vencimiento().toString() : "N/A", contenidoFont));
        celdaVencimiento.setHorizontalAlignment(Element.ALIGN_CENTER);
        celdaVencimiento.setPadding(5);
        tabla.addCell(celdaVencimiento);
    }

    /**
     * Obtiene el color de fondo para la prioridad
     */
    private static BaseColor obtenerColorPrioridad(String prioridad) {
        if ("Alta".equalsIgnoreCase(prioridad)) {
            return new BaseColor(255, 200, 200); // Rojo claro
        } else if ("Media".equalsIgnoreCase(prioridad)) {
            return new BaseColor(255, 255, 200); // Amarillo claro
        } else {
            return new BaseColor(200, 255, 200); // Verde claro
        }
    }

    /**
     * Obtiene el color de fondo para el estado
     */
    private static BaseColor obtenerColorEstado(String estado) {
        if ("Completada".equalsIgnoreCase(estado)) {
            return new BaseColor(144, 238, 144); // Verde
        } else if ("En Proceso".equalsIgnoreCase(estado)) {
            return new BaseColor(173, 216, 230); // Azul claro
        } else {
            return new BaseColor(255, 228, 196); // Naranja claro
        }
    }

    /**
     * Agrega un resumen de estadísticas al reporte
     */
    private static void agregarResumenEstadisticas(Document document, List<Tarea> tareas) throws DocumentException {
        if (tareas == null || tareas.isEmpty()) {
            return;
        }

        Font tituloEstadisticas = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Paragraph parrafoEstadisticas = new Paragraph("RESUMEN DE ESTADÍSTICAS", tituloEstadisticas);
        document.add(parrafoEstadisticas);

        // Contar estados y prioridades
        int totalTareas = tareas.size();
        int completadas = 0;
        int enProceso = 0;
        int pendientes = 0;
        int altasPrioridad = 0;
        int mediasPrioridad = 0;
        int bajasPrioridad = 0;

        for (Tarea t : tareas) {
            if ("Completada".equalsIgnoreCase(t.getEstado())) completadas++;
            else if ("En Proceso".equalsIgnoreCase(t.getEstado())) enProceso++;
            else pendientes++;

            if ("Alta".equalsIgnoreCase(t.getPrioridad())) altasPrioridad++;
            else if ("Media".equalsIgnoreCase(t.getPrioridad())) mediasPrioridad++;
            else bajasPrioridad++;
        }

        Font contenidoFont = new Font(Font.FontFamily.HELVETICA, 10);
        document.add(new Paragraph("Total de tareas: " + totalTareas, contenidoFont));
        document.add(new Paragraph("   • Completadas: " + completadas, contenidoFont));
        document.add(new Paragraph("   • En Proceso: " + enProceso, contenidoFont));
        document.add(new Paragraph("   • Pendientes: " + pendientes, contenidoFont));
        document.add(new Paragraph("\nPor Prioridad:", new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD)));
        document.add(new Paragraph("   • Alta: " + altasPrioridad, contenidoFont));
        document.add(new Paragraph("   • Media: " + mediasPrioridad, contenidoFont));
        document.add(new Paragraph("   • Baja: " + bajasPrioridad, contenidoFont));
    }
}
