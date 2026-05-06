<%-- HEADER/SIDEBAR COMPARTIDO - REUTILIZABLE EN TODAS LAS VISTAS --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="com.sena.gestion.model.Usuario" %>

<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    boolean esAdmin = "Administrador".equals(user.getRol());

    String requestURI = request.getRequestURI();
    String currentPage = "inicio";

    if (requestURI.contains("dashboard.jsp")) {
        currentPage = "inicio";
    } else if (requestURI.contains("listar-tareas.jsp") || requestURI.contains("formulario-tarea.jsp")) {
        currentPage = "tareas";
    } else if (requestURI.contains("listar-actividades.jsp") || requestURI.contains("formulario-actividad.jsp") || requestURI.contains("ver-actividad.jsp") || requestURI.contains("mis-actividades.jsp")) {
        currentPage = "actividades";
    } else if (requestURI.contains("reportes.jsp")) {
        currentPage = "reportes";
    } else if (requestURI.contains("gestion_categorias.jsp")) {
        currentPage = "categorias";
    } else if (requestURI.contains("registro_usuario.jsp")) {
        currentPage = "usuarios";
    } else if (requestURI.contains("Novedades.jsp") || requestURI.contains("NovedadServlet")) {
        currentPage = "novedades";
    }
%>

<style>
    .sidebar {
        width: 300px;
        background: linear-gradient(180deg, #7c3aed 0%, #5b21b6 100%);
        position: fixed;
        height: 100vh;
        overflow-y: auto;
        box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        z-index: 1000;
    }

    .sidebar-header {
        padding: 30px 20px;
        color: white;
        border-bottom: 1px solid rgba(255,255,255,0.1);
    }

    .sidebar-header h2 {
        font-size: 1.3rem;
        font-weight: 600;
        letter-spacing: 0.5px;
        margin: 0;
    }

    .user-profile {
        padding: 15px 25px;
        border-bottom: 1px solid rgba(255,255,255,0.1);
        color: white;
    }

    .nav-menu {
        padding: 20px 0;
    }

    .nav-item {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 15px 25px;
        color: rgba(255,255,255,0.9);
        text-decoration: none;
        transition: all 0.3s;
        font-size: 0.95rem;
    }

    .nav-item:hover {
        background: rgba(255,255,255,0.1);
        color: white;
    }

    .nav-item.active {
        background: rgba(255,255,255,0.15);
        color: white;
        border-left: 4px solid white;
    }

    .nav-item i {
        font-size: 1.1rem;
        width: 25px;
    }

    .nav-divider {
        height: 1px;
        background: rgba(255,255,255,0.1);
        margin: 15px 20px;
    }

    .logout-btn {
        background: rgba(239, 68, 68, 0.2) !important;
        color: white !important;
        margin: 10px 20px;
        border-radius: 8px;
    }

    .main-content {
        margin-left: 300px;
        width: calc(100% - 300px);
        min-height: 100vh;
    }

    @media (max-width: 768px) {
        .sidebar {
            width: 100%;
            position: relative;
            height: auto;
        }
        .main-content {
            margin-left: 0;
            width: 100%;
        }
    }
</style>

<div class="sidebar">
    <div class="sidebar-header">
        <h2>GESTIÓN DE TAREAS</h2>
    </div>

    <div class="user-profile">
        <div style="font-size: 0.9rem;">Bienvenido, <br><strong><%= user.getUsername() %></strong></div>
        <div style="font-size: 0.75rem; color: rgba(255,255,255,0.7);"><%= user.getRol() %></div>
    </div>

    <nav class="nav-menu">
        <a href="dashboard.jsp" class="nav-item <%= "inicio".equals(currentPage) ? "active" : "" %>">
            <i class="fas fa-home"></i><span>Inicio</span>
        </a>
        <a href="Tareaservlet?accion=listar" class="nav-item <%= "tareas".equals(currentPage) ? "active" : "" %>">
            <i class="fas fa-clipboard-list"></i><span>Tareas</span>
        </a>
        <a href="ActividadServlet?accion=listar" class="nav-item <%= "actividades".equals(currentPage) ? "active" : "" %>">
            <i class="fas fa-folder"></i><span>Actividades</span>
        </a>

        <%-- Novedades: solo visible para Administrador --%>
        <% if (esAdmin) { %>
            <a href="NovedadServlet?accion=listar" class="nav-item <%= "novedades".equals(currentPage) ? "active" : "" %>">
                <i class="fas fa-exclamation-circle"></i><span>Novedades</span>
            </a>
        <% } %>

        <% if (esAdmin) { %>
            <div class="nav-divider"></div>
            <a href="Reportesservlet?vista=reportes" class="nav-item <%= "reportes".equals(currentPage) ? "active" : "" %>">
                <i class="fas fa-chart-bar"></i><span>Reportes</span>
            </a>
            <a href="Categoriaservlet?accion=listar" class="nav-item <%= "categorias".equals(currentPage) ? "active" : "" %>">
                <i class="fas fa-tags"></i><span>Categorías</span>
            </a>
            <a href="registro_usuario.jsp" class="nav-item <%= "usuarios".equals(currentPage) ? "active" : "" %>">
                <i class="fas fa-users"></i><span>Usuarios</span>
            </a>
        <% } %>

        <div class="nav-divider"></div>
        <a href="index.jsp" class="nav-item logout-btn">
            <i class="fas fa-power-off"></i><span>Cerrar Sesión</span>
        </a>
    </nav>
</div>
