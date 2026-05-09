package com.mycompany.is.model;

public class CompaneroProgreso {

    private int usuarioId;
    private String nombre;
    private String rol;
    private int totalTareas;
    private int tareasCompletadas;
    private double progresoPromedio;

    public int getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(int usuarioId) {
        this.usuarioId = usuarioId;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
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

    public double getProgresoPromedio() {
        return progresoPromedio;
    }

    public void setProgresoPromedio(double progresoPromedio) {
        this.progresoPromedio = progresoPromedio;
    }
}
