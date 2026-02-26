package com.sena.gestion.model;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * Modelo Tarea actualizado para soportar relación con Actividades
 */
public class Tarea {
    // Atributos base (Coinciden con las columnas de la BD)
    private int id;
    private String titulo;
    private String descripcion;
    private String prioridad;
    private String estado;
    private Date fecha_inicio;
    private Date fecha_vencimiento;
    private int actividad_id; // LLAVE FORÁNEA: Conecta con la tabla actividades
    private int usuario_id;
    private int categoria_id;
    private boolean completada;
    private String notas;
    private Timestamp fecha_creacion;

    // Atributos de apoyo (Para mostrar nombres en lugar de IDs en la tabla)
    private String nombreActividad;
    private String nombreUsuario;
    private String nombreCategoria;

    // Constructor vacío (Obligatorio para frameworks y DAOs)
    public Tarea() {}

    // --- GETTERS Y SETTERS ESTÁNDAR ---

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public String getPrioridad() { return prioridad; }
    public void setPrioridad(String prioridad) { this.prioridad = prioridad; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public Date getFecha_inicio() { return fecha_inicio; }
    public void setFecha_inicio(Date fecha_inicio) { this.fecha_inicio = fecha_inicio; }

    public Date getFecha_vencimiento() { return fecha_vencimiento; }
    public void setFecha_vencimiento(Date fecha_vencimiento) { this.fecha_vencimiento = fecha_vencimiento; }

    public int getActividad_id() { return actividad_id; }
    public void setActividad_id(int actividad_id) { this.actividad_id = actividad_id; }

    public int getUsuario_id() { return usuario_id; }
    public void setUsuario_id(int usuario_id) { this.usuario_id = usuario_id; }

    public int getCategoria_id() { return categoria_id; }
    public void setCategoria_id(int categoria_id) { this.categoria_id = categoria_id; }

    public boolean isCompletada() { return completada; }
    public void setCompletada(boolean completada) { this.completada = completada; }

    public String getNotas() { return notas; }
    public void setNotas(String notas) { this.notas = notas; }

    public Timestamp getFecha_creacion() { return fecha_creacion; }
    public void setFecha_creacion(Timestamp fecha_creacion) { this.fecha_creacion = fecha_creacion; }

    // --- GETTERS Y SETTERS PARA NOMBRES (JOINs) ---

    public String getNombreActividad() { return nombreActividad; }
    public void setNombreActividad(String nombreActividad) { this.nombreActividad = nombreActividad; }

    public String getNombreUsuario() { return nombreUsuario; }
    public void setNombreUsuario(String nombreUsuario) { this.nombreUsuario = nombreUsuario; }

    public String getNombreCategoria() { return nombreCategoria; }
    public void setNombreCategoria(String nombreCategoria) { this.nombreCategoria = nombreCategoria; }

    // --- MÉTODOS EN camelCase (Para compatibilidad con etiquetas <c:out value="${tarea.actividadId}"/> en JSP) ---

    public int getActividadId() { return actividad_id; }
    public void setActividadId(int actividadId) { this.actividad_id = actividadId; }

    public int getUsuarioId() { return usuario_id; }
    public void setUsuarioId(int usuarioId) { this.usuario_id = usuarioId; }

    public int getCategoriaId() { return categoria_id; }
    public void setCategoriaId(int categoriaId) { this.categoria_id = categoriaId; }

    public Date getFechaInicio() { return fecha_inicio; }
    public void setFechaInicio(Date fechaInicio) { this.fecha_inicio = fechaInicio; }

    public Date getFechaVencimiento() { return fecha_vencimiento; }
    public void setFechaVencimiento(Date fechaVencimiento) { this.fecha_vencimiento = fechaVencimiento; }
}