# 🚀 GUÍA: INSTALACIÓN Y DESPLIEGUE DE TOMCAT

## ❌ PROBLEMA ACTUAL
El error `DirectoryNotFoundException` indica que Tomcat NO está instalado en `C:\apache-tomcat-9.0.84\webapps\`

## ✅ SOLUCIONES (Elige una)

---

### 🎯 OPCIÓN 1: IntelliJ IDEA con Smart Tomcat (RECOMENDADO para desarrollo)

**Esta es la forma más fácil si usas IntelliJ IDEA:**

1. **Instalar Plugin Smart Tomcat:**
   - Ve a `File` → `Settings` → `Plugins`
   - Busca "Smart Tomcat"
   - Haz clic en `Install` y reinicia IntelliJ

2. **Configurar Smart Tomcat:**
   - Ve a `Run` → `Edit Configurations`
   - Haz clic en `+` → Busca "Smart Tomcat"
   - Configura:
     - **Tomcat Server**: Descarga Tomcat si no lo tienes
     - **Context Path**: `/SistemaGestionTareas`
     - **Server Port**: `8080`

3. **Ejecutar:**
   - Haz clic en el botón verde ▶️ de Run
   - Tu aplicación se abrirá automáticamente en el navegador

---

### 🔧 OPCIÓN 2: Instalar Tomcat Manualmente

#### PASO 1: Descargar Tomcat
1. Ve a: https://tomcat.apache.org/download-90.cgi
2. Descarga **"32-bit/64-bit Windows Service Installer"** o el **ZIP** (Core)
3. Si descargas el ZIP, extráelo en una ubicación fácil de encontrar

#### PASO 2: Ubicaciones recomendadas
```
C:\apache-tomcat-9.0.84\
C:\tomcat\
C:\Program Files\Apache\Tomcat 9.0\
```

#### PASO 3: Verificar instalación
Abre PowerShell y ejecuta:
```powershell
Test-Path "C:\apache-tomcat-9.0.84\webapps"
```
Debe devolver `True`

#### PASO 4: Desplegar tu aplicación

**Opción A - Usar el script automático:**
```bash
.\desplegar_automatico.bat
```

**Opción B - Manual:**
```powershell
# Compilar
.\mvnw.cmd clean package -DskipTests

# Copiar el WAR (ajusta la ruta según tu instalación)
Copy-Item "target\SistemaGestionTareas.war" "C:\apache-tomcat-9.0.84\webapps\" -Force
```

#### PASO 5: Iniciar Tomcat
```powershell
C:\apache-tomcat-9.0.84\bin\startup.bat
```

#### PASO 6: Acceder a tu aplicación
```
http://localhost:8080/SistemaGestionTareas
```

---

### 🐛 OPCIÓN 3: Despliegue Rápido sin Tomcat Externo

**Puedes usar Maven Tomcat Plugin (para pruebas):**

1. Abre `pom.xml` y verifica que tengas este plugin:
```xml
<plugin>
    <groupId>org.apache.tomcat.maven</groupId>
    <artifactId>tomcat7-maven-plugin</artifactId>
    <version>2.2</version>
    <configuration>
        <port>8080</port>
        <path>/SistemaGestionTareas</path>
    </configuration>
</plugin>
```

2. Ejecuta:
```powershell
.\mvnw.cmd tomcat7:run
```

3. Accede a: `http://localhost:8080/SistemaGestionTareas`

---

## 🔍 DIAGNÓSTICO: ¿Dónde está Tomcat?

Ejecuta este comando en PowerShell para buscar Tomcat:
```powershell
Get-ChildItem -Path C:\ -Filter "apache-tomcat*" -Directory -Recurse -ErrorAction SilentlyContinue -Depth 2
```

---

## ✅ VERIFICACIÓN FINAL

### Tu clase Tarea.java ya está correcta ✓
Ya tiene todos los métodos necesarios:
- ✅ `getCategoriaId()`
- ✅ `getUsuarioId()`
- ✅ `getFechaVencimiento()`
- ✅ `getNombreUsuario()`

### Lo que falta:
1. ❌ Instalar Tomcat correctamente
2. ✅ Compilar el proyecto (ya lo haces con `mvnw.cmd`)
3. ❌ Desplegar el WAR en la ubicación correcta

---

## 📞 SOPORTE RÁPIDO

**Si sigues con errores:**

1. **Error 500 en dashboard.jsp:**
   - Ya está solucionado, tu clase Tarea tiene todos los métodos

2. **DirectoryNotFoundException:**
   - Usa el script `desplegar_automatico.bat` que creé
   - O instala Tomcat siguiendo OPCIÓN 2

3. **Tomcat no inicia:**
   - Verifica que el puerto 8080 esté libre
   - Ejecuta: `netstat -ano | findstr :8080`
   - Si está ocupado, cambia el puerto en `server.xml`

---

## 🎯 RECOMENDACIÓN FINAL

**Para desarrollo y aprendizaje:**
→ Usa IntelliJ IDEA + Smart Tomcat (OPCIÓN 1)

**Para producción o servidor:**
→ Instala Tomcat manualmente (OPCIÓN 2)

**Para pruebas rápidas:**
→ Usa Maven Tomcat Plugin (OPCIÓN 3)

