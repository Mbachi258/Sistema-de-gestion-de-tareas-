# TaskFlow Enterprise

Proyecto Java Web para gestion de tareas empresariales, organizado con MVC clasico:

- `controller`: Servlets que reciben peticiones y seleccionan vistas.
- `dao`: Acceso a datos con JDBC directo.
- `model`: Entidades del dominio.
- `util`: Conexion MySQL y utilidades.
- `WEB-INF/views`: JSP internas protegidas del acceso directo.

## Base de datos

Ejecuta el archivo `BD script` en MySQL. El proyecto espera MySQL de XAMPP en:

`localhost:3308`

Credenciales configuradas por defecto:

- Usuario: `root`
- Contrasena: vacia

Usuarios de prueba:

- `admin@empresa.com` / `admin123`
- `carlos@empresa.com` / `usuario123`

## Roles

- Administrador: ve la operacion completa, asigna tareas y puede actualizar avances.
- Usuario: ve sus tareas asignadas y actualiza progreso/comentarios.

## Ejecucion

1. Inicia MySQL desde XAMPP en el puerto `3308`.
2. Abre el proyecto `is` en NetBeans.
3. Ejecuta con Tomcat.
4. Abre `http://localhost:8080/is/`.
