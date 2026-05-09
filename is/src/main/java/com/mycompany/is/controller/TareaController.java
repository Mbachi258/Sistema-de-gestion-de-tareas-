package com.mycompany.is.controller;

import com.mycompany.is.dao.TareaDao;
import com.mycompany.is.dao.GrupoDao;
import com.mycompany.is.model.Tarea;
import com.mycompany.is.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;

public class TareaController extends HttpServlet {

    private final TareaDao tareaDao = new TareaDao();
    private final GrupoDao grupoDao = new GrupoDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        boolean ajax = esAjax(request);
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        if (usuario == null) {
            if (ajax) {
                responderJson(response, false, "Vuelve a ingresar para guardar tus cambios.");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String accion = valor(request.getParameter("accion"));
        try {
            if ("asignar".equals(accion)) {
                asignarTarea(request, usuario);
            } else if ("actualizar".equals(accion)) {
                String mensaje = actualizarTarea(request, usuario);
                if (ajax) {
                    responderJson(response, true, mensaje);
                    return;
                }
            } else if (ajax) {
                responderJson(response, false, "No pudimos guardar este cambio.");
                return;
            }
        } catch (Exception e) {
            if (ajax) {
                responderJson(response, false, "No pudimos guardar este cambio. Intentalo otra vez.");
                return;
            }
            request.getSession().setAttribute("flashError", "No pudimos guardar el cambio. Intentalo otra vez.");
        }

        response.sendRedirect(request.getContextPath() + "/dashboard");
    }

    private boolean esAjax(HttpServletRequest request) {
        return "XMLHttpRequest".equals(request.getHeader("X-Requested-With"))
                || "1".equals(request.getParameter("ajax"));
    }

    private void asignarTarea(HttpServletRequest request, Usuario usuario) throws Exception {
        boolean lider = "lider".equalsIgnoreCase(usuario.getRol());
        if (!lider) {
            request.getSession().setAttribute("flashError", "Esta opcion solo esta disponible para lideres.");
            return;
        }

        String titulo = valor(request.getParameter("titulo"));
        int responsableId = entero(request.getParameter("usuarioId"));
        int grupoId = entero(request.getParameter("grupoId"));
        String prioridad = valor(request.getParameter("prioridad"));

        if (titulo.isEmpty() || responsableId <= 0 || grupoId <= 0 || prioridad.isEmpty()) {
            request.getSession().setAttribute("flashError", "Completa los datos de la tarea.");
            return;
        }
        if (!grupoDao.esLiderDeGrupo(usuario.getId(), grupoId)) {
            request.getSession().setAttribute("flashError", "Elige un equipo que tengas asignado.");
            return;
        }
        if (!grupoDao.usuarioPerteneceGrupo(responsableId, grupoId)) {
            request.getSession().setAttribute("flashError", "Esa persona no pertenece al equipo elegido.");
            return;
        }

        Tarea tarea = new Tarea();
        tarea.setTitulo(titulo);
        tarea.setDescripcion(valor(request.getParameter("descripcion")));
        tarea.setUsuarioId(responsableId);
        tarea.setGrupoId(grupoId);
        tarea.setAsignadoPor(usuario.getId());
        tarea.setPrioridad(prioridad);
        String fechaLimite = valor(request.getParameter("fechaLimite"));
        if (!fechaLimite.isEmpty()) {
            tarea.setFechaLimite(LocalDate.parse(fechaLimite));
        }
        tareaDao.crear(tarea);
        request.getSession().setAttribute("flashExito", "Tarea creada correctamente.");
    }

    private String actualizarTarea(HttpServletRequest request, Usuario usuario) throws Exception {
        int tareaId = entero(request.getParameter("tareaId"));
        int progreso = Math.max(0, Math.min(100, entero(request.getParameter("progreso"))));
        boolean trabajador = "usuario".equalsIgnoreCase(usuario.getRol());

        if (tareaId <= 0 || !trabajador) {
            request.getSession().setAttribute("flashError", "No encontramos esa tarea.");
            throw new IllegalArgumentException("Tarea no disponible");
        }

        boolean actualizado = tareaDao.actualizarProgreso(
                tareaId,
                usuario.getId(),
                false,
                progreso,
                valor(request.getParameter("comentario"))
        );

        if (actualizado) {
            request.getSession().setAttribute("flashExito", "Avance guardado.");
            return "Avance guardado.";
        } else {
            request.getSession().setAttribute("flashError", "No encontramos esa tarea.");
            throw new IllegalArgumentException("Tarea no disponible");
        }
    }

    private void responderJson(HttpServletResponse response, boolean ok, String mensaje) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"ok\":" + ok + ",\"mensaje\":\"" + escaparJson(mensaje) + "\"}");
    }

    private String escaparJson(String texto) {
        return texto == null ? "" : texto.replace("\\", "\\\\").replace("\"", "\\\"");
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
