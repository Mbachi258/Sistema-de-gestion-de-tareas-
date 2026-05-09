package com.mycompany.is.dao;

import com.mycompany.is.model.Usuario;
import com.mycompany.is.util.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDao {

    public Usuario buscarPorEmail(String email) throws SQLException {
        String sql = "SELECT id, nombre, email, password, rol, fecha_registro, activo "
                + "FROM usuarios WHERE email = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapearUsuario(rs);
                }
            }
        }
        return null;
    }

    public boolean existeEmail(String email) throws SQLException {
        String sql = "SELECT 1 FROM usuarios WHERE email = ? LIMIT 1";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public int crear(Usuario usuario) throws SQLException {
        String sql = "INSERT INTO usuarios (nombre, email, password, rol, activo) VALUES (?, ?, ?, ?, TRUE)";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, usuario.getNombre());
            stmt.setString(2, usuario.getEmail());
            stmt.setString(3, usuario.getPassword());
            stmt.setString(4, usuario.getRol());
            stmt.executeUpdate();
            try (ResultSet keys = stmt.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        return 0;
    }

    public int contarActivos() throws SQLException {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE activo = TRUE";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public List<Usuario> listarActivos() throws SQLException {
        String sql = "SELECT id, nombre, email, password, rol, fecha_registro, activo "
                + "FROM usuarios WHERE activo = TRUE ORDER BY nombre";
        return listarPorSql(sql);
    }

    public List<Usuario> listarLideres() throws SQLException {
        String sql = "SELECT id, nombre, email, password, rol, fecha_registro, activo "
                + "FROM usuarios WHERE activo = TRUE AND rol IN ('lider', 'usuario') ORDER BY nombre";
        return listarPorSql(sql);
    }

    public List<Usuario> listarMiembrosDeLider(int liderId) throws SQLException {
        String sql = "SELECT DISTINCT u.id, u.nombre, u.email, u.password, u.rol, u.fecha_registro, u.activo "
                + "FROM usuarios u "
                + "JOIN grupo_usuarios gu ON u.id = gu.usuario_id AND gu.activo = TRUE "
                + "JOIN grupos g ON gu.grupo_id = g.id "
                + "WHERE u.activo = TRUE AND g.lider_id = ? "
                + "ORDER BY u.nombre";
        List<Usuario> usuarios = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, liderId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Usuario usuario = mapearUsuario(rs);
                    usuario.setPassword(null);
                    usuarios.add(usuario);
                }
            }
        }
        return usuarios;
    }

    public void actualizarRol(int usuarioId, String rol) throws SQLException {
        String sql = "UPDATE usuarios SET rol = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, rol);
            stmt.setInt(2, usuarioId);
            stmt.executeUpdate();
        }
    }

    private List<Usuario> listarPorSql(String sql) throws SQLException {
        List<Usuario> usuarios = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Usuario usuario = mapearUsuario(rs);
                usuario.setPassword(null);
                usuarios.add(usuario);
            }
        }
        return usuarios;
    }

    private Usuario mapearUsuario(ResultSet rs) throws SQLException {
        Usuario usuario = new Usuario();
        usuario.setId(rs.getInt("id"));
        usuario.setNombre(rs.getString("nombre"));
        usuario.setEmail(rs.getString("email"));
        usuario.setPassword(rs.getString("password"));
        usuario.setRol(rs.getString("rol"));
        usuario.setActivo(rs.getBoolean("activo"));
        Timestamp fechaRegistro = rs.getTimestamp("fecha_registro");
        if (fechaRegistro != null) {
            usuario.setFechaRegistro(fechaRegistro.toLocalDateTime());
        }
        return usuario;
    }
}
