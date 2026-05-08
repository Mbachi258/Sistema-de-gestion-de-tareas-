<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ingresar - Gestión de Tareas</title>
    <base href="<%= request.getContextPath() %>/">
    <link rel="stylesheet" href="css/estilo.css?v=20260508-2">
</head>
<body class="auth-page">
    <main class="auth-shell">
        <section class="auth-card">
            <a class="brand auth-brand" href="./">Gestión de Tareas</a>
            <h1>Ingresa a tu panel</h1>
            <p>Usa tu email y contraseña para continuar.</p>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getAttribute("exito") != null) { %>
                <div class="alert alert-success"><%= request.getAttribute("exito") %></div>
            <% } %>

            <form class="form-stack" action="login" method="post">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" placeholder="usuario@empresa.com" required>

                <label for="password">Contraseña</label>
                <div class="password-field">
                    <input type="password" id="password" name="password" placeholder="Tu contraseña" required>
                    <button type="button" class="icon-button" data-toggle-password aria-label="Mostrar contraseña">Ver</button>
                </div>

                <button class="button button-primary full-width" type="submit">Ingresar</button>
            </form>

            <p class="form-footer">¿No tienes cuenta? <a href="registro">Regístrate</a></p>
        </section>
    </main>
    <script src="js/script.js?v=20260508-2"></script>
</body>
</html>
