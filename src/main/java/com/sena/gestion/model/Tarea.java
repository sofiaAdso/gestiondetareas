package com.sena.gestion.model;

import java.sql.Date;

public class Tarea {

    private int id;
    private String titulo;
    private String descripcion;
    private int actividadId;
    private int categoriaId;
    private int usuarioId;
    private String prioridad;
    private String estado;
    private Date fechaInicio;
    private Date fechaVencimiento;
    private String nombreCategoria;

    // ============================
    // GETTERS Y SETTERS PRINCIPALES
    // ============================

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public int getActividadId() { return actividadId; }
    public void setActividadId(int actividadId) { this.actividadId = actividadId; }

    public int getCategoriaId() { return categoriaId; }
    public void setCategoriaId(int categoriaId) { this.categoriaId = categoriaId; }

    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }

    public String getPrioridad() { return prioridad; }
    public void setPrioridad(String prioridad) { this.prioridad = prioridad; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public Date getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(Date fechaInicio) { this.fechaInicio = fechaInicio; }

    public Date getFechaVencimiento() { return fechaVencimiento; }
    public void setFechaVencimiento(Date fechaVencimiento) { this.fechaVencimiento = fechaVencimiento; }

    public String getNombreCategoria() { return nombreCategoria; }
    public void setNombreCategoria(String nombreCategoria) { this.nombreCategoria = nombreCategoria; }

    // ── Aliases legacy (para compatibilidad con servlets y JSPs que usan guion bajo) ──
    public String getNombreActividad() { return null; }

    public void setFecha_inicio(Date fechaInicio)       { this.fechaInicio = fechaInicio; }
    public void setFecha_vencimiento(Date fechaVenc)    { this.fechaVencimiento = fechaVenc; }
    public Date getFecha_inicio()                        { return this.fechaInicio; }
    public Date getFecha_vencimiento()                   { return this.fechaVencimiento; }

    public void setActividad_id(int actividadId)        { this.actividadId = actividadId; }
    public void setCategoria_id(int categoriaId)        { this.categoriaId = categoriaId; }
    public void setUsuario_id(int usuarioId)            { this.usuarioId = usuarioId; }
}
