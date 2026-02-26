package com.sena.gestion.model;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Clase modelo para representar una Actividad del sistema
 * Una actividad puede contener múltiples tareas
 */
public class Actividad {
    private int id;
    private int usuario_id;
    private String titulo;
    private String descripcion;
    private Date fecha_inicio;
    private Date fecha_fin;
    private String prioridad;
    private String estado;
    private String color;
    private Timestamp fecha_creacion;

    // Campos calculados (no están en la BD)
    private int totalTareas;
    private int tareasCompletadas;
    private double porcentajeCompletado;
    private String nombreUsuario;
    private List<Tarea> tareas = new ArrayList<>();

    // Constructor vacío
    public Actividad() {
    }

    // Constructor completo
    public Actividad(int id, int usuario_id, String titulo, String descripcion,
                     Date fecha_inicio, Date fecha_fin, String prioridad,
                     String estado, String color, Timestamp fecha_creacion) {
        this.id = id;
        this.usuario_id = usuario_id;
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.fecha_inicio = fecha_inicio;
        this.fecha_fin = fecha_fin;
        this.prioridad = prioridad;
        this.estado = estado;
        this.color = color;
        this.fecha_creacion = fecha_creacion;
    }

    // Constructor sin ID (para crear nuevas actividades)
    public Actividad(int usuario_id, String titulo, String descripcion,
                     Date fecha_inicio, Date fecha_fin, String prioridad,
                     String estado, String color) {
        this.usuario_id = usuario_id;
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.fecha_inicio = fecha_inicio;
        this.fecha_fin = fecha_fin;
        this.prioridad = prioridad;
        this.estado = estado;
        this.color = color;
    }

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUsuario_id() {
        return usuario_id;
    }

    public void setUsuario_id(int usuario_id) {
        this.usuario_id = usuario_id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public Date getFecha_inicio() {
        return fecha_inicio;
    }

    public void setFecha_inicio(Date fecha_inicio) {
        this.fecha_inicio = fecha_inicio;
    }

    public Date getFecha_fin() {
        return fecha_fin;
    }

    public void setFecha_fin(Date fecha_fin) {
        this.fecha_fin = fecha_fin;
    }

    public String getPrioridad() {
        return prioridad;
    }

    public void setPrioridad(String prioridad) {
        this.prioridad = prioridad;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public Timestamp getFecha_creacion() {
        return fecha_creacion;
    }

    public void setFecha_creacion(Timestamp fecha_creacion) {
        this.fecha_creacion = fecha_creacion;
    }

    public int getTotalTareas() {
        return totalTareas;
    }

    public void setTotalTareas(int totalTareas) {
        this.totalTareas = totalTareas;
    }

    public int getTareasCompletadas() {
        return tareasCompletadas;
    }

    public void setTareasCompletadas(int tareasCompletadas) {
        this.tareasCompletadas = tareasCompletadas;
    }

    public double getPorcentajeCompletado() {
        return porcentajeCompletado;
    }

    public void setPorcentajeCompletado(double porcentajeCompletado) {
        this.porcentajeCompletado = porcentajeCompletado;
    }

    public String getNombreUsuario() {
        return nombreUsuario;
    }

    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }

    public List<Tarea> getTareas() {
        return tareas;
    }

    public void setTareas(List<Tarea> tareas) {
        this.tareas = tareas;
    }

    @Override
    public String toString() {
        return "Actividad{" +
                "id=" + id +
                ", titulo='" + titulo + '\'' +
                ", prioridad='" + prioridad + '\'' +
                ", estado='" + estado + '\'' +
                ", totalTareas=" + totalTareas +
                ", tareasCompletadas=" + tareasCompletadas +
                ", porcentajeCompletado=" + porcentajeCompletado +
                '}';
    }
}

