package com.mycompany.is.controller;

import com.mycompany.is.dao.GrupoDao;
import com.mycompany.is.dao.UsuarioDao;
import com.mycompany.is.model.Grupo;
import com.mycompany.is.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class GrupoController extends HttpServlet {

    private final GrupoDao grupoDao = new GrupoDao();
    private final UsuarioDao usuarioDao = new UsuarioDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!"admin".equalsIgnoreCase(usuario.getRol())) {
            request.getSession().setAttribute("flashError", "Solo el administrador puede gestionar grupos.");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        try {
            String accion = valor(request.getParameter("accion"));
            if ("crear".equals(accion)) {
                crearGrupo(request, usuario);
            } else if ("miembro".equals(accion)) {
                asignarMiembro(request);
            }
        } catch (Exception e) {
            request.getSession().setAttribute("flashError", "No pudimos actualizar el grupo. Intentalo nuevamente.");
        }

        response.sendRedirect(request.getContextPath() + "/dashboard");
    }

    private void crearGrupo(HttpServletRequest request, Usuario admin) throws Exception {
        String nombre = valor(request.getParameter("nombre"));
        int liderId = entero(request.getParameter("liderId"));
        if (nombre.isEmpty() || liderId <= 0) {
            request.getSession().setAttribute("flashError", "Indica nombre y lider del grupo.");
            return;
        }

        Grupo grupo = new Grupo();
        grupo.setNombre(nombre);
        grupo.setDescripcion(valor(request.getParameter("descripcion")));
        grupo.setAdminId(admin.getId());
        grupo.setLiderId(liderId);
        int grupoId = grupoDao.crear(grupo);
        grupoDao.asignarMiembro(grupoId, liderId);
        usuarioDao.actualizarRol(liderId, "lider");
        request.getSession().setAttribute("flashExito", "Grupo creado con lider asignado.");
    }

    private void asignarMiembro(HttpServletRequest request) throws Exception {
        int grupoId = entero(request.getParameter("grupoId"));
        int usuarioId = entero(request.getParameter("usuarioId"));
        if (grupoId <= 0 || usuarioId <= 0) {
            request.getSession().setAttribute("flashError", "Selecciona grupo y trabajador.");
            return;
        }
        grupoDao.asignarMiembro(grupoId, usuarioId);
        request.getSession().setAttribute("flashExito", "Trabajador agregado al grupo.");
    }

    private String valor(String texto) {
        return texto == null ? "" : texto.trim();
    }

    private int entero(String texto) {
        try {
            return Integer.parseInt(valor(texto));
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}
