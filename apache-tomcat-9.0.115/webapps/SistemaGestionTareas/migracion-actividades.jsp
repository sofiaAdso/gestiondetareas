<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sena.gestion.model.Usuario" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null || !"Administrador".equals(user.getRol())) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Migración Automática de Actividades</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            max-width: 800px;
            width: 100%;
            padding: 40px;
            animation: slideIn 0.6s ease;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

        .header-icon {
            width: 100px;
            height: 100px;
            margin: 0 auto 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }

        .header-icon i {
            font-size: 3rem;
            color: white;
        }

        h1 {
            color: #2c3e50;
            font-size: 2rem;
            margin-bottom: 10px;
        }

        .subtitle {
            color: #7f8c8d;
            font-size: 1rem;
        }

        .info-box {
            background: #f8f9fa;
            border-left: 5px solid #667eea;
            padding: 20px;
            margin: 20px 0;
            border-radius: 10px;
        }

        .info-box h3 {
            color: #667eea;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .info-box ul {
            list-style: none;
            padding: 0;
        }

        .info-box li {
            padding: 8px 0;
            color: #555;
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }

        .info-box li i {
            color: #667eea;
            margin-top: 4px;
        }

        .warning-box {
            background: #fff3cd;
            border-left: 5px solid #ffc107;
            padding: 20px;
            margin: 20px 0;
            border-radius: 10px;
        }

        .warning-box h3 {
            color: #856404;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .warning-box p {
            color: #856404;
            margin: 10px 0;
        }

        .button-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }

        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.5);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.3);
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .steps {
            margin: 30px 0;
        }

        .step {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
        }

        .step-number {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            flex-shrink: 0;
        }

        .step-content h4 {
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .step-content p {
            color: #666;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="header-icon">
                <i class="fas fa-sync-alt"></i>
            </div>
            <h1>Migración Automática de Actividades</h1>
            <p class="subtitle">Agrupa tus tareas existentes en actividades automáticamente</p>
        </div>

        <div class="info-box">
            <h3>
                <i class="fas fa-info-circle"></i>
                ¿Qué hace esta herramienta?
            </h3>
            <ul>
                <li>
                    <i class="fas fa-check"></i>
                    <span>Analiza todas las tareas que no tienen actividad asignada</span>
                </li>
                <li>
                    <i class="fas fa-check"></i>
                    <span>Las agrupa por usuario y categoría</span>
                </li>
                <li>
                    <i class="fas fa-check"></i>
                    <span>Crea automáticamente una actividad por cada grupo</span>
                </li>
                <li>
                    <i class="fas fa-check"></i>
                    <span>Asigna las tareas a sus actividades correspondientes</span>
                </li>
            </ul>
        </div>

        <div class="steps">
            <h3 style="color: #2c3e50; margin-bottom: 20px;">
                <i class="fas fa-list-ol"></i> Proceso de Migración:
            </h3>

            <div class="step">
                <div class="step-number">1</div>
                <div class="step-content">
                    <h4>Identificación</h4>
                    <p>Se identifican todas las tareas sin actividad asignada</p>
                </div>
            </div>

            <div class="step">
                <div class="step-number">2</div>
                <div class="step-content">
                    <h4>Agrupación</h4>
                    <p>Las tareas se agrupan por usuario y categoría</p>
                </div>
            </div>

            <div class="step">
                <div class="step-number">3</div>
                <div class="step-content">
                    <h4>Creación</h4>
                    <p>Se crea una actividad automática para cada grupo</p>
                </div>
            </div>

            <div class="step">
                <div class="step-number">4</div>
                <div class="step-content">
                    <h4>Asignación</h4>
                    <p>Todas las tareas se vinculan a su actividad correspondiente</p>
                </div>
            </div>
        </div>

        <div class="warning-box">
            <h3>
                <i class="fas fa-exclamation-triangle"></i>
                Importante - Antes de ejecutar
            </h3>
            <p>✓ Este proceso es <strong>irreversible</strong></p>
            <p>✓ Se recomienda hacer un <strong>respaldo de la base de datos</strong></p>
            <p>✓ Las actividades creadas tendrán el prefijo "Actividad -"</p>
            <p>✓ Puedes editarlas después de la migración</p>
        </div>

        <div class="button-group">
            <a href="dashboard.jsp" class="btn btn-secondary">
                <i class="fas fa-times"></i>
                Cancelar
            </a>
            <button onclick="confirmarMigracion()" class="btn btn-primary">
                <i class="fas fa-play"></i>
                Ejecutar Migración
            </button>
        </div>
    </div>

    <script>
        function confirmarMigracion() {
            Swal.fire({
                title: '¿Iniciar Migración?',
                html: `
                    <p style="margin-bottom: 15px;">Se van a crear actividades automáticamente para agrupar tus tareas.</p>
                    <div style="background: #f8f9fa; padding: 15px; border-radius: 10px; text-align: left;">
                        <strong>Recuerda:</strong>
                        <ul style="margin: 10px 0; padding-left: 20px;">
                            <li>Este proceso es irreversible</li>
                            <li>Todas las tareas serán asignadas a actividades</li>
                            <li>Las actividades se pueden editar después</li>
                        </ul>
                    </div>
                `,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#667eea',
                cancelButtonColor: '#6c757d',
                confirmButtonText: '<i class="fas fa-check"></i> Sí, ejecutar',
                cancelButtonText: '<i class="fas fa-times"></i> Cancelar',
                allowOutsideClick: false,
                allowEscapeKey: false
            }).then((result) => {
                if (result.isConfirmed) {
                    ejecutarMigracion();
                }
            });
        }

        function ejecutarMigracion() {
            // Mostrar loading
            Swal.fire({
                title: 'Ejecutando Migración',
                html: `
                    <div style="text-align: center;">
                        <i class="fas fa-sync-alt fa-spin" style="font-size: 48px; color: #667eea; margin: 20px 0;"></i>
                        <p>Analizando tareas y creando actividades...</p>
                        <p style="color: #999; font-size: 0.9rem;">Por favor espera, esto puede tomar unos momentos</p>
                    </div>
                `,
                showConfirmButton: false,
                allowOutsideClick: false,
                allowEscapeKey: false
            });

            // Redirigir para ejecutar la migración
            window.location.href = 'MigracionServlet?accion=ejecutar';
        }

        // Verificar mensajes de error en la URL
        window.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const error = urlParams.get('error');
            const errores = urlParams.get('errores');

            if (error === 'migracion_fallida') {
                Swal.fire({
                    icon: 'error',
                    title: 'Migración Fallida',
                    html: `La migración no pudo completarse correctamente.<br>Errores encontrados: ${errores || 'Desconocido'}`,
                    confirmButtonColor: '#667eea'
                });
            } else if (error === 'excepcion') {
                Swal.fire({
                    icon: 'error',
                    title: 'Error Crítico',
                    text: 'Ocurrió un error fatal durante la migración. Revisa los logs del servidor.',
                    confirmButtonColor: '#667eea'
                });
            }
        });
    </script>
</body>
</html>

