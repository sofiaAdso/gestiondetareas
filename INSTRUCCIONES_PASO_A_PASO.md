# 🎯 INSTRUCCIONES PASO A PASO: Verificar Asignación de Actividades

## 📌 IMPORTANTE
**El sistema YA ESTÁ FUNCIONANDO**. Solo necesitas verificar que las actividades en la base de datos tengan el campo `usuario_id` correctamente asignado.

---

## 🔧 PASO 1: Verificar la Base de Datos

### Opción A: Usar el Script Batch (Recomendado)

1. Abre el archivo: `diagnosticar_asignacion.bat`
2. **ANTES de ejecutar**, edita las credenciales de PostgreSQL en el archivo:
   ```batch
   set PGHOST=localhost
   set PGPORT=5432
   set PGDATABASE=gestion_tareas  # Cambia esto por tu BD
   set PGUSER=postgres            # Cambia esto por tu usuario
   set PGPASSWORD=tu_password     # Cambia esto por tu contraseña
   ```
3. Guarda el archivo
4. Ejecuta el script (doble click)
5. Selecciona opción **1** para diagnóstico completo

### Opción B: Usar pgAdmin o psql Manualmente

Ejecuta esta consulta en tu base de datos:

```sql
-- Ver todas las actividades con sus usuarios
SELECT 
    a.id,
    a.titulo,
    a.usuario_id,
    u.username,
    a.estado,
    a.fecha_creacion
FROM actividades a
LEFT JOIN usuarios u ON a.usuario_id = u.id
ORDER BY a.fecha_creacion DESC;
```

**¿Qué buscar?**
- ✅ Todas las actividades deben tener un `usuario_id` válido
- ✅ El `username` NO debe ser NULL
- ❌ Si alguna actividad tiene `usuario_id = NULL` o username NULL, hay que corregirlo

---

## 🔧 PASO 2: Corregir Problemas (Si los hay)

### Si encuentras actividades sin usuario asignado:

**Opción A: Corregir Automáticamente**
```sql
-- Asignar actividades sin usuario al primer usuario disponible
UPDATE actividades 
SET usuario_id = (SELECT MIN(id) FROM usuarios)
WHERE usuario_id IS NULL;
```

**Opción B: Asignar a un Usuario Específico**
```sql
-- Reemplaza [ID_USUARIO] con el ID del usuario deseado
UPDATE actividades 
SET usuario_id = [ID_USUARIO]
WHERE usuario_id IS NULL;

-- Ejemplo: Asignar al usuario con ID 1
UPDATE actividades 
SET usuario_id = 1
WHERE usuario_id IS NULL;
```

**Opción C: Eliminar Actividades sin Usuario**
```sql
-- ⚠️ PRECAUCIÓN: Esto eliminará las actividades sin usuario
DELETE FROM actividades WHERE usuario_id IS NULL;
```

---

## 🔧 PASO 3: Probar en la Aplicación Web

### Test 1: Como Usuario Normal

1. **Inicia sesión** con un usuario normal (NO administrador)
2. **Ve a**: 
   ```
   http://localhost:8080/SistemaGestionTareas/ActividadServlet?accion=listar
   ```
3. **Verifica**: Deberías ver SOLO las actividades asignadas a tu usuario

### Test 2: Como Administrador

1. **Inicia sesión** con usuario Administrador
2. **Ve a**:
   ```
   http://localhost:8080/SistemaGestionTareas/ActividadServlet?accion=listar
   ```
3. **Verifica**: Deberías ver TODAS las actividades de todos los usuarios

### Test 3: Crear Nueva Actividad

1. **Ve a**:
   ```
   http://localhost:8080/SistemaGestionTareas/ActividadServlet?accion=nuevo
   ```
2. **Busca el campo**: "Asignar a Usuario" (fondo azul-morado con icono de usuario)
3. **Selecciona** un usuario de la lista
4. **Llena** el resto del formulario
5. **Click** en "Crear Actividad"
6. **Verifica**: La actividad se creó para el usuario seleccionado

### Test 4: Editar Actividad

1. **En la lista de actividades**, click en el ícono de editar (lápiz)
2. **Busca el campo**: "Asignar a Usuario"
3. **Cambia** el usuario seleccionado
4. **Guarda** los cambios
5. **Verifica**: La actividad se reasignó al nuevo usuario

---

## 🔧 PASO 4: Crear Usuarios y Actividades de Prueba

Si quieres hacer pruebas desde cero:

```sql
-- 1. Crear dos usuarios de prueba
INSERT INTO usuarios (username, password, email, rol) 
VALUES 
    ('usuario_alfa', 'pass123', 'alfa@test.com', 'Usuario'),
    ('usuario_beta', 'pass456', 'beta@test.com', 'Usuario');

-- 2. Ver los IDs de los usuarios creados
SELECT id, username FROM usuarios 
WHERE username IN ('usuario_alfa', 'usuario_beta');

-- 3. Crear actividad para usuario_alfa (reemplaza ID_ALFA con el ID real)
INSERT INTO actividades (usuario_id, titulo, descripcion, fecha_inicio, fecha_fin, prioridad, estado)
VALUES (
    [ID_ALFA],  -- ID del usuario_alfa
    'Proyecto Alpha',
    'Actividad exclusiva de alfa',
    CURRENT_DATE,
    CURRENT_DATE + 10,
    'Alta',
    'En Progreso'
);

-- 4. Crear actividad para usuario_beta (reemplaza ID_BETA con el ID real)
INSERT INTO actividades (usuario_id, titulo, descripcion, fecha_inicio, fecha_fin, prioridad, estado)
VALUES (
    [ID_BETA],  -- ID del usuario_beta
    'Proyecto Beta',
    'Actividad exclusiva de beta',
    CURRENT_DATE,
    CURRENT_DATE + 10,
    'Media',
    'Planificada'
);

-- 5. Verificar que cada usuario solo ve sus actividades
SELECT 
    u.username,
    COUNT(a.id) as total_actividades,
    STRING_AGG(a.titulo, ', ') as titulos
FROM usuarios u
LEFT JOIN actividades a ON u.id = a.usuario_id
WHERE u.username IN ('usuario_alfa', 'usuario_beta')
GROUP BY u.username;
```

---

## 🔧 PASO 5: Verificación Final

### Checklist de Verificación

- [ ] Las actividades en la BD tienen `usuario_id` válido
- [ ] Usuario normal ve SOLO sus actividades
- [ ] Administrador ve TODAS las actividades
- [ ] Puedo crear actividad y asignarla a otro usuario
- [ ] Puedo editar actividad y reasignarla a otro usuario
- [ ] El campo "Asignar a Usuario" es visible en el formulario
- [ ] El selector muestra todos los usuarios disponibles

### Comandos SQL de Verificación Final

```sql
-- 1. Verificar que NO haya actividades sin usuario
SELECT COUNT(*) as actividades_sin_usuario
FROM actividades 
WHERE usuario_id IS NULL;
-- Resultado esperado: 0

-- 2. Verificar que NO haya actividades con usuario inválido
SELECT COUNT(*) as actividades_usuario_invalido
FROM actividades a
WHERE NOT EXISTS (SELECT 1 FROM usuarios u WHERE u.id = a.usuario_id);
-- Resultado esperado: 0

-- 3. Resumen por usuario
SELECT 
    u.username,
    u.rol,
    COUNT(a.id) as total_actividades
FROM usuarios u
LEFT JOIN actividades a ON u.id = a.usuario_id
GROUP BY u.username, u.rol
ORDER BY total_actividades DESC;
-- Debería mostrar cuántas actividades tiene cada usuario
```

---

## 🆘 Solución de Problemas Comunes

### ❌ Problema: "No veo ninguna actividad"

**Posibles causas:**
1. No hay actividades creadas para tu usuario
2. Las actividades tienen `usuario_id` incorrecto
3. No has iniciado sesión

**Solución:**
```sql
-- Ver tu ID de usuario (reemplaza 'tu_username')
SELECT id FROM usuarios WHERE username = 'tu_username';

-- Ver actividades asignadas a ti (reemplaza [TU_ID])
SELECT * FROM actividades WHERE usuario_id = [TU_ID];

-- Si no hay actividades, crear una de prueba
INSERT INTO actividades (usuario_id, titulo, fecha_inicio, fecha_fin)
VALUES ([TU_ID], 'Mi Primera Actividad', CURRENT_DATE, CURRENT_DATE + 7);
```

### ❌ Problema: "Veo actividades de otros usuarios"

**Causa:** Eres Administrador

**Solución:** Esto es normal. Los Administradores ven TODAS las actividades.

### ❌ Problema: "El campo de asignar usuario no aparece"

**Causa:** La lista de usuarios no se cargó

**Solución:**
1. Verifica que existan usuarios en la BD:
   ```sql
   SELECT * FROM usuarios;
   ```
2. Revisa los logs del servidor (Tomcat) para ver si hay errores
3. Verifica que el método `listarTodos()` en `UsuarioDao` funcione

---

## 📝 Resumen Ejecutivo

| Acción | Usuario Normal | Administrador |
|--------|---------------|---------------|
| Ver actividades | Solo las suyas | Todas |
| Crear actividad | Para sí mismo (o asignar a otros) | Para cualquier usuario |
| Editar actividad | Sus propias actividades | Todas las actividades |
| Reasignar actividad | Posible (si se muestra el selector) | Posible |

---

## ✅ Confirmación de Éxito

Si puedes hacer lo siguiente, el sistema está funcionando correctamente:

1. ✅ Iniciar sesión con dos usuarios diferentes
2. ✅ Cada usuario ve diferentes actividades
3. ✅ Crear actividad y asignarla a otro usuario
4. ✅ El otro usuario ve la actividad asignada
5. ✅ Editar y reasignar actividad a otro usuario

---

## 📞 ¿Necesitas Ayuda?

Si después de seguir estos pasos sigues teniendo problemas:

1. **Ejecuta el diagnóstico completo**:
   ```
   diagnosticar_asignacion.bat → Opción 1
   ```

2. **Revisa los logs del servidor** (Tomcat):
   ```
   [TOMCAT_HOME]/logs/catalina.out
   ```

3. **Ejecuta las consultas de verificación** del PASO 5

4. **Consulta las guías adicionales**:
   - `GUIA_VERIFICACION_ASIGNACION_ACTIVIDADES.md` (guía detallada)
   - `RESUMEN_ASIGNACION_ACTIVIDADES.md` (resumen rápido)

---

**Última actualización**: 2026-02-23  
**Versión**: 1.0  
**Estado**: ✅ Verificado y Funcional

