<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.mycompany.is.model.CompaneroProgreso"%>
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
    List<CompaneroProgreso> companeros = (List<CompaneroProgreso>) request.getAttribute("companeros");
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
    <title>Inicio - TaskFlow</title>
    <base href="<%= request.getContextPath() %>/">
    <link rel="stylesheet" href="css/estilo.css?v=20260509-6">
</head>
<body class="dashboard-page">
    <header class="topbar dashboard-topbar">
        <a class="brand" href="dashboard">TaskFlow</a>
        <nav class="nav-actions">
            <span><%= usuario != null ? usuario.getNombre() : "Usuario" %></span>
            <span class="role-pill"><%= esAdmin ? "Administrador" : (esLider ? "Lider" : "Trabajador") %></span>
            <a href="logout">Salir</a>
        </nav>
    </header>

    <main class="dashboard-layout">
        <section class="page-title page-title-hero">
            <p class="eyebrow"><%= esAdmin ? "Equipos y personas" : (esLider ? "Mi equipo" : "Mis tareas") %></p>
            <h1><%= esAdmin ? "Organiza quienes trabajan juntos" : (esLider ? "Reparte tareas y acompana avances" : "Tienes trabajo por avanzar") %></h1>
            <p><%= esAdmin ? "Crea equipos, elige lideres y agrega trabajadores donde corresponde." : (esLider ? "Asigna tareas a tu equipo y revisa como van." : "Revisa tus pendientes, mira como avanza tu equipo y deja comentarios cuando sea necesario.") %></p>
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
                <span><%= esAdmin ? "Personas activas" : (esLider ? "Personas en mi equipo" : "Mis tareas") %></span>
                <strong><%= esAdmin ? (resumen != null ? resumen.getTotalUsuarios() : 0) : (esLider ? (usuariosDisponibles != null ? usuariosDisponibles.size() : 0) : (tareas != null ? tareas.size() : 0)) %></strong>
            </article>
            <article class="stat-card">
                <span><%= esAdmin ? "Equipos creados" : "Tareas abiertas" %></span>
                <strong><%= esAdmin ? (resumen != null ? resumen.getGruposActivos() : 0) : (resumen != null ? resumen.getTareasPendientes() : 0) %></strong>
            </article>
            <article class="stat-card">
                <span><%= esAdmin ? "Posibles lideres" : "Mis equipos" %></span>
                <strong><%= esAdmin ? (lideresDisponibles != null ? lideresDisponibles.size() : 0) : (gruposDisponibles != null ? gruposDisponibles.size() : 0) %></strong>
            </article>
        </section>

        <% if (esAdmin) { %>
        <section class="admin-grid">
            <article class="panel action-panel">
                <div class="panel-heading">
                    <div>
                        <h2>Crear equipo</h2>
                        <p>Elige quien guiara el trabajo de este equipo.</p>
                    </div>
                </div>
                <form class="task-form compact-form" action="grupos" method="post">
                    <input type="hidden" name="accion" value="crear">
                    <label>Nombre del equipo<input type="text" name="nombre" placeholder="Ej. Ventas Norte" required></label>
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
                    <label class="form-wide">Descripcion<input type="text" name="descripcion" placeholder="Que hara este equipo"></label>
                    <button class="button button-primary" type="submit">Crear equipo</button>
                </form>
            </article>

            <article class="panel action-panel">
                <div class="panel-heading">
                    <div>
                        <h2>Agregar persona</h2>
                        <p>Elige a que equipo pertenecera.</p>
                    </div>
                </div>
                <form class="task-form compact-form" action="grupos" method="post">
                    <input type="hidden" name="accion" value="miembro">
                    <label>
                        Equipo
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
                        Persona
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
                    <h2>Como va cada equipo</h2>
                    <p>Revisa el avance general y abre el detalle cuando lo necesites.</p>
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
                    <div><span>Guia</span><strong><%= grupo.getLiderNombre() != null ? grupo.getLiderNombre() : "Sin lider" %></strong></div>
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
                    <h2>Crear tarea para mi equipo</h2>
                    <p>Elige una persona, una prioridad y la fecha esperada.</p>
                </div>
            </div>
            <form class="task-form" action="tareas" method="post">
                <input type="hidden" name="accion" value="asignar">
                <label>Titulo<input type="text" name="titulo" placeholder="Ej. Preparar reporte semanal" required></label>
                <label>
                    Persona responsable
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
                    Equipo
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
                <label class="form-wide">Descripcion<input type="text" name="descripcion" placeholder="Que se debe hacer"></label>
                <button class="button button-primary" type="submit">Crear tarea</button>
            </form>
        </section>

        <section class="leader-grid">
            <article class="panel">
                <h2>Tareas por prioridad</h2>
                <div class="priority-list">
                    <% if (resumen != null) {
                        for (Map.Entry<String, Integer> entry : resumen.getTareasPorPrioridad().entrySet()) { %>
                    <div class="priority-row"><span class="priority <%= entry.getKey() %>"></span><span><%= entry.getKey() %></span><strong><%= entry.getValue() %></strong></div>
                    <%  }
                    } %>
                </div>
            </article>
            <article class="panel">
                <h2>Mis equipos</h2>
                <div class="table-wrap">
                    <table>
                        <thead><tr><th>Equipo</th><th>Personas</th><th>Tareas</th><th>Avance</th></tr></thead>
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
            <div class="panel-heading"><div><h2>Tareas del equipo</h2><p>Consulta el avance sin cambiar el reporte de cada persona.</p></div></div>
            <div class="table-wrap">
                <table class="tasks-table">
                    <thead><tr><th>Titulo</th><th>Responsable</th><th>Equipo</th><th>Prioridad</th><th>Estado</th><th>Avance</th></tr></thead>
                    <tbody>
                    <% if (tareas != null && !tareas.isEmpty()) {
                        for (Tarea tarea : tareas) { %>
                        <tr><td><%= tarea.getTitulo() %></td><td><%= tarea.getResponsableNombre() %></td><td><%= tarea.getGrupoNombre() %></td><td><span class="tag"><%= tarea.getPrioridad() %></span></td><td><%= tarea.getEstado() %></td><td><div class="progress"><span style="width:<%= tarea.getProgreso() %>%"></span></div><small><%= tarea.getProgreso() %>%</small></td></tr>
                    <%  }
                    } else { %>
                        <tr><td colspan="6">No hay tareas por ahora.</td></tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </section>
        <% } %>

        <% if (esTrabajador) { %>
        <section class="worker-layout">
            <aside class="panel teammates-panel">
                <div class="panel-heading">
                    <div>
                        <h2>Organizacion del equipo</h2>
                        <p>Personas, equipos y avance general de tu area.</p>
                    </div>
                </div>
                <div class="team-organization">
                    <% if (grupos != null && !grupos.isEmpty()) {
                        for (GrupoEstadistica grupo : grupos) {
                            long avanceEquipo = Math.round(grupo.getProgresoPromedio());
                    %>
                    <article class="team-mini-card">
                        <div>
                            <span>Equipo</span>
                            <strong><%= grupo.getNombre() %></strong>
                        </div>
                        <b><%= avanceEquipo %>%</b>
                        <div class="progress teammate-progress"><span style="width:<%= avanceEquipo %>%"></span></div>
                        <small><%= grupo.getTotalMiembros() %> personas · <%= grupo.getTotalTareas() %> tareas</small>
                    </article>
                    <%  }
                    } %>
                </div>
                <div class="teammate-list">
                    <% if (companeros != null && !companeros.isEmpty()) {
                        for (CompaneroProgreso companero : companeros) {
                            long avanceCompanero = Math.round(companero.getProgresoPromedio());
                            String rolCompanero = "lider".equals(companero.getRol()) ? "Lider" : ("admin".equals(companero.getRol()) ? "Administrador" : "Trabajador");
                    %>
                    <article class="teammate-card">
                        <div class="teammate-head">
                            <div>
                                <strong><%= companero.getNombre() %></strong>
                                <span><%= rolCompanero %></span>
                            </div>
                            <b><%= avanceCompanero %>%</b>
                        </div>
                        <div class="progress teammate-progress"><span style="width:<%= avanceCompanero %>%"></span></div>
                        <small><%= companero.getTareasCompletadas() %> completadas de <%= companero.getTotalTareas() %> tareas</small>
                    </article>
                    <%  }
                    } else { %>
                    <article class="teammate-card empty-state">
                        <strong>Aun no hay personas para mostrar</strong>
                        <span>Cuando tu equipo tenga mas integrantes, veras aqui su avance.</span>
                    </article>
                    <% } %>
                </div>
            </aside>

            <section class="my-tasks-panel">
                <div class="panel-heading worker-heading">
                    <div>
                        <h2>Mi panel de tareas</h2>
                        <p>Actualiza tu avance y agrega comentarios para tu lider.</p>
                    </div>
                </div>
                <div class="worker-task-grid">
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
                        <div class="task-meta">
                            <span><%= tarea.getGrupoNombre() %></span>
                            <span data-state-label><%= "en_progreso".equals(tarea.getEstado()) ? "En progreso" : ("pendiente".equals(tarea.getEstado()) ? "Pendiente" : ("completada".equals(tarea.getEstado()) ? "Completada" : "Cancelada")) %></span>
                        </div>
                        <form class="ajax-progress-form" action="tareas" method="post">
                            <input type="hidden" name="accion" value="actualizar">
                            <input type="hidden" name="tareaId" value="<%= tarea.getId() %>">
                            <label class="range-label">
                                Avance
                                <input type="range" name="progreso" min="0" max="100" value="<%= tarea.getProgreso() %>" data-progress-range>
                            </label>
                            <input type="text" name="comentario" placeholder="Subir comentarios">
                            <button class="button button-primary" type="submit">Guardar avance</button>
                            <small class="form-status" data-form-status></small>
                        </form>
                    </article>
                    <%  }
                    } else { %>
                    <article class="worker-task-card"><h2>No tienes tareas por ahora</h2></article>
                    <% } %>
                </div>
            </section>
        </section>
        <% } %>
    </main>
    <script src="js/script.js?v=20260509-6"></script>
</body>
</html>
