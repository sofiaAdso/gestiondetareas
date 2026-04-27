package com.sena.gestion.model;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Modelo optimizado para Actividad.
 * Compatible con JSP EL y persistencia JDBC.
 */
public class Actividad {
    // Atributos de Persistencia (Base de Datos)
    private int id;
    private int usuarioId; // Cambiado a camelCase para estándar Java
    private String titulo;
    private String descripcion;
    private Date fechaInicio;
    private Date fechaFin;
    private String prioridad;
    private String estado;
    private String color;
    private Timestamp fechaCreacion;

    // Atributos de UI / DTO (Campos calculados)
    private int totalTareas;
    private int tareasCompletadas;
    private double porcentajeCompletado;
    private String nombreUsuario;
    private List<Tarea> tareas = new ArrayList<>();

    public Actividad() {}

    // Constructor para inserción (Sin ID ni timestamps de sistema)
    public Actividad(int usuarioId, String titulo, String descripcion, Date fechaInicio, Date fechaFin, String prioridad, String estado) {
        this.usuarioId = usuarioId;
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.fechaInicio = fechaInicio;
        this.fechaFin = fechaFin;
        this.prioridad = prioridad;
        this.estado = estado;
    }

    // --- Getters y Setters Estándar (Compatibles con JSP EL) ---

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }

    // Alias para compatibilidad con código antiguo que use usuario_id
    public int getUsuario_id() { return usuarioId; }
    public void setUsuario_id(int usuario_id) { this.usuarioId = usuario_id; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public Date getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(Date fechaInicio) { this.fechaInicio = fechaInicio; }

    // Alias para compatibilidad JSP antiguo
    public Date getFecha_inicio() { return fechaInicio; }
    public void setFecha_inicio(Date f) { this.fechaInicio = f; }

    public Date getFechaFin() { return fechaFin; }
    public void setFechaFin(Date fechaFin) { this.fechaFin = fechaFin; }

    // Alias para compatibilidad JSP antiguo
    public Date getFecha_fin() { return fechaFin; }
    public void setFecha_fin(Date f) { this.fechaFin = f; }

    public String getPrioridad() { return prioridad; }
    public void setPrioridad(String prioridad) { this.prioridad = prioridad; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public Timestamp getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(Timestamp fechaCreacion) { this.fechaCreacion = fechaCreacion; }

    // --- Getters/Setters de lógica de negocio ---

    public int getTotalTareas() { return totalTareas; }
    public void setTotalTareas(int totalTareas) {
        this.totalTareas = totalTareas;
        calcularProgreso();
    }

    public int getTareasCompletadas() { return tareasCompletadas; }
    public void setTareasCompletadas(int tareasCompletadas) {
        this.tareasCompletadas = tareasCompletadas;
        calcularProgreso();
    }

    public double getPorcentajeCompletado() { return porcentajeCompletado; }

    private void calcularProgreso() {
        if (this.totalTareas > 0) {
            this.porcentajeCompletado = (double) this.tareasCompletadas * 100 / this.totalTareas;
        } else {
            this.porcentajeCompletado = 0;
        }
    }

    public String getNombreUsuario() { return nombreUsuario; }
    public void setNombreUsuario(String nombreUsuario) { this.nombreUsuario = nombreUsuario; }

    public List<Tarea> getTareas() { return tareas; }
    public void setTareas(List<Tarea> tareas) { this.tareas = tareas; }

    @Override
    public String toString() {
        return "Actividad [id=" + id + ", titulo=" + titulo + ", progreso=" + porcentajeCompletado + "%]";
    }

    public void setPorcentajeCompletado(double porcentajeCompletado) {
        this.porcentajeCompletado = porcentajeCompletado;
    }
}
