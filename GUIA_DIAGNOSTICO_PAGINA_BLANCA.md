# Guía de Diagnóstico: Página en Blanco en "Mis Actividades"

## 🔍 Problema
Cuando accedes a "Mis Actividades" (ActividadServlet?accion=listar), la página aparece en blanco.

## ✅ Cambios Realizados

He agregado logs de depuración extensivos en:

1. **ActividadServlet.java**
   - Método `doGet()`: Muestra qué acción se está ejecutando
   - Método `listarActividades()`: Muestra paso a paso el proceso de carga de datos
   - Nuevo método `listarActividadesTest()`: Version de test con JSP simplificado

2. **listar-actividades.jsp**
   - Logs al inicio para verificar usuario y datos

3. **Nuevo archivo: test-actividades-simple.jsp**
   - Página de diagnóstico simplificada que muestra información detallada

## 🔧 Pasos para Diagnosticar

### Paso 1: Recompilar la Aplicación
```powershell
cd C:\Users\sofsh\Desktop\Gestiondetareas\SistemaGestionTareas
mvn clean package -DskipTests
```

### Paso 2: Copiar el WAR a Tomcat
```powershell
# Detener Tomcat
# Eliminar la carpeta antigua: <TOMCAT_HOME>\webapps\SistemaGestionTareas
# Copiar el nuevo WAR: 
copy .\target\SistemaGestionTareas.war <TOMCAT_HOME>\webapps\
# Iniciar Tomcat
```

### Paso 3: Acceder a la Página de Test
Después de iniciar sesión, accede a:
```
http://localhost:8080/SistemaGestionTareas/ActividadServlet?accion=test
```

Esta página te mostrará:
- ✅ Si el usuario está autenticado
- ✅ Si los datos se están cargando del servlet
- ✅ Cuántas actividades hay
- ✅ Detalles de cada actividad

### Paso 4: Revisar Logs de Tomcat
Los logs de depuración se mostrarán en:
- **Windows**: `<TOMCAT_HOME>\logs\catalina.out` o consola de Tomcat
- Busca líneas que empiecen con `===` para ver el flujo de ejecución

## 🐛 Posibles Causas del Problema

### Causa 1: Error de JavaScript o CSS
**Síntoma**: La página carga pero aparece en blanco
**Solución**: 
- Abre la consola del navegador (F12 → Console)
- Busca errores en rojo
- Verifica que se carguen los recursos externos (Font Awesome, SweetAlert2)

### Causa 2: El Servlet No Se Ejecuta
**Síntoma**: No hay logs en Tomcat
**Solución**:
- Verifica que el WAR se haya desplegado correctamente
- Verifica la URL: debe ser `/ActividadServlet?accion=listar`
- Verifica el mapeo del servlet en web.xml o la anotación @WebServlet

### Causa 3: Datos NULL desde la Base de Datos
**Síntoma**: Logs muestran "listaActividades: NULL"
**Solución**:
- Verifica la conexión a la base de datos
- Ejecuta en MySQL: `SELECT * FROM actividades WHERE usuario_id = <tu_id>;`
- Revisa los métodos en ActividadDao.java

### Causa 4: Excepción en el JSP
**Síntoma**: Página en blanco sin errores visibles
**Solución**:
- Revisa los logs de Tomcat para excepciones
- Usa la página de test (accion=test) que es más simple

### Causa 5: Sesión Perdida
**Síntoma**: Redirección continua o página en blanco
**Solución**:
- Verifica que el login funcione correctamente
- Verifica que `session.getAttribute("usuario")` no sea null

## 📋 Checklist de Verificación

- [ ] Maven compiló sin errores
- [ ] El WAR se copió a Tomcat
- [ ] Tomcat se reinició correctamente
- [ ] Puedes hacer login correctamente
- [ ] Otras páginas funcionan (Dashboard, Mis Tareas)
- [ ] La URL es correcta: `/ActividadServlet?accion=listar`
- [ ] Revisaste la consola del navegador (F12)
- [ ] Revisaste los logs de Tomcat
- [ ] Probaste la página de test: `/ActividadServlet?accion=test`

## 🔄 URLs para Probar

1. **Página Normal** (puede fallar):
   ```
   http://localhost:8080/SistemaGestionTareas/ActividadServlet?accion=listar
   ```

2. **Página de Test** (simplificada):
   ```
   http://localhost:8080/SistemaGestionTareas/ActividadServlet?accion=test
   ```

3. **Crear Nueva Actividad**:
   ```
   http://localhost:8080/SistemaGestionTareas/ActividadServlet?accion=nuevo
   ```

## 📊 Interpretando los Logs

Cuando accedas a la página, deberías ver en los logs de Tomcat:

```
=== SERVLET: ACTIVIDAD - doGet() ===
Usuario autenticado: [tu_usuario]
Acción solicitada: listar
Ejecutando: listarActividades()
=== SERVLET: LISTAR ACTIVIDADES - INICIO ===
Usuario: [tu_usuario] (ID: X, Rol: Usuario)
Cargando actividades del usuario ID: X
Actividades obtenidas: Y
Cargando tareas para cada actividad...
  - Actividad: [nombre] (ID: Z)
    Tareas asociadas: N
    Progreso: XX.X%
✓ Enviando Y actividades al JSP
=== JSP LISTAR-ACTIVIDADES: INICIO ===
Usuario en sesión: [tu_usuario]
Lista de actividades recibida: SI (Y items)
=== JSP LISTAR-ACTIVIDADES: DATOS CARGADOS ===
=== SERVLET: LISTAR ACTIVIDADES - FIN ===
```

Si ves algo diferente, ese es el punto del error.

## 💡 Solución Rápida

Si todo falla, puedes usar temporalmente la página de test:

1. En `dashboard.jsp`, cambia el enlace de "Mis Actividades" de:
   ```jsp
   <a href="ActividadServlet?accion=listar">
   ```
   a:
   ```jsp
   <a href="ActividadServlet?accion=test">
   ```

Esto te permitirá ver tus actividades mientras depuramos el problema del JSP principal.

## 📞 Información Adicional

Si sigues teniendo problemas:
1. Copia y pega los logs completos de Tomcat
2. Toma una captura de la consola del navegador (F12 → Console)
3. Verifica en MySQL: `SELECT * FROM actividades;`

