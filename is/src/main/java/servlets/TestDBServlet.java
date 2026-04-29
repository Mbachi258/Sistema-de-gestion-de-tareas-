package servlets   ;

import com.mycompany.is.util.DatabaseConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/testdb")
public class TestDBServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();
        try (Connection conn = DatabaseConnection.getConnection()) {
            out.println("<h2>✅ Conexión exitosa a MySQL</h2>");
            out.println("<p>Base de datos: " + conn.getCatalog() + "</p>");
        } catch (Exception e) {
            out.println("<h2>❌ Error de conexión</h2>");
            out.println("<pre>" + e.getMessage() + "</pre>");
            e.printStackTrace(out);
        }
    }
}