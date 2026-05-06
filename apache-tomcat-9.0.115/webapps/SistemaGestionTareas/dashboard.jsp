<%-- DASHBOARD - SOLO TARJETAS DE INFORMACIÓN CONCEPTUAL --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="com.sena.gestion.model.Usuario" %>

<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    boolean esAdmin = "Administrador".equals(user.getRol());
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Sistema de Gestión</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
            min-height: 100vh;
            display: flex;
        }

        /* MAIN CONTENT */
        .main-content {
            margin-left: 300px;
            width: calc(100% - 300px);
            min-height: 100vh;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
        }

        .page-header {
            background: white;
            padding: 35px 40px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-left: 0;
            border-bottom: 4px solid #7c3aed;
            margin-bottom: 30px;
        }

        .page-header h1 {
            color: #2c3e50;
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .page-header p {
            color: #7f8c8d;
            font-size: 1rem;
        }

        .content-area {
            padding: 0 40px 40px 40px;
        }

        /* CONCEPT CARDS */
        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 25px;
        }

        .concept-card {
            background: white;
            padding: 28px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            border-left: 6px solid #7c3aed;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            cursor: default;
            min-height: 200px;
            justify-content: center;
        }

        .concept-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

        .concept-card::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 80px;
            height: 80px;
            background: rgba(124, 58, 237, 0.08);
            border-radius: 0 12px 0 50px;
            z-index: 0;
        }

        .concept-card h3 {
            color: #2c3e50;
            font-size: 1.35rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 12px;
            position: relative;
            z-index: 1;
            font-weight: 600;
        }

        .concept-card p {
            color: #555;
            font-size: 0.95rem;
            line-height: 1.7;
            margin-bottom: 0;
            position: relative;
            z-index: 1;
        }

        /* Botones ocultos - Tarjetas solo informativas */
        .card-buttons {
            display: none;
        }

        /* COLORES POR TARJETA */
        .blue { border-left-color: #3b82f6; }
        .blue::before { background: rgba(59, 130, 246, 0.08); }
        .blue h3 i { color: #3b82f6; }

        .green { border-left-color: #10b981; }
        .green::before { background: rgba(16, 185, 129, 0.08); }
        .green h3 i { color: #10b981; }

        .orange { border-left-color: #f59e0b; }
        .orange::before { background: rgba(245, 158, 11, 0.08); }
        .orange h3 i { color: #f59e0b; }

        .pink { border-left-color: #ec4899; }
        .pink::before { background: rgba(236, 72, 153, 0.08); }
        .pink h3 i { color: #ec4899; }

        /* Responsive */
        @media (max-width: 1024px) {
            .cards-grid {
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                width: 100%;
            }

            .page-header {
                padding: 25px 20px;
            }

            .page-header h1 {
                font-size: 1.8rem;
            }

            .content-area {
                padding: 0 20px 30px 20px;
            }

            .cards-grid {
                grid-template-columns: 1fr;
            }

            .card-buttons {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>

<body>
    <jsp:include page="components/header.jsp" />

    <div class="main-content">
        <div class="page-header">
            <h1>Panel de Control</h1>
            <p>Gestiona tus tareas y actividades de manera eficiente</p>
        </div>

        <div class="content-area">
            <div class="cards-grid">
                <!-- TAREAS -->
                <div class="concept-card">
                    <h3><i class="fas fa-check-circle"></i> Tareas</h3>
                    <p>Gestiona tus pendientes y organiza tu día a día de manera eficiente. Crea nuevas tareas, asigna prioridades y realiza un seguimiento de tu progreso.</p>
                </div>

                <!-- ACTIVIDADES -->
                <div class="concept-card blue">
                    <h3><i class="fas fa-project-diagram">hhhh</i> Actividades</h3>
                    <p>Agrupa tus tareas en proyectos para un seguimiento detallado de tus objetivos. Organiza mejor tu trabajo mediante actividades relacionadas.</p>
                </div>

                <% if (esAdmin) { %>
                    <!-- REPORTES (ADMIN) -->
                    <div class="concept-card green">
                        <h3><i class="fas fa-chart-bar"></i> Reportes</h3>
                        <p>Visualiza estadísticas y métricas del sistema para una mejor toma de decisiones. Analiza el desempeño y productividad de tu equipo.</p>
                    </div>

                    <!-- CATEGORÍAS (ADMIN) -->
                    <div class="concept-card orange">
                        <h3><i class="fas fa-tags"></i> Categorías</h3>
                        <p>Administra las categorías del sistema para una mejor organización. Define y personaliza las categorías según tus necesidades.</p>
                    </div>

                    <!-- USUARIOS (ADMIN) -->
                    <div class="concept-card pink">
                        <h3><i class="fas fa-users"></i> Usuarios</h3>
                        <p>Administra los usuarios del sistema y sus permisos de acceso. Controla quién puede acceder a qué información.</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <script>
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('res') === 'ok') {
            Swal.fire({
                icon: 'success',
                title: '¡Hecho!',
                text: 'Operación realizada con éxito.',
                confirmButtonColor: '#7c3aed'
            });
        }
    </script>
</body>
</html>