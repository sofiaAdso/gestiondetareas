# 🎬 TUTORIAL VISUAL: Crear Tu Primera Actividad

**Sigue estos pasos visuales para crear tu primera actividad**

---

## PASO 1️⃣: PREPARAR LA BASE DE DATOS

### Opción A: Windows (Recomendado)

```
┌─────────────────────────────────────────┐
│  1. Abre PowerShell o CMD               │
│  2. Navega a la carpeta del proyecto:   │
│                                         │
│  $ cd C:\Users\sofsh\Desktop\...        │
│     ...GestiondetareasSistema...        │
│                                         │
│  3. Ejecuta el script:                  │
│                                         │
│  $ .\crear-tabla-actividades.bat        │
│                                         │
│  4. Espera el mensaje:                  │
│     "TABLA CREADA EXITOSAMENTE"         │
└─────────────────────────────────────────┘
```

### Opción B: pgAdmin (GUI)

```
┌──────────────────────────────────────────────┐
│ 1. Abre pgAdmin en tu navegador             │
│ 2. Conéctate a PostgreSQL                   │
│ 3. Selecciona BD: Gestiondetareas           │
│ 4. Abre Query Tool (F4)                     │
│ 5. Copia el SQL de:                         │
│    src/main/resources/sql/                  │
│    crear-actividades.sql                    │
│ 6. Presiona F5 o ejecuta                    │
│ 7. Verifica que se creó la tabla            │
│    (deberías ver: "CREATE TABLE (0 rows)")  │
└──────────────────────────────────────────────┘
```

---

## PASO 2️⃣: COMPILAR EL PROYECTO

```
┌─────────────────────────────────────────┐
│  En PowerShell/CMD, ejecuta:            │
│                                         │
│  $ mvn clean package                    │
│                                         │
│  Espera hasta ver:                      │
│  "BUILD SUCCESS"                        │
│                                         │
│  Esto puede tomar 1-2 minutos la       │
│  primera vez (descargará dependencias) │
└─────────────────────────────────────────┘
```

---

## PASO 3️⃣: INICIAR TOMCAT

```
┌─────────────────────────────────────────┐
│  En PowerShell/CMD, ejecuta:            │
│                                         │
│  $ .\start-tomcat.bat                   │
│                                         │
│  Verás mensajes de inicialización      │
│  Espera hasta ver:                      │
│  "✅ Conexión exitosa a la BD"          │
│                                         │
│  Esto indica que todo está listo        │
└─────────────────────────────────────────┘
```

---

## PASO 4️⃣: ACCEDER A LA APLICACIÓN

```
┌─────────────────────────────────────────┐
│  Abre tu navegador web y ve a:          │
│                                         │
│  http://localhost:8080/                 │
│  SistemaGestionTareas/                  │
│                                         │
│  Deberías ver la pantalla de login      │
└─────────────────────────────────────────┘
```

### Pantalla de Login

```
┌─────────────────────────────────────┐
│      SISTEMA DE GESTIÓN DE TAREAS  │
│                                     │
│  Usuario:  [____________]           │
│  Contraseña: [____________]         │
│                                     │
│              [INGRESAR]             │
│                                     │
│  ¿No tienes cuenta? Regístrate      │
└─────────────────────────────────────┘
```

**Ingresa con:**
- Usuario: (usuario administrador)
- Contraseña: (tu contraseña)

---

## PASO 5️⃣: NAVEGAR AL FORMULARIO

### Opción A: Por URL Directa

```
┌──────────────────────────────────────────┐
│  En la barra de dirección del navegador: │
│                                          │
│  http://localhost:8080/                  │
│  SistemaGestionTareas/                   │
│  ActividadServlet?accion=nuevo           │
│                                          │
│  Presiona Enter                          │
└──────────────────────────────────────────┘
```

### Opción B: Por Menú

```
┌──────────────────────────────────────────┐
│  1. Después de iniciar sesión            │
│  2. Busca en el menú: "Actividades"      │
│  3. Haz clic en: "Nueva Actividad"       │
│  4. O busca el botón: "+ Crear"          │
└──────────────────────────────────────────┘
```

---

## PASO 6️⃣: VER EL FORMULARIO

```
┌───────────────────────────────────────┐
│    📋 Nueva Actividad                 │
├───────────────────────────────────────┤
│                                       │
│  📋 INFORMACIÓN GENERAL               │
│  ─────────────────────────            │
│  Título:       [________________]     │
│  Descripción:  [________________]     │
│                 [________________]     │
│                                       │
│  👤 ASIGNACIÓN Y PRIORIDAD            │
│  ─────────────────────────            │
│  Usuario:      [▼ Seleccionar]        │
│  Prioridad:    [▼ Media      ]        │
│                                       │
│  📅 TIEMPOS Y PLAZOS                  │
│  ─────────────────────────            │
│  Inicio:       [__________]           │
│  Vencimiento:  [__________]           │
│                                       │
│         [Cancelar]  [Crear]           │
└───────────────────────────────────────┘
```

---

## PASO 7️⃣: LLENAR EL FORMULARIO

### Campo 1: Título

```
┌──────────────────────────────────────────┐
│ Título de la Actividad *                │
│ ┌────────────────────────────────────┐  │
│ │ Mantenimiento de Servidores        │  │
│ └────────────────────────────────────┘  │
└──────────────────────────────────────────┘

Ejemplo de títulos válidos:
✓ Mantenimiento de Servidores
✓ Capacitación de Usuarios
✓ Actualización de Base de Datos
✓ Revisión de Seguridad
```

### Campo 2: Descripción

```
┌──────────────────────────────────────────┐
│ Descripción / Detalle                   │
│ ┌────────────────────────────────────┐  │
│ │ Realizar mantenimiento preventivo  │  │
│ │ de los servidores principales en   │  │
│ │ horario de 2-4 AM                  │  │
│ └────────────────────────────────────┘  │
└──────────────────────────────────────────┘

Este campo es OPCIONAL, pero se recomienda
```

### Campo 3: Usuario Asignado

```
┌──────────────────────────────────────────┐
│ Asignar a Instructor/Usuario *           │
│ ┌────────────────────────────────────┐  │
│ │ ▼ Seleccionar Usuario              │  │
│ ├────────────────────────────────────┤  │
│ │ • Jesús Valest                     │  │
│ │ • Juan Pérez                       │  │
│ │ • María García                     │  │
│ │ • Carlos López                     │  │
│ └────────────────────────────────────┘  │
└──────────────────────────────────────────┘

Selecciona la persona responsable
```

### Campo 4: Prioridad

```
┌──────────────────────────────────────────┐
│ Nivel de Prioridad *                    │
│ ┌────────────────────────────────────┐  │
│ │ ▼ Media                            │  │
│ ├────────────────────────────────────┤  │
│ │ • Baja                             │  │
│ │ • Media     (RECOMENDADO)          │  │
│ │ • Alta                             │  │
│ └────────────────────────────────────┘  │
└──────────────────────────────────────────┘

Opciones:
🟢 Baja    - Puede esperar
🟡 Media   - Importante (por defecto)
🔴 Alta    - Urgente
```

### Campo 5: Fecha de Inicio

```
┌──────────────────────────────────────────┐
│ Fecha de Inicio *                       │
│ ┌────────────────────────────────────┐  │
│ │ [📅 05/05/2026]                    │  │
│ └────────────────────────────────────┘  │
└──────────────────────────────────────────┘

Formato: dd/mm/yyyy
Ejemplo: 05/05/2026

Puedes:
• Escribir la fecha
• Hacer clic en el calendario 📅
```

### Campo 6: Fecha de Vencimiento

```
┌──────────────────────────────────────────┐
│ Fecha de Vencimiento *                  │
│ ┌────────────────────────────────────┐  │
│ │ [📅 10/05/2026]                    │  │
│ └────────────────────────────────────┘  │
└──────────────────────────────────────────┘

Formato: dd/mm/yyyy
Ejemplo: 10/05/2026

IMPORTANTE:
⚠️ Debe ser MAYOR que la fecha de inicio
❌ NO puedes poner: 03/05/2026 (anterior)
✅ Puedes poner: 10/05/2026 (posterior)
```

---

## PASO 8️⃣: VALIDACIONES AUTOMÁTICAS

### El Sistema Verifica Automáticamente

```
┌────────────────────────────────────────────┐
│ ✓ Título: No vacío                        │
│ ✓ Usuario: Seleccionado                   │
│ ✓ Prioridad: Seleccionada                 │
│ ✓ Fecha Inicio: Válida (dd/mm/yyyy)       │
│ ✓ Fecha Vencimiento: Mayor que inicio     │
└────────────────────────────────────────────┘

Si algo está mal, verás mensajes en rojo ❌
```

### Si las Fechas están Mal

```
┌────────────────────────────────────────────┐
│  ⚠️ ERROR EN FECHAS                        │
│                                            │
│  "La fecha de vencimiento debe ser         │
│   posterior a la de inicio"                │
│                                            │
│  [Aceptar]                                 │
└────────────────────────────────────────────┘
```

---

## PASO 9️⃣: GUARDAR LA ACTIVIDAD

### Haz Clic en el Botón "Crear"

```
┌──────────────────────────────────────────────┐
│  Botones al pie del formulario:              │
│                                              │
│     [Cancelar]     [Crear]                   │
│      gris          azul                      │
│                                              │
│  Haz clic en [Crear] para guardar            │
└──────────────────────────────────────────────┘
```

---

## PASO 🔟: CONFIRMACIÓN

### Si Todo Está Correcto

```
┌──────────────────────────────────────────┐
│  ✓ Procesando...                         │
│  ✓ Guardando en BD...                    │
│  ✓ ¡Éxito!                               │
│                                          │
│  Serás redirigido al listado de          │
│  actividades en 2-3 segundos             │
└──────────────────────────────────────────┘
```

### Verás el Listado de Actividades

```
┌───────────────────────────────────────────┐
│  ACTIVIDADES                              │
├─────────────────────────────────────────┬─┤
│ Título              │ Usuario  │ Estado│ │
├─────────────────────────────────────────┤─┤
│ Mantenimiento...    │ J. Valest│Pendiente
│ ← Tu nueva actividad                  ▼  │
│                                           │
│ [Ver] [Editar] [Eliminar]                │
└───────────────────────────────────────────┘
```

---

## 🎉 ¡ÉXITO!

Tu primera actividad ha sido creada exitosamente.

### La Actividad Ahora:
- ✅ Está guardada en PostgreSQL
- ✅ Aparece en el listado
- ✅ Puede ser editada
- ✅ Puede ser eliminada
- ✅ Puede cambiar de estado

---

## 🔄 PRÓXIMAS ACCIONES

### 1. Crear Más Actividades
Repite los pasos 6-9 para cada nueva actividad

### 2. Editar Actividad
En el listado, haz clic en [Editar]

### 3. Cambiar Estado
Busca el selector de estado (si existe)

### 4. Generar Reportes
Ve a la sección de Reportes

---

## ⚠️ SOLUCIÓN RÁPIDA DE PROBLEMAS

### Problema: No veo el formulario

```
SOLUCIÓN:
1. Verifica que estés logueado
2. Verifica que seas administrador
3. Intenta con URL directa:
   http://localhost:8080/...
   ActividadServlet?accion=nuevo
```

### Problema: "Error al guardar"

```
SOLUCIÓN:
1. Verifica que todos los campos requeridos
   estén completados
2. Verifica que las fechas sean válidas
3. Verifica que la conexión a BD esté activa
4. Mira el error específico y consulta:
   GUIA-CREAR-ACTIVIDADES.md
```

### Problema: No se ve la actividad en el listado

```
SOLUCIÓN:
1. Actualiza la página (F5)
2. Verifica que Tomcat esté corriendo
3. Verifica que la tabla existe en BD
4. Consulta los logs:
   apache-tomcat-9.0.115/logs/
```

---

## 💡 TIPS ÚTILES

```
✓ Copia y pega para no cometer errores
✓ Verifica fechas antes de guardar
✓ Usa títulos descriptivos
✓ Asigna siempre un usuario
✓ Establece prioridades realistas
✓ Guarda la descripción para contexto
```

---

**¡Ahora puedes crear actividades! 🎊**

Para más ayuda: Consulta **GUIA-CREAR-ACTIVIDADES.md**

