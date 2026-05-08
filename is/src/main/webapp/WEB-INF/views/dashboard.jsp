<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
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
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Gestión de Tareas</title>
    <base href="<%= request.getContextPath() %>/">
    <link rel="stylesheet" href="css/estilo.css?v=20260508-2">
</head>
<body class="dashboard-page">
    <header class="topbar dashboard-topbar">
        <a class="brand" href="dashboard">Gestión de Tareas</a>
        <nav class="nav-actions">
            <span><%= usuario != null ? usuario.getNombre() : "Usuario" %></span>
            <a href="logout">Salir</a>
        </nav>
    </header>

    <main class="dashboard-layout">
        <section class="page-title">
            <p class="eyebrow">MVC con JSP, Servlets y JDBC</p>
            <h1>Resumen de actividad</h1>
            <p>Estado actual tomado desde la base de datos gestion_tareas.</p>
        </section>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>

        <section class="stats-grid">
            <article class="stat-card">
                <span>Usuarios activos</span>
                <strong><%= resumen != null ? resumen.getTotalUsuarios() : 0 %></strong>
            </article>
            <article class="stat-card">
                <span>Tareas pendientes</span>
                <strong><%= resumen != null ? resumen.getTareasPendientes() : 0 %></strong>
            </article>
            <article class="stat-card">
                <span>Grupos activos</span>
                <strong><%= resumen != null ? resumen.getGruposActivos() : 0 %></strong>
            </article>
        </section>

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
            <h2>Tareas recientes</h2>
            <div class="table-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>Título</th>
                            <th>Responsable</th>
                            <th>Grupo</th>
                            <th>Prioridad</th>
                            <th>Estado</th>
                            <th>Progreso</th>
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
                        </tr>
                        <%  }
                        } else { %>
                        <tr><td colspan="6">No hay tareas para mostrar.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</body>
</html>
