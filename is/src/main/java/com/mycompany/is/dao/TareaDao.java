package com.mycompany.is.dao;

import com.mycompany.is.model.Tarea;
import com.mycompany.is.util.DatabaseConnection;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class TareaDao {

    public int contarPendientes() throws SQLException {
        String sql = "SELECT COUNT(*) FROM tareas WHERE estado IN ('pendiente', 'en_progreso')";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public Map<String, Integer> contarPorPrioridad() throws SQLException {
        Map<String, Integer> conteo = new LinkedHashMap<>();
        conteo.put("alta", 0);
        conteo.put("media", 0);
        conteo.put("baja", 0);
        String sql = "SELECT prioridad, COUNT(*) AS total FROM tareas GROUP BY prioridad";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                conteo.put(rs.getString("prioridad"), rs.getInt("total"));
            }
        }
        return conteo;
    }

    public List<Tarea> listarRecientes(Integer usuarioId, boolean soloUsuario) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT t.id, t.titulo, t.descripcion, t.usuario_id, t.grupo_id, t.asignado_por, ");
        sql.append("t.fecha_limite, t.prioridad, t.estado, t.progreso, t.comentarios, ");
        sql.append("t.fecha_creacion, t.fecha_actualizacion, u.nombre AS responsable, g.nombre AS grupo ");
        sql.append("FROM tareas t ");
        sql.append("JOIN usuarios u ON t.usuario_id = u.id ");
        sql.append("JOIN grupos g ON t.grupo_id = g.id ");
        if (soloUsuario) {
            sql.append("WHERE t.usuario_id = ? ");
        }
        sql.append("ORDER BY t.fecha_actualizacion DESC LIMIT 8");

        List<Tarea> tareas = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            if (soloUsuario) {
                stmt.setInt(1, usuarioId);
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    tareas.add(mapearTarea(rs));
                }
            }
        }
        return tareas;
    }

    private Tarea mapearTarea(ResultSet rs) throws SQLException {
        Tarea tarea = new Tarea();
        tarea.setId(rs.getInt("id"));
        tarea.setTitulo(rs.getString("titulo"));
        tarea.setDescripcion(rs.getString("descripcion"));
        tarea.setUsuarioId(rs.getInt("usuario_id"));
        tarea.setGrupoId(rs.getInt("grupo_id"));
        tarea.setAsignadoPor(rs.getInt("asignado_por"));
        Date fechaLimite = rs.getDate("fecha_limite");
        if (fechaLimite != null) {
            tarea.setFechaLimite(fechaLimite.toLocalDate());
        }
        tarea.setPrioridad(rs.getString("prioridad"));
        tarea.setEstado(rs.getString("estado"));
        tarea.setProgreso(rs.getInt("progreso"));
        tarea.setComentarios(rs.getString("comentarios"));
        Timestamp fechaCreacion = rs.getTimestamp("fecha_creacion");
        if (fechaCreacion != null) {
            tarea.setFechaCreacion(fechaCreacion.toLocalDateTime());
        }
        Timestamp fechaActualizacion = rs.getTimestamp("fecha_actualizacion");
        if (fechaActualizacion != null) {
            tarea.setFechaActualizacion(fechaActualizacion.toLocalDateTime());
        }
        tarea.setResponsableNombre(rs.getString("responsable"));
        tarea.setGrupoNombre(rs.getString("grupo"));
        return tarea;
    }
}
