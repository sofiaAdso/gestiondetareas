# Resumen de Cambios - Agregar Tareas a Actividades

## 📋 Problema Identificado
La página de actividades mostraba "0 de 0 tareas" aunque las actividades deberían tener tareas asociadas.

## ✅ Solución Implementada

### 1. Corrección del JSP (listar-actividades.jsp)
**Problema:** Error de compilación JSP en línea 307
```
The method getTareas() is undefined for the type Actividad
```

**Solución:** 
- Eliminada la variable local `List<Tarea> tareas = act.getTareas();`
- Reemplazadas todas las referencias a `tareas` por llamadas directas a `act.getTareas()`

**Cambios específicos:**
```jsp
<!-- ANTES -->
<% List<Tarea> tareas = act.getTareas(); %>
<% if (tareas != null && !tareas.isEmpty()) { %>
    <span>Ver tareas (<%= tareas.size() %>)</span>
    <% for (Tarea tarea : tareas) { %>
    
<!-- DESPUÉS -->
<% if (act.getTareas() != null && !act.getTareas().isEmpty()) { %>
    <span>Ver tareas (<%= act.getTareas().size() %>)</span>
    <% for (Tarea tarea : act.getTareas()) { %>
```

### 2. ActividadServlet.java - Método listarActividades()
**Problema:** Las tareas se cargaban pero no se calculaban las estadísticas

**Solución:** Agregado cálculo de estadísticas después de cargar las tareas

**Código agregado:**
```java
// Cargar las tareas de cada actividad y calcular estadísticas
for (Actividad actividad : listaActividades) {
    List<Tarea> tareas = tareaDao.listarPorActividad(actividad.getId());
    actividad.setTareas(tareas);
    
    // Calcular estadísticas de tareas
    int totalTareas = tareas.size();
    int tareasCompletadas = 0;
    
    for (Tarea tarea : tareas) {
        if ("Completada".equals(tarea.getEstado()) || tarea.isCompletada()) {
            tareasCompletadas++;
        }
    }
    
    actividad.setTotalTareas(totalTareas);
    actividad.setTareasCompletadas(tareasCompletadas);
    
    // Calcular porcentaje
    if (totalTareas > 0) {
        double porcentaje = (tareasCompletadas * 100.0) / totalTareas;
        actividad.setPorcentajeCompletado(porcentaje);
    } else {
        actividad.setPorcentajeCompletado(0);
    }
}
```

### 3. ActividadServlet.java - Método verActividad()
**Solución:** Mismo cálculo de estadísticas aplicado al ver una actividad individual

## 📁 Archivos Modificados

1. **src/main/webapp/listar-actividades.jsp**
   - Línea 307: Eliminada declaración de variable local
   - Líneas 356-363: Reemplazadas referencias a variable local

2. **src/main/java/com/sena/gestion/controller/ActividadServlet.java**
   - Método `listarActividades()`: Agregado cálculo de estadísticas (líneas 106-127)
   - Método `verActividad()`: Agregado cálculo de estadísticas (líneas 247-268)

## 📄 Archivos Creados

1. **INSTRUCCIONES_RECOMPILAR.md** - Guía detallada para recompilar y redesplegar
2. **verificar_y_crear_tareas_actividades.sql** - Script SQL para verificar/crear tareas de ejemplo
3. **RESUMEN_CAMBIOS_TAREAS.md** - Este archivo

## 🔄 Pasos para Aplicar los Cambios

### Paso 1: Recompilar el Proyecto
Desde IntelliJ IDEA:
```
Build → Rebuild Project
Build → Build Artifacts → SistemaGestionTareas:war → Rebuild
```

O usando Maven:
```bash
mvn clean package
```

### Paso 2: Verificar/Crear Tareas en la Base de Datos
Ejecutar en PostgreSQL:
```bash
psql -U postgres -d Gestiondetareas -f verificar_y_crear_tareas_actividades.sql
```

O desde pgAdmin/DBeaver, ejecutar el contenido del archivo SQL.

### Paso 3: Redesplegar en Tomcat
**Opción A - Desde IntelliJ:**
- Run → Run (Shift+F10)

**Opción B - Manualmente:**
1. Detener Tomcat
2. Eliminar: `[TOMCAT]/webapps/SistemaGestionTareas/` y `.war`
3. Copiar nuevo WAR: `target/SistemaGestionTareas.war` → `[TOMCAT]/webapps/`
4. Iniciar Tomcat

### Paso 4: Verificar
Acceder a:
```
http://localhost:8080/SistemaGestionTareas/ActividadServlet?accion=listar
```

## ✨ Resultado Esperado

Ahora en la página de actividades verás:

✅ **Contador de tareas correcto:**
- "2 de 4 tareas" (ejemplo)
- Barra de progreso con porcentaje real

✅ **Lista de tareas expandible:**
- Al hacer clic en "Ver tareas (4)" se despliegan las tareas
- Cada tarea muestra: título, estado, prioridad, fecha

✅ **Tarjetas con información completa:**
- Título de la actividad
- Descripción
- Fechas de inicio y fin
- Prioridad (Alta/Media/Baja)
- Progreso visual con barra de porcentaje
- Lista de tareas asociadas

## 🐛 Solución de Problemas

### Error: "The method getTareas() is undefined"
✅ **Ya corregido** - El JSP ahora usa llamadas directas

### Las tareas no se muestran (0 de 0)
Posibles causas:
1. **No hay tareas en la BD** → Ejecutar `verificar_y_crear_tareas_actividades.sql`
2. **Clases no recompiladas** → Ejecutar `mvn clean package` o Rebuild en IntelliJ
3. **Tomcat con versión antigua** → Limpiar directorio work y redesplegar

### El porcentaje siempre es 0%
Verificar que las tareas tengan:
- `estado = 'Completada'` O
- `completada = true`

SQL de verificación:
```sql
SELECT titulo, estado, completada FROM tareas;
```

## 🔍 Validación de la BD

Ejecutar este query para ver el estado actual:
```sql
SELECT 
    a.titulo AS actividad,
    COUNT(t.id) AS total_tareas,
    SUM(CASE WHEN t.estado = 'Completada' OR t.completada = true THEN 1 ELSE 0 END) AS completadas,
    ROUND(
        CASE 
            WHEN COUNT(t.id) > 0 THEN 
                (SUM(CASE WHEN t.estado = 'Completada' OR t.completada = true THEN 1 ELSE 0 END)::numeric / COUNT(t.id)::numeric) * 100
            ELSE 0 
        END, 
        2
    ) AS porcentaje
FROM actividades a
LEFT JOIN tareas t ON t.actividad_id = a.id
GROUP BY a.id, a.titulo
ORDER BY a.id;
```

## 📊 Ejemplo de Datos de Prueba

Si ejecutaste el script SQL, tendrás algo como:

**Actividad: "bañarse"**
- ✅ Preparar ropa limpia (Completada)
- ✅ Calentar agua (Completada)
- 🔄 Lavarse el cabello (En Progreso)
- ⏳ Secar y vestirse (Pendiente)
- **Progreso: 50% (2 de 4 tareas)**

**Actividad: "desarrollo web"**
- ✅ Diseñar mockups (Completada)
- ✅ Implementar HTML/CSS (Completada)
- 🔄 Añadir JavaScript (En Progreso)
- ⏳ Configurar backend (Pendiente)
- ⏳ Pruebas y deployment (Pendiente)
- **Progreso: 40% (2 de 5 tareas)**

## 🎯 Funcionalidad Implementada

- [x] Cargar tareas asociadas a cada actividad
- [x] Calcular total de tareas
- [x] Calcular tareas completadas
- [x] Calcular porcentaje de completado
- [x] Mostrar barra de progreso visual
- [x] Listar tareas en sección expandible
- [x] Mostrar estado de cada tarea (Completada/En Progreso/Pendiente)
- [x] Mostrar prioridad con colores
- [x] Mostrar fechas de vencimiento

## 📝 Notas Adicionales

- Las tareas deben tener `actividad_id` válido para asociarse correctamente
- El estado de las tareas puede ser: 'Pendiente', 'En Progreso', 'Completada'
- El campo `completada` es booleano y también se considera para el cálculo
- El color de la barra de progreso es el mismo que el color de la actividad

---

**Fecha de cambios:** 2026-02-23
**Archivos afectados:** 2 archivos Java, 1 archivo JSP
**Nuevos archivos:** 3 documentos de soporte + 1 script SQL

