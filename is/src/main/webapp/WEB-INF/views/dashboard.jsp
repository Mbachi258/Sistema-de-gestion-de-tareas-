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
    List<Grupo> gruposDisponibles = (List<Grupo>) request.getAttribute("gruposDisponibles");
    boolean esAdmin = Boolean.TRUE.equals(request.getAttribute("esAdmin"));
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - TaskFlow Enterprise</title>
    <base href="<%= request.getContextPath() %>/">
    <link rel="stylesheet" href="css/estilo.css?v=20260508-6">
</head>
<body class="dashboard-page">
    <header class="topbar dashboard-topbar">
        <a class="brand" href="dashboard">TaskFlow Enterprise</a>
        <nav class="nav-actions">
            <span><%= usuario != null ? usuario.getNombre() : "Usuario" %></span>
            <span class="role-pill"><%= esAdmin ? "Administrador" : "Usuario" %></span>
            <a href="logout">Salir</a>
        </nav>
    </header>

    <main class="dashboard-layout">
        <section class="page-title">
            <p class="eyebrow"><%= esAdmin ? "Panel ejecutivo" : "Mi espacio de trabajo" %></p>
            <h1><%= esAdmin ? "Gestion operativa" : "Mis tareas asignadas" %></h1>
            <p><%= esAdmin ? "Asigna trabajo, revisa equipos y controla prioridades." : "Actualiza avances y manten visible el estado de tus entregables." %></p>
        </section>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getAttribute("exito") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("exito") %></div>
        <% } %>

        <section class="stats-grid">
            <article class="stat-card">
                <span><%= esAdmin ? "Usuarios activos" : "Equipo activo" %></span>
                <strong><%= resumen != null ? resumen.getTotalUsuarios() : 0 %></strong>
            </article>
            <article class="stat-card">
                <span>Tareas abiertas</span>
                <strong><%= resumen != null ? resumen.getTareasPendientes() : 0 %></strong>
            </article>
            <article class="stat-card">
                <span>Grupos activos</span>
                <strong><%= resumen != null ? resumen.getGruposActivos() : 0 %></strong>
            </article>
        </section>

        <% if (esAdmin) { %>
        <section class="panel action-panel">
            <div class="panel-heading">
                <div>
                    <h2>Asignar nueva tarea</h2>
                    <p>Define responsable, grupo, prioridad y fecha limite.</p>
                </div>
            </div>
            <form class="task-form" action="tareas" method="post">
                <input type="hidden" name="accion" value="asignar">
                <label>
                    Titulo
                    <input type="text" name="titulo" placeholder="Ej. Revisar entregable mensual" required>
                </label>
                <label>
                    Responsable
                    <select name="usuarioId" required>
                        <option value="">Seleccionar</option>
                        <% if (usuariosDisponibles != null) {
                            for (Usuario item : usuariosDisponibles) { %>
                        <option value="<%= item.getId() %>"><%= item.getNombre() %> - <%= item.getRol() %></option>
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
                <label>
                    Fecha limite
                    <input type="date" name="fechaLimite">
                </label>
                <label class="form-wide">
                    Descripcion
                    <input type="text" name="descripcion" placeholder="Contexto breve de la tarea">
                </label>
                <button class="button button-primary" type="submit">Asignar tarea</button>
            </form>
        </section>
        <% } %>

        <section class="content-grid">
            <article class="panel">
                <h2>Prioridades</h2>
                <div class="priority-list">
                    <%
                        if (resumen != null) {
                            for (Map.Entry<String, Integer> entry : resumen.getTareasPorPrioridad().entrySet()) {
                    %>
                    <div class="priority-row">
                        <span class="priority <%= entry.getKey() %>"></span>
                        <span><%= entry.getKey() %></span>
                        <strong><%= entry.getValue() %></strong>
                    </div>
                    <%
                            }
                        }
                    %>
                </div>
            </article>

            <article class="panel">
                <h2>Grupos</h2>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>Grupo</th>
                                <th>Miembros</th>
                                <th>Tareas</th>
                                <th>Promedio</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (grupos != null && !grupos.isEmpty()) {
                                for (GrupoEstadistica grupo : grupos) { %>
                            <tr>
                                <td><%= grupo.getNombre() %></td>
                                <td><%= grupo.getTotalMiembros() %></td>
                                <td><%= grupo.getTotalTareas() %></td>
                                <td><%= grupo.getProgresoPromedio() %>%</td>
                            </tr>
                            <%  }
                            } else { %>
                            <tr><td colspan="4">No hay grupos registrados.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </article>
        </section>

        <section class="panel">
            <div class="panel-heading">
                <div>
                    <h2><%= esAdmin ? "Tareas recientes" : "Actualizar mis avances" %></h2>
                    <p><%= esAdmin ? "El administrador puede ajustar cualquier avance." : "Cada cambio actualiza el estado de la tarea automaticamente." %></p>
                </div>
            </div>
            <div class="table-wrap">
                <table class="tasks-table">
                    <thead>
                        <tr>
                            <th>Titulo</th>
                            <th>Responsable</th>
                            <th>Grupo</th>
                            <th>Prioridad</th>
                            <th>Estado</th>
                            <th>Progreso</th>
                            <th>Accion</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (tareas != null && !tareas.isEmpty()) {
                            for (Tarea tarea : tareas) { %>
                        <tr>
                            <td><%= tarea.getTitulo() %></td>
                            <td><%= tarea.getResponsableNombre() %></td>
                            <td><%= tarea.getGrupoNombre() %></td>
                            <td><span class="tag"><%= tarea.getPrioridad() %></span></td>
                            <td><%= tarea.getEstado() %></td>
                            <td>
                                <div class="progress"><span style="width:<%= tarea.getProgreso() %>%"></span></div>
                                <small><%= tarea.getProgreso() %>%</small>
                            </td>
                            <td>
                                <form class="inline-update" action="tareas" method="post">
                                    <input type="hidden" name="accion" value="actualizar">
                                    <input type="hidden" name="tareaId" value="<%= tarea.getId() %>">
                                    <input type="number" name="progreso" min="0" max="100" value="<%= tarea.getProgreso() %>" aria-label="Progreso">
                                    <input type="text" name="comentario" placeholder="Comentario">
                                    <button class="button button-secondary" type="submit">Guardar</button>
                                </form>
                            </td>
                        </tr>
                        <%  }
                        } else { %>
                        <tr><td colspan="7">No hay tareas para mostrar.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</body>
</html>
