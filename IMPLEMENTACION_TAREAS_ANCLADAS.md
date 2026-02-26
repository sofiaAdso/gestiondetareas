# ✅ Implementación: Tareas Ancladas a Actividades

## 🎯 Objetivo Completado

Se ha implementado exitosamente la lógica para que **cada tarea esté obligatoriamente anclada a una actividad**, estableciendo la relación: **1 Actividad → N Tareas**

---

## 📋 Cambios Realizados

### 1. **Formulario de Tareas** (`formulario-tarea.jsp`)

#### Cambios Principales:
- ✅ **Actividad ahora es OBLIGATORIA** (campo `required`)
- ✅ Etiqueta actualizada: "Actividad * (Requerida)"
- ✅ Mensaje claro: "Cada tarea debe estar asociada a una actividad"
- ✅ Validación visual: si no hay actividades, muestra enlace para crear una
- ✅ Alertas SweetAlert para errores de actividad:
  - Error si no se selecciona actividad
  - Error si la actividad es inválida

**Antes:**
```html
<label>Actividad (Opcional)</label>
<select name="txtactividad">
    <option value="">-- Sin Actividad --</option>
    ...
</select>
```

**Después:**
```html
<label>Actividad * <span style="color: #e74c3c;">(Requerida)</span></label>
<select name="txtactividad" required>
    <option value="">-- Seleccionar Actividad --</option>
    ...
</select>
<small>
    ⚠️ Cada tarea debe estar asociada a una actividad.
    [Enlace para crear actividad si no hay]
</small>
```

---

### 2. **Servlet de Tareas** (`Tareaservlet.java`)

#### Validación Obligatoria de Actividad:

**Antes** (actividad opcional):
```java
// Manejo seguro de Actividad (opcional)
String actStr = request.getParameter("txtactividad");
if (actStr != null && !actStr.trim().isEmpty()) {
    try {
        t.setActividad_id(Integer.parseInt(actStr));
    } catch (NumberFormatException ex) {
        t.setActividad_id(0); // Sin actividad si hay error
    }
} else {
    t.setActividad_id(0); // Sin actividad
}
```

**Después** (actividad obligatoria):
```java
// Manejo de Actividad (OBLIGATORIA)
String actStr = request.getParameter("txtactividad");
if (actStr != null && !actStr.trim().isEmpty()) {
    try {
        t.setActividad_id(Integer.parseInt(actStr));
    } catch (NumberFormatException ex) {
        // ERROR: redirigir con mensaje
        response.sendRedirect("...&error=actividad_invalida");
        return;
    }
} else {
    // ERROR: actividad es obligatoria
    response.sendRedirect("...&error=actividad_requerida");
    return;
}
```

---

### 3. **DAO de Tareas** (`TareaDao.java`)

#### Se agregó el nombre de la actividad en los listados mediante LEFT JOIN:

**Métodos Actualizados:**

1. **`listar()`** - Lista todas las tareas (Admin)
2. **`listarPorUsuario(int idUsuario)`** - Lista tareas del usuario
3. **`listarReporteConFiltros(...)`** - Lista con filtros para reportes

**SQL Actualizado:**
```sql
SELECT t.*, u.username, c.nombre AS nombre_cat, a.titulo AS nombre_act
FROM tareas t
LEFT JOIN usuarios u ON t.usuario_id = u.id
LEFT JOIN categorias c ON t.categoria_id = c.id
LEFT JOIN actividades a ON t.actividad_id = a.id  -- NUEVO
ORDER BY a.titulo, t.id DESC  -- Ordenar por actividad
```

**Ahora se setea:**
```java
t.setNombreActividad(rs.getString("nombre_act"));
```

---

### 4. **Vista de Listado de Tareas** (`listar-tareas.jsp`)

#### Se agregó columna de Actividad:

**Tabla Actualizada:**

| Antes (7 columnas) | Después (8 columnas) |
|-------------------|---------------------|
| - | **Actividad** ✨ (NUEVA) |
| Título | Título |
| Descripción | Descripción |
| F. Inicio | F. Inicio |
| F. Venc. | F. Venc. |
| Categoría | Categoría |
| Prior. | Prior. |
| Estado | Estado |
| (Admin: Asignado a) | (Admin: Asignado a) |
| (Admin: Acciones) | (Admin: Acciones) |

**Ejemplo de visualización:**
```html
<td>
    <strong style="color: #667eea;">
        <i class="fas fa-folder"></i> 
        Proyecto Final SENA
    </strong>
</td>
<td><strong>Diseñar mockups</strong></td>
```

**Mensaje cuando no hay tareas:**
- Admin: "Primero crea una actividad, luego podrás agregar tareas a ella"
- Usuario: "El administrador aún no te ha asignado ninguna tarea"

---

## 🗺️ Flujo de Trabajo Actualizado

### **Para el Administrador:**

```
1. Crear Actividad
   ↓
2. Crear Tareas asociadas a esa Actividad
   ↓
3. Ver tareas agrupadas por actividad
```

### **Para el Usuario:**

```
1. Ver Actividades asignadas
   ↓
2. Ver Tareas dentro de cada Actividad
   ↓
3. Cambiar estado de las tareas
```

---

## 📊 Estructura de Datos

### **Relación:**
```
ACTIVIDADES (1) ←─── (N) TAREAS
     ↓
   titulo
   descripcion
   usuario_id
   ...
                        ↓
                      titulo
                      descripcion
                      actividad_id (FK) ← OBLIGATORIO
                      categoria_id
                      usuario_id
                      estado
                      ...
```

### **Tabla `tareas`:**
- ✅ Campo `actividad_id` INT **NOT NULL** (debe existir)
- ✅ FOREIGN KEY hacia `actividades(id)`
- ✅ ON DELETE: SET NULL o CASCADE (según preferencia)

---

## ✅ Validaciones Implementadas

### **Frontend (formulario-tarea.jsp):**
1. ✅ Campo `select` con atributo `required`
2. ✅ Validación HTML5 impide envío sin actividad
3. ✅ Alertas SweetAlert si hay error
4. ✅ Mensaje visual si no hay actividades disponibles
5. ✅ Enlace directo para crear actividad

### **Backend (Tareaservlet.java):**
1. ✅ Validación de actividad no vacía
2. ✅ Validación de formato numérico
3. ✅ Redirección con mensaje de error específico
4. ✅ Prevención de inserción de tareas sin actividad

---

## 🔍 Ejemplo de Uso

### **Crear una Tarea:**

1. **Usuario intenta crear tarea SIN seleccionar actividad:**
   ```
   ❌ Error mostrado: "Actividad Requerida - Debes seleccionar una actividad"
   ```

2. **Usuario selecciona una actividad válida:**
   ```
   ✅ Tarea creada exitosamente y vinculada a la actividad
   ```

3. **Vista de tareas muestra:**
   ```
   ┌─────────────────────┬──────────────────┬──────────┐
   │ Actividad           │ Tarea            │ Estado   │
   ├─────────────────────┼──────────────────┼──────────┤
   │ 📁 Proyecto Final   │ Diseñar mockups  │ Pendiente│
   │ 📁 Proyecto Final   │ Codificar vistas │ En Proceso│
   │ 📁 Mantenimiento    │ Revisar código   │ Completada│
   └─────────────────────┴──────────────────┴──────────┘
   ```

---

## 🎨 Mejoras Visuales

### **Icono de Carpeta:**
- Cada actividad se muestra con icono 📁
- Color distintivo (#667eea) para actividades

### **Ordenamiento:**
- Las tareas se ordenan primero por actividad
- Luego por ID descendente dentro de cada actividad

### **Mensaje de Sin Tareas:**
- Guía clara para crear actividad primero
- Enlace directo a creación de actividad

---

## 📁 Archivos Modificados

| Archivo | Cambios | Líneas Aprox. |
|---------|---------|---------------|
| `formulario-tarea.jsp` | Campo obligatorio + validaciones | ~30 |
| `Tareaservlet.java` | Validación obligatoria | ~15 |
| `TareaDao.java` | JOIN con actividades | ~20 |
| `listar-tareas.jsp` | Nueva columna Actividad | ~15 |
| `ActividadServlet.java` | Fix catch order ✅ | ~5 |

**Total:** ~85 líneas modificadas/agregadas

---

## 🚀 Próximos Pasos

Para desplegar los cambios:

1. **Compilar el proyecto:**
   ```bash
   mvn clean package
   ```

2. **Desplegar el WAR** generado

3. **Probar el flujo:**
   - Crear una actividad
   - Intentar crear tarea sin actividad (debe fallar)
   - Crear tarea con actividad (debe funcionar)
   - Ver listado de tareas agrupadas por actividad

4. **(Opcional) Actualizar BD:**
   Si tienes tareas antiguas sin actividad:
   ```sql
   -- Opción 1: Crear una actividad por defecto
   INSERT INTO actividades (titulo, descripcion, usuario_id, fecha_inicio, fecha_fin, prioridad, estado, color)
   VALUES ('Tareas Generales', 'Actividad por defecto para tareas existentes', 1, CURRENT_DATE, CURRENT_DATE + INTERVAL '30 days', 'Media', 'En Progreso', '#3498db');
   
   -- Opción 2: Asignar las tareas huérfanas a esa actividad
   UPDATE tareas 
   SET actividad_id = (SELECT id FROM actividades WHERE titulo = 'Tareas Generales')
   WHERE actividad_id IS NULL OR actividad_id = 0;
   ```

---

## ✅ Estado Final

- ✅ **Compilación:** Sin errores (solo warnings menores)
- ✅ **Validación Frontend:** Implementada
- ✅ **Validación Backend:** Implementada
- ✅ **Vista actualizada:** Muestra actividad por tarea
- ✅ **Relación DB:** Actividad → Tareas (1:N)
- ✅ **Mensajes de error:** Claros y útiles

---

## 📝 Notas Importantes

1. **Todas las tareas nuevas DEBEN tener una actividad asociada**
2. **No se pueden crear tareas sin primero tener al menos una actividad**
3. **El listado de tareas está ordenado por actividad**
4. **Las tareas huérfanas (sin actividad) deben ser actualizadas en la BD**

---

✅ **Implementación completada exitosamente**

La lógica de negocio ahora refleja correctamente que **cada tarea pertenece a una actividad**, estableciendo una jerarquía clara: **Actividades → Tareas → Subtareas**

