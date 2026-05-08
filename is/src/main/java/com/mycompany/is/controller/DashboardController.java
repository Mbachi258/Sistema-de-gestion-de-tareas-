package com.mycompany.is.controller;

import com.mycompany.is.dao.GrupoDao;
import com.mycompany.is.dao.TareaDao;
import com.mycompany.is.dao.UsuarioDao;
import com.mycompany.is.model.DashboardResumen;
import com.mycompany.is.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class DashboardController extends HttpServlet {

    private final UsuarioDao usuarioDao = new UsuarioDao();
    private final GrupoDao grupoDao = new GrupoDao();
    private final TareaDao tareaDao = new TareaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            DashboardResumen resumen = new DashboardResumen();
            resumen.setTotalUsuarios(usuarioDao.contarActivos());
            resumen.setTareasPendientes(tareaDao.contarPendientes());
            resumen.setGruposActivos(grupoDao.contarActivos());
            resumen.getTareasPorPrioridad().putAll(tareaDao.contarPorPrioridad());

            boolean soloUsuario = !"admin".equalsIgnoreCase(usuario.getRol());
            request.setAttribute("resumen", resumen);
            request.setAttribute("grupos", grupoDao.listarEstadisticas());
            request.setAttribute("tareas", tareaDao.listarRecientes(usuario.getId(), soloUsuario));
            request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "No se pudo cargar el panel. Revisa la base de datos gestion_tareas.");
            request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
        }
    }
}
