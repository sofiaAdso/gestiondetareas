# 🚀 INSTRUCCIONES DE COMPILACIÓN Y DESPLIEGUE

## ⚠️ IMPORTANTE: Maven no está en el PATH

El sistema no encuentra el comando `mvn`. Puedes compilar de dos formas:

---

## 📋 OPCIÓN 1: Compilar desde IntelliJ IDEA (RECOMENDADO)

### Paso 1: Limpiar el proyecto
1. Abre el proyecto en IntelliJ IDEA
2. Ve al menú **Build** → **Clean Project**
3. Espera a que termine

### Paso 2: Reconstruir el proyecto
1. Ve al menú **Build** → **Rebuild Project**
2. Espera a que compile (verás el progreso en la barra inferior)
3. Verifica que no haya errores en la pestaña **Build**

### Paso 3: Generar el archivo WAR
1. Ve al panel de Maven (lateral derecho, icono M)
2. Si no ves el panel, ve a **View** → **Tool Windows** → **Maven**
3. Expande **SistemaGestionTareas** → **Lifecycle**
4. Doble clic en **clean**
5. Luego doble clic en **package**
6. El WAR se generará en: `target\SistemaGestionTareas.war`

### Paso 4: Desplegar en Tomcat
1. **Detener Tomcat** (si está corriendo)
2. Ir a la carpeta de Tomcat: `C:\apache-tomcat-X.X\webapps\`
3. **Eliminar** la carpeta vieja `SistemaGestionTareas` (si existe)
4. **Eliminar** el archivo viejo `SistemaGestionTareas.war` (si existe)
5. **Copiar** el nuevo `SistemaGestionTareas.war` desde `target\` a `webapps\`
6. **Iniciar Tomcat**
7. Esperar 10-15 segundos a que descomprima el WAR
8. Acceder a: http://localhost:8080/SistemaGestionTareas

---

## 📋 OPCIÓN 2: Instalar Maven en el PATH

### Windows 10/11:
1. Descarga Maven desde: https://maven.apache.org/download.cgi
2. Descomprime en `C:\Program Files\Maven\`
3. Agregar al PATH:
   - Busca "Variables de entorno" en el menú inicio
   - Clic en "Variables de entorno"
   - En "Variables del sistema", selecciona "Path" → Editar
   - Clic en "Nuevo"
   - Agrega: `C:\Program Files\Maven\bin`
   - Aceptar todo
4. **Cierra y abre PowerShell** nuevamente
5. Verifica con: `mvn -version`
6. Ahora sí podrás ejecutar `.\compilar_desplegar.bat`

---

## 📋 OPCIÓN 3: Compilar desde la terminal manualmente

Si Maven está instalado pero no en PATH, busca la carpeta de instalación y usa la ruta completa:

```cmd
cd C:\Users\sofsh\Desktop\Gestiondetareas\SistemaGestionTareas
"C:\ruta\a\maven\bin\mvn.cmd" clean package
```

---

## ✅ VERIFICAR QUE LA COMPILACIÓN FUE EXITOSA

Después de compilar, verifica:

1. ✓ El archivo `target\SistemaGestionTareas.war` existe
2. ✓ No hay errores en la consola de compilación
3. ✓ El tamaño del WAR es similar al anterior (varios MB)

---

## 🔧 DESPUÉS DE DESPLEGAR EN TOMCAT

1. **Iniciar Tomcat** (startup.bat o desde servicios)
2. **Abrir logs** de Tomcat en tiempo real:
   - Archivo: `C:\apache-tomcat-X.X\logs\catalina.out` (o `.log`)
   - Verifica que no haya errores al iniciar

3. **Acceder a la aplicación:**
   ```
   http://localhost:8080/SistemaGestionTareas
   ```

4. **Probar las funcionalidades:**
   - ✓ Login
   - ✓ Dashboard
   - ✓ Crear tarea
   - ✓ Editar tarea
   - ✓ Eliminar tarea
   - ✓ Crear actividad
   - ✓ Editar actividad
   - ✓ Ver actividad

---

## 🐛 SI HAY ERRORES DESPUÉS DEL DESPLIEGUE

### Error 404 - Not Found
- Verifica que la carpeta `SistemaGestionTareas` existe en `webapps\`
- Espera unos segundos más (Tomcat aún está desplegando)
- Revisa los logs de Tomcat

### Error 500 - Internal Server Error
- Revisa los logs de Tomcat: `logs\catalina.out`
- Verifica que la base de datos MySQL esté corriendo
- Verifica las credenciales en `application.properties`

### Pantalla en blanco (morada/blanca)
- Abre las herramientas de desarrollo del navegador (F12)
- Ve a la pestaña "Console" - busca errores JavaScript
- Ve a la pestaña "Network" - verifica que los recursos carguen correctamente
- **Recarga con Ctrl+F5** (limpia caché del navegador)

---

## 📊 CAMBIOS APLICADOS EN ESTA VERSIÓN

✅ **Blindaje completo contra NumberFormatException:**
- TareaServlet: 6 validaciones agregadas
- ActividadServlet: 6 validaciones agregadas
- SubtareaServlet: 4 validaciones agregadas
- LoginServlet: 2 validaciones agregadas

✅ **Mejoras de seguridad:**
- Validación de parámetros nulos
- Validación de parámetros vacíos
- Validación de espacios en blanco (trim)
- Try-catch en todas las conversiones
- Mensajes de error descriptivos
- Redirección segura ante fallos

---

## 🎯 RESULTADO ESPERADO

Después de aplicar estas correcciones y recompilar:

✅ **YA NO verás:**
```
HTTP Status 500 – Internal Server Error
java.lang.NumberFormatException: For input string: ""
```

✅ **VERÁS:**
- Operaciones CRUD funcionando sin errores
- Redirecciones suaves ante datos inválidos
- Mensajes de error amigables (opcional)
- Sistema estable y robusto

---

## 📞 SOPORTE

Si después de seguir estos pasos sigues teniendo problemas:

1. Revisa el archivo: `SOLUCION_ERROR_500_APLICADA.md`
2. Verifica los logs de Tomcat
3. Verifica que MySQL esté corriendo
4. Limpia caché del navegador (Ctrl+Shift+Delete)
5. Reinicia Tomcat completamente

---

**Fecha:** 2026-02-23  
**Versión:** 2.0 - Blindaje completo contra errores 500  
**Estado:** ✅ LISTO PARA DESPLEGAR

