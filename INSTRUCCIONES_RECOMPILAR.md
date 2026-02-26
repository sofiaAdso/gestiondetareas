# Instrucciones para Recompilar y Redesplegar

## Cambios Realizados

Se han realizado los siguientes cambios para que las actividades muestren correctamente sus tareas asociadas:

### 1. ActividadServlet.java
- Modificado el método `listarActividades()` para calcular las estadísticas de tareas
- Modificado el método `verActividad()` para calcular las estadísticas de tareas
- Ahora se calculan: `totalTareas`, `tareasCompletadas` y `porcentajeCompletado`

### 2. listar-actividades.jsp
- Corregido el error de compilación JSP
- Cambiado el uso de variable local por llamadas directas a `act.getTareas()`

## Cómo Recompilar desde IntelliJ IDEA

### Opción 1: Build del Proyecto
1. En IntelliJ, ve a: **Build** → **Rebuild Project**
2. Espera a que termine la compilación
3. Ve a: **Build** → **Build Artifacts** → **SistemaGestionTareas:war** → **Rebuild**

### Opción 2: Maven desde IntelliJ
1. Abre la ventana de Maven (View → Tool Windows → Maven)
2. Expande el proyecto **SistemaGestionTareas**
3. Expande **Lifecycle**
4. Ejecuta en orden:
   - `clean`
   - `compile`
   - `package`

### Opción 3: Terminal de IntelliJ
1. Abre el terminal de IntelliJ (Alt+F12)
2. Ejecuta:
   ```bash
   mvn clean package
   ```

## Desplegar en Tomcat

### Desde IntelliJ (Recomendado)
1. Ve a: **Run** → **Edit Configurations**
2. Si ya tienes una configuración de Tomcat:
   - Haz clic en **Run** (Shift+F10)
3. Si no tienes configuración de Tomcat:
   - Clic en **+** → **Tomcat Server** → **Local**
   - Configura la ruta de Tomcat
   - En la pestaña **Deployment**, agrega el artefacto WAR
   - Clic en **OK** y luego **Run**

### Manualmente
1. Detén Tomcat si está corriendo
2. Elimina la carpeta antigua: `[TOMCAT]/webapps/SistemaGestionTareas`
3. Elimina el WAR antiguo: `[TOMCAT]/webapps/SistemaGestionTareas.war`
4. Copia el nuevo WAR: `target/SistemaGestionTareas.war` → `[TOMCAT]/webapps/`
5. Inicia Tomcat

## Verificar los Cambios

Después de redesplegar, accede a:
```
http://localhost:8080/SistemaGestionTareas/ActividadServlet?accion=listar
```

Deberías ver:
- El contador de tareas correcto (ej: "2 de 5 tareas")
- El porcentaje de completado calculado correctamente
- Las tareas listadas cuando haces clic en "Ver tareas"

## Solución de Problemas

### Error: "The method getTareas() is undefined"
- Asegúrate de haber recompilado completamente el proyecto
- Limpia el directorio work de Tomcat: `[TOMCAT]/work/Catalina/localhost/SistemaGestionTareas`
- Reinicia Tomcat

### Las tareas no se muestran
- Verifica que las tareas tengan `actividad_id` correctamente asignado en la base de datos
- Ejecuta en PostgreSQL:
  ```sql
  SELECT a.titulo AS actividad, COUNT(t.id) AS num_tareas
  FROM actividades a
  LEFT JOIN tareas t ON t.actividad_id = a.id
  GROUP BY a.id, a.titulo;
  ```

### El porcentaje no se calcula
- Verifica que las tareas tengan el campo `estado` = 'Completada' o `completada` = true
- Ejecuta:
  ```sql
  SELECT estado, completada, COUNT(*) 
  FROM tareas 
  GROUP BY estado, completada;
  ```

