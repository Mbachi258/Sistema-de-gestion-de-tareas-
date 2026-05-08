<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro - TaskFlow Enterprise</title>
    <base href="<%= request.getContextPath() %>/">
    <link rel="stylesheet" href="css/estilo.css?v=20260508-5">
</head>
<body class="auth-page">
    <main class="auth-shell">
        <section class="auth-card">
            <a class="brand auth-brand" href="./">TaskFlow Enterprise</a>
            <h1>Solicita tu acceso</h1>
            <p>Ingresa tus datos para comenzar a organizar el trabajo de tu equipo.</p>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error"><%= request.getAttribute("error") %></div>
            <% } %>

            <form class="form-stack" action="registro" method="post">
                <label for="nombre">Nombre completo</label>
                <input type="text" id="nombre" name="nombre" placeholder="Tu nombre" required>

                <label for="email">Email</label>
                <input type="email" id="email" name="email" placeholder="usuario@empresa.com" required>

                <label for="password">Contrasena</label>
                <input type="password" id="password" name="password" placeholder="Minimo 6 caracteres" required>

                <label for="confirmarPassword">Confirmar contrasena</label>
                <input type="password" id="confirmarPassword" name="confirmarPassword" placeholder="Repite la contrasena" required>

                <button class="button button-primary full-width" type="submit">Solicitar acceso</button>
            </form>

            <p class="form-footer">Ya tienes cuenta? <a href="login">Ingresa</a></p>
        </section>
    </main>
    <script src="js/script.js?v=20260508-5"></script>
</body>
</html>
