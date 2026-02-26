<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sena.gestion.model.Usuario" %>
<%
    // Verificar que el usuario esté autenticado y sea administrador
    Usuario user = (Usuario) session.getAttribute("usuario");
    if (user == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    if (!"Administrador".equals(user.getRol())) {
        response.sendRedirect("Tareaservlet?accion=listar");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Cuenta - Sistema SENA</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Mantenemos tus estilos originales que son excelentes */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .register-container {
            background: white;
            padding: 45px 40px;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 480px;
            animation: slideIn 0.6s ease;
        }
        @keyframes slideIn { from { opacity: 0; transform: translateY(-30px); } to { opacity: 1; transform: translateY(0); } }
        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 25px;
            padding: 12px 24px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            border-radius: 10px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }
        .btn-back:hover {
            transform: translateX(-5px) translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }
        .btn-back:active {
            transform: translateX(-3px) translateY(0px);
        }
        .btn-back i {
            font-size: 16px;
        }
        .logo-section { text-align: center; margin-bottom: 35px; }
        .logo-icon {
            width: 80px; height: 80px; margin: 0 auto 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px; display: flex; align-items: center; justify-content: center;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }
        .logo-icon i { font-size: 2.5rem; color: white; }
        h2 { color: #2c3e50; text-align: center; margin-bottom: 8px; font-size: 1.9rem; font-weight: 700; }
        .subtitle { text-align: center; color: #7f8c8d; margin-bottom: 30px; font-size: 0.95rem; }
        .alert { padding: 14px 16px; margin-bottom: 25px; border-radius: 12px; font-size: 0.9rem; font-weight: 500; }
        .alert-error { background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%); color: white; border-left: 5px solid #c0392b; }
        .alert-success { background: linear-gradient(135deg, #51cf66 0%, #37b24d 100%); color: white; border-left: 5px solid #2d7a3e; }
        .form-group { margin-bottom: 22px; position: relative; }
        label { display: block; color: #2c3e50; font-weight: 600; margin-bottom: 10px; font-size: 0.95rem; }
        label i { margin-right: 10px; color: #667eea; width: 18px; display: inline-block; }
        .required { color: #e74c3c; margin-left: 3px; }
        input, select {
            width: 100%; padding: 14px 16px 14px 16px; border: 2px solid #e8e8e8;
            border-radius: 12px; font-size: 1rem; transition: all 0.3s ease; background: #fafafa;
        }
        input:focus, select:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.15);
            transform: translateY(-1px);
        }

        .btn-register {
            width: 100%; padding: 16px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; border: none; border-radius: 12px; font-size: 1.1rem; font-weight: 700;
            cursor: pointer; transition: all 0.3s ease; text-transform: uppercase; margin-top: 10px;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }
        .btn-register:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.5);
        }
        .btn-register:active {
            transform: translateY(-1px);
        }
        .btn-register i {
            margin-right: 10px;
        }
        .divider { text-align: center; margin: 28px 0; position: relative; color: #bdc3c7; }
        .login-link { text-align: center; margin-top: 20px; color: #7f8c8d; }
        .login-link a { color: #667eea; text-decoration: none; font-weight: 700; }
        .password-strength { height: 5px; background: #ecf0f1; border-radius: 3px; margin-top: 8px; overflow: hidden; }
        .password-strength-bar { height: 100%; width: 0; transition: all 0.4s ease; }
        .strength-weak { width: 33%; background: #e74c3c; }
        .strength-medium { width: 66%; background: #f39c12; }
        .strength-strong { width: 100%; background: #2ecc71; }
        .password-match {
            margin-top: 8px;
            font-size: 0.8rem;
            padding: 4px 8px;
            border-radius: 4px;
            display: none;
            font-weight: 600;
        }
        .match-error {
            background: rgba(255, 107, 107, 0.2);
            color: #e74c3c;
            display: block;
        }
        .match-success {
            background: rgba(81, 207, 102, 0.2);
            color: #27ae60;
            display: block;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <a href="dashboard.jsp" class="btn-back">
            <i class="fas fa-arrow-left"></i> Volver al Inicio
        </a>

        <div class="logo-section">
            <div class="logo-icon"><i class="fas fa-user-plus"></i></div>
            <h2>Crear Cuenta</h2>
            <p class="subtitle">Sistema de Gestión de Tareas - SENA</p>
        </div>

        <%-- Mensajes de Alerta --%>
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-triangle"></i>
                <%
                    String error = request.getParameter("error");
                    if ("existe".equals(error)) {
                        out.print("❌ El usuario o correo ya está registrado. Intenta con otros datos.");
                    } else if ("campos".equals(error)) {
                        out.print("❌ Por favor completa todos los campos requeridos.");
                    } else if ("db".equals(error)) {
                        out.print("❌ Error al registrar. Por favor intenta de nuevo más tarde.");
                    } else {
                        out.print("❌ Error desconocido. Intenta de nuevo.");
                    }
                %>
            </div>
        <% } %>

        <form action="Usuarioservlet" method="POST" id="registerForm">
            <input type="hidden" name="accion" value="registrar">

            <div class="form-group">
                <label for="txtUser"><i class="fas fa-user"></i>Usuario<span class="required">*</span></label>
                <input type="text" id="txtUser" name="txtusername" placeholder="Usuario" required minlength="4">
            </div>

            <div class="form-group">
                <label for="txtEmail"><i class="fas fa-envelope"></i>Correo Electrónico<span class="required">*</span></label>
                <input type="email" id="txtEmail" name="txtemail" placeholder="ejemplo@sena.edu.co" required>
            </div>

            <div class="form-group">
                <label for="txtPass"><i class="fas fa-lock"></i>Contraseña<span class="required">*</span></label>
                <input type="password" id="txtPass" name="txtpassword" placeholder="••••••••" required minlength="6">
                <div class="password-strength"><div class="password-strength-bar" id="strengthBar"></div></div>
            </div>

            <div class="form-group">
                <label for="txtConfirm"><i class="fas fa-lock"></i>Confirmar Contraseña<span class="required">*</span></label>
                <input type="password" id="txtConfirm" name="txtconfirm" placeholder="••••••••" required minlength="6">
                <div class="password-match" id="passwordMatch"></div>
            </div>

            <div class="form-group">
                <label for="txtRol"><i class="fas fa-user-tag"></i>Rol<span class="required">*</span></label>
                <select id="txtRol" name="txtrol" required>
                    <option value="Usuario">👤 Usuario Estándar</option>
                    <option value="Administrador">👑 Administrador</option>
                </select>
            </div>

            <button type="submit" class="btn-register">
                <i class="fas fa-check"></i> Crear Mi Cuenta
            </button>
        </form>
    </div>

    <script>
        // Elementos del formulario
        const passwordInput = document.getElementById('txtPass');
        const confirmInput = document.getElementById('txtConfirm');
        const strengthBar = document.getElementById('strengthBar');
        const passwordMatch = document.getElementById('passwordMatch');
        const registerForm = document.getElementById('registerForm');


        // Indicador de fuerza de contraseña
        passwordInput.addEventListener('input', function() {
            updatePasswordStrength();
            validatePasswordMatch();
        });

        // Validación de coincidencia de contraseña
        confirmInput.addEventListener('input', function() {
            validatePasswordMatch();
        });

        // Función para actualizar indicador de fuerza
        function updatePasswordStrength() {
            const val = passwordInput.value;
            strengthBar.className = 'password-strength-bar';
            if (val.length > 0 && val.length < 6) {
                strengthBar.classList.add('strength-weak');
            } else if (val.length >= 6 && val.length < 10) {
                strengthBar.classList.add('strength-medium');
            } else if (val.length >= 10) {
                strengthBar.classList.add('strength-strong');
            }
        }

        // Función para validar coincidencia
        function validatePasswordMatch() {
            const pass = passwordInput.value;
            const confirm = confirmInput.value;

            if (confirm === '') {
                passwordMatch.className = 'password-match';
                passwordMatch.innerHTML = '';
                return true;
            }

            if (pass === confirm) {
                passwordMatch.className = 'password-match match-success';
                passwordMatch.innerHTML = '✅ Las contraseñas coinciden';
                return true;
            } else {
                passwordMatch.className = 'password-match match-error';
                passwordMatch.innerHTML = '❌ Las contraseñas no coinciden';
                return false;
            }
        }

        // Validación en submit
        registerForm.addEventListener('submit', function(e) {
            const pass = passwordInput.value;
            const confirm = confirmInput.value;

            if (pass !== confirm) {
                e.preventDefault();
                passwordMatch.className = 'password-match match-error';
                passwordMatch.innerHTML = '❌ Las contraseñas deben coincidir para continuar';
                confirmInput.focus();
                return false;
            }

            if (pass.length < 6) {
                e.preventDefault();
                alert('⚠️ La contraseña debe tener al menos 6 caracteres.');
                passwordInput.focus();
                return false;
            }

            return true;
        });
    </script>
</body>
</html>