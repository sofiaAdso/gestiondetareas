# ✅ Solución: Mostrar Tareas al Crear una Actividad

## 🎯 Problema Resuelto
Cuando creabas una actividad nueva, el sistema te redirigía al listado de actividades sin mostrarte las tareas asociadas. Ahora, al crear una actividad, **automáticamente se te dirige a la vista detallada** donde puedes:

- ✅ Ver los detalles completos de la actividad recién creada
- ✅ Ver todas las tareas asociadas (si ya existen)
- ✅ Agregar nuevas tareas fácilmente con un solo clic

---

## 🔧 Cambios Implementados

### 1️⃣ **Modificación en `ActividadServlet.java`**

**Archivo:** `src/main/java/com/sena/gestion/controller/ActividadServlet.java`

**Cambio realizado:**
- Ahora cuando se crea una actividad, el sistema usa el método `crearYRetornarId()` en lugar de `crear()`
- Este método devuelve el ID de la actividad recién creada
- Luego redirige automáticamente a la vista de detalles: `ver-actividad.jsp`

**Código anterior:**
```java
boolean creado = actividadDao.crear(actividad);
if (creado) {
    response.sendRedirect("ActividadServlet?accion=listar&res=ok");
}
```

**Código nuevo:**
```java
int nuevoId = actividadDao.crearYRetornarId(actividad);
if (nuevoId > 0) {
    // Redirige a la vista de detalles de la actividad recién creada
    response.sendRedirect("ActividadServlet?accion=ver&id=" + nuevoId + "&res=creada");
}
```

---

### 2️⃣ **Mejora en `ver-actividad.jsp`**

**Archivo:** `src/main/webapp/ver-actividad.jsp`

**Mejoras añadidas:**
- ✨ **Mensaje de éxito interactivo** con SweetAlert2 cuando creas una actividad
- 🎯 **Tres opciones claras** después de crear:
  1. **Agregar Tareas** → Te lleva directamente al formulario de nueva tarea
  2. **Ver Todas las Actividades** → Regresa al listado completo
  3. **Quedarse Aquí** → Permaneces en la vista de detalles

**Funcionalidad del mensaje:**
```javascript
Swal.fire({
    icon: 'success',
    title: '¡Actividad Creada!',
    html: '<p>¿Qué deseas hacer ahora?</p>',
    showDenyButton: true,
    showCancelButton: true,
    confirmButtonText: 'Agregar Tareas',
    denyButtonText: 'Ver Todas las Actividades',
    cancelButtonText: 'Quedarse Aquí'
});
```

---

## 🚀 Cómo Funciona Ahora

### **Flujo Completo al Crear una Actividad:**

1. 📝 **Llenas el formulario** de nueva actividad (título, descripción, fechas, etc.)

2. 💾 **Haces clic en "Guardar"**
   - El sistema crea la actividad en la base de datos
   - Obtiene automáticamente el ID de la actividad recién creada

3. ✅ **Aparece un mensaje de éxito** con 3 opciones:
   - 🆕 **Agregar Tareas**: Te lleva directo al formulario para crear tareas
   - 📋 **Ver Todas**: Regresa al listado de actividades
   - 👁️ **Quedarse Aquí**: Permaneces en la vista de detalles

4. 👀 **Estás en la vista de detalles** de tu actividad donde puedes:
   - Ver toda la información de la actividad
   - Ver las tareas existentes (si ya las creaste)
   - Agregar nuevas tareas con el botón "Agregar Tarea"
   - Editar la actividad
   - Ver el progreso (tareas completadas vs totales)

---

## 📊 Ventajas de esta Solución

### ✅ **Experiencia de Usuario Mejorada**
- Ya no tienes que buscar tu actividad recién creada en el listado
- Acceso inmediato para agregar tareas
- Flujo de trabajo más natural y eficiente

### ✅ **Vista Completa**
- Ves todos los detalles de la actividad recién creada
- Puedes verificar que todo se guardó correctamente
- Acceso directo a todas las funcionalidades relacionadas

### ✅ **Opciones Flexibles**
- Tres acciones claras después de crear
- Decides qué hacer según tu flujo de trabajo
- Sin pasos innecesarios

---

## 🎨 Características de la Vista de Detalles

Cuando creas una actividad, ahora verás:

### **Información de la Actividad:**
- 📌 Título y descripción
- 🎯 Prioridad (Alta/Media/Baja)
- 🎨 Estado con color personalizado
- 📅 Fechas de inicio y fin
- 👤 Usuario asignado

### **Sección de Tareas:**
- 📋 Lista de todas las tareas asociadas
- ➕ Botón destacado "Agregar Tarea"
- 📊 Progreso visual (tareas completadas)
- ✏️ Edición rápida de tareas

### **Cuando no hay tareas:**
- 💡 Mensaje claro: "No hay tareas en esta actividad"
- 🎯 Botón grande: "Crear Primera Tarea"
- Acceso directo al formulario de tareas

---

## 🧪 Cómo Probar los Cambios

### **Paso 1: Crear una Nueva Actividad**
1. Ve a tu aplicación: `http://localhost:8080/SistemaGestionTareas`
2. Inicia sesión
3. Haz clic en "Actividades" o "Crear Actividad"
4. Llena el formulario con:
   - Título: "Mi Proyecto de Prueba"
   - Descripción: "Probando la nueva funcionalidad"
   - Prioridad: Alta
   - Fechas válidas
5. Haz clic en "Guardar"

### **Paso 2: Verificar el Resultado**
✅ Deberías ver:
- Un mensaje de éxito con 3 opciones
- La vista de detalles de tu actividad
- La sección de tareas (vacía pero con botón para agregar)

### **Paso 3: Agregar Tareas**
1. Haz clic en "Agregar Tareas" en el mensaje
   O
   Haz clic en "Agregar Tarea" en la página
2. Crea una tarea asociada a esta actividad
3. Regresa a la vista de detalles
4. ¡Verás tu tarea listada!

---

## 📝 Código Relevante

### **Método `crearYRetornarId` en ActividadDao:**
```java
public int crearYRetornarId(Actividad actividad) {
    String sql = "INSERT INTO actividades (...) VALUES (...) RETURNING id";
    
    try (Connection conn = Conexion.getConexion();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        // Configurar parámetros...
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            int nuevoId = rs.getInt(1);
            return nuevoId;  // Retorna el ID de la actividad creada
        }
    } catch (SQLException e) {
        System.err.println("Error al crear actividad: " + e.getMessage());
    }
    return 0;  // Error
}
```

### **URL de Redirección:**
```
ActividadServlet?accion=ver&id=<ID_ACTIVIDAD>&res=creada
```

- `accion=ver`: Muestra la vista de detalles
- `id=<ID>`: ID de la actividad recién creada
- `res=creada`: Activa el mensaje de éxito

---

## 🔄 Integración con Tareas

### **Crear Tarea desde la Actividad:**
El botón "Agregar Tarea" genera esta URL:
```
Tareaservlet?accion=nuevo&actividad_id=<ID_ACTIVIDAD>
```

Esto pre-selecciona automáticamente la actividad en el formulario de tareas, facilitando la asociación.

---

## 📦 Archivos Modificados

1. ✅ **ActividadServlet.java**
   - Líneas modificadas: ~318-334
   - Cambio: Usar `crearYRetornarId()` y redirigir a vista de detalles

2. ✅ **ver-actividad.jsp**
   - Líneas añadidas: Después de `<body>`
   - Cambio: Mensaje de éxito con SweetAlert2

---

## 🎉 Resultado Final

Ahora tienes un flujo de trabajo más intuitivo:

```
[Crear Actividad] 
      ↓
[Guardar en BD]
      ↓
[Obtener ID de la actividad creada]
      ↓
[Redirigir a vista de detalles]
      ↓
[Mostrar mensaje de éxito]
      ↓
[Usuario puede agregar tareas inmediatamente]
```

---

## 💡 Consejos de Uso

1. **Después de crear una actividad:**
   - Si sabes qué tareas necesitas, haz clic en "Agregar Tareas"
   - Si quieres revisar primero, haz clic en "Quedarse Aquí"

2. **Para agregar múltiples tareas:**
   - Usa el botón "Agregar Tarea" repetidamente
   - Cada tarea se asociará automáticamente a la actividad

3. **Para ver el progreso:**
   - Regresa a la vista de detalles
   - Verás el porcentaje de tareas completadas

---

## 🐛 Solución de Problemas

### **Si no ves el mensaje de éxito:**
- Verifica que SweetAlert2 esté cargado (ya está en el JSP)
- Revisa la consola del navegador (F12) por errores

### **Si no aparecen las tareas:**
- Asegúrate de que las tareas tengan el `actividad_id` correcto
- Verifica en la base de datos: `SELECT * FROM tareas WHERE actividad_id = X`

### **Si la redirección falla:**
- Verifica que el método `crearYRetornarId()` retorne un ID válido
- Revisa los logs del servidor

---

## ✅ Verificación de Despliegue

Los cambios ya fueron compilados y desplegados:
- ✅ Compilación exitosa con Maven
- ✅ Archivo WAR copiado a Tomcat
- ✅ Tomcat detectará y desplegará automáticamente

**Para aplicar los cambios:**
- Si Tomcat está corriendo, esperará unos segundos (redesplegará automáticamente)
- Si no está corriendo, inícialo normalmente

---

## 🎯 Resumen

**Antes:**
- Crear actividad → Redirige al listado → No ves tareas

**Ahora:**
- Crear actividad → Vista de detalles → Mensaje de éxito → Agregar tareas fácilmente

**¡Mucho más intuitivo y eficiente!** 🚀

---

**Fecha de implementación:** 24 de febrero de 2026
**Archivos modificados:** 2
**Estado:** ✅ Completado y desplegado

