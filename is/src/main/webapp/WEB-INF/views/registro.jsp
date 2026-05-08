<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro - Gestión de Tareas</title>
    <base href="<%= request.getContextPath() %>/">
    <link rel="stylesheet" href="css/estilo.css?v=20260508-2">
</head>
<body class="auth-page">
    <main class="auth-shell">
        <section class="auth-card">
            <a class="brand auth-brand" href="./">Gestión de Tareas</a>
            <h1>Crea tu cuenta</h1>
            <p>El registro crea un usuario activo con rol de usuario.</p>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error"><%= request.getAttribute("error") %></div>
            <% } %>

            <form class="form-stack" action="registro" method="post">
                <label for="nombre">Nombre completo</label>
                <input type="text" id="nombre" name="nombre" placeholder="Tu nombre" required>

                <label for="email">Email</label>
                <input type="email" id="email" name="email" placeholder="usuario@empresa.com" required>

                <label for="password">Contraseña</label>
                <input type="password" id="password" name="password" placeholder="Mínimo 6 caracteres" required>

                <label for="confirmarPassword">Confirmar contraseña</label>
                <input type="password" id="confirmarPassword" name="confirmarPassword" placeholder="Repite la contraseña" required>

                <button class="button button-primary full-width" type="submit">Crear cuenta</button>
            </form>

            <p class="form-footer">¿Ya tienes cuenta? <a href="login">Ingresa</a></p>
        </section>
    </main>
    <script src="js/script.js?v=20260508-2"></script>
</body>
</html>
