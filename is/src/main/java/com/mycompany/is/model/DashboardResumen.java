package com.mycompany.is.model;

import java.util.LinkedHashMap;
import java.util.Map;

public class DashboardResumen {

    private int totalUsuarios;
    private int tareasPendientes;
    private int gruposActivos;
    private final Map<String, Integer> tareasPorPrioridad = new LinkedHashMap<>();

    public int getTotalUsuarios() {
        return totalUsuarios;
    }

    public void setTotalUsuarios(int totalUsuarios) {
        this.totalUsuarios = totalUsuarios;
    }

    public int getTareasPendientes() {
        return tareasPendientes;
    }

    public void setTareasPendientes(int tareasPendientes) {
        this.tareasPendientes = tareasPendientes;
    }

    public int getGruposActivos() {
        return gruposActivos;
    }

    public void setGruposActivos(int gruposActivos) {
        this.gruposActivos = gruposActivos;
    }

    public Map<String, Integer> getTareasPorPrioridad() {
        return tareasPorPrioridad;
    }
}
