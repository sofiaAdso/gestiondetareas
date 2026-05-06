<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sena.gestion.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) { response.sendRedirect("index.jsp"); return; }

    // ✅ Bloquear acceso a usuarios que no sean Administrador
    boolean isAdmin = "Administrador".equals(user.getRol());
    if (!isAdmin) { response.sendRedirect("dashboard.jsp"); return; }

    // Lista de novedades cargadas por el servlet (NovedadServlet?accion=listar)
    List<Novedad> listaNovedades = (List<Novedad>) request.getAttribute("listaNovedades");
    if (listaNovedades == null) listaNovedades = new ArrayList<>();

    // Mensaje de éxito o error tras guardar
    String msg   = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Novedades | Gestión SENA</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=DM+Serif+Display&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        :root {
            --primary: #667eea;
            --primary-dark: #764ba2;
            --bg: #f4f5fb;
            --card: #ffffff;
            --text: #1a1a2e;
            --muted: #6b7280;
            --border: #e5e7ef;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --info: #3b82f6;
            --radius: 14px;
            --shadow: 0 4px 24px rgba(102,126,234,0.10);
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--bg);
            color: var(--text);
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            margin-left: 300px;
            width: calc(100% - 300px);
            padding: 36px 40px;
            min-height: 100vh;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
        }
        .page-title {
            font-family: 'DM Serif Display', serif;
            font-size: 2rem;
            color: var(--primary);
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .page-title i { font-size: 1.6rem; }

        .btn-nueva {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            border: none;
            border-radius: var(--radius);
            font-family: 'DM Sans', sans-serif;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 4px 16px rgba(102,126,234,0.30);
            transition: all 0.25s ease;
            text-decoration: none;
        }
        .btn-nueva:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(102,126,234,0.40); }

        .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 32px;
        }
        .stat-card {
            background: var(--card);
            border-radius: var(--radius);
            padding: 20px 24px;
            box-shadow: var(--shadow);
            border-left: 4px solid var(--primary);
            display: flex;
            align-items: center;
            gap: 16px;
            transition: transform 0.2s;
        }
        .stat-card:hover { transform: translateY(-3px); }
        .stat-card.warn  { border-left-color: var(--warning); }
        .stat-card.ok    { border-left-color: var(--success); }
        .stat-card.crit  { border-left-color: var(--danger); }
        .stat-icon {
            width: 46px; height: 46px;
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.2rem;
            flex-shrink: 0;
        }
        .stat-card .stat-icon       { background: rgba(102,126,234,0.12); color: var(--primary); }
        .stat-card.warn .stat-icon  { background: rgba(245,158,11,0.12);  color: var(--warning); }
        .stat-card.ok   .stat-icon  { background: rgba(16,185,129,0.12);  color: var(--success); }
        .stat-card.crit .stat-icon  { background: rgba(239,68,68,0.12);   color: var(--danger);  }
        .stat-value { font-size: 1.75rem; font-weight: 700; line-height: 1; }
        .stat-label { font-size: 0.8rem; color: var(--muted); margin-top: 4px; }

        .table-card {
            background: var(--card);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
        }
        .table-toolbar {
            padding: 20px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border);
            gap: 16px;
            flex-wrap: wrap;
        }
        .table-toolbar h3 { font-weight: 600; font-size: 1.05rem; }
        .search-box {
            display: flex;
            align-items: center;
            gap: 8px;
            background: var(--bg);
            border: 2px solid var(--border);
            border-radius: 10px;
            padding: 8px 14px;
            transition: border-color 0.2s;
        }
        .search-box:focus-within { border-color: var(--primary); }
        .search-box input {
            border: none; background: transparent; outline: none;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.9rem; width: 220px; color: var(--text);
        }
        .search-box i { color: var(--muted); }

        table { width: 100%; border-collapse: collapse; }
        thead tr { background: var(--bg); }
        th {
            padding: 13px 18px;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.06em;
            text-align: left;
        }
        td {
            padding: 14px 18px;
            font-size: 0.88rem;
            border-bottom: 1px solid var(--border);
            vertical-align: middle;
        }
        tr:last-child td { border-bottom: none; }
        tbody tr { transition: background 0.15s; }
        tbody tr:hover { background: rgba(102,126,234,0.04); }

        .badge {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 4px 10px; border-radius: 20px;
            font-size: 0.75rem; font-weight: 600;
        }
        .badge-ambiente  { background: rgba(59,130,246,0.12);  color: var(--info); }
        .badge-equipo    { background: rgba(245,158,11,0.12);  color: var(--warning); }
        .badge-material  { background: rgba(16,185,129,0.12);  color: var(--success); }
        .badge-biblioteca{ background: rgba(102,126,234,0.12); color: var(--primary); }
        .badge-apto      { background: rgba(16,185,129,0.15);  color: #059669; }
        .badge-noapto    { background: rgba(239,68,68,0.12);   color: var(--danger); }

        .table-actions { display: flex; gap: 6px; }
        .btn-icon {
            width: 32px; height: 32px;
            border-radius: 8px; border: none; cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.8rem; transition: all 0.2s;
        }
        .btn-icon.view   { background: rgba(59,130,246,0.10);  color: var(--info); }
        .btn-icon.del    { background: rgba(239,68,68,0.10);   color: var(--danger); }
        .btn-icon.print  { background: rgba(102,126,234,0.10); color: var(--primary); }
        .btn-icon:hover  { transform: scale(1.15); }

        .empty-state {
            text-align: center; padding: 80px 20px; color: var(--muted);
        }
        .empty-state i { font-size: 3.5rem; margin-bottom: 16px; opacity: 0.3; display: block; }
        .empty-state p { font-size: 1rem; }

        .modal-overlay {
            display: none;
            position: fixed; inset: 0; z-index: 1000;
            background: rgba(10,10,30,0.55);
            backdrop-filter: blur(4px);
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .modal-overlay.active { display: flex; animation: fadeIn 0.25s ease; }
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }

        .modal-box {
            background: white;
            border-radius: 20px;
            width: 100%;
            max-width: 740px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 30px 80px rgba(0,0,0,0.25);
            animation: slideUp 0.3s cubic-bezier(.16,1,.3,1);
        }
        @keyframes slideUp { from { transform: translateY(40px); opacity:0; } to { transform: translateY(0); opacity:1; } }

        .modal-header {
            padding: 28px 32px 20px;
            border-bottom: 1px solid var(--border);
            display: flex; justify-content: space-between; align-items: center;
            position: sticky; top: 0; background: white; z-index: 1;
            border-radius: 20px 20px 0 0;
        }
        .modal-header h2 {
            font-family: 'DM Serif Display', serif;
            font-size: 1.4rem; color: var(--primary);
            display: flex; align-items: center; gap: 10px;
        }
        .modal-close {
            width: 36px; height: 36px; border-radius: 50%;
            border: 2px solid var(--border); background: white;
            cursor: pointer; font-size: 1rem; color: var(--muted);
            display: flex; align-items: center; justify-content: center;
            transition: all 0.2s;
        }
        .modal-close:hover { background: var(--danger); color: white; border-color: var(--danger); }

        .modal-body { padding: 28px 32px; }

        .form-section {
            background: var(--bg);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .form-section-title {
            font-size: 0.78rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--primary);
            margin-bottom: 16px;
            display: flex; align-items: center; gap: 8px;
        }
        .form-section-title::after {
            content: ''; flex: 1; height: 1px; background: var(--border);
        }

        .fila { display: grid; gap: 16px; margin-bottom: 16px; }
        .fila.col2 { grid-template-columns: 1fr 1fr; }
        .fila.col3 { grid-template-columns: 1fr 1fr 1fr; }

        .fgroup { display: flex; flex-direction: column; gap: 6px; }
        .fgroup label { font-size: 0.8rem; font-weight: 600; color: #444; }
        .fgroup input, .fgroup select, .fgroup textarea {
            padding: 10px 14px;
            border: 2px solid var(--border);
            border-radius: 10px;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.88rem;
            color: var(--text);
            background: white;
            transition: border-color 0.2s;
            width: 100%;
        }
        .fgroup input:focus, .fgroup select:focus, .fgroup textarea:focus {
            border-color: var(--primary); outline: none;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.10);
        }
        .fgroup input:invalid:not(:placeholder-shown),
        .fgroup select:invalid,
        .fgroup textarea:invalid:not(:placeholder-shown) {
            border-color: var(--danger);
            box-shadow: 0 0 0 3px rgba(239,68,68,0.10);
        }
        .fgroup input:valid:not(:placeholder-shown),
        .fgroup textarea:valid:not(:placeholder-shown) {
            border-color: var(--success);
        }
        .fgroup textarea { resize: vertical; min-height: 70px; }

        .viabilidad-toggle { display: flex; gap: 10px; }
        .viab-btn {
            flex: 1; padding: 12px; border-radius: 10px;
            border: 2px solid var(--border); background: white;
            font-family: 'DM Sans', sans-serif; font-weight: 600;
            font-size: 0.88rem; cursor: pointer; transition: all 0.2s;
            display: flex; align-items: center; justify-content: center; gap: 8px;
        }
        .viab-btn.apto   { color: var(--success); }
        .viab-btn.noapto { color: var(--danger); }
        .viab-btn.apto.active   { background: var(--success); color: white; border-color: var(--success); }
        .viab-btn.noapto.active { background: var(--danger);  color: white; border-color: var(--danger); }

        .firmas-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .firma-box {
            border: 2px dashed var(--border); border-radius: 12px;
            padding: 16px; text-align: center;
        }
        .firma-box label { font-size: 0.78rem; color: var(--muted); display: block; margin-bottom: 8px; }
        .firma-box input {
            width: 100%; border: none; border-bottom: 2px solid var(--border);
            padding: 6px 4px; font-size: 0.88rem; background: transparent;
            outline: none; transition: border-color 0.2s;
        }
        .firma-box input:focus { border-bottom-color: var(--primary); }

        .modal-footer {
            padding: 20px 32px 28px;
            display: flex; gap: 12px; justify-content: flex-end;
            border-top: 1px solid var(--border);
        }
        .btn-cancel {
            padding: 11px 24px; border-radius: 10px;
            border: 2px solid var(--border); background: white;
            font-family: 'DM Sans', sans-serif; font-weight: 600;
            cursor: pointer; color: var(--muted); transition: all 0.2s;
        }
        .btn-cancel:hover { border-color: var(--danger); color: var(--danger); }
        .btn-save {
            padding: 11px 28px; border-radius: 10px; border: none;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white; font-family: 'DM Sans', sans-serif; font-weight: 700;
            cursor: pointer; box-shadow: 0 4px 14px rgba(102,126,234,0.35);
            display: flex; align-items: center; gap: 8px; transition: all 0.2s;
        }
        .btn-save:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(102,126,234,0.45); }

        .toast {
            position: fixed; bottom: 30px; right: 30px; z-index: 9999;
            background: white; border-radius: 14px; padding: 16px 22px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.15);
            display: flex; align-items: center; gap: 12px;
            font-weight: 500; font-size: 0.9rem;
            border-left: 4px solid var(--success);
            animation: toastIn 0.4s cubic-bezier(.16,1,.3,1);
        }
        .toast.error { border-left-color: var(--danger); }
        @keyframes toastIn { from { transform: translateX(120px); opacity:0; } to { transform: translateX(0); opacity:1; } }

        @media (max-width: 900px) {
            .main-content { margin-left: 0; width: 100%; padding: 20px; }
            .stats-row { grid-template-columns: 1fr 1fr; }
            .fila.col2, .fila.col3, .firmas-row { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <div class="main-content">

        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-clipboard-list"></i> Novedades
            </h1>
            <button class="btn-nueva" onclick="abrirModal()">
                <i class="fas fa-plus"></i> Reportar Novedad
            </button>
        </div>

        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-clipboard-list"></i></div>
                <div>
                    <div class="stat-value"><%= listaNovedades.size() %></div>
                    <div class="stat-label">Total novedades</div>
                </div>
            </div>
            <div class="stat-card warn">
                <div class="stat-icon"><i class="fas fa-tools"></i></div>
                <div>
                    <div class="stat-value" id="cntEquipos">0</div>
                    <div class="stat-label">Equipos / Mobiliario</div>
                </div>
            </div>
            <div class="stat-card crit">
                <div class="stat-icon"><i class="fas fa-ban"></i></div>
                <div>
                    <div class="stat-value" id="cntNoAptos">0</div>
                    <div class="stat-label">Ambientes no aptos</div>
                </div>
            </div>
            <div class="stat-card ok">
                <div class="stat-icon"><i class="fas fa-check-circle"></i></div>
                <div>
                    <div class="stat-value" id="cntAptos">0</div>
                    <div class="stat-label">Ambientes aptos</div>
                </div>
            </div>
        </div>

        <div class="table-card">
            <div class="table-toolbar">
                <h3><i class="fas fa-list" style="color:var(--primary);margin-right:8px;"></i>Registro de novedades</h3>
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" id="buscar" placeholder="Buscar novedad..." oninput="filtrarTabla()">
                </div>
            </div>

            <table id="tablaNovedades">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Ambiente</th>
                        <th>Programa</th>
                        <th>Tipo</th>
                        <th>Fecha</th>
                        <th>Viabilidad</th>
                        <th>Instructor</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody id="tbodyNovedades">
                <%
                    if (listaNovedades.isEmpty()) {
                %>
                    <tr>
                        <td colspan="8">
                            <div class="empty-state">
                                <i class="fas fa-clipboard"></i>
                                <p>No hay novedades registradas aún.</p>
                            </div>
                        </td>
                    </tr>
                <%
                    } else {
                        int idx = 1;
                        for (Novedad n : listaNovedades) {
                            String badgeTipo = "badge-ambiente";
                            if ("Equipos".equals(n.getTipoNovedad()))     badgeTipo = "badge-equipo";
                            if ("Materiales".equals(n.getTipoNovedad()))  badgeTipo = "badge-material";
                            if ("Biblioteca".equals(n.getTipoNovedad()))  badgeTipo = "badge-biblioteca";
                            String badgeViab = "Apto".equals(n.getViabilidad()) ? "badge-apto" : "badge-noapto";
                %>
                    <tr>
                        <td style="color:var(--muted);font-weight:600;"><%= idx++ %></td>
                        <td><strong><%= n.getAmbiente() %></strong><br><small style="color:var(--muted);"><%= n.getLocalizacion() %></small></td>
                        <td><%= n.getProgramaFormacion() %></td>
                        <td><span class="badge <%= badgeTipo %>"><%= n.getTipoNovedad() %></span></td>
                        <td><%= n.getFechaReporte() %></td>
                        <td><span class="badge <%= badgeViab %>"><i class="fas fa-<%= "Apto".equals(n.getViabilidad()) ? "check" : "times" %>"></i> <%= n.getViabilidad() %></span></td>
                        <td><%= n.getNombreInstructor() %></td>
                        <td>
                            <div class="table-actions">
                                <button class="btn-icon view" title="Ver detalle" onclick="verDetalle(<%= n.getId() %>)"><i class="fas fa-eye"></i></button>
                                <button class="btn-icon print" title="Imprimir formato" onclick="imprimirFormato(<%= n.getId() %>)"><i class="fas fa-print"></i></button>
                                <button class="btn-icon del" title="Eliminar" onclick="confirmarEliminar(<%= n.getId() %>)"><i class="fas fa-trash"></i></button>
                            </div>
                        </td>
                    </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

    <div class="modal-overlay" id="modalNovedad">
        <div class="modal-box">
            <div class="modal-header">
                <h2><i class="fas fa-file-alt"></i> Reporte de Novedad</h2>
                <button class="modal-close" onclick="cerrarModal()"><i class="fas fa-times"></i></button>
            </div>

            <form action="NovedadServlet" method="POST" id="formNovedad">
                <input type="hidden" name="accion" value="registrar">

                <div class="modal-body">

                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-info-circle"></i> Información General</div>
                        <div class="fila col2">
                            <div class="fgroup">
                                <label>Regional *</label>
                                <input type="text" name="regional" placeholder="Ej: Antioquia" required minlength="2" maxlength="50" pattern="[a-zA-ZáéíóúÁÉÍÓÚñÑ\s\-]*" title="Solo se permiten letras, espacios y guiones">
                            </div>
                            <div class="fgroup">
                                <label>Centro de Formación *</label>
                                <input type="text" name="centroFormacion" placeholder="Nombre del centro" required minlength="3" maxlength="100" pattern="[a-zA-ZáéíóúÁÉÍÓÚñÑ0-9\s\-\.]*" title="Solo se permiten letras, números, espacios, guiones y puntos">
                            </div>
                        </div>
                        <div class="fila col2">
                            <div class="fgroup">
                                <label>Programa de Formación *</label>
                                <input type="text" name="programaFormacion" placeholder="Nombre del programa" required minlength="3" maxlength="150" pattern="[a-zA-ZáéíóúÁÉÍÓÚñÑ0-9\s\-\.\y]*" title="Solo se permiten letras, números, espacios, guiones, puntos y 'y'">
                            </div>
                            <div class="fgroup">
                                <label>Código del Programa</label>
                                <input type="text" name="codigoPrograma" placeholder="Ej: 228110" pattern="\d*" maxlength="20">
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-door-open"></i> Identificación del Ambiente</div>
                        <div class="fila col3">
                            <div class="fgroup">
                                <label>Identificación del Ambiente *</label>
                                <input type="text" name="ambiente" placeholder="Ej: Aula 301" required minlength="2" maxlength="50" pattern="[a-zA-ZáéíóúÁÉÍÓÚñÑ0-9\s\-\.]*" title="Solo se permiten letras, números, espacios, guiones y puntos">
                            </div>
                            <div class="fgroup">
                                <label>Localización</label>
                                <input type="text" name="localizacion" placeholder="Bloque / Piso" maxlength="50" pattern="[a-zA-ZáéíóúÁÉÍÓÚñÑ0-9\s\-\.,/]*" title="Solo se permiten letras, números, espacios y caracteres de ubicación">
                            </div>
                            <div class="fgroup">
                                <label>Denominación</label>
                                <input type="text" name="denominacion" placeholder="Ej: Laboratorio de Sistemas" maxlength="100" pattern="[a-zA-ZáéíóúÁÉÍÓÚñÑ0-9\s\-\.]*" title="Solo se permiten letras, números, espacios, guiones y puntos">
                            </div>
                        </div>
                        <div class="fila col2">
                            <div class="fgroup">
                                <label>Tipo de Ambiente</label>
                                <select name="tipoAmbiente">
                                    <option value="Interno">Interno</option>
                                    <option value="Externo">Externo</option>
                                </select>
                            </div>
                            <div class="fgroup">
                                <label>Fecha del Reporte *</label>
                                <input type="date" name="fechaReporte" id="inputFecha" required>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-exclamation-triangle"></i> Identificación de Novedades</div>
                        <div class="fila col2">
                            <div class="fgroup">
                                <label>Tipo de Novedad *</label>
                                <select name="tipoNovedad" required onchange="actualizarPlaceholder(this)">
                                    <option value="">-- Seleccionar --</option>
                                    <option value="Ambiente">Ambiente, aula o laboratorio</option>
                                    <option value="Equipos">Equipos, máquinas y mobiliario</option>
                                    <option value="Materiales">Materiales de formación</option>
                                    <option value="Biblioteca">Biblioteca y bibliografía</option>
                                </select>
                            </div>
                            <div class="fgroup">
                                <label>Detalle de la Novedad *</label>
                                <textarea name="detalleNovedad" id="txtDetalle" placeholder="Describe la novedad presentada..." required minlength="10" maxlength="1000"></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-gavel"></i> Decisión sobre la Viabilidad de Uso</div>
                        <input type="hidden" name="viabilidad" id="inputViabilidad" value="Apto">
                        <div class="viabilidad-toggle">
                            <button type="button" class="viab-btn apto active" id="btnApto" onclick="setViabilidad('Apto')">
                                <i class="fas fa-check-circle"></i> APTO
                            </button>
                            <button type="button" class="viab-btn noapto" id="btnNoApto" onclick="setViabilidad('No Apto')">
                                <i class="fas fa-times-circle"></i> NO APTO
                            </button>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-signature"></i> Firmas</div>
                        <div class="firmas-row">
                            <div class="firma-box">
                                <label>Instructor que realiza el reporte</label>
                                <input type="text" name="nombreInstructor"
                                       value="<%= user.getNombre() %>" required minlength="3" maxlength="100" pattern="[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]*" title="Solo se permiten letras, espacios y acentos">
                                <small style="color:var(--muted);font-size:0.75rem;margin-top:6px;display:block;">Ciudad y fecha se toman del sistema</small>
                            </div>
                            <div class="firma-box">
                                <label>Coordinador que recibe el reporte</label>
                                <input type="text" name="nombreCoordinador" placeholder="Nombre del coordinador" required minlength="3" maxlength="100" pattern="[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]*" title="Solo se permiten letras, espacios y acentos">
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="usuarioId" value="<%= user.getId() %>">

                </div>

                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="cerrarModal()">
                        <i class="fas fa-times"></i> Cancelar
                    </button>
                    <button type="submit" class="btn-save">
                        <i class="fas fa-save"></i> Guardar Novedad
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        const hoyISO = new Date().toISOString().split('T')[0];
        const inputFecha = document.getElementById('inputFecha');
        inputFecha.value = hoyISO;
        inputFecha.min = hoyISO;
        inputFecha.max = '2099-12-31';

        function abrirModal() {
            document.getElementById('modalNovedad').classList.add('active');
            document.body.style.overflow = 'hidden';
        }
        function cerrarModal() {
            document.getElementById('modalNovedad').classList.remove('active');
            document.body.style.overflow = '';
        }
        document.getElementById('modalNovedad').addEventListener('click', function(e) {
            if (e.target === this) cerrarModal();
        });

        function setViabilidad(valor) {
            document.getElementById('inputViabilidad').value = valor;
            document.getElementById('btnApto').classList.toggle('active', valor === 'Apto');
            document.getElementById('btnNoApto').classList.toggle('active', valor === 'No Apto');
        }

        const placeholders = {
            'Ambiente':    'Describe el estado del ambiente, aula o laboratorio...',
            'Equipos':     'Describe el problema con equipos, máquinas o mobiliario...',
            'Materiales':  'Describe la novedad con los materiales de formación...',
            'Biblioteca':  'Describe la novedad en biblioteca o bibliografía...'
        };
        function actualizarPlaceholder(sel) {
            const txt = document.getElementById('txtDetalle');
            txt.placeholder = placeholders[sel.value] || 'Describe la novedad presentada...';
        }

        function filtrarTabla() {
            const q = document.getElementById('buscar').value.toLowerCase();
            document.querySelectorAll('#tbodyNovedades tr').forEach(tr => {
                tr.style.display = tr.textContent.toLowerCase().includes(q) ? '' : 'none';
            });
        }

        function confirmarEliminar(id) {
            Swal.fire({
                title: '¿Eliminar novedad?',
                text: 'Esta acción no se puede deshacer.',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#ef4444',
                confirmButtonText: 'Sí, eliminar',
                cancelButtonText: 'Cancelar'
            }).then(r => {
                if (r.isConfirmed) {
                    window.location.href = 'NovedadServlet?accion=eliminar&id=' + id;
                }
            });
        }

        function verDetalle(id) {
            window.location.href = 'NovedadServlet?accion=ver&id=' + id;
        }

        function imprimirFormato(id) {
            window.open('NovedadServlet?accion=imprimir&id=' + id, '_blank');
        }

        function calcularStats() {
            let equipos = 0, aptos = 0, noAptos = 0;
            document.querySelectorAll('#tbodyNovedades tr').forEach(tr => {
                const badges = tr.querySelectorAll('.badge');
                badges.forEach(b => {
                    if (b.classList.contains('badge-equipo'))  equipos++;
                    if (b.classList.contains('badge-apto'))    aptos++;
                    if (b.classList.contains('badge-noapto'))  noAptos++;
                });
            });
            document.getElementById('cntEquipos').textContent = equipos;
            document.getElementById('cntAptos').textContent   = aptos;
            document.getElementById('cntNoAptos').textContent  = noAptos;
        }
        calcularStats();

        <% if ("ok".equals(msg)) { %>
        mostrarToast('✅ Novedad registrada correctamente', false);
        <% } else if (error != null) { %>
        mostrarToast('❌ Error al registrar la novedad', true);
        <% } %>

        function mostrarToast(texto, esError) {
            const t = document.createElement('div');
            t.className = 'toast' + (esError ? ' error' : '');
            t.innerHTML = texto;
            document.body.appendChild(t);
            setTimeout(() => t.remove(), 4000);
        }

        function esNombreValido(valor) {
            return /^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]*$/.test(valor);
        }
        function esTextoValido(valor) {
            return /^[a-zA-ZáéíóúÁÉÍÓÚñÑ0-9\s\-\.]*$/.test(valor);
        }
        function esUbicacionValida(valor) {
            return /^[a-zA-ZáéíóúÁÉÍÓÚñÑ0-9\s\-\.,/]*$/.test(valor);
        }

        document.getElementById('formNovedad').addEventListener('submit', function(e) {
            e.preventDefault();

            const regional = document.querySelector('[name="regional"]').value.trim();
            const centroFormacion = document.querySelector('[name="centroFormacion"]').value.trim();
            const programaFormacion = document.querySelector('[name="programaFormacion"]').value.trim();
            const ambiente = document.querySelector('[name="ambiente"]').value.trim();
            const fechaReporte = document.querySelector('[name="fechaReporte"]').value.trim();
            const tipoNovedad = document.querySelector('[name="tipoNovedad"]').value.trim();
            const detalleNovedad = document.querySelector('[name="detalleNovedad"]').value.trim();
            const nombreInstructor = document.querySelector('[name="nombreInstructor"]').value.trim();
            const nombreCoordinador = document.querySelector('[name="nombreCoordinador"]').value.trim();

            if (!regional) { Swal.fire({ icon:'error', title:'Validación', text:'El campo Regional es obligatorio.' }); return false; }
            if (!centroFormacion) { Swal.fire({ icon:'error', title:'Validación', text:'El campo Centro de Formación es obligatorio.' }); return false; }
            if (!programaFormacion) { Swal.fire({ icon:'error', title:'Validación', text:'El campo Programa de Formación es obligatorio.' }); return false; }
            if (!ambiente) { Swal.fire({ icon:'error', title:'Validación', text:'El campo Identificación del Ambiente es obligatorio.' }); return false; }
            if (!fechaReporte) { Swal.fire({ icon:'error', title:'Validación', text:'La Fecha del Reporte es obligatoria.' }); return false; }
            if (!tipoNovedad) { Swal.fire({ icon:'error', title:'Validación', text:'Debes seleccionar el Tipo de Novedad.' }); return false; }
            if (!detalleNovedad) { Swal.fire({ icon:'error', title:'Validación', text:'El Detalle de la Novedad es obligatorio.' }); return false; }
            if (!nombreInstructor) { Swal.fire({ icon:'error', title:'Validación', text:'El nombre del Instructor es obligatorio.' }); return false; }
            if (!nombreCoordinador) { Swal.fire({ icon:'error', title:'Validación', text:'El nombre del Coordinador es obligatorio.' }); return false; }

            if (regional.length < 2 || regional.length > 50) { Swal.fire({ icon:'error', title:'Validación', text:'Regional debe tener entre 2 y 50 caracteres.' }); return false; }
            if (centroFormacion.length < 3 || centroFormacion.length > 100) { Swal.fire({ icon:'error', title:'Validación', text:'Centro de Formación debe tener entre 3 y 100 caracteres.' }); return false; }
            if (programaFormacion.length < 3 || programaFormacion.length > 150) { Swal.fire({ icon:'error', title:'Validación', text:'Programa de Formación debe tener entre 3 y 150 caracteres.' }); return false; }
            if (ambiente.length < 2 || ambiente.length > 50) { Swal.fire({ icon:'error', title:'Validación', text:'Identificación del Ambiente debe tener entre 2 y 50 caracteres.' }); return false; }
            if (detalleNovedad.length < 10 || detalleNovedad.length > 1000) { Swal.fire({ icon:'error', title:'Validación', text:'Detalle de Novedad debe tener entre 10 y 1000 caracteres.' }); return false; }
            if (nombreInstructor.length < 3 || nombreInstructor.length > 100) { Swal.fire({ icon:'error', title:'Validación', text:'Nombre del Instructor debe tener entre 3 y 100 caracteres.' }); return false; }
            if (nombreCoordinador.length < 3 || nombreCoordinador.length > 100) { Swal.fire({ icon:'error', title:'Validación', text:'Nombre del Coordinador debe tener entre 3 y 100 caracteres.' }); return false; }

            if (!esTextoValido(regional)) { Swal.fire({ icon:'error', title:'Validación', text:'Regional: Solo se permiten letras, espacios y guiones.' }); return false; }
            if (!esTextoValido(centroFormacion)) { Swal.fire({ icon:'error', title:'Validación', text:'Centro de Formación: Solo se permiten letras, números, espacios, guiones y puntos.' }); return false; }
            if (!esTextoValido(programaFormacion)) { Swal.fire({ icon:'error', title:'Validación', text:'Programa de Formación: Solo se permiten letras, números, espacios, guiones y puntos.' }); return false; }
            if (!esTextoValido(ambiente)) { Swal.fire({ icon:'error', title:'Validación', text:'Identificación del Ambiente: Solo se permiten letras, números, espacios, guiones y puntos.' }); return false; }
            if (!esNombreValido(nombreInstructor)) { Swal.fire({ icon:'error', title:'Validación', text:'Nombre del Instructor: Solo se permiten letras, espacios y acentos.' }); return false; }
            if (!esNombreValido(nombreCoordinador)) { Swal.fire({ icon:'error', title:'Validación', text:'Nombre del Coordinador: Solo se permiten letras, espacios y acentos.' }); return false; }

            const fechaSeleccionada = new Date(fechaReporte);
            const hoy = new Date();
            hoy.setHours(0, 0, 0, 0);
            fechaSeleccionada.setHours(0, 0, 0, 0);
            if (fechaSeleccionada < hoy) { Swal.fire({ icon:'error', title:'Validación', text:'La fecha del reporte no puede ser en el pasado.' }); return false; }

            const codigoPrograma = document.querySelector('[name="codigoPrograma"]').value.trim();
            if (codigoPrograma && !/^\d+$/.test(codigoPrograma)) { Swal.fire({ icon:'error', title:'Validación', text:'El Código del Programa debe contener solo números.' }); return false; }

            this.submit();
        });
    </script>
</body>
</html>