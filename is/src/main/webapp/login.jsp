<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Sistema de Tareas</title>
    <!-- Bootstrap 5 CSS (CDN) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome (iconos) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Estilos personalizados -->
    <link rel="stylesheet" href="css/estilo.css">
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card login-card fade-in">
                    <div class="card-header login-card-header">
                        <i class="fas fa-tasks fa-2x mb-2"></i>
                        <h3 class="mb-0">Sistema de Gestión de Tareas</h3>
                        <small>Inicia sesión para continuar</small>
                    </div>
                    <div class="card-body p-4">
                        
                        <!-- Mostrar mensajes de error -->
                        <%
                            String error = request.getParameter("error");
                            if (error != null) {
                                String mensaje = "";
                                String tipo = "danger";
                                switch (error) {
                                    case "empty":
                                        mensaje = "❌ Email y contraseña son obligatorios";
                                        break;
                                    case "password":
                                        mensaje = "❌ Contraseña incorrecta";
                                        break;
                                    case "notfound":
                                        mensaje = "❌ Usuario no encontrado";
                                        break;
                                    case "inactive":
                                        mensaje = "❌ Usuario inactivo, contacte al administrador";
                                        break;
                                    case "system":
                                        mensaje = "❌ Error del sistema, intente más tarde";
                                        break;
                                    default:
                                        mensaje = "❌ Error al iniciar sesión";
                                }
                                if (!mensaje.isEmpty()) {
                                    out.println("<div class='alert alert-" + tipo + " alert-dismissible fade show alert-custom' role='alert'>");
                                    out.println(mensaje);
                                    out.println("<button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>");
                                    out.println("</div>");
                                }
                            }
                        %>
                        
                        <!-- Formulario de Login -->
                        <form action="login" method="post">
                            <div class="mb-3">
                                <label for="email" class="form-label">
                                    <i class="fas fa-envelope"></i> Correo Electrónico
                                </label>
                                <input type="email" 
                                       class="form-control" 
                                       id="email" 
                                       name="email" 
                                       placeholder="usuario@ejemplo.com"
                                       required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">
                                    <i class="fas fa-lock"></i> Contraseña
                                </label>
                                <div class="position-relative">
                                    <input type="password" 
                                           class="form-control" 
                                           id="password" 
                                           name="password" 
                                           placeholder="••••••••"
                                           required>
                                    <i class="fas fa-eye position-absolute" 
                                       id="togglePassword" 
                                       style="right: 10px; top: 12px; cursor: pointer; opacity: 0.6;"></i>
                                </div>
                            </div>
                            <div class="mb-3 form-check">
                                <input type="checkbox" class="form-check-input" id="remember">
                                <label class="form-check-label" for="remember">Recordarme</label>
                            </div>
                            <button type="submit" class="btn btn-primary btn-gradient" id="submitBtn">
                                <i class="fas fa-sign-in-alt"></i> Ingresar
                            </button>
                        </form>
                        
                        <hr class="my-4">
                        
                       
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Script personalizado -->
    <script src="js/script.js"></script>
</body>
</html>
