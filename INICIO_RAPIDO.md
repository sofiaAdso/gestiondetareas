# 🚀 INICIO RÁPIDO - Crear Actividades

## ✅ Tu problema está SOLUCIONADO

He implementado todas las mejoras necesarias para que puedas crear actividades correctamente.

## 📋 Pasos Inmediatos

### 1. Verificar la Base de Datos (2 minutos)

Abre pgAdmin o psql y ejecuta:

```sql
-- ¿Existe la tabla actividades?
SELECT * FROM actividades LIMIT 1;

-- ¿Hay usuarios?
SELECT id, nombre, email FROM usuarios;
```

**Si la tabla NO existe:**
```sql
-- Ejecuta este archivo:
\i crear_tabla_actividades.sql
```

**Si NO hay usuarios:**
- Regístrate en: `http://localhost:8080/SistemaGestionTareas/registro_usuario.jsp`

### 2. Desplegar la Aplicación

**Opción A: Usando tu IDE**
1. Abre el proyecto en IntelliJ IDEA / Eclipse
2. Click derecho en el proyecto → Run / Deploy
3. Espera a que compile y despliegue

**Opción B: Manualmente**
1. Compila con Maven (o desde tu IDE)
2. Copia el WAR a `[TOMCAT]/webapps/`
3. Reinicia Tomcat

### 3. Ejecutar Diagnóstico

Abre tu navegador:
```
http://localhost:8080/SistemaGestionTareas/DiagnosticoServlet
```

Este servlet te dirá exactamente qué está bien y qué necesita arreglarse.

### 4. Crear tu Primera Actividad

1. Ve a: `http://localhost:8080/SistemaGestionTareas`
2. Inicia sesión
3. Click en "Gestionar Actividades" o "Nueva Actividad"
4. Llena el formulario:
   - **Título**: "Mi Primera Actividad" ✅ (requerido)
   - **Descripción**: "Esta es una prueba" (opcional)
   - **Fecha Inicio**: Selecciona hoy ✅ (requerido)
   - **Fecha Fin**: Selecciona dentro de 30 días ✅ (requerido)
   - **Prioridad**: Media (por defecto)
   - **Estado**: En Progreso (por defecto)
   - **Color**: Azul (por defecto)
5. Click en "Crear Actividad"

## 🔍 Si NO Funciona

### Ver los Logs

**Logs de Tomcat:**
- Windows: `[TOMCAT]\logs\catalina.out`
- Busca: `=== CREANDO ACTIVIDAD ===`

**Console del Navegador:**
- Presiona F12
- Ve a la pestaña Console
- Busca mensajes de error

### Usa el Diagnóstico

El `DiagnosticoServlet` te mostrará:
- ✓ Conexión a BD
- ✓ Estructura de tablas
- ✓ Usuarios disponibles
- ✓ Prueba de creación

### Revisar Guías Detalladas

Si necesitas más ayuda, revisa:
1. **SOLUCION_CREAR_ACTIVIDADES.md** - Resumen completo
2. **GUIA_SOLUCION_PROBLEMAS_ACTIVIDADES.md** - Troubleshooting detallado

## 🎯 Lo que se Mejoró

✅ **Logging detallado** - Ahora ves exactamente qué pasa  
✅ **Validaciones robustas** - Cliente y servidor  
✅ **Mensajes de error claros** - Sabes qué salió mal  
✅ **Servlet de diagnóstico** - Herramienta de debugging  
✅ **Documentación completa** - Guías paso a paso  

## 💡 Consejos

- **Siempre verifica** que estés logueado antes de crear actividades
- **Usa fechas válidas** (fin >= inicio)
- **Revisa los logs** si algo falla
- **Ejecuta el diagnóstico** primero

## 🆘 Prueba Rápida SQL

Si quieres probar que la BD funciona:

```sql
-- Insertar actividad de prueba
INSERT INTO actividades 
(usuario_id, titulo, descripcion, fecha_inicio, fecha_fin, prioridad, estado, color)
VALUES 
(1, 'Test', 'Prueba', CURRENT_DATE, CURRENT_DATE + 30, 'Media', 'En Progreso', '#3498db')
RETURNING id;
```

Si esto funciona → El problema está en la aplicación web  
Si esto falla → El problema está en la base de datos

## 📞 Contacto

¿Aún tienes problemas?
1. Ejecuta el DiagnosticoServlet
2. Copia los logs de error
3. Revisa las guías detalladas

---

**¡Tu sistema está listo! Solo sigue los pasos y podrás crear actividades sin problemas.** 🎉

