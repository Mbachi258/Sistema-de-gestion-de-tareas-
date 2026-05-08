package com.mycompany.is.controller;

import com.mycompany.is.dao.UsuarioDao;
import com.mycompany.is.model.Usuario;
import com.mycompany.is.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class RegistroController extends HttpServlet {

    private final UsuarioDao usuarioDao = new UsuarioDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String nombre = valor(request.getParameter("nombre"));
        String email = valor(request.getParameter("email"));
        String password = valor(request.getParameter("password"));
        String confirmarPassword = valor(request.getParameter("confirmarPassword"));

        if (nombre.isEmpty() || email.isEmpty() || password.isEmpty() || confirmarPassword.isEmpty()) {
            request.setAttribute("error", "Completa todos los campos para crear tu cuenta.");
            request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmarPassword)) {
            request.setAttribute("error", "Las contrasenas no coinciden.");
            request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("error", "La contrasena debe tener al menos 6 caracteres.");
            request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
            return;
        }

        try {
            if (usuarioDao.existeEmail(email)) {
                request.setAttribute("error", "Ya existe una cuenta registrada con ese email.");
                request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
                return;
            }

            Usuario usuario = new Usuario(nombre, email, PasswordUtil.hash(password), "usuario");
            usuarioDao.crear(usuario);
            request.setAttribute("exito", "Cuenta creada correctamente. Ya puedes iniciar sesion.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "No pudimos completar el registro en este momento. Intentalo nuevamente.");
            request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request, response);
        }
    }

    private String valor(String texto) {
        return texto == null ? "" : texto.trim();
    }
}
