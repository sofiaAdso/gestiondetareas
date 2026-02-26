# 🔍 Guía de Verificación: Asignación de Actividades a Usuarios

## 📋 Resumen de la Funcionalidad

El sistema **YA TIENE IMPLEMENTADO** el filtrado de actividades por usuario. Cada usuario solo puede ver las actividades que le han sido asignadas (excepto los Administradores que ven todas).

---

## ✅ Verificación del Sistema

### 1️⃣ **Verificar Base de Datos**

Ejecuta este script SQL en tu base de datos PostgreSQL:

```sql
-- Ejecutar el archivo: verificar_asignacion_actividades.sql
\i verificar_asignacion_actividades.sql
```

O ejecuta manualmente:

```sql
-- Ver todas las actividades con sus usuarios asignados
SELECT 
    a.id,
    a.titulo,
    a.usuario_id,
    u.username as nombre_usuario,
    a.estado
FROM actividades a
LEFT JOIN usuarios u ON a.usuario_id = u.id
ORDER BY a.fecha_creacion DESC;
```

### 2️⃣ **Verificar el Flujo en la Aplicación**

#### A. Como Administrador:
1. Inicia sesión con usuario Administrador
2. Ve a: `ActividadServlet?accion=listar`
3. **Resultado esperado**: Verás TODAS las actividades del sistema

#### B. Como Usuario Normal:
1. Inicia sesión con usuario normal
2. Ve a: `ActividadServlet?accion=listar`
3. **Resultado esperado**: Solo verás las actividades asignadas a tu usuario

---

## 🎯 Cómo Funciona el Sistema

### **Filtrado de Actividades (ActividadServlet.java)**

```java
if ("Administrador".equals(user.getRol())) {
    // Administrador ve TODAS las actividades
    listaActividades = actividadDao.listarTodas();
} else {
    // Usuario normal ve SOLO sus actividades
    listaActividades = actividadDao.listarPorUsuario(user.getId());
}
```

### **Consulta SQL (ActividadDao.java)**

El método `listarPorUsuario()` ejecuta:

```sql
SELECT a.*, COUNT(t.id) as total_tareas
FROM actividades a 
LEFT JOIN tareas t ON a.id = t.actividad_id 
WHERE a.usuario_id = ?  -- ← FILTRO POR USUARIO
GROUP BY a.id
ORDER BY a.fecha_creacion DESC
```

---

## 🔧 Solución de Problemas

### ❌ Problema: "No veo mis actividades"

**Posibles causas:**

1. **Las actividades no tienen `usuario_id` asignado**
   ```sql
   -- Verificar actividades sin usuario
   SELECT * FROM actividades WHERE usuario_id IS NULL;
   
   -- Solución: Asignar al primer usuario
   UPDATE actividades 
   SET usuario_id = (SELECT MIN(id) FROM usuarios)
   WHERE usuario_id IS NULL;
   ```

2. **El usuario_id no coincide con tu usuario**
   ```sql
   -- Ver qué usuario tiene cada actividad
   SELECT a.id, a.titulo, a.usuario_id, u.username
   FROM actividades a
   JOIN usuarios u ON a.usuario_id = u.id;
   ```

3. **Reasignar actividades a un usuario específico**
   ```sql
   -- Reasignar actividad con ID 1 al usuario con ID 2
   UPDATE actividades 
   SET usuario_id = 2 
   WHERE id = 1;
   ```

### ❌ Problema: "Quiero que otro usuario vea una actividad"

**Solución 1: Desde la interfaz web**
1. Inicia sesión como Administrador
2. Ve a la actividad que quieres reasignar
3. Click en "Editar" (ícono de lápiz)
4. En el campo **"Asignar a Usuario"** selecciona el nuevo usuario
5. Guarda los cambios

**Solución 2: Desde la base de datos**
```sql
-- Reasignar actividad al usuario específico
UPDATE actividades 
SET usuario_id = [ID_DEL_NUEVO_USUARIO] 
WHERE id = [ID_DE_LA_ACTIVIDAD];
```

---

## 📝 Crear Actividades para Otros Usuarios

### Desde el Formulario Web:

1. **Crear Nueva Actividad:**
   - Ve a: `ActividadServlet?accion=nuevo`
   - Llena el formulario
   - En el campo **"Asignar a Usuario"** (con icono de usuario y fondo azul-morado)
   - Selecciona el usuario al que quieres asignar la actividad
   - Click en "Crear Actividad"

2. **Editar Actividad Existente:**
   - En la lista de actividades, click en el ícono de editar
   - Modifica el campo **"Asignar a Usuario"**
   - Guarda los cambios

---

## 🧪 Pruebas Recomendadas

### Test 1: Crear usuario y asignarle actividad
```sql
-- 1. Crear usuario de prueba
INSERT INTO usuarios (username, password, email, rol) 
VALUES ('usuario_test', 'password123', 'test@example.com', 'Usuario');

-- 2. Ver el ID del nuevo usuario
SELECT id, username FROM usuarios WHERE username = 'usuario_test';

-- 3. Crear actividad para ese usuario (reemplaza [USER_ID])
INSERT INTO actividades (usuario_id, titulo, descripcion, fecha_inicio, fecha_fin, prioridad, estado)
VALUES ([USER_ID], 'Actividad de Prueba', 'Esta es una prueba', CURRENT_DATE, CURRENT_DATE + 7, 'Media', 'En Progreso');
```

### Test 2: Verificar desde la aplicación
1. Inicia sesión con `usuario_test`
2. Ve a: `ActividadServlet?accion=listar`
3. Deberías ver la actividad "Actividad de Prueba"

### Test 3: Verificar aislamiento
1. Crea otro usuario
2. Inicia sesión con ese usuario
3. Ve a: `ActividadServlet?accion=listar`
4. **NO** deberías ver la actividad de `usuario_test`

---

## 📊 Estadísticas por Usuario

Para ver cuántas actividades tiene cada usuario:

```sql
SELECT 
    u.id,
    u.username,
    u.rol,
    COUNT(a.id) as total_actividades,
    COUNT(CASE WHEN a.estado = 'Completada' THEN 1 END) as completadas,
    COUNT(CASE WHEN a.estado = 'En Progreso' THEN 1 END) as en_progreso,
    COUNT(CASE WHEN a.estado = 'Planificada' THEN 1 END) as planificadas
FROM usuarios u
LEFT JOIN actividades a ON u.id = a.usuario_id
GROUP BY u.id, u.username, u.rol
ORDER BY total_actividades DESC;
```

---

## 🔐 Permisos y Roles

### **Administrador:**
- ✅ Ve TODAS las actividades de todos los usuarios
- ✅ Puede crear actividades para cualquier usuario
- ✅ Puede editar y reasignar cualquier actividad

### **Usuario Normal:**
- ✅ Ve SOLO las actividades asignadas a él
- ✅ Puede crear actividades (se asignan a sí mismo por defecto)
- ✅ Puede editar sus propias actividades
- ⚠️ Si el selector de usuarios aparece, puede asignar a otros (esto se puede restringir si es necesario)

---

## 🚀 URLs Importantes

- **Ver mis actividades:** `http://localhost:8080/SistemaGestionTareas/ActividadServlet?accion=listar`
- **Crear nueva actividad:** `http://localhost:8080/SistemaGestionTareas/ActividadServlet?accion=nuevo`
- **Dashboard principal:** `http://localhost:8080/SistemaGestionTareas/dashboard.jsp`

---

## 📌 Notas Importantes

1. **El campo de asignación de usuario es VISIBLE** en el formulario con un diseño destacado (fondo degradado azul-morado)

2. **El filtrado es AUTOMÁTICO** basado en el rol del usuario que inició sesión

3. **Las actividades se guardan con el `usuario_id`** especificado en el formulario

4. **Si no hay lista de usuarios**, el sistema asigna automáticamente al usuario actual

---

## 🔄 Recompilar Después de Cambios

Si haces modificaciones al código:

```bash
cd C:\Users\sofsh\Desktop\Gestiondetareas\SistemaGestionTareas
mvn clean package
```

O copia el WAR generado a tu servidor Tomcat:
```
target/SistemaGestionTareas.war → [TOMCAT]/webapps/
```

---

## ✨ Conclusión

El sistema **ESTÁ FUNCIONANDO CORRECTAMENTE**. Cada usuario ve solo las actividades que le han sido asignadas. Si un usuario no ve sus actividades, verifica:

1. ✅ Que las actividades tengan el campo `usuario_id` correctamente asignado
2. ✅ Que el `usuario_id` coincida con el ID del usuario en sesión
3. ✅ Que el usuario haya iniciado sesión correctamente

Para cualquier duda, ejecuta el script de diagnóstico: `verificar_asignacion_actividades.sql`

