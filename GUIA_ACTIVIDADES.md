# 🎯 SISTEMA DE ACTIVIDADES - GUÍA COMPLETA DE INSTALACIÓN

## ✅ IMPLEMENTACIÓN COMPLETADA

Se ha creado exitosamente el sistema completo de **Actividades** que permite organizar múltiples **Tareas** dentro de cada actividad, y cada tarea puede tener **Subtareas**.

---

## 📊 JERARQUÍA DEL SISTEMA

```
📁 ACTIVIDAD (Ej: "Proyecto SENA 2026")
   ├── 📋 Tarea 1 (Ej: "Diseñar interfaz")
   │   ├── ☑ Subtarea 1.1 (Ej: "Crear mockups")
   │   ├── ☑ Subtarea 1.2 (Ej: "Definir paleta de colores")
   │   └── ☐ Subtarea 1.3 (Ej: "Aprobar con cliente")
   ├── 📋 Tarea 2 (Ej: "Desarrollar backend")
   │   ├── ☑ Subtarea 2.1 (Ej: "Crear base de datos")
   │   └── ☐ Subtarea 2.2 (Ej: "Implementar API REST")
   └── 📋 Tarea 3 (Ej: "Realizar pruebas")
       └── ☐ Subtarea 3.1 (Ej: "Testing unitario")
```

---

## 📦 ARCHIVOS CREADOS

### Backend (Java)

1. ✅ **Actividad.java** - Modelo de datos
   - `src/main/java/com/sena/gestion/model/Actividad.java`

2. ✅ **ActividadDao.java** - Acceso a datos
   - `src/main/java/com/sena/gestion/repository/ActividadDao.java`
   - Métodos: crear, listar, actualizar, eliminar, obtener estadísticas

3. ✅ **ActividadServlet.java** - Controlador
   - `src/main/java/com/sena/gestion/controller/ActividadServlet.java`
   - URL: `/ActividadServlet`

### Frontend (JSP)

4. ✅ **listar-actividades.jsp** - Lista de actividades con tarjetas
5. ✅ **formulario-actividad.jsp** - Crear/Editar actividad
6. ✅ **ver-actividad.jsp** - Ver detalles y tareas de una actividad

### Modificaciones

7. ✅ **Tarea.java** - Agregado campo `actividad_id`
8. ✅ **TareaDao.java** - Actualizado para manejar `actividad_id`
9. ✅ **Tareaservlet.java** - Carga lista de actividades
10. ✅ **formulario-tarea.jsp** - Selector de actividad
11. ✅ **dashboard.jsp** - Enlace a "Mis Actividades"

### Base de Datos

12. ✅ **crear_tabla_actividades.sql** - Script SQL completo

### Utilidades

13. ✅ **instalar_actividades.bat** - Script de instalación automática

---

## 🚀 INSTALACIÓN PASO A PASO

### PASO 1: Ejecutar el Script SQL

**Opción A - Usando el script batch (Recomendado):**
```
1. Haz doble clic en: instalar_actividades.bat
2. Espera a que termine la ejecución
3. Verifica que diga "TABLA CREADA EXITOSAMENTE"
```

**Opción B - Manualmente en pgAdmin:**
```
1. Abre pgAdmin 4
2. Conecta a la base de datos "Gestiondetareas"
3. Abre el Query Tool (Herramienta de consulta)
4. Abre el archivo: crear_tabla_actividades.sql
5. Ejecuta el script (F5 o botón Play)
6. Verifica: SELECT * FROM actividades;
```

**Opción C - Por línea de comandos:**
```bash
psql -U postgres -d Gestiondetareas -f crear_tabla_actividades.sql
```

**Verificar instalación:**
```sql
-- Verificar tabla actividades
SELECT * FROM actividades;

-- Verificar columna actividad_id en tareas
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'tareas' AND column_name = 'actividad_id';
```

---

### PASO 2: Compilar el Proyecto

**Si usas Maven desde terminal:**
```bash
cd C:\Users\sofsh\Desktop\Gestiondetareas\SistemaGestionTareas
mvn clean package
```

**Si usas IntelliJ IDEA:**
```
1. Clic derecho en el proyecto
2. Maven → Reload Project
3. Maven → Clean
4. Maven → Package
```

**Si usas Eclipse:**
```
1. Clic derecho en el proyecto
2. Run As → Maven clean
3. Run As → Maven install
```

---

### PASO 3: Desplegar la Aplicación

**Si usas Tomcat:**
```
1. Detén el servidor Tomcat
2. Copia: target/SistemaGestionTareas.war
3. Pega en: [TOMCAT_HOME]/webapps/
4. Elimina la carpeta antigua SistemaGestionTareas (si existe)
5. Inicia el servidor Tomcat
```

---

### PASO 4: Probar el Sistema

1. **Accede a la aplicación:**
   ```
   http://localhost:8080/SistemaGestionTareas
   ```

2. **Inicia sesión** con tu usuario

3. **Ve al Dashboard** y haz clic en **"📁 Mis Actividades"**

4. **Crea tu primera actividad:**
   - Clic en "Nueva Actividad"
   - Título: "Proyecto de Desarrollo Web"
   - Descripción: "Desarrollo completo de sistema web"
   - Fecha inicio y fin
   - Selecciona prioridad y color
   - Guarda

5. **Agrega tareas a la actividad:**
   - Abre la actividad creada
   - Clic en "Agregar Tarea"
   - Completa el formulario
   - En el campo "Actividad", selecciona la actividad
   - Guarda

6. **Agrega subtareas:**
   - Edita una tarea
   - En la sección "Subtareas" al final
   - Agrega subtareas y márcalas como completadas

---

## 🎨 CARACTERÍSTICAS PRINCIPALES

### ✨ Funcionalidades de Actividades

| Característica | Descripción |
|---------------|-------------|
| ➕ **Crear Actividades** | Organiza proyectos grandes |
| 📊 **Barra de Progreso** | Visual del avance de tareas |
| 🎨 **Colores Personalizados** | Identifica visualmente cada actividad |
| 📅 **Fechas de Inicio/Fin** | Planificación temporal |
| 🔢 **Contador de Tareas** | "X de Y completadas" |
| 🏷️ **Prioridades** | Alta, Media, Baja |
| 📝 **Estados** | Planificada, En Progreso, Pausada, Completada |
| 👁️ **Vista Detallada** | Ver todas las tareas de una actividad |

### 🎯 Ventajas del Sistema

✅ **Organización Jerárquica:**
- Actividades → Tareas → Subtareas
- Tres niveles de organización

✅ **Seguimiento de Progreso:**
- Barra de progreso automática
- Porcentajes calculados en tiempo real
- Contadores de tareas completadas

✅ **Flexibilidad:**
- Las tareas pueden estar dentro o fuera de actividades
- Selector opcional en formulario de tareas

✅ **Interfaz Intuitiva:**
- Tarjetas con colores personalizados
- Diseño moderno y responsive
- Iconos descriptivos

---

## 📋 CASOS DE USO REALES

### Ejemplo 1: Proyecto Académico SENA

**Actividad:** "Proyecto Final SENA 2026"
- **Color:** Azul (#3498db)
- **Prioridad:** Alta
- **Fechas:** 01/02/2026 - 30/06/2026

**Tareas:**
1. 📋 Investigación preliminar
   - ☑ Revisar bibliografía
   - ☑ Definir objetivos
   - ☐ Aprobar con instructor

2. 📋 Desarrollo del proyecto
   - ☑ Diseñar arquitectura
   - ☐ Implementar funcionalidades
   - ☐ Realizar pruebas

3. 📋 Documentación
   - ☐ Escribir manual técnico
   - ☐ Crear presentación
   - ☐ Preparar defensa

---

### Ejemplo 2: Evento Empresarial

**Actividad:** "Capacitación para Clientes"
- **Color:** Verde (#27ae60)
- **Prioridad:** Media
- **Fechas:** 15/03/2026 - 20/03/2026

**Tareas:**
1. 📋 Logística
   - ☑ Reservar salón
   - ☑ Contratar catering
   - ☐ Preparar materiales

2. 📋 Contenido
   - ☑ Diseñar diapositivas
   - ☐ Preparar ejercicios prácticos
   - ☐ Revisar con equipo

3. 📋 Comunicación
   - ☑ Enviar invitaciones
   - ☐ Confirmar asistencia
   - ☐ Enviar recordatorios

---

### Ejemplo 3: Desarrollo de Software

**Actividad:** "Sistema de Gestión v2.0"
- **Color:** Morado (#9b59b6)
- **Prioridad:** Alta
- **Fechas:** 01/03/2026 - 31/05/2026

**Tareas:**
1. 📋 Sprint 1: Base de datos
   - ☑ Diseñar modelo ER
   - ☑ Crear tablas
   - ☐ Migrar datos

2. 📋 Sprint 2: Backend
   - ☐ Implementar API REST
   - ☐ Crear servicios
   - ☐ Testing unitario

3. 📋 Sprint 3: Frontend
   - ☐ Diseñar UI/UX
   - ☐ Desarrollar componentes
   - ☐ Integrar con backend

---

## 🔍 ESTRUCTURA DE LA BASE DE DATOS

### Tabla: actividades

```sql
actividades
├── id (SERIAL PRIMARY KEY)
├── usuario_id (INTEGER, FK → usuarios)
├── titulo (VARCHAR 200, NOT NULL)
├── descripcion (TEXT)
├── fecha_inicio (DATE)
├── fecha_fin (DATE)
├── prioridad (VARCHAR 20, DEFAULT 'Media')
├── estado (VARCHAR 20, DEFAULT 'En Progreso')
├── color (VARCHAR 7, DEFAULT '#3498db')
└── fecha_creacion (TIMESTAMP, DEFAULT NOW())
```

### Tabla: tareas (modificada)

```sql
tareas
├── ... (campos existentes)
└── actividad_id (INTEGER, FK → actividades, NULL)
```

**Relaciones:**
- Una **Actividad** tiene muchas **Tareas** (1:N)
- Una **Tarea** pertenece a una **Actividad** (opcional)
- Una **Tarea** tiene muchas **Subtareas** (1:N)
- Si se elimina una **Actividad**, las tareas quedan sin actividad (SET NULL)

---

## 🎓 FLUJO DE TRABAJO RECOMENDADO

### Para Usuarios:

1. **Planifica tu proyecto:**
   - Crea una actividad para el proyecto completo
   - Define fechas inicio/fin realistas
   - Asigna un color identificativo

2. **Desglosa en tareas:**
   - Crea tareas específicas dentro de la actividad
   - Asigna prioridades y fechas de vencimiento
   - Distribuye el trabajo en el tiempo

3. **Detalla con subtareas:**
   - Divide tareas complejas en pasos pequeños
   - Marca subtareas completadas progresivamente
   - Observa el avance en la barra de progreso

4. **Monitorea el progreso:**
   - Revisa el dashboard de la actividad
   - Verifica porcentajes de avance
   - Ajusta fechas si es necesario

---

## 📊 REPORTES Y ESTADÍSTICAS

El sistema calcula automáticamente:

- **Total de tareas** por actividad
- **Tareas completadas** vs pendientes
- **Porcentaje de avance** (0-100%)
- **Estado visual** con barras de progreso
- **Fechas de vencimiento** próximas

---

## 🔧 SOLUCIÓN DE PROBLEMAS

### Error: "Tabla actividades no existe"
**Causa:** No ejecutaste el script SQL
**Solución:** Ejecuta `instalar_actividades.bat` o el SQL manualmente

### Error: "Column actividad_id does not exist"
**Causa:** La columna no se agregó a la tabla tareas
**Solución:** Ejecuta el script SQL nuevamente

### Error: "ClassNotFoundException: Actividad"
**Causa:** No compilaste el proyecto
**Solución:** Ejecuta `mvn clean package`

### No aparece el enlace "Mis Actividades"
**Causa:** No desplegaste la versión actualizada
**Solución:** Reemplaza el .war y reinicia el servidor

### Las actividades no se guardan
**Causa:** Error en la base de datos o validación
**Solución:** Revisa los logs del servidor y la consola del navegador (F12)

---

## ✅ CHECKLIST DE VERIFICACIÓN

Antes de considerar completa la instalación:

- [ ] Tabla `actividades` existe en PostgreSQL
- [ ] Columna `actividad_id` existe en tabla `tareas`
- [ ] El proyecto compila sin errores
- [ ] Archivo .war generado en `target/`
- [ ] Aplicación desplegada en servidor
- [ ] Enlace "📁 Mis Actividades" visible en dashboard
- [ ] Puedes crear una actividad nueva
- [ ] Puedes agregar tareas a una actividad
- [ ] Puedes ver detalles de una actividad
- [ ] La barra de progreso se actualiza
- [ ] El contador "X de Y completadas" funciona
- [ ] Puedes editar una actividad
- [ ] Puedes eliminar una actividad

---

## 📱 ACCESOS RÁPIDOS

### URLs del Sistema:

- **Dashboard:** `http://localhost:8080/SistemaGestionTareas/dashboard.jsp`
- **Actividades:** `http://localhost:8080/SistemaGestionTareas/ActividadServlet?accion=listar`
- **Nueva Actividad:** `http://localhost:8080/SistemaGestionTareas/ActividadServlet?accion=nuevo`
- **Tareas:** `http://localhost:8080/SistemaGestionTareas/Tareaservlet?accion=listar`

---

## 🎉 SISTEMA COMPLETAMENTE FUNCIONAL

Tu aplicación ahora tiene **tres niveles de organización:**

```
🏢 SISTEMA DE GESTIÓN DE TAREAS
   └── 📁 ACTIVIDADES (Proyectos grandes)
       └── 📋 TAREAS (Objetivos específicos)
           └── ☑ SUBTAREAS (Pasos detallados)
```

**¡Disfruta de tu nuevo sistema de gestión de actividades! 🚀**

---

## 📞 NOTAS FINALES

- Todos los archivos fueron creados y modificados correctamente
- El sistema está listo para usar después de ejecutar los 4 pasos
- La interfaz es moderna, intuitiva y responsive
- Se respetan todos los permisos de usuario (Admin/Usuario)
- Los datos están protegidos con validaciones
- El código está documentado y organizado

**Desarrollado para: SENA - Sistema de Gestión de Tareas**
**Fecha:** Febrero 2026

---

✨ **¡ÉXITO EN TU PROYECTO!** ✨

