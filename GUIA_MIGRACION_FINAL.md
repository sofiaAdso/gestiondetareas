# MIGRACIÓN COMPLETA: TAREAS → ACTIVIDADES CON TAREAS HIJAS

## 📋 RESUMEN DE LA MIGRACIÓN

Esta migración reorganiza tu base de datos para tener una estructura jerárquica:
- **ANTES**: Usuario → Tarea (directa)
- **DESPUÉS**: Usuario → Actividad → Tarea (jerárquica)

## 🔄 CAMBIOS EN LA BASE DE DATOS

### 1. Tabla ACTIVIDADES (nueva)
La tabla `tareas` actual se renombrará a `actividades`. Esta contendrá:
- Todas tus tareas actuales convertidas en actividades
- Campos: id, titulo, descripcion, prioridad, estado, fecha_inicio, fecha_fin, usuario_id, categoria_id, color, fecha_creacion

### 2. Tabla TAREAS (nueva)
Se creará una nueva tabla `tareas` que dependerá obligatoriamente de actividades:
- Cada tarea DEBE pertenecer a una actividad
- Campos: id, titulo, descripcion, prioridad, estado, fecha_inicio, fecha_vencimiento, actividad_id, completada, notas, fecha_creacion

### 3. Migración de Subtareas
Si tienes subtareas existentes, se migrarán automáticamente a la nueva tabla de tareas.

## 📁 ARCHIVOS ACTUALIZADOS

### Archivos Java Modificados:
1. ✅ **Tarea.java** (modelo)
   - Eliminados campos: usuario_id, categoria_id, activo
   - Agregados campos: completada, notas, fecha_creacion
   - actividad_id ahora es OBLIGATORIO

2. ✅ **TareaDao.java** (repositorio)
   - Actualizado para trabajar con la nueva estructura
   - Todas las consultas ahora hacen JOIN con actividades
   - Agregados métodos para el campo completada

3. ✅ **Tareaservlet.java** (controlador)
   - Actualizado para manejar la nueva estructura
   - Eliminadas referencias a usuario_id y categoria_id en tareas
   - Validación obligatoria de actividad_id

### Archivos SQL Creados:
- **migracion_final_tareas_a_actividades.sql** - Script completo de migración
- **ejecutar_migracion_final.bat** - Script para ejecutar la migración

## 🚀 PASOS PARA EJECUTAR LA MIGRACIÓN

### Paso 1: Preparación
1. **IMPORTANTE**: Cierra tu aplicación si está corriendo
2. Asegúrate de tener PostgreSQL instalado y accesible
3. Verifica que tienes la contraseña de tu usuario de PostgreSQL

### Paso 2: Ejecutar la Migración
```batch
# Opción 1: Usar el script batch (recomendado)
ejecutar_migracion_final.bat

# Opción 2: Manualmente
# Primero crear backup:
pg_dump -U postgres -d gestion_tareas -f backup_antes_migracion.sql

# Luego ejecutar la migración:
psql -U postgres -d gestion_tareas -f migracion_final_tareas_a_actividades.sql
```

### Paso 3: Compilar el Proyecto
```batch
mvn clean package
```

### Paso 4: Desplegar
Despliega el WAR generado en tu servidor Tomcat/GlassFish.

## 📊 ESTRUCTURA FINAL

### Relación de Tablas:
```
usuarios
   ↓
actividades (antes tareas)
   ↓
tareas (nueva tabla)
```

### Ejemplo Práctico:
- **Usuario**: Juan Pérez
  - **Actividad**: "Proyecto Sistema de Gestión"
    - **Tarea 1**: "Diseñar base de datos"
    - **Tarea 2**: "Implementar DAOs"
    - **Tarea 3**: "Crear vistas JSP"
  - **Actividad**: "Documentación"
    - **Tarea 1**: "Manual de usuario"
    - **Tarea 2**: "Manual técnico"

## ⚙️ CAMBIOS NECESARIOS EN EL CÓDIGO (YA REALIZADOS)

### Modelo Tarea
```java
// ANTES
private int usuario_id;
private int categoria_id;
private int actividad_id; // opcional

// DESPUÉS
private int actividad_id; // OBLIGATORIO
private boolean completada;
private String notas;
```

### Crear/Editar Tareas
Ahora las tareas REQUIEREN una actividad:
```java
// actividad_id es obligatorio
if (actStr != null && !actStr.trim().isEmpty()) {
    t.setActividad_id(Integer.parseInt(actStr));
} else {
    // Error: actividad requerida
}
```

## 🎯 PRÓXIMOS PASOS RECOMENDADOS

### 1. Actualizar Vistas JSP
Necesitarás actualizar los siguientes archivos JSP:

**formulario-tarea.jsp**:
- Cambiar el selector de categoría y usuario por un selector de actividad
- Agregar campo para "completada"
- Agregar campo para "notas"

**listar-tareas.jsp**:
- Mostrar el nombre de la actividad en lugar de usuario/categoría
- Agregar indicador de completada

**ver-actividad.jsp**:
- Mostrar la lista de tareas asociadas a cada actividad
- Mostrar progreso basado en tareas completadas

### 2. Crear Vista de Actividades Mejorada
La vista `vista_actividades_progreso` ya fue creada y contiene:
- Total de tareas por actividad
- Tareas completadas
- Porcentaje de progreso

### 3. Agregar Funcionalidad de Gestión
- Permitir crear tareas directamente desde la vista de actividad
- Mostrar estadísticas de progreso
- Filtros por actividad

## 🔧 SOLUCIÓN DE PROBLEMAS

### Error: "column does not exist"
Si ves errores sobre columnas que no existen después de la migración:
1. Verifica que ejecutaste el script de migración completamente
2. Revisa los logs de PostgreSQL
3. Restaura desde el backup si es necesario:
   ```bash
   psql -U postgres -d gestion_tareas -f backup_antes_migracion.sql
   ```

### Error: "relation tareas does not exist"
La migración no se ejecutó. Ejecuta el script SQL manualmente.

### Error al compilar Java
Asegúrate de que todos los archivos Java fueron actualizados y guarda todos los cambios antes de compilar.

## 📝 VERIFICACIÓN POST-MIGRACIÓN

Ejecuta estas consultas para verificar:

```sql
-- Ver todas las actividades
SELECT * FROM actividades LIMIT 5;

-- Ver todas las tareas
SELECT * FROM tareas LIMIT 5;

-- Ver actividades con sus tareas
SELECT 
    a.titulo as actividad,
    COUNT(t.id) as total_tareas,
    COUNT(t.id) FILTER (WHERE t.completada = TRUE) as completadas
FROM actividades a
LEFT JOIN tareas t ON t.actividad_id = a.id
GROUP BY a.id, a.titulo;

-- Usar la vista de progreso
SELECT * FROM vista_actividades_progreso;
```

## ✅ BENEFICIOS DE ESTA ESTRUCTURA

1. **Mejor Organización**: Las actividades agrupan tareas relacionadas
2. **Más Flexible**: Fácil agregar tareas a proyectos/actividades
3. **Mejor Seguimiento**: Progreso visible por actividad
4. **Escalabilidad**: Estructura preparada para crecer
5. **Separación Clara**: Conceptos bien definidos (actividad vs tarea)

## 📞 NOTAS IMPORTANTES

- ✅ Se crea un backup automático antes de la migración
- ✅ La migración es transaccional (todo o nada)
- ✅ Las subtareas existentes se migran automáticamente
- ✅ Los datos no se pierden, solo se reorganizan
- ⚠️ Asegúrate de actualizar las vistas JSP después de la migración

## 🎓 ESTRUCTURA RECOMENDADA DE TRABAJO

1. **Primero**: Crear actividades (proyectos grandes)
2. **Segundo**: Agregar tareas a cada actividad
3. **Tercero**: Marcar tareas como completadas
4. **Cuarto**: Ver el progreso de cada actividad

---

**Fecha de Migración**: 19 de Febrero de 2026
**Autor**: Sistema de Gestión de Tareas SENA
**Versión**: 2.0

