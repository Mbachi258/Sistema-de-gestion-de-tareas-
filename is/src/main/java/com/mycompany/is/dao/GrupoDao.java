package com.mycompany.is.dao;

import com.mycompany.is.model.GrupoEstadistica;
import com.mycompany.is.util.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class GrupoDao {

    public int contarActivos() throws SQLException {
        String sql = "SELECT COUNT(*) FROM grupos WHERE activo = TRUE";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public List<GrupoEstadistica> listarEstadisticas() throws SQLException {
        String sql = "SELECT g.nombre, "
                + "COUNT(DISTINCT gu.usuario_id) AS total_miembros, "
                + "COUNT(t.id) AS total_tareas, "
                + "SUM(CASE WHEN t.estado = 'completada' THEN 1 ELSE 0 END) AS tareas_completadas, "
                + "COALESCE(ROUND(AVG(t.progreso), 1), 0) AS progreso_promedio "
                + "FROM grupos g "
                + "LEFT JOIN grupo_usuarios gu ON g.id = gu.grupo_id AND gu.activo = TRUE "
                + "LEFT JOIN tareas t ON g.id = t.grupo_id "
                + "WHERE g.activo = TRUE "
                + "GROUP BY g.id, g.nombre "
                + "ORDER BY g.nombre";
        List<GrupoEstadistica> grupos = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                GrupoEstadistica grupo = new GrupoEstadistica();
                grupo.setNombre(rs.getString("nombre"));
                grupo.setTotalMiembros(rs.getInt("total_miembros"));
                grupo.setTotalTareas(rs.getInt("total_tareas"));
                grupo.setTareasCompletadas(rs.getInt("tareas_completadas"));
                grupo.setProgresoPromedio(rs.getDouble("progreso_promedio"));
                grupos.add(grupo);
            }
        }
        return grupos;
    }
}
