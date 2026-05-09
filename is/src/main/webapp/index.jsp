<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TaskFlow</title>
    <base href="<%= request.getContextPath() %>/">
    <link rel="stylesheet" href="css/estilo.css?v=20260508-3">
</head>
<body class="page-home">
    <header class="topbar">
        <a class="brand" href="./">TaskFlow</a>
        <nav class="nav-actions">
            <a href="login">Ingresar</a>
        </nav>
    </header>

    <main class="hero">
        <section class="hero-copy">
            <p class="eyebrow">Trabajo en equipo, sin desorden</p>
            <h1>Organiza tareas, equipos y avances en un solo lugar.</h1>
            <p class="hero-text">
                Crea equipos, reparte pendientes y sigue el avance diario sin perder de vista
                lo que cada persona necesita entregar.
            </p>
            <div class="hero-actions">
                <a class="button button-primary" href="registro">Solicitar acceso</a>
            </div>
        </section>

        <section class="preview-panel enterprise-panel" aria-label="Resumen de trabajo">
            <div class="preview-header">
                <span>Resumen del dia</span>
                <strong>En marcha</strong>
            </div>
            <div class="metric-grid enterprise-metrics">
                <article>
                    <small>Avance</small>
                    <strong>87%</strong>
                </article>
                <article>
                    <small>Urgentes</small>
                    <strong>12</strong>
                </article>
                <article>
                    <small>Equipos</small>
                    <strong>8</strong>
                </article>
            </div>
            <div class="task-preview enterprise-task">
                <span class="priority high"></span>
                <div>
                    <strong>Cierre de reporte semanal</strong>
                    <small>Equipo comercial - 75%</small>
                </div>
            </div>
            <div class="task-preview enterprise-task">
                <span class="priority medium"></span>
                <div>
                    <strong>Revision de pendientes internos</strong>
                    <small>Equipo de soporte - 42%</small>
                </div>
            </div>
            <div class="task-preview enterprise-task">
                <span class="priority low"></span>
                <div>
                    <strong>Entrega de informe final</strong>
                    <small>Equipo administrativo - completado</small>
                </div>
            </div>
        </section>
    </main>

    <section class="business-strip" aria-label="Capacidades principales">
        <article>
            <span>01</span>
            <strong>Equipos claros</strong>
            <p>Agrupa personas por equipo y define quien guia el trabajo.</p>
        </article>
        <article>
            <span>02</span>
            <strong>Avances visibles</strong>
            <p>Revisa que falta, que esta en camino y que ya se termino.</p>
        </article>
        <article>
            <span>03</span>
            <strong>Menos pendientes sueltos</strong>
            <p>Cada tarea tiene responsable, equipo y estado actualizado.</p>
        </article>
    </section>
</body>
</html>
