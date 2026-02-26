# 🎯 GUÍA COMPLETA: Mostrar Tareas al Ver una Actividad

## 📋 Descripción del Problema
Cuando haces clic en el botón **"Ver"** de una actividad (como "Arquitectura" o "Desarrollo Web"), el sistema debe mostrar automáticamente todas las tareas que pertenecen a esa actividad específica.

---

## ✅ Estado Actual del Sistema

### **¡BUENAS NOTICIAS!** 🎉
El código ya está completamente implementado y funcionando. Aquí está todo lo que ya está hecho:

#### 1️⃣ **Modelo de Datos (Actividad.java)** ✅
```java
public class Actividad {
    // ...otros campos...
    private List<Tarea> tareas = new ArrayList<>();  // ← Lista de tareas
    
    public List<Tarea> getTareas() {
        return tareas;
    }
    
    public void setTareas(List<Tarea> tareas) {
        this.tareas = tareas;
    }
}
```

#### 2️⃣ **Modelo de Datos (Tarea.java)** ✅
```java
public class Tarea {
    private int actividad_id; // ← Columna que conecta con actividades
    
    public int getActividad_id() { return actividad_id; }
    public void setActividad_id(int actividad_id) { this.actividad_id = actividad_id; }
}
```

#### 3️⃣ **Repositorio (TareaDao.java)** ✅
```java
public List<Tarea> listarPorActividad(int actividadId) {
    List<Tarea> lista = new ArrayList<>();
    String sql = "SELECT t.*, a.titulo AS nombre_act " +
            "FROM tareas t " +
            "INNER JOIN actividades a ON t.actividad_id = a.id " +
            "WHERE t.actividad_id = ? " +
            "ORDER BY t.id DESC";
    
    // ...código que ejecuta la consulta y llena la lista...
    return lista;
}
```

#### 4️⃣ **Controlador (ActividadServlet.java)** ✅
```java
private void manejarVerDetalle(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String idStr = request.getParameter("id");
    int id = Integer.parseInt(idStr);
    
    // 1. Obtener la actividad
    Actividad actividad = actividadDao.obtenerPorId(id);
    
    // 2. Obtener las tareas de esta actividad (LA CONEXIÓN MÁGICA 🔗)
    List<Tarea> tareas = tareaDao.listarPorActividad(id);
    
    // 3. Asignar las tareas a la actividad
    actividad.setTareas(tareas);
    
    // 4. Calcular estadísticas
    int total = tareas.size();
    int completadas = 0;
    for (Tarea t : tareas) {
        if ("Completada".equals(t.getEstado())) {
            completadas++;
        }
    }
    actividad.setTotalTareas(total);
    actividad.setTareasCompletadas(completadas);
    
    // 5. Enviar al JSP
    request.setAttribute("actividad", actividad);
    request.setAttribute("listaTareas", tareas);
    request.getRequestDispatcher("ver-actividad.jsp").forward(request, response);
}
```

#### 5️⃣ **Vista (ver-actividad.jsp)** ✅
```jsp
<%
    Actividad actividad = (Actividad) request.getAttribute("actividad");
    List<Tarea> listaTareas = (List<Tarea>) request.getAttribute("listaTareas");
%>

<!-- Mostrar las tareas -->
<% if (listaTareas != null && !listaTareas.isEmpty()) { %>
    <% for (Tarea tarea : listaTareas) { %>
        <div class="tarea-card">
            <div class="tarea-titulo"><%= tarea.getTitulo() %></div>
            <div class="tarea-info">
                <span><i class="fas fa-exclamation-triangle"></i> <%= tarea.getPrioridad() %></span>
                <span><i class="fas fa-info-circle"></i> <%= tarea.getEstado() %></span>
                <span><i class="far fa-calendar"></i> <%= tarea.getFecha_vencimiento() %></span>
            </div>
        </div>
    <% } %>
<% } else { %>
    <div class="empty-tareas">
        <h3>No hay tareas en esta actividad</h3>
        <a href="Tareaservlet?accion=nuevo&actividad_id=<%= actividad.getId() %>"
           class="btn btn-primary">
            <i class="fas fa-plus"></i> Crear Primera Tarea
        </a>
    </div>
<% } %>
```

---

## 🔍 Cómo Funciona el Sistema (Lógica Completa)

### **Flujo de Datos paso a paso:**

```
👤 Usuario
    ↓
    Hace clic en "Ver" actividad (id=5)
    ↓
🌐 Navegador
    ↓
    GET → ActividadServlet?accion=ver&id=5
    ↓
☕ ActividadServlet.doGet()
    ↓
    switch(accion) → case "ver" → manejarVerDetalle()
    ↓
📊 Base de Datos
    ├─ SELECT * FROM actividades WHERE id = 5
    │  → Obtiene: "Proyecto Arquitectura"
    │
    └─ SELECT t.* FROM tareas t WHERE t.actividad_id = 5
       → Obtiene: 3 tareas
          1. "Diseñar diagrama"
          2. "Documentar API"
          3. "Crear mockups"
    ↓
🎨 JSP (ver-actividad.jsp)
    ↓
    Muestra:
    ┌─────────────────────────────────────┐
    │ Proyecto Arquitectura               │
    │ ───────────────────────────────────│
    │ 📋 Tareas de esta Actividad         │
    │                                     │
    │ ✅ Diseñar diagrama      [Editar]  │
    │ 🔄 Documentar API         [Editar]  │
    │ ⏳ Crear mockups         [Editar]  │
    └─────────────────────────────────────┘
```

---

## 🔗 La "Llave" de Conexión: actividad_id

### **En la Base de Datos:**
```sql
-- Tabla actividades
CREATE TABLE actividades (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(200),
    descripcion TEXT,
    -- ...otros campos...
);

-- Tabla tareas
CREATE TABLE tareas (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(100),
    actividad_id INTEGER NOT NULL,  -- ← LA LLAVE DE CONEXIÓN
    -- ...otros campos...
    
    CONSTRAINT fk_tarea_actividad
        FOREIGN KEY (actividad_id)
        REFERENCES actividades(id)
);
```

### **Ejemplo de datos:**

**Tabla `actividades`:**
| id | titulo                    | estado       |
|----|---------------------------|--------------|
| 1  | Proyecto Arquitectura     | En Progreso  |
| 2  | Desarrollo Web            | En Progreso  |
| 3  | Testing                   | Completada   |

**Tabla `tareas`:**
| id | titulo              | actividad_id | estado       |
|----|---------------------|--------------|--------------|
| 1  | Diseñar diagrama    | 1            | En Progreso  |
| 2  | Documentar API      | 1            | Pendiente    |
| 3  | Crear mockups       | 1            | Completada   |
| 4  | Diseñar frontend    | 2            | En Progreso  |
| 5  | Crear tests         | 3            | Completada   |

**Cuando veo la Actividad ID=1:**
- Se busca en `actividades` WHERE id = 1 → "Proyecto Arquitectura"
- Se busca en `tareas` WHERE actividad_id = 1 → Obtiene tareas 1, 2, 3
- Se muestran las 3 tareas en el JSP

---

## 🛠️ Verificación: ¿Por qué no veo las tareas?

### **Checklist de Diagnóstico:**

#### ✅ 1. Verificar que la columna `actividad_id` existe
```sql
-- Ejecuta esto en PostgreSQL:
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'tareas'
AND column_name = 'actividad_id';
```

**Debe retornar:**
```
column_name  | data_type | is_nullable
-------------|-----------|-------------
actividad_id | integer   | NO
```

**Si NO existe la columna:**
```sql
ALTER TABLE tareas ADD COLUMN actividad_id INTEGER;

ALTER TABLE tareas
ADD CONSTRAINT fk_tarea_actividad
FOREIGN KEY (actividad_id)
REFERENCES actividades(id)
ON DELETE CASCADE;
```

---

#### ✅ 2. Verificar que las tareas tienen actividad_id asignado
```sql
-- Buscar tareas sin actividad:
SELECT id, titulo, actividad_id
FROM tareas
WHERE actividad_id IS NULL;
```

**Si hay tareas con actividad_id NULL:**
```sql
-- Opción 1: Crear una actividad general y asignarlas
INSERT INTO actividades (usuario_id, titulo, descripcion, fecha_inicio, fecha_fin, prioridad, estado, color)
VALUES (
    1,  -- Tu ID de usuario
    'Tareas Generales',
    'Actividad para tareas sin categorizar',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '30 days',
    'Media',
    'En Progreso',
    '#6c757d'
) RETURNING id;  -- Anota el ID que retorna (ej: 10)

-- Luego asigna las tareas a esa actividad:
UPDATE tareas
SET actividad_id = 10  -- Usa el ID que obtuviste
WHERE actividad_id IS NULL;
```

---

#### ✅ 3. Verificar que existe la relación entre actividad y tareas
```sql
-- Prueba la consulta que hace el sistema:
SELECT
    t.id,
    t.titulo AS tarea_titulo,
    t.estado AS tarea_estado,
    a.id AS actividad_id,
    a.titulo AS actividad_titulo
FROM tareas t
INNER JOIN actividades a ON t.actividad_id = a.id
WHERE t.actividad_id = 1  -- Cambia por un ID de actividad real
ORDER BY t.id DESC;
```

**Debe retornar las tareas de esa actividad.**

---

#### ✅ 4. Verificar el servidor Java (logs)
Revisa la consola de Tomcat o tu IDE. El TareaDao imprime información de debug:

```
=== DEBUG TareaDao.listarPorActividad() ===
Buscando tareas para actividad ID: 5
Tareas encontradas: 3
```

Si no ves esto, el servlet no está llamando al método correctamente.

---

#### ✅ 5. Verificar el JSP
En `ver-actividad.jsp`, agrega esto temporalmente al inicio:

```jsp
<%
    System.out.println("=== DEBUG JSP ===");
    System.out.println("Actividad: " + actividad.getTitulo());
    System.out.println("ID Actividad: " + actividad.getId());
    System.out.println("Lista tareas es null: " + (listaTareas == null));
    if (listaTareas != null) {
        System.out.println("Cantidad de tareas: " + listaTareas.size());
        for (Tarea t : listaTareas) {
            System.out.println("  - " + t.getTitulo());
        }
    }
%>
```

Esto te mostrará en la consola qué datos están llegando al JSP.

---

## 🚀 Prueba Completa del Sistema

### **Paso 1: Crear datos de prueba**

```sql
-- 1. Verificar tu usuario
SELECT id, username FROM usuarios;  -- Anota tu ID

-- 2. Crear una actividad de prueba
INSERT INTO actividades (usuario_id, titulo, descripcion, fecha_inicio, fecha_fin, prioridad, estado, color)
VALUES (
    1,  -- Tu ID de usuario
    'Proyecto de Prueba',
    'Actividad para probar el sistema de tareas',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '30 days',
    'Alta',
    'En Progreso',
    '#667eea'
) RETURNING id;  -- Anota el ID (ej: 15)

-- 3. Crear tareas para esa actividad
INSERT INTO tareas (titulo, descripcion, prioridad, estado, fecha_inicio, fecha_vencimiento, actividad_id, usuario_id, categoria_id, completada)
VALUES
('Tarea de Prueba 1', 'Primera tarea', 'Alta', 'En Progreso', CURRENT_DATE, CURRENT_DATE + 7, 15, 1, 1, false),
('Tarea de Prueba 2', 'Segunda tarea', 'Media', 'Pendiente', CURRENT_DATE, CURRENT_DATE + 14, 15, 1, 1, false),
('Tarea de Prueba 3', 'Tercera tarea', 'Baja', 'Completada', CURRENT_DATE, CURRENT_DATE + 21, 15, 1, 1, true);

-- Nota: Reemplaza 15 con el ID de actividad que obtuviste
--       Reemplaza 1 con tu ID de usuario y un ID de categoría válido
```

### **Paso 2: Probar en el navegador**

1. **Accede a tu sistema:**
   ```
   http://localhost:8080/SistemaGestionTareas/dashboard.jsp
   ```

2. **Ve al menú de Actividades:**
   - Clic en "Actividades" o "Mis Actividades"

3. **Busca "Proyecto de Prueba"**

4. **Haz clic en el botón "Ver"** (👁️ o "Ver Detalles")

5. **Deberías ver:**
   ```
   ┌─────────────────────────────────────────────┐
   │ 📂 Proyecto de Prueba                       │
   │ ────────────────────────────────────────── │
   │ Prioridad: Alta    Estado: En Progreso     │
   │ Fecha: 2026-02-24 a 2026-03-26             │
   │                                             │
   │ 📋 Tareas de esta Actividad                │
   │ ────────────────────────────────────────── │
   │                                             │
   │ 🔴 Tarea de Prueba 1     [En Progreso]    │
   │    Prioridad: Alta                          │
   │    Vence: 2026-03-03                       │
   │                                             │
   │ 🟡 Tarea de Prueba 2     [Pendiente]      │
   │    Prioridad: Media                         │
   │    Vence: 2026-03-10                       │
   │                                             │
   │ ✅ Tarea de Prueba 3     [Completada]     │
   │    Prioridad: Baja                          │
   │    Vence: 2026-03-17                       │
   └─────────────────────────────────────────────┘
   ```

---

## 📁 Archivos del Sistema

### **Archivos Clave:**

1. **Modelo:**
   - `src/main/java/com/sena/gestion/model/Actividad.java` ✅
   - `src/main/java/com/sena/gestion/model/Tarea.java` ✅

2. **Repositorio:**
   - `src/main/java/com/sena/gestion/repository/ActividadDao.java` ✅
   - `src/main/java/com/sena/gestion/repository/TareaDao.java` ✅

3. **Controlador:**
   - `src/main/java/com/sena/gestion/controller/ActividadServlet.java` ✅

4. **Vista:**
   - `src/main/webapp/ver-actividad.jsp` ✅

5. **Scripts SQL:**
   - `VERIFICAR_TAREAS_POR_ACTIVIDAD.sql` ← **NUEVO** (Ejecuta este para diagnóstico)

---

## 🎓 Conceptos Clave

### **Relación Uno a Muchos (1:N)**
```
ACTIVIDAD (1) ──────┐
                     │
                     ├─── TAREA 1
                     ├─── TAREA 2
                     ├─── TAREA 3
                     └─── TAREA N
```

### **Foreign Key (Clave Foránea)**
- La columna `actividad_id` en la tabla `tareas` es una **foreign key**
- Apunta al `id` de la tabla `actividades`
- Garantiza que cada tarea pertenezca a una actividad válida

### **JOIN en SQL**
```sql
SELECT tareas.*
FROM tareas
INNER JOIN actividades ON tareas.actividad_id = actividades.id
WHERE actividades.id = 5;
```

Esto dice: "Dame todas las tareas donde su actividad_id sea igual al id de una actividad, específicamente la actividad con id=5"

---

## 🎯 Resumen Ejecutivo

### **✅ LO QUE YA FUNCIONA:**
1. ✅ Modelo Actividad con lista de tareas
2. ✅ Modelo Tarea con actividad_id
3. ✅ ActividadDao.obtenerPorId()
4. ✅ TareaDao.listarPorActividad()
5. ✅ ActividadServlet.manejarVerDetalle()
6. ✅ JSP ver-actividad.jsp

### **🔧 LO QUE DEBES VERIFICAR:**
1. ❓ Columna `actividad_id` existe en tabla `tareas`
2. ❓ Todas las tareas tienen `actividad_id` válido (no NULL)
3. ❓ Existe relación FK entre tareas y actividades
4. ❓ Hay datos de prueba en la base de datos

### **📝 PARA PROBAR:**
1. Ejecuta `VERIFICAR_TAREAS_POR_ACTIVIDAD.sql`
2. Revisa los resultados
3. Si hay errores, usa las SOLUCIONES incluidas en el script
4. Crea datos de prueba si no tienes
5. Accede a una actividad y verifica que se muestren las tareas

---

## 💡 Consejos Adicionales

### **Si aún no funciona:**

1. **Reinicia el servidor Tomcat** después de cualquier cambio en el código
2. **Limpia el caché del navegador** (Ctrl + F5)
3. **Revisa los logs** de Tomcat para ver errores
4. **Verifica las rutas** de los servlets (deben coincidir con @WebServlet)
5. **Prueba con diferentes navegadores**

### **Para desarrollo futuro:**

- Puedes agregar filtros por estado de tarea
- Puedes ordenar tareas por prioridad
- Puedes agregar búsqueda de tareas
- Puedes implementar drag & drop para reordenar tareas

---

## 📞 Soporte

Si necesitas ayuda adicional:
1. Ejecuta `VERIFICAR_TAREAS_POR_ACTIVIDAD.sql`
2. Copia los resultados de cada consulta
3. Revisa los logs del servidor
4. Verifica que las URL estén correctas

**¡El sistema ya está implementado y debería funcionar! Solo necesitas verificar la base de datos.** 🚀

