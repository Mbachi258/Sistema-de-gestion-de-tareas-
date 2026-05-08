<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ingresar - TaskFlow Enterprise</title>
    <base href="<%= request.getContextPath() %>/">
    <link rel="stylesheet" href="css/estilo.css?v=20260508-5">
</head>
<body class="auth-page">
    <main class="auth-shell">
        <section class="auth-card">
            <a class="brand auth-brand" href="./">TaskFlow Enterprise</a>
            <h1>Ingresa a tu panel</h1>
            <p>Usa tu email y contrasena para continuar.</p>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getAttribute("exito") != null) { %>
                <div class="alert alert-success"><%= request.getAttribute("exito") %></div>
            <% } %>

            <form class="form-stack" action="login" method="post">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" placeholder="usuario@empresa.com" required>

                <label for="password">Contrasena</label>
                <div class="password-field">
                    <input type="password" id="password" name="password" placeholder="Tu contrasena" required>
                    <button type="button" class="icon-button" data-toggle-password aria-label="Mostrar contrasena">Ver</button>
                </div>

                <button class="button button-primary full-width" type="submit">Ingresar</button>
            </form>

            <p class="form-footer">No tienes cuenta? <a href="registro">Solicita acceso</a></p>
        </section>
    </main>
    <script src="js/script.js?v=20260508-5"></script>
</body>
</html>
