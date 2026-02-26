package com.sena.gestion.model;

import java.sql.Timestamp;

/**
 * Clase modelo para representar una Subtarea del sistema
 * Cada subtarea está asociada a una tarea principal
 */
public class Subtarea {
    private int id;
    private int tarea_id;
    private String titulo;
    private String descripcion;
    private boolean completada;
    private Timestamp fecha_creacion;

    // Constructor vacío
    public Subtarea() {
    }

    // Constructor completo
    public Subtarea(int id, int tarea_id, String titulo, String descripcion, boolean completada, Timestamp fecha_creacion) {
        this.id = id;
        this.tarea_id = tarea_id;
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.completada = completada;
        this.fecha_creacion = fecha_creacion;
    }

    // Constructor sin ID (para crear nuevas subtareas)
    public Subtarea(int tarea_id, String titulo, String descripcion, boolean completada) {
        this.tarea_id = tarea_id;
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.completada = completada;
    }

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTarea_id() {
        return tarea_id;
    }

    public void setTarea_id(int tarea_id) {
        this.tarea_id = tarea_id;
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

    public boolean isCompletada() {
        return completada;
    }

    public void setCompletada(boolean completada) {
        this.completada = completada;
    }

    public Timestamp getFecha_creacion() {
        return fecha_creacion;
    }

    public void setFecha_creacion(Timestamp fecha_creacion) {
        this.fecha_creacion = fecha_creacion;
    }

    @Override
    public String toString() {
        return "Subtarea{" +
                "id=" + id +
                ", tarea_id=" + tarea_id +
                ", titulo='" + titulo + '\'' +
                ", completada=" + completada +
                ", fecha_creacion=" + fecha_creacion +
                '}';
    }
}

