# 🚀 INSTRUCCIONES RÁPIDAS - Despliegue Manual

## ⚡ PASOS PARA SOLUCIONAR EL ERROR 500

### 1️⃣ Localiza tu Tomcat
Busca en alguna de estas rutas comunes:
- `C:\Program Files\Apache Software Foundation\Tomcat 9.0`
- `C:\apache-tomcat-9.0`
- `C:\tomcat`
- `C:\Program Files\Tomcat`

### 2️⃣ Detén Tomcat (si está corriendo)
**Opción A - Ventana de Tomcat:**
- Si ves una ventana negra de Tomcat, ciérrala

**Opción B - Servicios de Windows:**
- Presiona `Win + R`
- Escribe `services.msc`
- Busca "Apache Tomcat" y haz clic en "Detener"

**Opción C - Línea de comandos:**
```bash
# Ve a la carpeta bin de Tomcat
cd "C:\ruta\a\tu\tomcat\bin"
shutdown.bat
```

### 3️⃣ Elimina la aplicación antigua
Ve a la carpeta `webapps` de Tomcat y elimina:
- ❌ `SistemaGestionTareas.war`
- ❌ Carpeta `SistemaGestionTareas\` (completa)

### 4️⃣ (Opcional) Limpia el caché de trabajo
Ve a la carpeta `work` de Tomcat:
```
[TU_TOMCAT]\work\Catalina\localhost\SistemaGestionTareas
```
Elimina esa carpeta si existe.

### 5️⃣ Copia el nuevo WAR
Copia el archivo:
```
C:\Users\sofsh\Desktop\Gestiondetareas\SistemaGestionTareas\target\SistemaGestionTareas.war
```

Y pégalo en:
```
[TU_TOMCAT]\webapps\
```

### 6️⃣ Inicia Tomcat
**Opción A - Ventana:**
```bash
cd "C:\ruta\a\tu\tomcat\bin"
startup.bat
```

**Opción B - Servicio:**
- Abre `services.msc`
- Busca "Apache Tomcat"
- Haz clic en "Iniciar"

### 7️⃣ Espera y prueba
- ⏱️ Espera 15-30 segundos
- 🌐 Ve a: http://localhost:8080/SistemaGestionTareas/
- 🔄 Limpia caché: `Ctrl + F5`

---

## ✅ ¿Funcionó?

Si ves el dashboard nuevo con las estadísticas: **¡ÉXITO!** 🎉

Si aún hay error 500:
1. Verifica los logs en `[TU_TOMCAT]\logs\catalina.out`
2. Asegúrate de que MySQL está corriendo
3. Verifica que copiaste el WAR correcto (el de `target\`)

---

## 📍 ¿No encuentras Tomcat?

Busca con el explorador de archivos:
1. Abre el explorador
2. En la barra de búsqueda escribe: `startup.bat`
3. La carpeta padre será tu carpeta bin de Tomcat
4. Sube un nivel para llegar a la raíz de Tomcat

---

## 🔧 Comando de Búsqueda Rápida

Ejecuta en PowerShell:
```powershell
Get-ChildItem -Path C:\ -Filter "startup.bat" -Recurse -ErrorAction SilentlyContinue | Select-Object Directory
```

Esto buscará Tomcat en todo el disco C.

---

**Archivo WAR listo en:**
```
C:\Users\sofsh\Desktop\Gestiondetareas\SistemaGestionTareas\target\SistemaGestionTareas.war
```

**Tamaño:** ~5 MB  
**Estado:** ✅ COMPILADO Y LISTO PARA DESPLEGAR

