package com.sena.gestion.model;

import java.sql.Date;

public class Usuario {
    private int id;
    private String username;
    private String email;    // Campo esencial para el registro profesional
    private String password;
    private String rol;
    private Date fecha_inicio;
    private Date fecha_vencimiento;

    public Usuario() {}

    // Getters y Setters corregidos
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    // Método de compatibilidad - retorna username como nombre
    public String getNombre() { return username; }
    public void setNombre(String nombre) { this.username = nombre; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; } // Soluciona error en el Servlet

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRol() { return rol; }
    public void setRol(String rol) { this.rol = rol; }

    public Date getFecha_inicio() { return fecha_inicio; }
    public void setFecha_inicio(Date fecha_inicio) { this.fecha_inicio = fecha_inicio; }

    public Date getFecha_vencimiento() { return fecha_vencimiento; }
    public void setFecha_vencimiento(Date fecha_vencimiento) { this.fecha_vencimiento = fecha_vencimiento; }
}