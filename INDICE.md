# 📚 ÍNDICE DE DOCUMENTACIÓN - SISTEMA DE ACTIVIDADES

**Bienvenido al Sistema de Gestión de Actividades**

Este índice te ayudará a encontrar rápidamente la información que necesitas.

---

## 🎯 COMIENZA AQUÍ

### ⚡ Prisa (5 minutos)
**👉 Lee**: [`INICIO-RAPIDO.md`](INICIO-RAPIDO.md)
- 5 pasos principales
- Comandos básicos
- Tabla de campos
- FAQ rápido

### 📖 Normal (20 minutos)
**👉 Lee**: [`GUIA-CREAR-ACTIVIDADES.md`](GUIA-CREAR-ACTIVIDADES.md)
- Instrucciones detalladas
- Paso a paso
- Solución de problemas
- Consejos y buenas prácticas

### 🔍 Completo (30+ minutos)
**👉 Lee**: [`RESUMEN-ACTIVIDADES.md`](RESUMEN-ACTIVIDADES.md)
- Visión general del proyecto
- Arquitectura
- Preguntas frecuentes
- Próximos pasos

---

## 📄 DOCUMENTOS DISPONIBLES

### Guías de Inicio

| Archivo | Duración | Propósito |
|---------|----------|----------|
| **INICIO-RAPIDO.md** | 5 min | Pasos rápidos y comandos |
| **GUIA-CREAR-ACTIVIDADES.md** | 20 min | Guía completa y detallada |
| **RESUMEN-ACTIVIDADES.md** | 15 min | Visión general del proyecto |

### Documentación Técnica

| Archivo | Duración | Propósito |
|---------|----------|----------|
| **VERIFICACION-FINAL.md** | 10 min | Checklist y validaciones |
| **ARCHIVOS-ENTREGADOS.md** | 10 min | Inventario de archivos |
| **README.md** | 15 min | Documentación general |

### Este Documento

| Archivo | Propósito |
|---------|----------|
| **INDICE.md** | Mapa de documentación (TÚ ESTÁS AQUÍ) |

---

## 🔧 SCRIPTS Y HERRAMIENTAS

### Scripts Disponibles

| Script | Sistema | Propósito |
|--------|---------|----------|
| `crear-tabla-actividades.bat` | Windows | Crear tabla en PostgreSQL |
| `probar-actividades.sh` | Linux/Mac | Verificar instalación |
| `start-tomcat.bat` | Windows | Iniciar servidor |

### Archivos SQL

| Archivo | Propósito |
|---------|----------|
| `src/main/resources/sql/crear-actividades.sql` | Script SQL para crear tabla |

---

## 💻 CÓDIGO FUENTE

### Archivos Java

#### Backend
| Archivo | Propósito |
|---------|----------|
| `src/main/java/com/sena/gestion/model/Actividad.java` | Modelo de datos |
| `src/main/java/com/sena/gestion/controller/ActividadServlet.java` | Controlador |
| `src/main/java/com/sena/gestion/repository/ActividadDao.java` | Acceso a datos |
| `src/main/java/com/sena/gestion/repository/Conexion.java` | Conexión BD |

#### Frontend (JSP)
| Archivo | Propósito |
|---------|----------|
| `src/main/webapp/formulario-actividad.jsp` | Formulario de creación |
| `src/main/webapp/listar-actividades.jsp` | Listado de actividades |
| `src/main/webapp/ver-actividad.jsp` | Vista de detalle |

### Configuración
| Archivo | Propósito |
|---------|----------|
| `pom.xml` | Configuración Maven |

---

## 📋 PREGUNTAS COMUNES POR TEMA

### Instalación y Setup
- ❓ ¿Cómo instalar? → Ver: **INICIO-RAPIDO.md**
- ❓ ¿Qué requisitos? → Ver: **README.md**
- ❓ ¿Crear tabla? → Ver: **GUIA-CREAR-ACTIVIDADES.md** (Paso 1)
- ❓ ¿Compilar? → Ver: **GUIA-CREAR-ACTIVIDADES.md** (Paso 3)

### Uso de la Aplicación
- ❓ ¿Crear actividad? → Ver: **INICIO-RAPIDO.md** (Paso 5)
- ❓ ¿Editar actividad? → Ver: **GUIA-CREAR-ACTIVIDADES.md** (Características)
- ❓ ¿Cambiar estado? → Ver: **RESUMEN-ACTIVIDADES.md** (FAQ)
- ❓ ¿Eliminar actividad? → Ver: **GUIA-CREAR-ACTIVIDADES.md** (Características)

### Solución de Problemas
- ❌ "Tabla no existe" → Ver: **GUIA-CREAR-ACTIVIDADES.md** (Troubleshooting)
- ❌ "Error de conexión" → Ver: **VERIFICACION-FINAL.md** (Soporte)
- ❌ "404 Servlet not found" → Ver: **INICIO-RAPIDO.md** (Si Algo Falla)
- ❌ "No estoy logueado" → Ver: **INICIO-RAPIDO.md** (Si Algo Falla)

### Validaciones
- ✓ ¿Qué campos son obligatorios? → Ver: **INICIO-RAPIDO.md** (Tabla de Campos)
- ✓ ¿Formato de fechas? → Ver: **GUIA-CREAR-ACTIVIDADES.md** (Validaciones)
- ✓ ¿Quién puede crear? → Ver: **RESUMEN-ACTIVIDADES.md** (FAQ)
- ✓ ¿Valores válidos? → Ver: **VERIFICACION-FINAL.md** (Validaciones)

---

## 🗺️ MAPA DE NAVEGACIÓN

```
INICIO
  ├─ ⚡ PRISA (5 min)
  │  └─ INICIO-RAPIDO.md
  │
  ├─ 📖 NORMAL (20 min)
  │  └─ GUIA-CREAR-ACTIVIDADES.md
  │
  ├─ 🔍 COMPLETO (30 min)
  │  └─ RESUMEN-ACTIVIDADES.md
  │
  └─ 🛠️ TÉCNICO
     ├─ VERIFICACION-FINAL.md
     ├─ ARCHIVOS-ENTREGADOS.md
     └─ README.md
```

---

## ✅ FLUJO RECOMENDADO

### 1️⃣ Primera Vez (Primeros 30 minutos)

```
1. Lee: RESUMEN-ACTIVIDADES.md (5 min)
   ↓
2. Lee: INICIO-RAPIDO.md (10 min)
   ↓
3. Ejecuta: crear-tabla-actividades.bat
   ↓
4. Ejecuta: mvn clean package
   ↓
5. Ejecuta: start-tomcat.bat
   ↓
6. Accede: http://localhost:8080/SistemaGestionTareas/
```

### 2️⃣ Crear Actividades (5 minutos)

```
1. Inicia sesión
   ↓
2. Ve a: ActividadServlet?accion=nuevo
   ↓
3. Rellena el formulario (consulta: INICIO-RAPIDO.md)
   ↓
4. Haz clic en "Crear"
   ↓
5. ¡Hecho!
```

### 3️⃣ Si hay Problemas (10-20 minutos)

```
1. Identifica el error
   ↓
2. Consulta la sección "Si Algo Falla" en INICIO-RAPIDO.md
   ↓
3. Si persiste, consulta GUIA-CREAR-ACTIVIDADES.md
   ↓
4. Verifica: VERIFICACION-FINAL.md (Troubleshooting)
   ↓
5. Revisa los logs: apache-tomcat-9.0.115/logs/catalina.log
```

---

## 🎯 ACCESOS RÁPIDOS

### Crear Actividad
```
http://localhost:8080/SistemaGestionTareas/ActividadServlet?accion=nuevo
```
*Requiere estar logueado como administrador*

### Listar Actividades
```
http://localhost:8080/SistemaGestionTareas/ActividadServlet?accion=listar
```

### Ver Detalle (reemplaza X con el ID)
```
http://localhost:8080/SistemaGestionTareas/ActividadServlet?accion=ver&id=X
```

---

## 📊 CARACTERÍSTICAS POR DOCUMENTO

### INICIO-RAPIDO.md
- ✅ Pasos en 5 minutos
- ✅ Tabla de campos
- ✅ Checklist
- ✅ FAQ básico
- ✅ Troubleshooting rápido

### GUIA-CREAR-ACTIVIDADES.md
- ✅ Instrucciones paso a paso
- ✅ Múltiples opciones de instalación
- ✅ Verificación de instalación
- ✅ Detalles del formulario
- ✅ Troubleshooting completo
- ✅ Consejos de buenas prácticas

### RESUMEN-ACTIVIDADES.md
- ✅ Lo que se implementó
- ✅ Estructura del proyecto
- ✅ Pasos para empezar
- ✅ Preguntas frecuentes
- ✅ Próximos pasos

### VERIFICACION-FINAL.md
- ✅ Checklist completo
- ✅ Estado de componentes
- ✅ Pruebas realizadas
- ✅ Instrucciones finales
- ✅ Soporte técnico

### ARCHIVOS-ENTREGADOS.md
- ✅ Inventario de archivos
- ✅ Estructura de carpetas
- ✅ Resumen de cambios
- ✅ Integridad de archivos

### README.md
- ✅ Visión general
- ✅ Características
- ✅ Tecnologías
- ✅ Requisitos
- ✅ Instalación
- ✅ Uso

---

## 🔍 BÚSQUEDA POR TÓPICO

### Instalación
- 📍 INICIO-RAPIDO.md (Pasos 1-3)
- 📍 GUIA-CREAR-ACTIVIDADES.md (Pasos 1-5)
- 📍 README.md (Instalación)

### Base de Datos
- 📍 GUIA-CREAR-ACTIVIDADES.md (Paso 1)
- 📍 crear-actividades.sql
- 📍 crear-tabla-actividades.bat

### Uso de Aplicación
- 📍 GUIA-CREAR-ACTIVIDADES.md (Paso 6)
- 📍 INICIO-RAPIDO.md (Paso 5)
- 📍 formulario-actividad.jsp

### Solución de Problemas
- 📍 INICIO-RAPIDO.md (Si Algo Falla)
- 📍 GUIA-CREAR-ACTIVIDADES.md (Troubleshooting)
- 📍 VERIFICACION-FINAL.md (Soporte)

### Arquitectura
- 📍 RESUMEN-ACTIVIDADES.md (Backend, Frontend)
- 📍 ARCHIVOS-ENTREGADOS.md (Estructura)
- 📍 README.md (Tecnologías)

### Campos y Validaciones
- 📍 INICIO-RAPIDO.md (Tabla de Campos)
- 📍 GUIA-CREAR-ACTIVIDADES.md (Validaciones)
- 📍 VERIFICACION-FINAL.md (Validaciones)

---

## 🆘 AYUDA RÁPIDA

### "¡Necesito ayuda YA!"
1. Ejecuta los 3 comandos en INICIO-RAPIDO.md
2. Si falla, consulta "Si Algo Falla"
3. Si persiste, lee GUIA-CREAR-ACTIVIDADES.md completa

### "No sé qué hacer"
1. Lee RESUMEN-ACTIVIDADES.md (visión general)
2. Lee INICIO-RAPIDO.md (pasos principales)
3. Ejecuta los comandos

### "Tengo un error específico"
1. Anota el error exacto
2. Busca en GUIA-CREAR-ACTIVIDADES.md (Troubleshooting)
3. Busca en VERIFICACION-FINAL.md (Soporte)
4. Revisa los logs de Tomcat

---

## 📞 CONTACTO

Si después de leer toda la documentación aún tienes dudas:

1. Verifica que PostgreSQL esté corriendo
2. Verifica los datos de conexión en `Conexion.java`
3. Revisa los logs: `apache-tomcat-9.0.115/logs/catalina.log`
4. Verifica el puerto: `http://localhost:8080`

---

## ✨ TIPS Y TRUCOS

### Para desarrolladores
- Consulta `ActividadDao.java` para ver cómo funcionan las consultas
- Consulta `ActividadServlet.java` para ver el flujo de control
- Consulta `formulario-actividad.jsp` para ver la interfaz

### Para usuarios
- Ten a mano los datos que necesitas antes de crear actividad
- Verifica que el usuario exista en el sistema
- Las fechas deben estar en formato dd/mm/yyyy

### Para administradores
- Haz backup de la BD regularmente
- Revisa los logs después de cambios
- Valida que la tabla se creó correctamente

---

## 🎓 APRENDER MÁS

### Estructura del Proyecto
Ver: `ARCHIVOS-ENTREGADOS.md` → Estructura de Carpetas

### Componentes Técnicos
Ver: `VERIFICACION-FINAL.md` → Validaciones de Funcionalidad

### Próximos Pasos
Ver: `RESUMEN-ACTIVIDADES.md` → Próximos Pasos

---

## 📋 ÚLTIMAS NOTAS

- ✅ Todo está documentado
- ✅ No hay dependencias ocultas
- ✅ Todos los scripts funcionan
- ✅ Toda la documentación es accesible

---

**Ahora estás listo para comenzar. ¡Elige tu ruta y comienza! 🚀**

---

**Índice de Documentación**  
Fecha: 05/05/2026  
Versión: 1.0  
Sistema: Gestión de Actividades

