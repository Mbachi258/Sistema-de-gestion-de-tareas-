<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.mycompany.is.model.Grupo"%>
<%@page import="com.mycompany.is.model.Tarea"%>
<%@page import="com.mycompany.is.model.Usuario"%>
<%@page import="com.mycompany.is.model.GrupoEstadistica"%>
<%@page import="com.mycompany.is.model.DashboardResumen"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    DashboardResumen resumen = (DashboardResumen) request.getAttribute("resumen");
    List<GrupoEstadistica> grupos = (List<GrupoEstadistica>) request.getAttribute("grupos");
    List<Tarea> tareas = (List<Tarea>) request.getAttribute("tareas");
    List<Usuario> usuariosDisponibles = (List<Usuario>) request.getAttribute("usuariosDisponibles");
    List<Usuario> lideresDisponibles = (List<Usuario>) request.getAttribute("lideresDisponibles");
    List<Grupo> gruposDisponibles = (List<Grupo>) request.getAttribute("gruposDisponibles");
    boolean esAdmin = Boolean.TRUE.equals(request.getAttribute("esAdmin"));
    boolean esLider = Boolean.TRUE.equals(request.getAttribute("esLider"));
    boolean esTrabajador = Boolean.TRUE.equals(request.getAttribute("esTrabajador"));
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - TaskFlow Enterprise</title>
    <base href="<%= request.getContextPath() %>/">
    <link rel="stylesheet" href="css/estilo.css?v=20260509-2">
</head>
<body class="dashboard-page">
    <header class="topbar dashboard-topbar">
        <a class="brand" href="dashboard">TaskFlow Enterprise</a>
        <nav class="nav-actions">
            <span><%= usuario != null ? usuario.getNombre() : "Usuario" %></span>
            <span class="role-pill"><%= esAdmin ? "Administrador" : (esLider ? "Lider" : "Trabajador") %></span>
            <a href="logout">Salir</a>
        </nav>
    </header>

    <main class="dashboard-layout">
        <section class="page-title page-title-hero">
            <p class="eyebrow"><%= esAdmin ? "Estructura organizacional" : (esLider ? "Delegacion de equipo" : "Mi tablero personal") %></p>
            <h1><%= esAdmin ? "Organiza equipos sin mezclar tareas" : (esLider ? "Coordina solo tu grupo" : "Avanza tus tareas sin recargar") %></h1>
            <p><%= esAdmin ? "Tu vista se concentra en grupos, lideres y trabajadores. Las tareas quedan en manos de los lideres." : (esLider ? "Delega tareas a miembros de tus grupos y revisa el avance sin ver otros equipos." : "Usa los controles de progreso para reportar cambios al instante.") %></p>
        </section>

        <div id="ajaxMessage" class="ajax-message" hidden></div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getAttribute("exito") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("exito") %></div>
        <% } %>

        <section class="stats-grid">
            <article class="stat-card">
                <span><%= esAdmin ? "Usuarios activos" : (esLider ? "Miembros disponibles" : "Tareas propias") %></span>
                <strong><%= esAdmin ? (resumen != null ? resumen.getTotalUsuarios() : 0) : (esLider ? (usuariosDisponibles != null ? usuariosDisponibles.size() : 0) : (tareas != null ? tareas.size() : 0)) %></strong>
            </article>
            <article class="stat-card">
                <span><%= esAdmin ? "Grupos gestionados" : "Tareas abiertas" %></span>
                <strong><%= esAdmin ? (resumen != null ? resumen.getGruposActivos() : 0) : (resumen != null ? resumen.getTareasPendientes() : 0) %></strong>
            </article>
            <article class="stat-card">
                <span><%= esAdmin ? "Lideres disponibles" : "Grupos visibles" %></span>
                <strong><%= esAdmin ? (lideresDisponibles != null ? lideresDisponibles.size() : 0) : (gruposDisponibles != null ? gruposDisponibles.size() : 0) %></strong>
            </article>
        </section>

        <% if (esAdmin) { %>
        <section class="admin-grid">
            <article class="panel action-panel">
                <div class="panel-heading">
                    <div>
                        <h2>Crear grupo con lider</h2>
                        <p>El lider recibe el alcance operativo del grupo.</p>
                    </div>
                </div>
                <form class="task-form compact-form" action="grupos" method="post">
                    <input type="hidden" name="accion" value="crear">
                    <label>Nombre del grupo<input type="text" name="nombre" placeholder="Ej. Ventas Norte" required></label>
                    <label>
                        Lider
                        <select name="liderId" required>
                            <option value="">Seleccionar</option>
                            <% if (lideresDisponibles != null) {
                                for (Usuario item : lideresDisponibles) { %>
                            <option value="<%= item.getId() %>"><%= item.getNombre() %> - <%= item.getRol() %></option>
                            <%  }
                            } %>
                        </select>
                    </label>
                    <label class="form-wide">Descripcion<input type="text" name="descripcion" placeholder="Alcance del equipo"></label>
                    <button class="button button-primary" type="submit">Crear grupo</button>
                </form>
            </article>

            <article class="panel action-panel">
                <div class="panel-heading">
                    <div>
                        <h2>Agregar trabajador</h2>
                        <p>El trabajador queda asociado al grupo seleccionado.</p>
                    </div>
                </div>
                <form class="task-form compact-form" action="grupos" method="post">
                    <input type="hidden" name="accion" value="miembro">
                    <label>
                        Grupo
                        <select name="grupoId" required>
                            <option value="">Seleccionar</option>
                            <% if (gruposDisponibles != null) {
                                for (Grupo grupo : gruposDisponibles) { %>
                            <option value="<%= grupo.getId() %>"><%= grupo.getNombre() %> - <%= grupo.getLiderNombre() != null ? grupo.getLiderNombre() : "Sin lider" %></option>
                            <%  }
                            } %>
                        </select>
                    </label>
                    <label>
                        Trabajador
                        <select name="usuarioId" required>
                            <option value="">Seleccionar</option>
                            <% if (usuariosDisponibles != null) {
                                for (Usuario item : usuariosDisponibles) { %>
                            <option value="<%= item.getId() %>"><%= item.getNombre() %> - <%= item.getRol() %></option>
                            <%  }
                            } %>
                        </select>
                    </label>
                    <button class="button button-primary" type="submit">Agregar</button>
                </form>
            </article>
        </section>

        <section class="panel team-overview">
            <div class="panel-heading">
                <div>
                    <h2>Estado por equipo</h2>
                    <p>Vista general para revisar avance sin mezclar todas las tareas.</p>
                </div>
            </div>
            <div class="org-grid">
            <% if (gruposDisponibles != null && !gruposDisponibles.isEmpty()) {
                for (Grupo grupo : gruposDisponibles) {
                    GrupoEstadistica estadistica = null;
                    if (grupos != null) {
                        for (GrupoEstadistica item : grupos) {
                            if (item.getNombre().equals(grupo.getNombre())) {
                                estadistica = item;
                                break;
                            }
                        }
                    }
                    int totalTareas = estadistica != null ? estadistica.getTotalTareas() : 0;
                    int totalMiembros = estadistica != null ? estadistica.getTotalMiembros() : 0;
                    int tareasCompletadas = estadistica != null ? estadistica.getTareasCompletadas() : 0;
                    double promedio = estadistica != null ? estadistica.getProgresoPromedio() : 0;
            %>
            <article class="group-card">
                <div class="group-card-head">
                    <div>
                        <span>Equipo</span>
                        <strong><%= grupo.getNombre() %></strong>
                    </div>
                    <b><%= Math.round(promedio) %>%</b>
                </div>
                <div class="progress team-progress"><span style="width:<%= Math.round(promedio) %>%"></span></div>
                <p><%= grupo.getDescripcion() != null && !grupo.getDescripcion().isEmpty() ? grupo.getDescripcion() : "Sin descripcion" %></p>
                <button type="button" class="button button-secondary full-width" data-toggle-detail>Ver detalle</button>
                <div class="team-detail" hidden>
                    <div><span>Lider</span><strong><%= grupo.getLiderNombre() != null ? grupo.getLiderNombre() : "Sin lider" %></strong></div>
                    <div><span>Miembros</span><strong><%= totalMiembros %></strong></div>
                    <div><span>Tareas</span><strong><%= totalTareas %></strong></div>
                    <div><span>Completadas</span><strong><%= tareasCompletadas %></strong></div>
                </div>
            </article>
            <%  }
            } else { %>
            <article class="group-card"><strong>No hay grupos creados</strong></article>
            <% } %>
            </div>
        </section>
        <% } %>

        <% if (esLider) { %>
        <section class="panel action-panel leader-panel">
            <div class="panel-heading">
                <div>
                    <h2>Delegar tarea</h2>
                    <p>Solo aparecen miembros y grupos bajo tu liderazgo.</p>
                </div>
            </div>
            <form class="task-form" action="tareas" method="post">
                <input type="hidden" name="accion" value="asignar">
                <label>Titulo<input type="text" name="titulo" placeholder="Ej. Preparar reporte semanal" required></label>
                <label>
                    Responsable
                    <select name="usuarioId" required>
                        <option value="">Seleccionar</option>
                        <% if (usuariosDisponibles != null) {
                            for (Usuario item : usuariosDisponibles) { %>
                        <option value="<%= item.getId() %>"><%= item.getNombre() %></option>
                        <%  }
                        } %>
                    </select>
                </label>
                <label>
                    Grupo
                    <select name="grupoId" required>
                        <option value="">Seleccionar</option>
                        <% if (gruposDisponibles != null) {
                            for (Grupo grupo : gruposDisponibles) { %>
                        <option value="<%= grupo.getId() %>"><%= grupo.getNombre() %></option>
                        <%  }
                        } %>
                    </select>
                </label>
                <label>
                    Prioridad
                    <select name="prioridad" required>
                        <option value="alta">Alta</option>
                        <option value="media" selected>Media</option>
                        <option value="baja">Baja</option>
                    </select>
                </label>
                <label>Fecha limite<input type="date" name="fechaLimite"></label>
                <label class="form-wide">Descripcion<input type="text" name="descripcion" placeholder="Contexto breve de la tarea"></label>
                <button class="button button-primary" type="submit">Delegar</button>
            </form>
        </section>

        <section class="leader-grid">
            <article class="panel">
                <h2>Prioridades de mi equipo</h2>
                <div class="priority-list">
                    <% if (resumen != null) {
                        for (Map.Entry<String, Integer> entry : resumen.getTareasPorPrioridad().entrySet()) { %>
                    <div class="priority-row"><span class="priority <%= entry.getKey() %>"></span><span><%= entry.getKey() %></span><strong><%= entry.getValue() %></strong></div>
                    <%  }
                    } %>
                </div>
            </article>
            <article class="panel">
                <h2>Mis grupos</h2>
                <div class="table-wrap">
                    <table>
                        <thead><tr><th>Grupo</th><th>Miembros</th><th>Tareas</th><th>Promedio</th></tr></thead>
                        <tbody>
                        <% if (grupos != null && !grupos.isEmpty()) {
                            for (GrupoEstadistica grupo : grupos) { %>
                            <tr><td><%= grupo.getNombre() %></td><td><%= grupo.getTotalMiembros() %></td><td><%= grupo.getTotalTareas() %></td><td><%= grupo.getProgresoPromedio() %>%</td></tr>
                        <%  }
                        } else { %>
                            <tr><td colspan="4">No hay grupos para mostrar.</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </article>
        </section>

        <section class="panel">
            <div class="panel-heading"><div><h2>Seguimiento de tareas</h2><p>Vista de avance del equipo, sin editar progreso del trabajador.</p></div></div>
            <div class="table-wrap">
                <table class="tasks-table">
                    <thead><tr><th>Titulo</th><th>Responsable</th><th>Grupo</th><th>Prioridad</th><th>Estado</th><th>Progreso</th></tr></thead>
                    <tbody>
                    <% if (tareas != null && !tareas.isEmpty()) {
                        for (Tarea tarea : tareas) { %>
                        <tr><td><%= tarea.getTitulo() %></td><td><%= tarea.getResponsableNombre() %></td><td><%= tarea.getGrupoNombre() %></td><td><span class="tag"><%= tarea.getPrioridad() %></span></td><td><%= tarea.getEstado() %></td><td><div class="progress"><span style="width:<%= tarea.getProgreso() %>%"></span></div><small><%= tarea.getProgreso() %>%</small></td></tr>
                    <%  }
                    } else { %>
                        <tr><td colspan="6">No hay tareas para mostrar.</td></tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </section>
        <% } %>

        <% if (esTrabajador) { %>
        <section class="worker-task-grid">
            <% if (tareas != null && !tareas.isEmpty()) {
                for (Tarea tarea : tareas) { %>
            <article class="worker-task-card" data-task-card>
                <div class="task-card-head">
                    <div>
                        <span class="tag"><%= tarea.getPrioridad() %></span>
                        <h2><%= tarea.getTitulo() %></h2>
                    </div>
                    <strong data-progress-label><%= tarea.getProgreso() %>%</strong>
                </div>
                <p><%= tarea.getDescripcion() != null && !tarea.getDescripcion().isEmpty() ? tarea.getDescripcion() : "Sin descripcion" %></p>
                <div class="task-meta"><span><%= tarea.getGrupoNombre() %></span><span data-state-label><%= tarea.getEstado() %></span></div>
                <form class="ajax-progress-form" action="tareas" method="post">
                    <input type="hidden" name="accion" value="actualizar">
                    <input type="hidden" name="tareaId" value="<%= tarea.getId() %>">
                    <label class="range-label">
                        Progreso
                        <input type="range" name="progreso" min="0" max="100" value="<%= tarea.getProgreso() %>" data-progress-range>
                    </label>
                    <input type="text" name="comentario" placeholder="Comentario breve">
                    <button class="button button-primary" type="submit">Guardar avance</button>
                    <small class="form-status" data-form-status></small>
                </form>
            </article>
            <%  }
            } else { %>
            <article class="worker-task-card"><h2>No tienes tareas asignadas</h2></article>
            <% } %>
        </section>
        <% } %>
    </main>
    <script src="js/script.js?v=20260509-2"></script>
</body>
</html>
