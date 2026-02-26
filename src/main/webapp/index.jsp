<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Gestión de Tareas</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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

        .login-container {
            background: white;
            padding: 32px 40px;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 360px;
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

        .logo-section {
            text-align: center;
            margin-bottom: 35px;
        }

        .logo-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }

        .logo-icon i {
            font-size: 2.5rem;
            color: white;
        }

        h2 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 8px;
            font-size: 1.9rem;
            font-weight: 700;
        }

        .subtitle {
            text-align: center;
            color: #7f8c8d;
            margin-bottom: 30px;
            font-size: 0.95rem;
        }

        .error-msg {
            padding: 14px 16px;
            margin-bottom: 25px;
            border-radius: 12px;
            font-size: 0.9rem;
            font-weight: 500;
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
            color: white;
            border-left: 5px solid #c0392b;
            animation: slideDown 0.4s ease;
        }

        .success-msg {
            padding: 14px 16px;
            margin-bottom: 25px;
            border-radius: 12px;
            font-size: 0.9rem;
            font-weight: 500;
            background: linear-gradient(135deg, #51cf66 0%, #37b24d 100%);
            color: white;
            border-left: 5px solid #2d7a3e;
            animation: slideDown 0.4s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .input-group {
            margin-bottom: 22px;
            position: relative;
        }

        .input-group label {
            display: block;
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 10px;
            font-size: 0.95rem;
        }

        .input-group label i {
            margin-right: 10px;
            width: 18px;
        }

        .input-group input {
            width: 100%;
            padding: 14px 16px 14px 48px;
            border: 2px solid #e8e8e8;
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s ease;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #fafafa;
        }

        .input-group input:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.15);
            transform: translateY(-1px);
        }

        .btn-login {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-login:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.5);
        }

        .btn-login:active {
            transform: translateY(-1px);
        }

        .btn-login i {
            margin-right: 10px;
        }

        .divider {
            text-align: center;
            margin: 28px 0;
            position: relative;
            color: #bdc3c7;
            font-size: 0.9rem;
        }

        .divider::before,
        .divider::after {
            content: '';
            position: absolute;
            top: 50%;
            width: 42%;
            height: 1px;
            background: linear-gradient(to right, transparent, #e8e8e8, transparent);
        }

        .divider::before {
            left: 0;
        }

        .divider::after {
            right: 0;
        }

        .register-section {
            text-align: center;
            margin-top: 20px;
            padding: 20px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 12px;
            border: 2px dashed #dee2e6;
        }

        .register-section p {
            color: #495057;
            font-size: 0.95rem;
            margin-bottom: 12px;
            font-weight: 500;
        }

        .btn-register {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            background: white;
            color: #667eea;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            border: 2px solid #667eea;
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.2);
        }

        .btn-register:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
            gap: 12px;
        }

        .footer-text {
            margin-top: 25px;
            text-align: center;
            font-size: 0.85rem;
            color: #95a5a6;
        }

        @media (max-width: 576px) {
            .login-container {
                padding: 35px 25px;
            }

            h2 {
                font-size: 1.6rem;
            }

            .logo-icon {
                width: 70px;
                height: 70px;
            }

            .logo-icon i {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <!-- Logo Section -->
        <div class="logo-section">
            <div class="logo-icon">
                <i class="fas fa-tasks"></i>
            </div>
            <h2>Bienvenido</h2>
            <p class="subtitle">Sistema de Gestión de Tareas - SENA</p>
        </div>

        <!-- Alert Messages -->
        <% if (request.getParameter("registro") != null && "exito".equals(request.getParameter("registro"))) { %>
            <div class="success-msg">
                <i class="fas fa-check-circle"></i>
                ✅ ¡Cuenta creada exitosamente! Ahora inicia sesión con tus credenciales.
            </div>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-msg">
                <i class="fas fa-exclamation-triangle"></i>
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <% if ("exito".equals(request.getParameter("registro"))) { %>
            <div class="success-msg">
                <i class="fas fa-check-circle"></i>
                ¡Cuenta creada exitosamente! Inicia sesión ahora.
            </div>
        <% } %>

        <% if ("exito".equals(request.getParameter("msg"))) { %>
            <div class="success-msg">
                <i class="fas fa-check-circle"></i>
                Operación realizada con éxito.
            </div>
        <% } %>

        <!-- Login Form -->
        <form action="LoginServlet" method="POST" id="loginForm">
            <div class="input-group">
                <label for="txtuser">
                    <i class="fas fa-user"></i>
                    Usuario
                </label>
                <input
                    type="text"
                    id="txtuser"
                    name="txtuser"
                    placeholder="Ingresa tu usuario"
                    required
                    autocomplete="username">
            </div>

            <div class="input-group">
                <label for="txtpass">
                    <i class="fas fa-lock"></i>
                    Contraseña
                </label>
                <input
                    type="password"
                    id="txtpass"
                    name="txtpass"
                    placeholder="••••••••"
                    required
                    minlength="6"
                    autocomplete="current-password">
            </div>

            <button type="submit" class="btn-login">
                <i class="fas fa-sign-in-alt"></i>
                Iniciar Sesión
            </button>
        </form>
    </div>

    <script>

        // Form validation
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const username = document.getElementById('txtuser').value.trim();
            const password = document.getElementById('txtpass').value;

            if (!username || !password) {
                e.preventDefault();
                alert('⚠️ Por favor, completa todos los campos.');
                return false;
            }

            if (password.length < 6) {
                e.preventDefault();
                alert('⚠️ La contraseña debe tener al menos 6 caracteres.');
                passwordInput.focus();
                return false;
            }
        });
    </script>
</body>
</html>
