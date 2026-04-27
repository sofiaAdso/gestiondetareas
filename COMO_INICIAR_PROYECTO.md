# 🚀 CÓMO INICIAR EL PROYECTO

## ❌ PROBLEMA ACTUAL
El navegador muestra `ERR_CONNECTION_REFUSED` porque **NO HAY SERVIDOR EJECUTÁNDOSE** en el puerto 8080.

## ✅ SOLUCIONES DISPONIBLES

### OPCIÓN 1: Usar IntelliJ IDEA con Smart Tomcat (RECOMENDADO)

#### Paso 1: Configurar Smart Tomcat en IntelliJ IDEA

1. **Abrir el proyecto en IntelliJ IDEA** (ya lo tienes abierto)

2. **Configurar Run Configuration**:
   - Haz clic en el menú desplegable junto al botón verde de "Run" (arriba a la derecha)
   - Selecciona **"Edit Configurations..."**
   - Haz clic en el botón **"+"** (Add New Configuration)
   - Busca y selecciona **"Smart Tomcat"**
   
3. **Configurar Smart Tomcat**:
   - **Name**: `SistemaGestionTareas`
   - **Tomcat server**: Si no tienes Tomcat instalado, descárgalo de https://tomcat.apache.org/download-90.cgi
   - **Deployment directory**: Selecciona la carpeta `src/main/webapp` de tu proyecto
   - **Context path**: `/SistemaGestionTareas` o `/`
   - **Server port**: `8080`
   - **Admin port**: `8005`
   
4. **Guardar y ejecutar**:
   - Haz clic en **"Apply"** y luego **"OK"**
   - Presiona el botón verde **"Run"** (▶) o presiona **Shift + F10**
   
5. **Acceder a la aplicación**:
   - Abre el navegador en: `http://localhost:8080/`

---

### OPCIÓN 2: Usar Maven con Cargo Plugin (ALTERNATIVA)

Si Maven está configurado correctamente, ejecuta:

```powershell
cd C:\Users\sofsh\Desktop\Gestiondetareas\SistemaGestionTareas
.\mvnw.cmd clean package cargo:run
```

**NOTA**: Acabo de actualizar el `pom.xml` para que este comando funcione.

---

### OPCIÓN 3: Compilar WAR e instalar en Tomcat manualmente

#### Paso 1: Compilar el proyecto
```powershell
cd C:\Users\sofsh\Desktop\Gestiondetareas\SistemaGestionTareas
.\mvnw.cmd clean package
```

#### Paso 2: Copiar el WAR a Tomcat
1. Ve a la carpeta `target/` de tu proyecto
2. Encontrarás el archivo `SistemaGestionTareas.war`
3. Copia ese archivo a la carpeta `webapps/` de tu instalación de Tomcat
4. Inicia Tomcat ejecutando `bin/startup.bat`
5. Accede a: `http://localhost:8080/SistemaGestionTareas/`

---

## 🔍 VERIFICAR SI TOMCAT ESTÁ CORRIENDO

En PowerShell, ejecuta:
```powershell
netstat -ano | findstr :8080
```

Si ves algo como `LISTENING` significa que el servidor está corriendo.
Si solo ves `SYN_SENT` (como ahora), significa que NO hay servidor.

---

## ⚠️ PROBLEMAS COMUNES

### 1. "mvn no se reconoce"
**Solución**: Usa `.\mvnw.cmd` en lugar de `mvn`

### 2. "JAVA_HOME is not set"
**Solución**: 
```powershell
$env:JAVA_HOME = "C:\Program Files\Java\jdk-17"  # Ajusta la ruta según tu instalación
```

### 3. Puerto 8080 ya en uso
**Solución**: Encuentra y mata el proceso:
```powershell
netstat -ano | findstr :8080
# Anota el PID (último número)
taskkill /F /PID <número_del_PID>
```

### 4. Error de conexión a base de datos
Verifica que PostgreSQL esté corriendo:
```powershell
Get-Service -Name postgresql*
```

---

## 📝 CONFIGURACIÓN ACTUAL

- **Puerto del servidor**: 8080
- **Base de datos**: PostgreSQL en localhost:5432
- **Database name**: Gestiondetareas
- **Usuario DB**: postgres

---

## 🎯 SIGUIENTE PASO RECOMENDADO

**USA LA OPCIÓN 1** (Smart Tomcat en IntelliJ IDEA) porque:
- ✅ Es más fácil y rápido
- ✅ Permite debugging
- ✅ Recarga automática de cambios
- ✅ Integración con el IDE


