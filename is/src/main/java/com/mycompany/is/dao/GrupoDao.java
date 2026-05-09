package com.mycompany.is.dao;

import com.mycompany.is.model.Grupo;
import com.mycompany.is.model.GrupoEstadistica;
import com.mycompany.is.util.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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

    public List<Grupo> listarActivos() throws SQLException {
        String sql = "SELECT g.id, g.nombre, g.descripcion, g.admin_id, g.lider_id, "
                + "g.fecha_creacion, g.activo, u.nombre AS lider_nombre "
                + "FROM grupos g "
                + "LEFT JOIN usuarios u ON g.lider_id = u.id "
                + "WHERE g.activo = TRUE ORDER BY g.nombre";
        List<Grupo> grupos = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                grupos.add(mapearGrupo(rs));
            }
        }
        return grupos;
    }

    public List<Grupo> listarPorLider(int liderId) throws SQLException {
        String sql = "SELECT g.id, g.nombre, g.descripcion, g.admin_id, g.lider_id, "
                + "g.fecha_creacion, g.activo, u.nombre AS lider_nombre "
                + "FROM grupos g "
                + "LEFT JOIN usuarios u ON g.lider_id = u.id "
                + "WHERE g.activo = TRUE AND g.lider_id = ? ORDER BY g.nombre";
        List<Grupo> grupos = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, liderId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    grupos.add(mapearGrupo(rs));
                }
            }
        }
        return grupos;
    }

    public List<Grupo> listarPorUsuario(int usuarioId) throws SQLException {
        String sql = "SELECT g.id, g.nombre, g.descripcion, g.admin_id, g.lider_id, "
                + "g.fecha_creacion, g.activo, u.nombre AS lider_nombre "
                + "FROM grupos g "
                + "JOIN grupo_usuarios gu ON g.id = gu.grupo_id AND gu.activo = TRUE "
                + "LEFT JOIN usuarios u ON g.lider_id = u.id "
                + "WHERE g.activo = TRUE AND gu.usuario_id = ? ORDER BY g.nombre";
        List<Grupo> grupos = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, usuarioId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    grupos.add(mapearGrupo(rs));
                }
            }
        }
        return grupos;
    }

    public int crear(Grupo grupo) throws SQLException {
        String sql = "INSERT INTO grupos (nombre, descripcion, admin_id, lider_id, activo) "
                + "VALUES (?, ?, ?, ?, TRUE)";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, grupo.getNombre());
            stmt.setString(2, grupo.getDescripcion());
            stmt.setInt(3, grupo.getAdminId());
            stmt.setInt(4, grupo.getLiderId());
            stmt.executeUpdate();
            try (ResultSet keys = stmt.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        return 0;
    }

    public void asignarMiembro(int grupoId, int usuarioId) throws SQLException {
        String sql = "INSERT INTO grupo_usuarios (grupo_id, usuario_id, activo) "
                + "VALUES (?, ?, TRUE) "
                + "ON DUPLICATE KEY UPDATE activo = TRUE";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, grupoId);
            stmt.setInt(2, usuarioId);
            stmt.executeUpdate();
        }
    }

    public boolean esLiderDeGrupo(int liderId, int grupoId) throws SQLException {
        String sql = "SELECT 1 FROM grupos WHERE id = ? AND lider_id = ? AND activo = TRUE";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, grupoId);
            stmt.setInt(2, liderId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean usuarioPerteneceGrupo(int usuarioId, int grupoId) throws SQLException {
        String sql = "SELECT 1 FROM grupo_usuarios WHERE usuario_id = ? AND grupo_id = ? AND activo = TRUE";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, usuarioId);
            stmt.setInt(2, grupoId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<GrupoEstadistica> listarEstadisticas() throws SQLException {
        return listarEstadisticas(null, false);
    }

    public List<GrupoEstadistica> listarEstadisticas(Integer liderId, boolean soloLider) throws SQLException {
        String sql = "SELECT g.nombre, u.nombre AS lider_nombre, "
                + "COUNT(DISTINCT CASE WHEN gu.usuario_id <> g.lider_id THEN gu.usuario_id END) AS total_miembros, "
                + "COUNT(DISTINCT t.id) AS total_tareas, "
                + "COUNT(DISTINCT CASE WHEN t.estado = 'completada' THEN t.id END) AS tareas_completadas, "
                + "COALESCE(ROUND(AVG(t.progreso), 1), 0) AS progreso_promedio "
                + "FROM grupos g "
                + "LEFT JOIN grupo_usuarios gu ON g.id = gu.grupo_id AND gu.activo = TRUE "
                + "LEFT JOIN tareas t ON g.id = t.grupo_id "
                + "LEFT JOIN usuarios u ON g.lider_id = u.id "
                + "WHERE g.activo = TRUE ";
        if (soloLider) {
            sql += "AND g.lider_id = ? ";
        }
        sql += ""
                + "GROUP BY g.id, g.nombre, u.nombre "
                + "ORDER BY g.nombre";
        List<GrupoEstadistica> grupos = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (soloLider) {
                stmt.setInt(1, liderId);
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    GrupoEstadistica grupo = new GrupoEstadistica();
                    grupo.setNombre(rs.getString("nombre"));
                    grupo.setLiderNombre(rs.getString("lider_nombre"));
                    grupo.setTotalMiembros(rs.getInt("total_miembros"));
                    grupo.setTotalTareas(rs.getInt("total_tareas"));
                    grupo.setTareasCompletadas(rs.getInt("tareas_completadas"));
                    grupo.setProgresoPromedio(rs.getDouble("progreso_promedio"));
                    grupos.add(grupo);
                }
            }
        }
        return grupos;
    }

    public List<GrupoEstadistica> listarEstadisticasPorUsuario(int usuarioId) throws SQLException {
        String sql = "SELECT g.nombre, u.nombre AS lider_nombre, "
                + "COUNT(DISTINCT CASE WHEN gu.usuario_id <> g.lider_id THEN gu.usuario_id END) AS total_miembros, "
                + "COUNT(DISTINCT t.id) AS total_tareas, "
                + "COUNT(DISTINCT CASE WHEN t.estado = 'completada' THEN t.id END) AS tareas_completadas, "
                + "COALESCE(ROUND(AVG(t.progreso), 1), 0) AS progreso_promedio "
                + "FROM grupos g "
                + "JOIN grupo_usuarios scope ON g.id = scope.grupo_id AND scope.activo = TRUE "
                + "LEFT JOIN grupo_usuarios gu ON g.id = gu.grupo_id AND gu.activo = TRUE "
                + "LEFT JOIN tareas t ON g.id = t.grupo_id "
                + "LEFT JOIN usuarios u ON g.lider_id = u.id "
                + "WHERE g.activo = TRUE AND scope.usuario_id = ? "
                + "GROUP BY g.id, g.nombre, u.nombre "
                + "ORDER BY g.nombre";
        List<GrupoEstadistica> grupos = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, usuarioId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    GrupoEstadistica grupo = new GrupoEstadistica();
                    grupo.setNombre(rs.getString("nombre"));
                    grupo.setLiderNombre(rs.getString("lider_nombre"));
                    grupo.setTotalMiembros(rs.getInt("total_miembros"));
                    grupo.setTotalTareas(rs.getInt("total_tareas"));
                    grupo.setTareasCompletadas(rs.getInt("tareas_completadas"));
                    grupo.setProgresoPromedio(rs.getDouble("progreso_promedio"));
                    grupos.add(grupo);
                }
            }
        }
        return grupos;
    }

    private Grupo mapearGrupo(ResultSet rs) throws SQLException {
        Grupo grupo = new Grupo();
        grupo.setId(rs.getInt("id"));
        grupo.setNombre(rs.getString("nombre"));
        grupo.setDescripcion(rs.getString("descripcion"));
        grupo.setAdminId(rs.getInt("admin_id"));
        grupo.setLiderId(rs.getInt("lider_id"));
        grupo.setLiderNombre(rs.getString("lider_nombre"));
        grupo.setActivo(rs.getBoolean("activo"));
        if (rs.getTimestamp("fecha_creacion") != null) {
            grupo.setFechaCreacion(rs.getTimestamp("fecha_creacion").toLocalDateTime());
        }
        return grupo;
    }
}
