<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TaskFlow Enterprise</title>
    <base href="<%= request.getContextPath() %>/">
    <link rel="stylesheet" href="css/estilo.css?v=20260508-3">
</head>
<body class="page-home">
    <header class="topbar">
        <a class="brand" href="./">TaskFlow Enterprise</a>
        <nav class="nav-actions">
            <a href="login">Ingresar</a>
        </nav>
    </header>

    <main class="hero">
        <section class="hero-copy">
            <p class="eyebrow">Gestion operativa para empresas</p>
            <h1>Coordina tareas, responsables y avances con vision ejecutiva.</h1>
            <p class="hero-text">
                Centraliza el trabajo de areas, proyectos y equipos en una plataforma pensada
                para organizaciones que necesitan trazabilidad, prioridad y control diario.
            </p>
            <div class="hero-actions">
                <a class="button button-primary" href="registro">Solicitar acceso</a>
            </div>
        </section>

        <section class="preview-panel enterprise-panel" aria-label="Vista de operacion empresarial">
            <div class="preview-header">
                <span>Centro de operaciones</span>
                <strong>En seguimiento</strong>
            </div>
            <div class="metric-grid enterprise-metrics">
                <article>
                    <small>Cumplimiento</small>
                    <strong>87%</strong>
                </article>
                <article>
                    <small>Prioridad alta</small>
                    <strong>12</strong>
                </article>
                <article>
                    <small>Areas activas</small>
                    <strong>8</strong>
                </article>
            </div>
            <div class="task-preview enterprise-task">
                <span class="priority high"></span>
                <div>
                    <strong>Cierre de entregables comerciales</strong>
                    <small>Gerencia comercial - 75%</small>
                </div>
            </div>
            <div class="task-preview enterprise-task">
                <span class="priority medium"></span>
                <div>
                    <strong>Validacion de procesos internos</strong>
                    <small>Operaciones - 42%</small>
                </div>
            </div>
            <div class="task-preview enterprise-task">
                <span class="priority low"></span>
                <div>
                    <strong>Reporte semanal de desempeno</strong>
                    <small>Direccion general - completado</small>
                </div>
            </div>
        </section>
    </main>

    <section class="business-strip" aria-label="Capacidades principales">
        <article>
            <span>01</span>
            <strong>Asignacion por areas</strong>
            <p>Distribuye responsabilidades por equipos, lideres y responsables directos.</p>
        </article>
        <article>
            <span>02</span>
            <strong>Seguimiento ejecutivo</strong>
            <p>Consulta avances, prioridades y tareas criticas sin perder contexto operativo.</p>
        </article>
        <article>
            <span>03</span>
            <strong>Control de cumplimiento</strong>
            <p>Detecta pendientes, retrasos y cargas de trabajo antes de que afecten resultados.</p>
        </article>
    </section>
</body>
</html>
