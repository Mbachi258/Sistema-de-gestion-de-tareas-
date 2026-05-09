package com.mycompany.is.controller;

import com.mycompany.is.dao.UsuarioDao;
import com.mycompany.is.model.Usuario;
import com.mycompany.is.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class LoginController extends HttpServlet {

    private final UsuarioDao usuarioDao = new UsuarioDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String email = valor(request.getParameter("email"));
        String password = valor(request.getParameter("password"));

        if (email.isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "Escribe tu email y contrasena.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }

        try {
            Usuario usuario = usuarioDao.buscarPorEmail(email);
            if (usuario == null || !PasswordUtil.matches(password, usuario.getPassword())) {
                request.setAttribute("error", "El email o la contrasena no coinciden.");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            if (!usuario.isActivo()) {
                request.setAttribute("error", "Tu cuenta no esta activa. Pide ayuda al encargado.");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            usuario.setPassword(null);
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } catch (Exception e) {
            request.setAttribute("error", "No pudimos iniciar sesion. Intentalo otra vez.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }

    private String valor(String texto) {
        return texto == null ? "" : texto.trim();
    }
}
