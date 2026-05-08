<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Tareas</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
</head>
<body class="page-home">
    <header class="topbar">
        <a class="brand" href="${pageContext.request.contextPath}/">Gestión de Tareas</a>
        <nav class="nav-actions">
            <a href="${pageContext.request.contextPath}/login">Ingresar</a>
            <a class="button button-primary" href="${pageContext.request.contextPath}/registro">Crear cuenta</a>
        </nav>
    </header>

    <main class="hero">
        <section class="hero-copy">
            <p class="eyebrow">Base de datos: gestion_tareas</p>
            <h1>Organiza equipos, asigna tareas y mide avances desde un solo lugar.</h1>
            <p class="hero-text">
                Plataforma MVC en Java con JSP, Servlets y JDBC directo para administrar usuarios,
                grupos y tareas sin depender de Spring ni Hibernate.
            </p>
            <div class="hero-actions">
                <a class="button button-primary" href="${pageContext.request.contextPath}/registro">Empezar ahora</a>
                <a class="button button-secondary" href="${pageContext.request.contextPath}/login">Ya tengo cuenta</a>
            </div>
        </section>

        <section class="preview-panel" aria-label="Resumen del sistema">
            <div class="preview-header">
                <span>Panel principal</span>
                <strong>Activo</strong>
            </div>
            <div class="metric-grid">
                <article>
                    <small>Usuarios</small>
                    <strong>Equipo</strong>
                </article>
                <article>
                    <small>Grupos</small>
                    <strong>Áreas</strong>
                </article>
                <article>
                    <small>Tareas</small>
                    <strong>Avance</strong>
                </article>
            </div>
            <div class="task-preview">
                <span class="priority high"></span>
                <div>
                    <strong>Diseñar menú principal</strong>
                    <small>En progreso · 75%</small>
                </div>
            </div>
            <div class="task-preview">
                <span class="priority medium"></span>
                <div>
                    <strong>Documentar API</strong>
                    <small>Pendiente · 20%</small>
                </div>
            </div>
        </section>
    </main>
</body>
</html>
