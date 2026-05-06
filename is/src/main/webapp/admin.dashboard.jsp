<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Gestión de Tareas</title>
    
    <!-- Frameworks de Estilo (CDNs) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        /* Estilos basados en la referencia visual del compañero */
        body { 
            background-color: #f1f4f9; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
        }

        /* Tarjetas de Resumen (Superiores) */
        .card-custom {
            background: white;
            border: none;
            border-radius: 10px;
            padding: 15px 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            border-left: 6px solid #4a90e2; /* Color azul de la imagen */
            height: 100%;
            transition: transform 0.2s;
        }

        .card-custom:hover {
            transform: translateY(-3px);
        }

        .card-title-custom {
            font-size: 0.75rem;
            font-weight: 700;
            color: #666;
            text-transform: uppercase;
            margin-bottom: 8px;
            letter-spacing: 0.5px;
        }

        .card-value-custom {
            font-size: 1.8rem;
            font-weight: 800;
            margin: 0;
            color: #1a1a1a;
        }

        /* Contenedores de Secciones (Inferiores) */
        .section-container {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            height: 100%;
        }

        .section-title {
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 20px;
            color: #2c3e50;
        }

        /* Estilo de la Tabla de Equipos */
        .table thead th {
            font-size: 0.85rem;
            text-transform: capitalize;
            color: #444;
            background-color: transparent;
            border-bottom: 2px solid #f1f4f9;
            padding-bottom: 12px;
        }

        .table tbody td {
            padding: 15px 8px;
            font-size: 0.95rem;
        }

        .badge-sync {
            background-color: #2d8a61; /* Verde esmeralda de la imagen */
            color: white;
            font-weight: 500;
            padding: 5px 12px;
            border-radius: 6px;
            font-size: 0.8rem;
        }

        .icon-box {
            color: #4a90e2;
            margin-right: 12px;
            font-size: 1.1rem;
        }
    </style>
</head>
<body class="p-4">

    <div class="container-fluid">
        <!-- Encabezado -->
        <div class="mb-4">
            <h2 class="fw-bold mb-1">Resumen de Actividad</h2>
            <p class="text-muted small">Estado global de la base de datos: <strong>gestion_tareas</strong></p>
        </div>

        <!-- Fila de Tarjetas de Estadísticas -->
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="card-custom">
                    <p class="card-title-custom">USUARIOS TOTALES</p>
                    <p class="card-value-custom">3</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card-custom">
                    <p class="card-title-custom">TAREAS PENDIENTES</p>
                    <p class="card-value-custom">3</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card-custom">
                    <p class="card-title-custom">GRUPOS ACTIVOS</p>
                    <p class="card-value-custom">2</p>
                </div>
            </div>
        </div>

        <!-- Fila de Gráficos y Tablas -->
        <div class="row g-4">
            <!-- Gráfico de Prioridades -->
            <div class="col-md-4">
                <div class="section-container">
                    <h5 class="section-title">Prioridades</h5>
                    <div style="position: relative; height:250px;">
                        <canvas id="prioridadChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Tabla de Equipos -->
            <div class="col-md-8">
                <div class="section-container">
                    <h5 class="section-title">Distribución por Equipos</h5>
                    <div class="table-responsive">
                        <table class="table align-middle table-hover">
                            <thead>
                                <tr>
                                    <th>Grupo</th>
                                    <th>Miembros</th>
                                    <th>Estado BD</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><i class="fas fa-code icon-box"></i> Desarrollo Java</td>
                                    <td>2 Usuarios</td>
                                    <td><span class="badge badge-sync">Sincronizado</span></td>
                                </tr>
                                <tr>
                                    <td><i class="fas fa-paint-brush icon-box" style="color: #4dc3ff;"></i> Diseño UI/UX</td>
                                    <td>1 Usuario</td>
                                    <td><span class="badge badge-sync">Sincronizado</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Script para generar el gráfico -->
    <script>
        const ctx = document.getElementById('prioridadChart').getContext('2d');
        new Chart(ctx, {
            type: 'pie',
            data: {
                labels: ['Alta', 'Media', 'Baja'],
                datasets: [{
                    data: [2, 2, 1], // Datos de ejemplo basados en tu SQL
                    backgroundColor: [
                        '#e74c3c', // Rojo
                        '#f39c12', // Naranja/Amarillo
                        '#2ecc71'  // Verde
                    ],
                    borderWidth: 3,
                    borderColor: '#ffffff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top',
                        align: 'end',
                        labels: {
                            boxWidth: 15,
                            font: { size: 12 }
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>