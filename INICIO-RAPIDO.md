# ⚡ INICIO RÁPIDO - CREAR ACTIVIDADES

## Resumen de Pasos (5 minutos)

### 1️⃣ Crear la Tabla en BD (Una sola vez)
```powershell
cd C:\Users\sofsh\Desktop\Gestiondetareas\SistemaGestionTareas
.\crear-tabla-actividades.bat
```

### 2️⃣ Compilar el Proyecto
```powershell
mvn clean package
```

### 3️⃣ Iniciar Tomcat
```powershell
.\start-tomcat.bat
```
Espera a que aparezca: `✅ Conexión exitosa a la BD`

### 4️⃣ Acceder a la Aplicación
- Abre navegador: **http://localhost:8080/SistemaGestionTareas/**
- Inicia sesión con usuario administrador

### 5️⃣ Crear Actividad
- URL: **http://localhost:8080/SistemaGestionTareas/ActividadServlet?accion=nuevo**
- O busca el botón "Nueva Actividad" en el menú

---

## Campos del Formulario

| Campo | Requerido | Ejemplo |
|-------|:---------:|---------|
| Título | ✓ | Mantenimiento de Servidores |
| Descripción | ✗ | Descripción de la tarea |
| Instructor | ✓ | Jesús Valest |
| Prioridad | ✓ | Alta |
| Fecha Inicio | ✓ | 05/05/2026 |
| Fecha Vencimiento | ✓ | 10/05/2026 |

---

## ❌ Si Algo Falla

### Error: "Tabla no existe"
```powershell
# Ejecuta de nuevo:
.\crear-tabla-actividades.bat
```

### Error: "No se puede conectar a BD"
1. Verifica que PostgreSQL esté corriendo
2. Comprueba datos en: `Conexion.java`
   - Host: `localhost`
   - Puerto: `5432`
   - BD: `Gestiondetareas`
   - Usuario: `postgres`
   - Contraseña: `Mia1924.`

### Error: "404 ActividadServlet not found"
```powershell
# Reconstruye:
mvn clean package

# Reinicia Tomcat
.\start-tomcat.bat
```

### Error: "No estoy logueado"
- Cierra el navegador completamente
- Inicia sesión nuevamente
- Asegúrate de tener rol "Administrador"

---

## ✅ Checklist

- [ ] PostgreSQL está instalado y corriendo
- [ ] Base de datos `Gestiondetareas` existe
- [ ] Tabla `actividades` fue creada (ejecuté `crear-tabla-actividades.bat`)
- [ ] Compilé el proyecto (`mvn clean package`)
- [ ] Tomcat está corriendo
- [ ] Estoy logueado como Administrador
- [ ] Acceso a: `http://localhost:8080/SistemaGestionTareas/ActividadServlet?accion=nuevo`

---

## 📞 Ayuda Detallada

Para instrucciones completas, consulta: **[GUIA-CREAR-ACTIVIDADES.md](GUIA-CREAR-ACTIVIDADES.md)**

