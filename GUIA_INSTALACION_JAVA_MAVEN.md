# 🔧 GUÍA DE INSTALACIÓN - Java y Maven

## ⚠️ Problema Detectado

Tu sistema necesita **Java** y **Maven** para compilar y ejecutar el proyecto de Sistema de Gestión de Tareas.

## 📦 Opción 1: Instalación Manual (Recomendada)

### Paso 1: Instalar Java JDK

1. Ve a: https://www.oracle.com/java/technologies/downloads/
2. Descarga **Java JDK 11** o **Java JDK 17** (versión para Windows)
3. Ejecuta el instalador
4. Anota la ruta de instalación (ejemplo: `C:\Program Files\Java\jdk-17`)

#### Configurar JAVA_HOME:
1. Presiona `Win + X` → **Sistema**
2. Haz clic en **Configuración avanzada del sistema**
3. Clic en **Variables de entorno**
4. En "Variables del sistema", haz clic en **Nueva**:
   - Nombre: `JAVA_HOME`
   - Valor: `C:\Program Files\Java\jdk-17` (tu ruta de instalación)
5. Busca la variable `Path`, selecciónala y haz clic en **Editar**
6. Agrega una nueva entrada: `%JAVA_HOME%\bin`
7. Haz clic en **Aceptar** en todas las ventanas

#### Verificar:
```powershell
java -version
```

### Paso 2: Instalar Maven

1. Ve a: https://maven.apache.org/download.cgi
2. Descarga el archivo **Binary zip archive** (apache-maven-3.9.x-bin.zip)
3. Extrae el ZIP en `C:\Program Files\Apache\maven`

#### Configurar Maven:
1. Presiona `Win + X` → **Sistema**
2. Haz clic en **Configuración avanzada del sistema**
3. Clic en **Variables de entorno**
4. En "Variables del sistema", haz clic en **Nueva**:
   - Nombre: `M2_HOME`
   - Valor: `C:\Program Files\Apache\maven` (tu ruta de extracción)
5. Busca la variable `Path`, selecciónala y haz clic en **Editar**
6. Agrega una nueva entrada: `%M2_HOME%\bin`
7. Haz clic en **Aceptar** en todas las ventanas

#### Verificar:
```powershell
mvn -version
```

---

## 🚀 Opción 2: Instalación Rápida con Chocolatey

Si tienes Chocolatey instalado (gestor de paquetes para Windows):

```powershell
# Instalar Chocolatey primero (en PowerShell como Administrador):
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Luego instalar Java y Maven:
choco install openjdk11 -y
choco install maven -y

# Reinicia PowerShell y verifica:
java -version
mvn -version
```

---

## 🎯 Después de Instalar

### Reinicia PowerShell
Cierra todas las ventanas de PowerShell y abre una nueva.

### Verifica las Instalaciones
```powershell
java -version
mvn -version
```

### Compila el Proyecto
```powershell
cd C:\Users\sofsh\Desktop\Gestiondetareas\SistemaGestionTareas
mvn clean package
```

### O Usa los Scripts Batch
```powershell
.\compilar_desplegar.bat
```

---

## 🆘 Alternativa: Usar IntelliJ IDEA

Si usas IntelliJ IDEA:

1. **Archivo** → **Project Structure** → **SDKs**
2. Haz clic en **+** → **Download JDK**
3. Selecciona una versión (Oracle OpenJDK 17)
4. IntelliJ descargará e instalará Java automáticamente
5. Para Maven, IntelliJ trae uno integrado (bundled)

---

## 📝 Notas Importantes

- **Java JDK 11 o 17** son las versiones más estables para proyectos Java EE
- **Maven 3.8.x o superior** es la versión recomendada
- Después de instalar, **debes reiniciar PowerShell** para que las variables de entorno surtan efecto
- Si usas CMD en lugar de PowerShell, también funcionará

---

## ✅ Verificación Final

Después de instalar todo, ejecuta estos comandos:

```powershell
# Verificar Java
java -version
# Deberías ver algo como: java version "17.0.x" o "11.0.x"

# Verificar Maven
mvn -version
# Deberías ver: Apache Maven 3.x.x

# Compilar el proyecto
cd C:\Users\sofsh\Desktop\Gestiondetareas\SistemaGestionTareas
mvn clean compile
```

Si todo funciona correctamente, verás: `BUILD SUCCESS`

---

## 🔗 Enlaces Útiles

- Java JDK: https://www.oracle.com/java/technologies/downloads/
- Maven: https://maven.apache.org/download.cgi
- Chocolatey: https://chocolatey.org/install
- Tutorial Variables de Entorno: https://www.java.com/es/download/help/path_es.html

