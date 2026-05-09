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
    <link rel="stylesheet" href="css/estilo.css?v=20260509-1">
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
        <section class="page-title">
            <p class="eyebrow"><%= esAdmin ? "Estructura organizacional" : (esLider ? "Delegacion de equipo" : "Mi trabajo") %></p>
            <h1><%= esAdmin ? "Gestiona grupos y lideres" : (esLider ? "Coordina tu grupo" : "Actualiza tu progreso") %></h1>
            <p><%= esAdmin ? "Crea grupos, asigna lideres y suma trabajadores a cada equipo." : (esLider ? "Asigna tareas solo a miembros de tus grupos." : "Revisa tus tareas y reporta avances sin ver informacion de otros grupos.") %></p>
        </section>

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
                <span>Tareas abiertas</span>
                <strong><%= resumen != null ? resumen.getTareasPendientes() : 0 %></strong>
            </article>
            <article class="stat-card">
                <span><%= esAdmin ? "Grupos activos" : "Grupos visibles" %></span>
                <strong><%= esAdmin ? (resumen != null ? resumen.getGruposActivos() : 0) : (gruposDisponibles != null ? gruposDisponibles.size() : 0) %></strong>
            </article>
        </section>

        <% if (esAdmin) { %>
        <section class="admin-grid">
            <article class="panel action-panel">
                <div class="panel-heading">
                    <div>
                        <h2>Crear grupo con lider</h2>
                        <p>El lider queda como responsable operativo del grupo.</p>
                    </div>
                </div>
                <form class="task-form compact-form" action="grupos" method="post">
                    <input type="hidden" name="accion" value="crear">
                    <label>
                        Nombre del grupo
                        <input type="text" name="nombre" placeholder="Ej. Ventas Norte" required>
                    </label>
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
                    <label class="form-wide">
                        Descripcion
                        <input type="text" name="descripcion" placeholder="Alcance del equipo">
                    </label>
                    <button class="button button-primary" type="submit">Crear grupo</button>
                </form>
            </article>

            <article class="panel action-panel">
                <div class="panel-heading">
                    <div>
                        <h2>Agregar trabajador</h2>
                        <p>Los miembros solo podran ver tareas de su propio grupo.</p>
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
        <% } %>

        <% if (esLider) { %>
        <section class="panel action-panel leader-panel">
            <div class="panel-heading">
                <div>
                    <h2>Delegar tarea</h2>
                    <p>Solo puedes asignar tareas dentro de los grupos que lideras.</p>
                </div>
            </div>
            <form class="task-form" action="tareas" method="post">
                <input type="hidden" name="accion" value="asignar">
                <label>
                    Titulo
                    <input type="text" name="titulo" placeholder="Ej. Preparar reporte semanal" required>
                </label>
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
                <label>
                    Fecha limite
                    <input type="date" name="fechaLimite">
                </label>
                <label class="form-wide">
                    Descripcion
                    <input type="text" name="descripcion" placeholder="Contexto breve de la tarea">
                </label>
                <button class="button button-primary" type="submit">Delegar</button>
            </form>
        </section>
        <% } %>

        <section class="content-grid">
            <article class="panel">
                <h2>Prioridades</h2>
                <div class="priority-list">
                    <% if (resumen != null) {
                        for (Map.Entry<String, Integer> entry : resumen.getTareasPorPrioridad().entrySet()) { %>
                    <div class="priority-row">
                        <span class="priority <%= entry.getKey() %>"></span>
                        <span><%= entry.getKey() %></span>
                        <strong><%= entry.getValue() %></strong>
                    </div>
                    <%  }
                    } %>
                </div>
            </article>

            <article class="panel">
                <h2><%= esAdmin ? "Grupos de la empresa" : "Grupos visibles" %></h2>
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
                            <tr><td colspan="4">No hay grupos para mostrar.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </article>
        </section>

        <section class="panel">
            <div class="panel-heading">
                <div>
                    <h2><%= esTrabajador ? "Actualizar mis avances" : "Seguimiento de tareas" %></h2>
                    <p><%= esTrabajador ? "Cada trabajador actualiza su propio progreso." : "Vista de control segun tu alcance de rol." %></p>
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
                            <% if (esTrabajador) { %><th>Accion</th><% } %>
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
                            <% if (esTrabajador) { %>
                            <td>
                                <form class="inline-update" action="tareas" method="post">
                                    <input type="hidden" name="accion" value="actualizar">
                                    <input type="hidden" name="tareaId" value="<%= tarea.getId() %>">
                                    <input type="number" name="progreso" min="0" max="100" value="<%= tarea.getProgreso() %>" aria-label="Progreso">
                                    <input type="text" name="comentario" placeholder="Comentario">
                                    <button class="button button-secondary" type="submit">Guardar</button>
                                </form>
                            </td>
                            <% } %>
                        </tr>
                        <%  }
                        } else { %>
                        <tr><td colspan="<%= esTrabajador ? 7 : 6 %>">No hay tareas para mostrar.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</body>
</html>
