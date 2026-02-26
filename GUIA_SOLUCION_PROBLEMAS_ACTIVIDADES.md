# 🔧 Guía de Solución de Problemas - Creación de Actividades

## 📋 Lista de Verificación

### 1. Verificar que la tabla `actividades` existe
Ejecuta este SQL en tu base de datos PostgreSQL:
```sql
SELECT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_name = 'actividades'
);
```

**Si retorna `false`:**
- Ejecuta el script: `crear_tabla_actividades.sql`

### 2. Verificar la estructura de la tabla
```sql
\d actividades
```

**Debe tener estas columnas:**
- `id` (SERIAL PRIMARY KEY)
- `usuario_id` (INTEGER NOT NULL)
- `titulo` (VARCHAR(200) NOT NULL)
- `descripcion` (TEXT)
- `fecha_inicio` (DATE)
- `fecha_fin` (DATE)
- `prioridad` (VARCHAR(20))
- `estado` (VARCHAR(20))
- `color` (VARCHAR(7))
- `fecha_creacion` (TIMESTAMP)

### 3. Verificar que hay usuarios registrados
```sql
SELECT COUNT(*) FROM usuarios;
SELECT id, nombre, email FROM usuarios LIMIT 5;
```

**Si no hay usuarios:**
- Necesitas registrar al menos un usuario antes de crear actividades
- Ve a: `http://localhost:8080/SistemaGestionTareas/registro_usuario.jsp`

### 4. Verificar la conexión a la base de datos
Archivo: `src/main/resources/application.properties`
```properties
db.url=jdbc:postgresql://localhost:5432/Gestiondetareas
db.user=postgres
db.pass=TU_CONTRASEÑA
db.driver=org.postgresql.Driver
```

**Verifica:**
- ✓ El puerto de PostgreSQL (por defecto: 5432)
- ✓ El nombre de la base de datos
- ✓ Usuario y contraseña correctos
- ✓ PostgreSQL está corriendo

### 5. Probar la creación manualmente en SQL
```sql
INSERT INTO actividades 
(usuario_id, titulo, descripcion, fecha_inicio, fecha_fin, prioridad, estado, color) 
VALUES 
(1, 'Prueba', 'Actividad de prueba', CURRENT_DATE, CURRENT_DATE + 30, 'Media', 'En Progreso', '#3498db')
RETURNING id;
```

**Si falla:**
- Verifica que el `usuario_id` existe en la tabla usuarios
- Revisa los logs de PostgreSQL para ver el error específico

## 🛠️ Herramientas de Diagnóstico

### Usar el Servlet de Diagnóstico
1. Inicia tu aplicación en Tomcat
2. Accede a: `http://localhost:8080/SistemaGestionTareas/DiagnosticoServlet`
3. Este servlet mostrará:
   - Estado de la conexión a BD
   - Estructura de la tabla actividades
   - Usuarios registrados
   - Actividades existentes
   - Prueba de creación

### Ver los Logs del Servidor
Los logs se imprimen en la consola de Tomcat. Busca:
```
=== SERVLET: INICIANDO CREACIÓN DE ACTIVIDAD ===
=== CREANDO ACTIVIDAD ===
```

**Logs de error comunes:**
- `Error al crear actividad`: Problema con la BD
- `Título vacío`: Validación falló
- `SQLException`: Error en SQL (revisa el mensaje específico)

## 🔍 Problemas Comunes y Soluciones

### Problema 1: "No se pudo crear la actividad"
**Causa:** Tabla no existe o estructura incorrecta
**Solución:**
1. Ejecuta: `crear_tabla_actividades.sql`
2. Reinicia la aplicación

### Problema 2: "Usuario no válido"
**Causa:** No hay usuarios en el sistema
**Solución:**
1. Registra un usuario nuevo
2. O inserta uno manualmente:
```sql
INSERT INTO usuarios (nombre, email, username, password, rol) 
VALUES ('Admin', 'admin@test.com', 'admin', 'admin123', 'Administrador');
```

### Problema 3: "Error de conexión a la base de datos"
**Causa:** PostgreSQL no está corriendo o credenciales incorrectas
**Solución:**
1. Verifica que PostgreSQL está corriendo:
   - Windows: Servicios → PostgreSQL
   - Linux: `sudo systemctl status postgresql`
2. Verifica las credenciales en `application.properties`
3. Intenta conectarte con pgAdmin o psql

### Problema 4: "El formulario no envía datos"
**Causa:** Validación JavaScript fallando
**Solución:**
1. Abre la consola del navegador (F12)
2. Revisa los mensajes de error
3. Verifica que todos los campos requeridos estén llenos

### Problema 5: "Fechas inválidas"
**Causa:** Formato de fecha incorrecto
**Solución:**
- Usa el selector de fecha del navegador
- Formato debe ser: `YYYY-MM-DD`
- La fecha fin debe ser >= fecha inicio

## 📊 Scripts de Diagnóstico

### Script SQL Completo
Ejecuta: `diagnosticar_actividades.sql`

Este script verifica:
- Existencia de la tabla
- Estructura correcta
- Constraints y foreign keys
- Usuarios disponibles
- Actividades existentes
- Permisos

## 🚀 Pasos para Crear una Actividad

### Desde la Interfaz Web
1. Inicia sesión en el sistema
2. Ve al Dashboard
3. Click en "Nueva Actividad" o "Gestionar Actividades"
4. Llena el formulario:
   - **Título**: Obligatorio (máx 200 caracteres)
   - **Descripción**: Opcional (máx 500 caracteres)
   - **Fecha Inicio**: Obligatorio
   - **Fecha Fin**: Obligatorio (debe ser >= fecha inicio)
   - **Prioridad**: Baja/Media/Alta
   - **Estado**: Planificada/En Progreso/Pausada/Completada
   - **Color**: Selector de color para identificación visual
5. Click en "Crear Actividad"

### Desde Java (Programáticamente)
```java
Actividad actividad = new Actividad();
actividad.setUsuario_id(usuarioId);
actividad.setTitulo("Mi Actividad");
actividad.setDescripcion("Descripción");
actividad.setFecha_inicio(Date.valueOf("2024-01-01"));
actividad.setFecha_fin(Date.valueOf("2024-12-31"));
actividad.setPrioridad("Media");
actividad.setEstado("En Progreso");
actividad.setColor("#3498db");

ActividadDao dao = new ActividadDao();
boolean creada = dao.crear(actividad);
```

## 📞 Soporte Adicional

Si después de seguir esta guía aún tienes problemas:

1. **Revisa los logs de Tomcat**: Busca mensajes de error específicos
2. **Verifica la consola del navegador**: Puede haber errores JavaScript
3. **Usa el DiagnosticoServlet**: Te dará información detallada del estado
4. **Revisa los logs de PostgreSQL**: Ubicación típica:
   - Windows: `C:\Program Files\PostgreSQL\XX\data\log\`
   - Linux: `/var/log/postgresql/`

## ✅ Checklist Final

Antes de intentar crear una actividad, verifica:
- [ ] PostgreSQL está corriendo
- [ ] La base de datos `Gestiondetareas` existe
- [ ] La tabla `actividades` existe con estructura correcta
- [ ] Hay al menos un usuario registrado
- [ ] Puedes hacer login en el sistema
- [ ] El archivo `application.properties` tiene credenciales correctas
- [ ] Tomcat está corriendo
- [ ] La aplicación está desplegada correctamente
- [ ] No hay errores en los logs de Tomcat al iniciar

## 🔄 Reinicio Completo (última opción)

Si nada funciona:
1. Para Tomcat
2. Elimina la carpeta de despliegue en Tomcat
3. Ejecuta `compilar_desplegar.bat`
4. Reinicia PostgreSQL
5. Reinicia Tomcat
6. Intenta de nuevo

