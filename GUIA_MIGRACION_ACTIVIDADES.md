# 🔄 Herramienta de Migración Automática de Actividades

## 📋 Resumen

Se ha implementado una herramienta completa para **migrar tareas existentes creando actividades automáticamente**. Esta funcionalidad analiza las tareas actuales de la base de datos y las agrupa en actividades según su usuario y categoría.

---

## 🎯 Objetivo

Permitir al administrador organizar automáticamente todas las tareas que no tienen actividad asignada, agrupándolas inteligentemente para cumplir con la nueva lógica de negocio: **Actividades → Tareas**.

---

## 📊 ¿Cómo Funciona?

### **Paso 1: Análisis**
- Se identifican todas las tareas sin `actividad_id` asignada
- Se cuentan cuántos usuarios tienen tareas sin organizar

### **Paso 2: Agrupación**
- Las tareas se agrupan por:
  - **Usuario** (cada usuario tiene sus propias actividades)
  - **Categoría** (tareas de la misma categoría van juntas)

### **Paso 3: Creación de Actividades**
Para cada grupo Usuario-Categoría, se crea una actividad con:
- **Título**: "Actividad - [Nombre Categoría]"
- **Descripción**: "Actividad creada automáticamente para agrupar X tareas..."
- **Fecha Inicio**: La fecha más antigua de las tareas del grupo
- **Fecha Fin**: La fecha más lejana de las tareas del grupo
- **Color**: Según el tipo de categoría:
  - 🔵 Azul (#3498db) - Trabajo/Work
  - 🔴 Rojo (#e74c3c) - Personal
  - 🟣 Púrpura (#9b59b6) - Estudio/Educación
  - 🟠 Naranja (#f39c12) - Hogar/Casa
  - 🟢 Verde (#2ecc71) - General/Otros

### **Paso 4: Asignación**
- Todas las tareas del grupo se vinculan a la actividad creada
- Se actualiza el campo `actividad_id` en cada tarea

---

## 📁 Archivos Creados

### 1. **Script SQL** (`crear_actividades_automaticas.sql`)
Script completo de PostgreSQL con:
- ✅ Consultas de análisis previo
- ✅ Proceso automático con bloques PL/pgSQL
- ✅ Verificación de resultados
- ✅ Opción de ROLLBACK si algo sale mal

**Ubicación**: Raíz del proyecto

**Uso**:
```bash
psql -U tu_usuario -d tu_base_datos -f crear_actividades_automaticas.sql
```

---

### 2. **Clase Java** (`MigradorActividadesAutomatico.java`)
Utilidad Java para ejecutar la migración programáticamente.

**Ubicación**: `src/main/java/com/sena/gestion/util/`

**Características**:
- ✅ Conexión JDBC a la base de datos
- ✅ Lógica de agrupación inteligente
- ✅ Asignación de colores por categoría
- ✅ Logging detallado del proceso
- ✅ Resultado estructurado con estadísticas

**Uso desde consola**:
```bash
java com.sena.gestion.util.MigradorActividadesAutomatico
```

**Uso programático**:
```java
MigradorActividadesAutomatico migrador = new MigradorActividadesAutomatico();
MigracionResultado resultado = migrador.ejecutarMigracion();

System.out.println("Actividades creadas: " + resultado.actividadesCreadas);
System.out.println("Tareas asignadas: " + resultado.tareasAsignadas);
```

---

### 3. **Servlet Web** (`MigracionServlet.java`)
Controlador para ejecutar la migración desde la interfaz web.

**Ubicación**: `src/main/java/com/sena/gestion/controller/`

**URL**: `/MigracionServlet`

**Acciones**:
- `?accion=ver` - Muestra página de confirmación
- `?accion=ejecutar` - Ejecuta la migración

**Seguridad**:
- ✅ Solo accesible por **Administradores**
- ✅ Validación de sesión
- ✅ Redirección automática si no está autenticado

---

### 4. **Página de Interfaz** (`migracion-actividades.jsp`)
Interfaz visual moderna para ejecutar la migración.

**Ubicación**: `src/main/webapp/`

**Características**:
- ✅ Diseño moderno con gradientes
- ✅ Explicación clara del proceso
- ✅ Pasos visuales numerados
- ✅ Advertencias importantes
- ✅ Confirmación con SweetAlert2
- ✅ Indicador de progreso durante ejecución
- ✅ Mensajes de éxito/error

**Acceso**: Menú lateral del administrador → "🔄 Migración Automática"

---

## 🎨 Interfaz de Usuario

### **Página de Confirmación**

```
╔══════════════════════════════════════════╗
║                                          ║
║         [🔄 Icono Circular]              ║
║                                          ║
║   Migración Automática de Actividades   ║
║   Agrupa tus tareas en actividades      ║
║                                          ║
╠══════════════════════════════════════════╣
║                                          ║
║  ℹ️  ¿Qué hace esta herramienta?         ║
║  ✓ Analiza tareas sin actividad         ║
║  ✓ Las agrupa por usuario y categoría   ║
║  ✓ Crea actividades automáticamente     ║
║  ✓ Asigna las tareas                    ║
║                                          ║
╠══════════════════════════════════════════╣
║                                          ║
║  📋 Proceso de Migración:                ║
║                                          ║
║  [1] Identificación                     ║
║      Se identifican tareas sin actividad║
║                                          ║
║  [2] Agrupación                         ║
║      Las tareas se agrupan              ║
║                                          ║
║  [3] Creación                           ║
║      Se crean las actividades           ║
║                                          ║
║  [4] Asignación                         ║
║      Todas las tareas se vinculan       ║
║                                          ║
╠══════════════════════════════════════════╣
║                                          ║
║  ⚠️  Importante - Antes de ejecutar      ║
║  ✓ Este proceso es irreversible         ║
║  ✓ Haz respaldo de la base de datos     ║
║  ✓ Las actividades tienen prefijo       ║
║  ✓ Puedes editarlas después             ║
║                                          ║
╠══════════════════════════════════════════╣
║                                          ║
║    [Cancelar]  [▶️ Ejecutar Migración]   ║
║                                          ║
╚══════════════════════════════════════════╝
```

---

## 🔐 Seguridad

### **Control de Acceso**:
1. ✅ Solo **Administradores** pueden acceder
2. ✅ Validación de sesión activa
3. ✅ Redirección automática si no autorizado

### **Confirmación**:
- ⚠️ Doble confirmación antes de ejecutar
- ⚠️ Advertencias claras sobre irreversibilidad
- ⚠️ Recomendación de respaldo

---

## 📊 Ejemplo de Uso

### **Escenario:**
Tienes 50 tareas sin actividad distribuidas así:
- Usuario "Juan" - 20 tareas (10 Trabajo, 10 Personal)
- Usuario "María" - 30 tareas (15 Estudio, 15 Personal)

### **Resultado de la Migración:**

```
Actividades Creadas:
┌────┬─────────────────────────┬─────────┬────────┐
│ ID │ Título                  │ Usuario │ Tareas │
├────┼─────────────────────────┼─────────┼────────┤
│ 1  │ Actividad - Trabajo     │ Juan    │ 10     │
│ 2  │ Actividad - Personal    │ Juan    │ 10     │
│ 3  │ Actividad - Estudio     │ María   │ 15     │
│ 4  │ Actividad - Personal    │ María   │ 15     │
└────┴─────────────────────────┴─────────┴────────┘

Total: 4 actividades creadas
Total: 50 tareas organizadas
```

---

## 🛠️ Uso de la Herramienta

### **Opción 1: Desde la Interfaz Web** (Recomendado)

1. Login como **Administrador**
2. Dashboard → Menú lateral → **"🔄 Migración Automática"**
3. Leer la información del proceso
4. Click en **"Ejecutar Migración"**
5. Confirmar en el diálogo de SweetAlert
6. Esperar a que termine (se muestra loading)
7. Ver resultados en la lista de actividades

---

### **Opción 2: Ejecutar Script SQL Directamente**

```bash
# Conectar a PostgreSQL
psql -U postgres -d gestion_tareas

# Ejecutar el script
\i crear_actividades_automaticas.sql

# Ver resultados
SELECT * FROM actividades WHERE descripcion LIKE '%creada automáticamente%';
```

---

### **Opción 3: Ejecutar desde Java (Consola)**

```bash
# Compilar el proyecto
mvn clean compile

# Ejecutar la clase principal
java -cp target/classes com.sena.gestion.util.MigradorActividadesAutomatico
```

---

## 📈 Mensajes de Resultado

### **Éxito:**
```
╔════════════════════════════════════════╗
║   ✅ ¡Migración Completada!            ║
╠════════════════════════════════════════╣
║ Las tareas se han organizado en       ║
║ actividades correctamente             ║
║                                        ║
║ 📁 5 actividades creadas               ║
║ ✓ 42 tareas organizadas                ║
║                                        ║
║ Ahora todas tus tareas están          ║
║ agrupadas por categoría                ║
╚════════════════════════════════════════╝
```

### **Error:**
```
❌ Migración Fallida
La migración no pudo completarse correctamente.
Errores encontrados: 2
```

---

## 🔄 Proceso de Rollback (Si se necesita deshacer)

Si la migración no sale como esperabas, puedes revertir los cambios:

```sql
-- 1. Desasociar tareas de actividades automáticas
UPDATE tareas 
SET actividad_id = NULL 
WHERE actividad_id IN (
    SELECT id FROM actividades 
    WHERE descripcion LIKE '%creada automáticamente%'
);

-- 2. Eliminar actividades automáticas
DELETE FROM actividades 
WHERE descripcion LIKE '%creada automáticamente%';
```

---

## ✅ Checklist Pre-Migración

Antes de ejecutar la migración, asegúrate de:

- [ ] Tener un **respaldo reciente** de la base de datos
- [ ] Estar logueado como **Administrador**
- [ ] Verificar que hay tareas sin actividad (`actividad_id IS NULL`)
- [ ] Entender que el proceso es **irreversible**
- [ ] Tener tiempo para revisar y editar las actividades después

---

## 📝 Notas Importantes

1. **Las actividades creadas son editables**: Después de la migración, puedes cambiar títulos, descripciones, fechas y colores.

2. **El proceso es inteligente**: Las tareas se agrupan lógicamente por usuario y categoría, no aleatoriamente.

3. **Los colores son sugeridos**: Se asignan colores según palabras clave en las categorías, pero puedes cambiarlos.

4. **Fechas calculadas**: Las fechas de inicio y fin de cada actividad se calculan a partir de las tareas que contiene.

5. **Actividades vacías no se crean**: Solo se crean actividades si hay al menos una tarea en el grupo.

---

## 🎯 Beneficios

✅ **Ahorra tiempo**: No necesitas crear actividades manualmente
✅ **Organización automática**: Las tareas se agrupan lógicamente
✅ **Cumple con la nueva lógica**: Todas las tareas tendrán actividad
✅ **Visualización mejorada**: Estructura jerárquica clara
✅ **Fácil de usar**: Interfaz intuitiva con confirmaciones

---

## 🚀 Acceso Rápido

### **Desde el Menú:**
```
Dashboard → Menú Lateral → 🔄 Migración Automática
```

### **URL Directa:**
```
http://localhost:8080/SistemaGestionTareas/MigracionServlet?accion=ver
```

---

## 📊 Estadísticas de Ejemplo

Después de ejecutar la migración, verás algo como:

```
=== MIGRACIÓN COMPLETADA ===

Migración EXITOSA:
- Tareas analizadas: 47
- Actividades creadas: 8
- Tareas asignadas: 47
- Errores: 0

Actividades creadas:
✓ Actividad 1 - Usuario: juan - Trabajo - 12 tareas
✓ Actividad 2 - Usuario: juan - Personal - 8 tareas
✓ Actividad 3 - Usuario: maria - Estudio - 15 tareas
✓ Actividad 4 - Usuario: maria - Personal - 5 tareas
...
```

---

## 🎊 ¡Listo para Usar!

La herramienta está completamente implementada y lista para ejecutarse. Solo necesitas:

1. Compilar el proyecto
2. Desplegar el WAR
3. Acceder como administrador
4. Ejecutar la migración

---

✅ **Implementación Completa - Documentación Lista**

