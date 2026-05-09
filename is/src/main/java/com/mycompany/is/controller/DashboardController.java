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
            boolean admin = "admin".equalsIgnoreCase(usuario.getRol());
            boolean lider = "lider".equalsIgnoreCase(usuario.getRol());
            boolean trabajador = "usuario".equalsIgnoreCase(usuario.getRol());
            DashboardResumen resumen = new DashboardResumen();
            resumen.setTotalUsuarios(usuarioDao.contarActivos());
            if (lider) {
                resumen.setTareasPendientes(tareaDao.contarPendientesPorLider(usuario.getId()));
                resumen.getTareasPorPrioridad().putAll(tareaDao.contarPorPrioridadLider(usuario.getId()));
            } else {
                resumen.setTareasPendientes(tareaDao.contarPendientes(usuario.getId(), trabajador));
                resumen.getTareasPorPrioridad().putAll(tareaDao.contarPorPrioridad(usuario.getId(), trabajador));
            }
            resumen.setGruposActivos(grupoDao.contarActivos());

            request.setAttribute("esAdmin", admin);
            request.setAttribute("esLider", lider);
            request.setAttribute("esTrabajador", trabajador);
            request.setAttribute("resumen", resumen);
            if (trabajador) {
                request.setAttribute("grupos", grupoDao.listarEstadisticasPorUsuario(usuario.getId()));
                request.setAttribute("companeros", tareaDao.listarCompanerosPorUsuario(usuario.getId()));
            } else {
                request.setAttribute("grupos", grupoDao.listarEstadisticas(usuario.getId(), lider));
            }
            request.setAttribute("usuariosDisponibles", admin ? usuarioDao.listarActivos() : usuarioDao.listarMiembrosDeLider(usuario.getId()));
            request.setAttribute("lideresDisponibles", usuarioDao.listarLideres());
            if (admin) {
                request.setAttribute("gruposDisponibles", grupoDao.listarActivos());
            } else if (lider) {
                request.setAttribute("gruposDisponibles", grupoDao.listarPorLider(usuario.getId()));
            } else {
                request.setAttribute("gruposDisponibles", grupoDao.listarPorUsuario(usuario.getId()));
            }
            if (lider) {
                request.setAttribute("tareas", tareaDao.listarPorLider(usuario.getId()));
            } else {
                request.setAttribute("tareas", tareaDao.listarRecientes(usuario.getId(), trabajador));
            }
            moverFlash(request);
            request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "No pudimos cargar el panel en este momento. Intentalo nuevamente.");
            request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
        }
    }

    private void moverFlash(HttpServletRequest request) {
        Object error = request.getSession().getAttribute("flashError");
        Object exito = request.getSession().getAttribute("flashExito");
        if (error != null) {
            request.setAttribute("error", error);
            request.getSession().removeAttribute("flashError");
        }
        if (exito != null) {
            request.setAttribute("exito", exito);
            request.getSession().removeAttribute("flashExito");
        }
    }
}
