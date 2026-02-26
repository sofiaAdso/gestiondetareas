# 🔄 MIGRACIÓN COMPLETA: Tareas → Actividades con Tareas Hijas

## 📋 Resumen Ejecutivo

Se ha creado un **script SQL completo** que transforma la estructura de la base de datos de:

```
ANTES: tareas (independientes)
DESPUÉS: actividades → tareas (relación padre-hijo 1:N)
```

---

## 🎯 Objetivo

Convertir la tabla actual `tareas` en `actividades`, y crear una nueva tabla `tareas` que sean hijas de las actividades, estableciendo una jerarquía clara:

```
Usuario
  └── Actividad (proyecto, iniciativa)
       ├── Tarea 1
       ├── Tarea 2
       └── Tarea 3
```

---

## 📊 Transformación de Datos

### **ANTES:**
```sql
tareas (
    id, 
    titulo, 
    descripcion, 
    usuario_id, 
    categoria_id, 
    actividad_id,  -- no se usaba o era NULL
    estado, 
    prioridad, 
    fechas...
)
```

### **DESPUÉS:**
```sql
actividades (  -- Renombrada desde tareas
    id,
    titulo,
    descripcion,
    usuario_id,
    categoria_id,
    estado,
    prioridad,
    fechas...
)

tareas (  -- NUEVA TABLA
    id,
    titulo,
    descripcion,
    actividad_id,  -- OBLIGATORIO: FK a actividades
    prioridad,
    estado,
    completada,
    fechas...
)
```

---

## 📁 Archivos Generados

### 1. **Script SQL de Migración** ✅
**Archivo**: `migracion_tareas_a_actividades_completa.sql`

**Contiene:**
- ✅ Renombre de tabla `tareas` → `actividades`
- ✅ Renombre de secuencias e índices
- ✅ Creación de nueva tabla `tareas`
- ✅ Migración automática de datos
- ✅ Creación de vista de progreso
- ✅ Validaciones y estadísticas
- ✅ Comentarios y documentación
- ✅ Opción de rollback

---

### 2. **Modelo Tarea Actualizado** ✅
**Archivo**: `Tarea.java`

**Cambios:**
- ❌ Eliminado: `usuario_id`, `categoria_id`, `nombreCategoria`, `nombreUsuario`, `activo`
- ✅ Agregado: `completada`, `notas`, `fecha_creacion`
- ✅ Campo `actividad_id` ahora es **OBLIGATORIO**

**Campos finales:**
```java
- id
- titulo
- descripcion
- prioridad
- estado
- fecha_inicio
- fecha_vencimiento
- fecha_creacion
- actividad_id (OBLIGATORIO)
- completada
- notas
```

---

### 3. **TareaDao Reescrito** ✅
**Archivo**: `TareaDao.java`

**Métodos principales:**
- `listarPorActividad(int actividadId)` - Lista tareas de una actividad
- `registrar(Tarea tarea)` - Crea nueva tarea
- `actualizar(Tarea tarea)` - Actualiza tarea
- `eliminar(int id)` - Elimina tarea
- `obtenerPorId(int id)` - Obtiene una tarea
- `marcarCompletada(int id, boolean completada)` - Cambia estado
- `contarPorActividad(int actividadId)` - Cuenta tareas
- `contarCompletadasPorActividad(int actividadId)` - Cuenta completadas

---

### 4. **TareaServlet Nuevo** ✅
**Archivo**: `TareaServlet.java`

**Acciones:**
- `crear` - Crear tarea dentro de actividad
- `actualizar` - Actualizar tarea
- `eliminar` - Eliminar tarea
- `completar` - Marcar como completada
- `editar` - Preparar formulario de edición

---

## 🚀 Pasos para Ejecutar la Migración

### **PASO 1: Backup de la Base de Datos** ⚠️

```bash
pg_dump -U postgres gestion_tareas > backup_antes_migracion_$(date +%Y%m%d).sql
```

### **PASO 2: Ejecutar el Script SQL**

```bash
psql -U postgres -d gestion_tareas -f migracion_tareas_a_actividades_completa.sql
```

O desde la consola de PostgreSQL:

```sql
\i migracion_tareas_a_actividades_completa.sql
```

### **PASO 3: Verificar Resultados**

Después de ejecutar, verás estadísticas como:

```
╔════════════════════════════════════╗
║ MIGRACIÓN COMPLETADA EXITOSAMENTE ║
╠════════════════════════════════════╣
║ Total Actividades: 47              ║
║ Total Tareas: 47                   ║
║ Promedio Tareas/Actividad: 1.00    ║
╚════════════════════════════════════╝
```

### **PASO 4: Compilar el Proyecto**

```bash
mvn clean compile
```

### **PASO 5: Desplegar**

```bash
mvn package
# Desplegar el WAR generado
```

---

## 📊 Estructura Resultante

### **Tabla `actividades`** (antes `tareas`)
```sql
CREATE TABLE actividades (
    id SERIAL PRIMARY KEY,
    usuario_id INT REFERENCES usuarios(id),
    titulo VARCHAR(100) NOT NULL,
    descripcion TEXT,
    categoria_id INT REFERENCES categorias(id),
    fecha_inicio DATE,
    fecha_vencimiento DATE,
    prioridad VARCHAR(20),
    estado VARCHAR(20),
    color VARCHAR(7),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### **Tabla `tareas`** (nueva)
```sql
CREATE TABLE tareas (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    descripcion TEXT,
    prioridad VARCHAR(20) DEFAULT 'Media',
    estado VARCHAR(20) DEFAULT 'Pendiente',
    fecha_inicio DATE DEFAULT CURRENT_DATE,
    fecha_vencimiento DATE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actividad_id INT NOT NULL,  -- OBLIGATORIO
    completada BOOLEAN DEFAULT FALSE,
    notas TEXT,
    
    CONSTRAINT fk_tarea_actividad 
        FOREIGN KEY (actividad_id) 
        REFERENCES actividades(id) 
        ON DELETE CASCADE,  -- Si se elimina actividad, se eliminan tareas
    
    CONSTRAINT chk_prioridad CHECK (prioridad IN ('Baja', 'Media', 'Alta')),
    CONSTRAINT chk_estado CHECK (estado IN ('Pendiente', 'En Proceso', 'Completada')),
    CONSTRAINT chk_fechas CHECK (fecha_vencimiento >= fecha_inicio)
);
```

---

## 🔍 Vista de Progreso

El script crea automáticamente una vista para ver el progreso de cada actividad:

```sql
SELECT * FROM vista_actividades_progreso;
```

**Resultado:**
```
┌────┬──────────────┬─────────────┬──────────────────┬──────────────┐
│ ID │ Actividad    │ Total Tareas│ Completadas      │ % Completado │
├────┼──────────────┼─────────────┼──────────────────┼──────────────┤
│ 1  │ Proyecto Web │ 5           │ 3                │ 60.00        │
│ 2  │ Marketing    │ 3           │ 1                │ 33.33        │
└────┴──────────────┴─────────────┴──────────────────┴──────────────┘
```

---

## 🎨 Cambios en la Aplicación

### **Vista de Actividad Detallada** (actualizar `ver-actividad.jsp`)

Ahora debe mostrar:

```html
<div class="actividad">
    <h1>${actividad.titulo}</h1>
    <p>${actividad.descripcion}</p>
    
    <!-- LISTA DE TAREAS HIJAS -->
    <div class="tareas">
        <h2>Tareas de esta Actividad</h2>
        
        <c:forEach items="${listaTareas}" var="tarea">
            <div class="tarea">
                <input type="checkbox" 
                       ${tarea.completada ? 'checked' : ''}
                       onchange="marcarCompletada(${tarea.id}, this.checked)">
                <span>${tarea.titulo}</span>
                <span class="badge">${tarea.estado}</span>
                <a href="TareaServlet?accion=eliminar&id=${tarea.id}&actividad_id=${actividad.id}">
                    Eliminar
                </a>
            </div>
        </c:forEach>
        
        <!-- Formulario para agregar nueva tarea -->
        <form action="TareaServlet" method="post">
            <input type="hidden" name="accion" value="crear">
            <input type="hidden" name="actividad_id" value="${actividad.id}">
            <input type="text" name="titulo" placeholder="Nueva tarea..." required>
            <button type="submit">Agregar Tarea</button>
        </form>
    </div>
    
    <!-- Barra de progreso -->
    <div class="progreso">
        <div class="barra" style="width: ${porcentajeCompletado}%"></div>
        <span>${tareasCompletadas} de ${totalTareas} tareas completadas</span>
    </div>
</div>
```

---

## 📝 Actualización de Servlets

### **ActividadServlet** - Método `verActividad`

```java
private void verActividad(HttpServletRequest request, HttpServletResponse response, Usuario user)
        throws ServletException, IOException {
    try {
        int id = Integer.parseInt(request.getParameter("id"));
        Actividad actividad = actividadDao.obtenerPorId(id);

        if (actividad != null) {
            // Obtener las tareas de esta actividad
            TareaDao tareaDao = new TareaDao();
            List<Tarea> listaTareas = tareaDao.listarPorActividad(id);
            
            // Calcular progreso
            int totalTareas = listaTareas.size();
            int tareasCompletadas = (int) listaTareas.stream()
                .filter(Tarea::isCompletada)
                .count();
            double porcentaje = totalTareas > 0 
                ? (tareasCompletadas * 100.0) / totalTareas 
                : 0;

            request.setAttribute("actividad", actividad);
            request.setAttribute("listaTareas", listaTareas);
            request.setAttribute("totalTareas", totalTareas);
            request.setAttribute("tareasCompletadas", tareasCompletadas);
            request.setAttribute("porcentajeCompletado", porcentaje);
            
            request.getRequestDispatcher("ver-actividad.jsp").forward(request, response);
        } else {
            response.sendRedirect("ActividadServlet?accion=listar&error=actividad_no_encontrada");
        }
    } catch (NumberFormatException e) {
        response.sendRedirect("ActividadServlet?accion=listar&error=id_invalido");
    }
}
```

---

## 🔄 Rollback (Si algo sale mal)

Si necesitas revertir la migración:

```sql
BEGIN;

-- 1. Restaurar desde backup
-- pg_restore -U postgres -d gestion_tareas backup_antes_migracion.sql

-- O manualmente:

-- 2. Eliminar nueva tabla tareas
DROP TABLE IF EXISTS tareas CASCADE;

-- 3. Renombrar actividades de vuelta a tareas
ALTER TABLE actividades RENAME TO tareas;
ALTER SEQUENCE actividades_id_seq RENAME TO tareas_id_seq;

-- 4. Eliminar vista
DROP VIEW IF EXISTS vista_actividades_progreso;

COMMIT;
```

---

## ✅ Checklist de Migración

### **Antes de Ejecutar:**
- [ ] Hacer backup completo de la base de datos
- [ ] Revisar el script SQL
- [ ] Verificar que no hay procesos activos usando las tablas
- [ ] Tener plan de rollback listo

### **Durante la Ejecución:**
- [ ] Ejecutar en un ambiente de prueba primero
- [ ] Verificar que no hay errores en el script
- [ ] Revisar las estadísticas finales

### **Después de Ejecutar:**
- [ ] Verificar que todas las actividades se crearon
- [ ] Verificar que todas las tareas se migraron
- [ ] Probar la vista `vista_actividades_progreso`
- [ ] Compilar y desplegar la aplicación Java
- [ ] Probar la creación de nuevas tareas
- [ ] Probar la actualización de tareas
- [ ] Probar la eliminación de actividades (CASCADE)

---

## 🎯 Ventajas de la Nueva Estructura

### **1. Jerarquía Clara**
```
Usuario → Actividad → Tareas
```

### **2. Mejor Organización**
- Las actividades representan proyectos o iniciativas grandes
- Las tareas son pasos específicos dentro de cada actividad

### **3. Seguimiento de Progreso**
- Cada actividad tiene un % de completado basado en sus tareas
- Fácil visualización del avance

### **4. Escalabilidad**
- Más fácil agregar niveles adicionales (subtareas)
- Mejor para aplicaciones grandes

### **5. Integridad Referencial**
- ON DELETE CASCADE: eliminar actividad elimina sus tareas automáticamente
- Restricciones de integridad en la BD

---

## 📊 Comparación

| Aspecto | ANTES | DESPUÉS |
|---------|-------|---------|
| **Estructura** | Plana (tareas sueltas) | Jerárquica (actividades → tareas) |
| **Tabla tareas** | Contenía todo | Renombrada a `actividades` |
| **Tabla actividades** | No existía | Renombrada desde `tareas` |
| **Nueva tabla tareas** | No existía | Creada como hija de actividades |
| **Relación** | Ninguna | 1 actividad → N tareas |
| **Progreso** | Por tarea individual | Por actividad completa |
| **Complejidad** | Baja | Media (pero más organizada) |

---

## 🎊 Resultado Final

Después de la migración tendrás:

```
ESTRUCTURA DE BASE DE DATOS:
┌─────────────────────┐
│     usuarios        │
└─────────┬───────────┘
          │
          ├─── actividades (antes: tareas)
          │    ├── id
          │    ├── titulo
          │    ├── descripcion
          │    ├── usuario_id
          │    └── ...
          │
          └─── tareas (NUEVA)
               ├── id
               ├── titulo
               ├── descripcion
               ├── actividad_id (FK)
               ├── completada
               └── ...
```

---

## 📞 Soporte

Si encuentras problemas durante la migración:

1. **Revisar logs**: El script imprime mensajes detallados
2. **Verificar integridad**: Ejecutar las queries de verificación del script
3. **Rollback**: Usar el backup o los comandos de rollback
4. **Consultar documentación**: Este archivo tiene todos los detalles

---

✅ **Script de Migración Completo Creado y Listo para Ejecutar**

El archivo `migracion_tareas_a_actividades_completa.sql` contiene todo lo necesario para transformar tu estructura de datos de forma segura y completa.

