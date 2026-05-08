package com.mycompany.is.model;

public class GrupoEstadistica {

    private String nombre;
    private int totalMiembros;
    private int totalTareas;
    private int tareasCompletadas;
    private double progresoPromedio;

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getTotalMiembros() {
        return totalMiembros;
    }

    public void setTotalMiembros(int totalMiembros) {
        this.totalMiembros = totalMiembros;
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
