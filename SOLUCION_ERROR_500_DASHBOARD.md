# 🔧 SOLUCIÓN AL ERROR HTTP 500 - Dashboard

## 📋 Problema Identificado

**Error**: `java.lang.NoSuchMethodError: 'int com.sena.gestion.repository.TareaDao.contarTodas()'`

**Causa**: El servidor Tomcat tiene una versión antigua de las clases compiladas que no incluye los nuevos métodos agregados.

---

## ✅ SOLUCIÓN PASO A PASO

### Opción 1: Despliegue Automático (Recomendado)

1. **Ejecuta el archivo batch de despliegue**:
   ```
   redesplegar_dashboard.bat
   ```
   
2. **Espera** 10-15 segundos para que Tomcat despliegue

3. **Limpia la caché del navegador**:
   - Presiona `Ctrl + Shift + Delete`
   - O simplemente `Ctrl + F5` para forzar recarga

4. **Accede nuevamente**:
   ```
   http://localhost:8080/SistemaGestionTareas/
   ```

---

### Opción 2: Despliegue Manual

#### Paso 1: Detener Tomcat
```bash
# Busca el proceso de Tomcat y detenlo
# O desde Servicios de Windows si está instalado como servicio
```

#### Paso 2: Eliminar aplicación antigua
Localiza tu carpeta de Tomcat (ejemplo: `C:\apache-tomcat-9.0\webapps`) y elimina:
- `SistemaGestionTareas.war`
- Carpeta `SistemaGestionTareas\`

#### Paso 3: Limpiar caché de trabajo
Elimina la carpeta:
```
C:\apache-tomcat-9.0\work\Catalina\localhost\SistemaGestionTareas
```

#### Paso 4: Copiar nuevo WAR
Copia el archivo:
```
SistemaGestionTareas\target\SistemaGestionTareas.war
```
A:
```
C:\apache-tomcat-9.0\webapps\
```

#### Paso 5: Iniciar Tomcat
Inicia el servidor Tomcat nuevamente

#### Paso 6: Verificar despliegue
Espera 10-15 segundos y verifica los logs en:
```
C:\apache-tomcat-9.0\logs\catalina.out
```

---

## 🔍 Verificación de los Métodos

Los siguientes métodos están ahora disponibles en `TareaDao.java`:

```java
✅ public int contarPorUsuario(int usuarioId)
✅ public int contarPorEstado(int usuarioId, String estado)
✅ public int contarTodas()
✅ public int contarTodasPorEstado(String estado)
```

Los siguientes métodos están ahora disponibles en `ActividadDao.java`:

```java
✅ public int contarPorUsuario(int usuarioId)
✅ public int contarPorEstado(int usuarioId, String estado)
✅ public int contarTodas()
✅ public int contarTodasPorEstado(String estado)
```

---

## 🚨 Si el Error Persiste

### 1. Verifica que Tomcat se reinició completamente
```bash
# Verifica procesos de Java en ejecución
tasklist | findstr java
```

### 2. Elimina archivos temporales de compilación
```bash
cd C:\Users\sofsh\Desktop\Gestiondetareas\SistemaGestionTareas
rmdir /S /Q target
mvn clean package -DskipTests
```

### 3. Verifica los logs de Tomcat
Revisa el archivo:
```
C:\apache-tomcat-9.0\logs\catalina.[FECHA].log
```

### 4. Limpia completamente el caché del navegador
- Chrome: `Ctrl + Shift + Delete` → Seleccionar "Todo" → Borrar
- O usa modo incógnito: `Ctrl + Shift + N`

---

## 📊 Estado de Compilación

```
✅ Compilación exitosa: mvn clean compile
✅ Empaquetado exitoso: mvn package
✅ WAR generado: target/SistemaGestionTareas.war
✅ Tamaño aproximado: ~5 MB
```

---

## 🎯 Resultado Esperado

Después de seguir estos pasos, deberías ver:

1. **Dashboard con estadísticas** mostrando:
   - Total de tareas
   - Total de actividades
   - Progreso en porcentaje
   - Desglose por estados

2. **Sin errores HTTP 500**

3. **Interfaz moderna** con sidebar y tarjetas de estadísticas

---

## 📞 Troubleshooting Adicional

### Error: "No se puede conectar a localhost:8080"
- **Solución**: Verifica que Tomcat esté ejecutándose
- Verifica el puerto con: `netstat -ano | findstr :8080`

### Error: "404 - Not Found"
- **Solución**: Espera más tiempo (hasta 30 segundos) para que Tomcat despliegue
- Verifica que el archivo WAR esté en `webapps\`

### Error: Página en blanco
- **Solución**: Limpia caché del navegador completamente
- Intenta con otro navegador o modo incógnito

### Error: "Base de datos no conecta"
- **Solución**: Verifica que MySQL esté ejecutándose
- Verifica las credenciales en `Conexion.java`

---

## ✅ Checklist Final

Antes de reportar un problema, verifica:

- [ ] Maven compiló sin errores
- [ ] Tomcat se reinició completamente
- [ ] El WAR está en la carpeta webapps
- [ ] La caché del navegador está limpia
- [ ] MySQL está ejecutándose
- [ ] El usuario tiene sesión activa
- [ ] La URL es correcta: `http://localhost:8080/SistemaGestionTareas/`

---

## 📝 Comandos Rápidos

```bash
# Recompilar todo
cd C:\Users\sofsh\Desktop\Gestiondetareas\SistemaGestionTareas
mvn clean package -DskipTests

# Desplegar automáticamente
.\redesplegar_dashboard.bat

# Ver logs de Tomcat en tiempo real (PowerShell)
Get-Content "C:\apache-tomcat-9.0\logs\catalina.out" -Wait -Tail 50
```

---

**Fecha**: 24 de febrero de 2026  
**Versión**: 2.0  
**Estado**: ✅ Solución Documentada

