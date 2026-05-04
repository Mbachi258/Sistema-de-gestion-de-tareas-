package servlets;

import com.mycompany.is.util.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class login extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtener los parámetros del formulario
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // 2. Validar que no estén vacíos
        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect("login.jsp?error=empty");
            return;
        }
        
        // 3. Buscar el usuario en la base de datos
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "SELECT id, nombre, email, password, rol, activo FROM usuarios WHERE email = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                // Usuario existe: verificar contraseña
                String dbPassword = rs.getString("password");
                
                // Comparar (si tienes hash, usa bcrypt; por ahora texto plano)
                if (dbPassword.equals(password)) {
                    // Verificar si está activo
                    boolean activo = rs.getBoolean("activo");
                    if (!activo) {
                        response.sendRedirect("login.jsp?error=inactive");
                        return;
                    }
                    
                    // Login exitoso: crear sesión
                    HttpSession session = request.getSession();
                    session.setAttribute("usuario_id", rs.getInt("id"));
                    session.setAttribute("usuario_nombre", rs.getString("nombre"));
                    session.setAttribute("usuario_email", rs.getString("email"));
                    session.setAttribute("usuario_rol", rs.getString("rol"));
                    
                    // Redirigir según el rol
                    String rol = rs.getString("rol");
                    if ("admin".equals(rol)) {
                        response.sendRedirect("admin.dashboard.jsp");
                    } else {
                        response.sendRedirect("dashboard.jsp");
                    }
                } else {
                    // Contraseña incorrecta
                    response.sendRedirect("login.jsp?error=password");
                }
            } else {
                // Usuario no existe
                response.sendRedirect("login.jsp?error=notfound");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=system");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Si alguien intenta acceder por GET, redirigir al login
        response.sendRedirect("login.jsp");
    }
}