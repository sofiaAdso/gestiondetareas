# 📋 INSTRUCCIONES DE INSTALACIÓN - SISTEMA DE SUBTAREAS

## ✅ Archivos Creados

### 1. Modelo de Datos
- ✅ `src/main/java/com/sena/gestion/model/Subtarea.java`

### 2. Capa de Acceso a Datos (DAO)
- ✅ `src/main/java/com/sena/gestion/repository/SubtareaDao.java`

### 3. Controlador (Servlet)
- ✅ `src/main/java/com/sena/gestion/controller/SubtareaServlet.java`

### 4. Archivos Modificados
- ✅ `src/main/java/com/sena/gestion/controller/Tareaservlet.java` (actualizado con soporte de subtareas)
- ✅ `src/main/webapp/formulario-tarea.jsp` (agregada interfaz de subtareas)

### 5. Scripts SQL
- ✅ `crear_tabla_subtareas.sql`

---

## 🚀 PASOS PARA ACTIVAR LAS SUBTAREAS

### Paso 1: Ejecutar el Script SQL en PostgreSQL

Abre pgAdmin 4 o tu cliente de PostgreSQL y ejecuta el siguiente script:

```sql
-- Conectarse a la base de datos Gestiondetareas
\c Gestiondetareas

-- Ejecutar el script
\i 'C:/Users/sofsh/Desktop/Gestiondetareas/SistemaGestionTareas/crear_tabla_subtareas.sql'
```

O copia y pega el contenido del archivo `crear_tabla_subtareas.sql` en la ventana de consulta SQL.

**Verificar que la tabla se creó correctamente:**
```sql
SELECT * FROM subtareas;
```

---

### Paso 2: Compilar el Proyecto

Abre una terminal en la carpeta del proyecto y ejecuta:

```powershell
cd C:\Users\sofsh\Desktop\Gestiondetareas\SistemaGestionTareas
mvn clean package
```

---

### Paso 3: Desplegar en el Servidor

1. Copia el archivo `target/SistemaGestionTareas.war` a tu servidor de aplicaciones (Tomcat, WildFly, etc.)
2. Reinicia el servidor
3. Accede a la aplicación

---

## 📖 CÓMO USAR LAS SUBTAREAS

### 1. Crear una Tarea Principal
- Ve al dashboard y crea una tarea nueva normalmente

### 2. Agregar Subtareas
- **Edita** la tarea haciendo clic en el botón de editar
- En la parte inferior del formulario verás la sección "Subtareas"
- Escribe el título de la subtarea en el campo de texto
- Opcionalmente agrega una descripción
- Haz clic en "Agregar Subtarea"

### 3. Marcar Subtareas como Completadas
- Haz clic en el checkbox junto a la subtarea
- Se marcará automáticamente como completada (con tachado)
- La barra de progreso se actualizará automáticamente

### 4. Eliminar Subtareas
- Haz clic en el botón de la papelera (🗑️) junto a la subtarea
- Confirma la eliminación

### 5. Ver el Progreso
- En la parte superior de la sección de subtareas verás:
  - Un contador: "X de Y completadas"
  - Una barra de progreso visual con el porcentaje

---

## 🎨 CARACTERÍSTICAS

### ✅ Funcionalidades Implementadas:

1. **Crear Subtareas**: Agrega múltiples subtareas a cualquier tarea
2. **Marcar Completadas**: Sistema de checkbox para marcar como completadas
3. **Barra de Progreso**: Visual del avance de las subtareas
4. **Contador**: Muestra cuántas subtareas están completadas
5. **Descripción Opcional**: Cada subtarea puede tener descripción detallada
6. **Fecha de Creación**: Se registra automáticamente cuando se crea
7. **Eliminación en Cascada**: Si se elimina la tarea padre, se eliminan todas sus subtareas
8. **Interfaz Intuitiva**: Diseño moderno y fácil de usar

### 🎯 Validaciones:

- El título de la subtarea es obligatorio (máximo 200 caracteres)
- La descripción es opcional (máximo 300 caracteres)
- Solo se pueden agregar subtareas a tareas existentes (en modo edición)
- Confirmación al eliminar subtareas

---

## 🔧 SOLUCIÓN DE PROBLEMAS

### Error: "Tabla subtareas no existe"
**Solución:** Ejecuta el script SQL `crear_tabla_subtareas.sql` en tu base de datos

### Error: "ClassNotFoundException: Subtarea"
**Solución:** Recompila el proyecto con `mvn clean package`

### No aparece la sección de subtareas
**Solución:** Asegúrate de estar en modo **EDICIÓN** de una tarea (no en creación nueva)

### Las subtareas no se guardan
**Solución:** 
1. Verifica que el servlet `SubtareaServlet` esté mapeado correctamente
2. Revisa los logs del servidor para ver errores
3. Verifica la conexión a la base de datos

---

## 📊 ESTRUCTURA DE LA BASE DE DATOS

```sql
subtareas
├── id (SERIAL PRIMARY KEY)
├── tarea_id (INTEGER NOT NULL) → FK a tareas(id)
├── titulo (VARCHAR 200, NOT NULL)
├── descripcion (TEXT)
├── completada (BOOLEAN, DEFAULT FALSE)
└── fecha_creacion (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
```

---

## 🎓 DESARROLLADO PARA

**SENA - Sistema de Gestión de Tareas**

© 2026 - Todos los derechos reservados

