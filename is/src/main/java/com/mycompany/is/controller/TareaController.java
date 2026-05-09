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
        boolean ajax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        if (usuario == null) {
            if (ajax) {
                responderJson(response, false, "Sesion expirada. Vuelve a ingresar.");
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
            }
        } catch (Exception e) {
            if (ajax) {
                responderJson(response, false, "No pudimos procesar la accion. Intentalo nuevamente.");
                return;
            }
            request.getSession().setAttribute("flashError", "No pudimos procesar la accion. Intentalo nuevamente.");
        }

        response.sendRedirect(request.getContextPath() + "/dashboard");
    }

    private void asignarTarea(HttpServletRequest request, Usuario usuario) throws Exception {
        boolean lider = "lider".equalsIgnoreCase(usuario.getRol());
        if (!lider) {
            request.getSession().setAttribute("flashError", "Solo los lideres pueden delegar tareas.");
            return;
        }

        String titulo = valor(request.getParameter("titulo"));
        int responsableId = entero(request.getParameter("usuarioId"));
        int grupoId = entero(request.getParameter("grupoId"));
        String prioridad = valor(request.getParameter("prioridad"));

        if (titulo.isEmpty() || responsableId <= 0 || grupoId <= 0 || prioridad.isEmpty()) {
            request.getSession().setAttribute("flashError", "Completa los datos principales de la tarea.");
            return;
        }
        if (!grupoDao.esLiderDeGrupo(usuario.getId(), grupoId)) {
            request.getSession().setAttribute("flashError", "No puedes asignar tareas fuera de tu grupo.");
            return;
        }
        if (!grupoDao.usuarioPerteneceGrupo(responsableId, grupoId)) {
            request.getSession().setAttribute("flashError", "El responsable debe pertenecer al grupo seleccionado.");
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
        request.getSession().setAttribute("flashExito", "Tarea asignada correctamente.");
    }

    private String actualizarTarea(HttpServletRequest request, Usuario usuario) throws Exception {
        int tareaId = entero(request.getParameter("tareaId"));
        int progreso = Math.max(0, Math.min(100, entero(request.getParameter("progreso"))));
        boolean trabajador = "usuario".equalsIgnoreCase(usuario.getRol());

        if (tareaId <= 0 || !trabajador) {
            request.getSession().setAttribute("flashError", "Selecciona una tarea valida.");
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
            request.getSession().setAttribute("flashExito", "Avance actualizado correctamente.");
            return "Avance actualizado correctamente.";
        } else {
            request.getSession().setAttribute("flashError", "No se encontro una tarea disponible para actualizar.");
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
