package com.sena.gestion.model;

import java.sql.Date;

public class Novedad {

    private int id;
    private String regional;
    private String centroFormacion;
    private String programaFormacion;
    private String codigoPrograma;
    private String ambiente;
    private String localizacion;
    private String denominacion;
    private String tipoAmbiente;      // "Interno" | "Externo"
    private String tipoNovedad;       // "Ambiente" | "Equipos" | "Materiales" | "Biblioteca"
    private String detalleNovedad;
    private String viabilidad;        // "Apto" | "No Apto"
    private String nombreInstructor;
    private String nombreCoordinador;
    private Date   fechaReporte;
    private int    usuarioId;

    // ── Getters & Setters ──

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getRegional() { return regional; }
    public void setRegional(String regional) { this.regional = regional; }

    public String getCentroFormacion() { return centroFormacion; }
    public void setCentroFormacion(String centroFormacion) { this.centroFormacion = centroFormacion; }

    public String getProgramaFormacion() { return programaFormacion; }
    public void setProgramaFormacion(String programaFormacion) { this.programaFormacion = programaFormacion; }

    public String getCodigoPrograma() { return codigoPrograma; }
    public void setCodigoPrograma(String codigoPrograma) { this.codigoPrograma = codigoPrograma; }

    public String getAmbiente() { return ambiente; }
    public void setAmbiente(String ambiente) { this.ambiente = ambiente; }

    public String getLocalizacion() { return localizacion; }
    public void setLocalizacion(String localizacion) { this.localizacion = localizacion; }

    public String getDenominacion() { return denominacion; }
    public void setDenominacion(String denominacion) { this.denominacion = denominacion; }

    public String getTipoAmbiente() { return tipoAmbiente; }
    public void setTipoAmbiente(String tipoAmbiente) { this.tipoAmbiente = tipoAmbiente; }

    public String getTipoNovedad() { return tipoNovedad; }
    public void setTipoNovedad(String tipoNovedad) { this.tipoNovedad = tipoNovedad; }

    public String getDetalleNovedad() { return detalleNovedad; }
    public void setDetalleNovedad(String detalleNovedad) { this.detalleNovedad = detalleNovedad; }

    public String getViabilidad() { return viabilidad; }
    public void setViabilidad(String viabilidad) { this.viabilidad = viabilidad; }

    public String getNombreInstructor() { return nombreInstructor; }
    public void setNombreInstructor(String nombreInstructor) { this.nombreInstructor = nombreInstructor; }

    public String getNombreCoordinador() { return nombreCoordinador; }
    public void setNombreCoordinador(String nombreCoordinador) { this.nombreCoordinador = nombreCoordinador; }

    public Date getFechaReporte() { return fechaReporte; }
    public void setFechaReporte(Date fechaReporte) { this.fechaReporte = fechaReporte; }

    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }
}