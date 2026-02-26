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
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; min-height: 100vh; display: flex; }

        /* SIDEBAR */
        .sidebar {
            width: 300px; background: linear-gradient(180deg, #7c3aed 0%, #5b21b6 100%);
            position: fixed; height: 100vh; overflow-y: auto; box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }
        .sidebar-header { padding: 30px 20px; color: white; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .sidebar-header h2 { font-size: 1.3rem; font-weight: 600; letter-spacing: 0.5px; }
        .user-profile { padding: 15px 25px; border-bottom: 1px solid rgba(255,255,255,0.1); color: white; }
        .nav-menu { padding: 20px 0; }
        .nav-item {
            display: flex; align-items: center; gap: 12px; padding: 15px 25px;
            color: rgba(255,255,255,0.9); text-decoration: none; transition: all 0.3s; font-size: 0.95rem;
        }
        .nav-item:hover { background: rgba(255,255,255,0.1); color: white; }
        .nav-item.active { background: rgba(255,255,255,0.15); color: white; border-left: 4px solid white; }
        .nav-item i { font-size: 1.1rem; width: 25px; }
        .nav-divider { height: 1px; background: rgba(255,255,255,0.1); margin: 15px 20px; }
        .logout-btn { background: rgba(239, 68, 68, 0.2) !important; color: white !important; margin: 10px 20px; border-radius: 8px; }

        /* MAIN CONTENT */
        .main-content { margin-left: 300px; width: calc(100% - 300px); min-height: 100vh; }
        .page-header { background: white; padding: 30px 40px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .page-header h1 { color: #7c3aed; font-size: 2rem; font-weight: 700; }
        .content-area { padding: 40px; }

        /* CONCEPT CARDS */
        .cards-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 25px; }
        .concept-card {
            background: white; padding: 30px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-left: 4px solid #7c3aed; text-decoration: none; transition: transform 0.2s;
        }
        .concept-card:hover { transform: translateY(-5px); }
        .concept-card h3 { color: #333; font-size: 1.2rem; margin-bottom: 10px; display: flex; align-items: center; gap: 10px; }
        .concept-card p { color: #666; font-size: 0.95rem; line-height: 1.6; }
        .blue { border-left-color: #3b82f6; }
        .green { border-left-color: #10b981; }
    </style>
</head>

<body>
    <div class="sidebar">
        <div class="sidebar-header"><h2>GESTIÓN DE TAREAS</h2></div>
        <div class="user-profile">
            <div style="font-size: 0.9rem;">Bienvenido, <br><strong><%= user.getUsername() %></strong></div>
            <div style="font-size: 0.75rem; color: rgba(255,255,255,0.7);"><%= user.getRol() %></div>
        </div>
        <nav class="nav-menu">
            <a href="dashboard.jsp" class="nav-item active"><i class="fas fa-home"></i><span>Inicio</span></a>
            <a href="Tareaservlet?accion=listar" class="nav-item"><i class="fas fa-clipboard-list"></i><span>Tareas</span></a>
            <a href="ActividadServlet?accion=listar" class="nav-item"><i class="fas fa-folder"></i><span>Actividades</span></a>
            <% if (esAdmin) { %>
                <a href="Reportesservlet" class="nav-item"><i class="fas fa-chart-bar"></i><span>Reportes</span></a>
                <a href="Categoriaservlet?accion=listar" class="nav-item"><i class="fas fa-tags"></i><span>Categorías</span></a>
                <a href="registro_usuario.jsp" class="nav-item"><i class="fas fa-users"></i><span>Usuarios</span></a>
            <% } %>
            <div class="nav-divider"></div>
            <a href="index.jsp" class="nav-item logout-btn"><i class="fas fa-power-off"></i><span>Cerrar Sesión</span></a>
        </nav>
    </div>

    <div class="main-content">
        <div class="page-header">
            <h1>Hola, <%= user.getUsername() %> 👋</h1>
        </div>

        <div class="content-area">
            <div class="cards-grid">
                <div class="concept-card">
                    <h3><i class="fas fa-check-circle" style="color: #7c3aed;"></i> Tareas</h3>
                    <p>Gestiona tus pendientes y organiza tu día a día de manera eficiente.</p>
                </div>
                <div class="concept-card blue">
                    <h3><i class="fas fa-project-diagram" style="color: #3b82f6;"></i> Actividades</h3>
                    <p>Agrupa tus tareas en proyectos para un seguimiento detallado de tus objetivos.</p>
                </div>
                <% if (esAdmin) { %>
                <div class="concept-card green">
                    <h3><i class="fas fa-user-shield" style="color: #10b981;"></i> Administrador</h3>
                    <p>Acceso total a la configuración del sistema, gestión de usuarios y métricas.</p>
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