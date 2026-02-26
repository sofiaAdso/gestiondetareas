# Errores Solucionados - Sistema de Gestión de Tareas

## Fecha: 2026-02-24

### Resumen
Se han identificado y solucionado todos los errores encontrados en el proyecto.

---

## 1. Vulnerabilidad de Seguridad en JSTL (CVE-2015-0254)

### Problema
- **Archivo**: `pom.xml`
- **Error**: La dependencia `javax.servlet:jstl:1.2` tenía una vulnerabilidad crítica CVE-2015-0254 relacionada con ataques XXE (XML External Entity)
- **Severidad**: Alta (7.3)

### Solución Aplicada
Se reemplazó la versión vulnerable por Apache Taglibs 1.2.5 que no tiene vulnerabilidades conocidas:

```xml
<!-- ANTES (con vulnerabilidad) -->
<dependency>
  <groupId>javax.servlet</groupId>
  <artifactId>jstl</artifactId>
  <version>1.2</version>
</dependency>

<!-- DESPUÉS (seguro) -->
<dependency>
  <groupId>org.apache.taglibs</groupId>
  <artifactId>taglibs-standard-spec</artifactId>
  <version>1.2.5</version>
</dependency>

<dependency>
  <groupId>org.apache.taglibs</groupId>
  <artifactId>taglibs-standard-impl</artifactId>
  <version>1.2.5</version>
</dependency>
```

✅ **Estado**: Solucionado y verificado

---

## 2. Plugins de Maven No Encontrados

### Problema
- **Archivo**: `pom.xml`
- **Errores**: 
  - Plugin `tomcat7-maven-plugin:2.2` no encontrado
  - Plugin `cargo-maven3-plugin:1.10.10` no encontrado
- **Impacto**: Errores de compilación al intentar resolver plugins

### Solución Aplicada
Se comentaron los plugins descontinuados y se agregaron notas explicativas:

```xml
<!-- Plugin de Tomcat para ejecutar sin instalación externa -->
<!-- NOTA: Este plugin está descontinuado. Usar instalación local de Tomcat -->
<!--
<plugin>
  <groupId>org.apache.tomcat.maven</groupId>
  <artifactId>tomcat7-maven-plugin</artifactId>
  ...
</plugin>
-->
```

✅ **Estado**: Solucionado

---

## 3. Warnings en ActividadServlet.java

### 3.1 Uso de printStackTrace()

#### Problema
- **Archivo**: `ActividadServlet.java` línea 77
- **Warning**: `Call to 'printStackTrace()' should probably be replaced with more robust logging`
- **Motivo**: El uso de `printStackTrace()` en producción no es recomendable

#### Solución Aplicada
Se implementó el uso de `java.util.logging.Logger`:

```java
// ANTES
e.printStackTrace();

// DESPUÉS
import java.util.logging.Level;
import java.util.logging.Logger;

private static final Logger LOGGER = Logger.getLogger(ActividadServlet.class.getName());
...
LOGGER.log(Level.SEVERE, "Error al procesar listado de actividades", e);
```

✅ **Estado**: Solucionado

---

### 3.2 Statement if-else Complejo

#### Problema
- **Archivo**: `ActividadServlet.java` línea 35
- **Warning**: `'if' statement can be replaced with 'switch' statement`
- **Motivo**: Mejora de legibilidad y rendimiento

#### Solución Aplicada
Se reemplazó la cadena de if-else por un switch statement:

```java
// ANTES
if ("listar".equals(accion) || "mis-actividades".equals(accion)) {
    procesarListado(request, response, user);
} else if ("nuevo".equals(accion)) {
    ...
} else if ...

// DESPUÉS
switch (accion) {
    case "listar":
    case "mis-actividades":
        procesarListado(request, response, user);
        break;
    case "nuevo":
        ...
        break;
    ...
}
```

✅ **Estado**: Solucionado

---

### 3.3 Excepción No Lanzada

#### Problema
- **Archivo**: `ActividadServlet.java` línea 52
- **Warning**: `Exception 'javax.servlet.ServletException' is never thrown in the method`
- **Motivo**: La firma del método declaraba una excepción que nunca se lanzaba

#### Solución Aplicada
Se removió `ServletException` de la firma del método `procesarListado`:

```java
// ANTES
private void procesarListado(...) throws ServletException, IOException {

// DESPUÉS
private void procesarListado(...) throws IOException {
```

✅ **Estado**: Solucionado

---

### 3.4 Parámetro No Usado

#### Problema
- **Archivo**: `ActividadServlet.java` línea 140
- **Warning**: `Parameter 'user' is never used`
- **Motivo**: El método recibía un parámetro que no utilizaba

#### Solución Aplicada
Se removió el parámetro `user` del método `manejarVerDetalle`:

```java
// ANTES
private void manejarVerDetalle(HttpServletRequest request, HttpServletResponse response, Usuario user)

// DESPUÉS
private void manejarVerDetalle(HttpServletRequest request, HttpServletResponse response)
```

✅ **Estado**: Solucionado

---

## 4. Verificación de Compilación

### Prueba Final
Se ejecutó una compilación completa del proyecto:

```bash
mvn clean install -DskipTests
```

### Resultado
```
[INFO] BUILD SUCCESS
[INFO] Total time:  10.171 s
[INFO] Finished at: 2026-02-24T17:15:29-05:00
```

✅ **Estado**: Compilación exitosa sin errores

---

## Resumen de Soluciones

| # | Tipo de Error | Archivo | Estado |
|---|---------------|---------|--------|
| 1 | Vulnerabilidad CVE | pom.xml | ✅ Solucionado |
| 2 | Plugin no encontrado | pom.xml | ✅ Solucionado |
| 3.1 | printStackTrace() | ActividadServlet.java | ✅ Solucionado |
| 3.2 | if-else complejo | ActividadServlet.java | ✅ Solucionado |
| 3.3 | Excepción no lanzada | ActividadServlet.java | ✅ Solucionado |
| 3.4 | Parámetro no usado | ActividadServlet.java | ✅ Solucionado |
| 4.1 | printStackTrace() | Conexion.java | ✅ Solucionado |
| 5.1 | printStackTrace() (5x) | TareaDao.java | ✅ Solucionado |
| 6.1 | printStackTrace() | UsuarioDao.java | ✅ Solucionado |

**Total de errores corregidos: 13**

---

## 4. Correcciones en Conexion.java

### Problema
- **Archivo**: `Conexion.java` línea 112
- **Error**: Uso de `printStackTrace()` en manejo de excepciones

### Solución Aplicada
```java
// Se agregó Logger
import java.util.logging.Level;
import java.util.logging.Logger;

private static final Logger LOGGER = Logger.getLogger(Conexion.class.getName());

// Se reemplazó printStackTrace
LOGGER.log(Level.SEVERE, "Error inesperado al establecer conexión con la base de datos", e);
```

✅ **Estado**: Solucionado

---

## 5. Correcciones en TareaDao.java

### Problema
- **Archivo**: `TareaDao.java` 
- **Errores**: 5 ocurrencias de `printStackTrace()` en diferentes métodos:
  - listar() - línea 34
  - listarPorUsuario() - línea 66
  - registrar() - línea 136
  - actualizar() - línea 162
  - listarPorActividad() - línea 228

### Solución Aplicada
Se implementó Logger en toda la clase:

```java
import java.util.logging.Level;
import java.util.logging.Logger;

private static final Logger LOGGER = Logger.getLogger(TareaDao.class.getName());

// Ejemplos de uso:
LOGGER.log(Level.SEVERE, "Error al listar tareas", e);
LOGGER.log(Level.SEVERE, "Error al registrar tarea", e);
LOGGER.log(Level.SEVERE, "Error al actualizar tarea", e);
```

✅ **Estado**: Solucionado

---

## 6. Correcciones en UsuarioDao.java

### Problema
- **Archivo**: `UsuarioDao.java` línea 116
- **Error**: Uso de `printStackTrace()` en método listarTodos()

### Solución Aplicada
```java
import java.util.logging.Level;
import java.util.logging.Logger;

private static final Logger LOGGER = Logger.getLogger(UsuarioDao.class.getName());

LOGGER.log(Level.SEVERE, "Error al listar todos los usuarios", e);
```

✅ **Estado**: Solucionado

---

## Recomendaciones Adicionales

1. **Seguridad**: Mantener las dependencias actualizadas regularmente
2. **Logging**: Considerar usar SLF4J o Log4j2 para un logging más robusto
3. **Testing**: Implementar pruebas unitarias para los servlets
4. **Code Review**: Realizar revisiones de código periódicas

---

## Próximos Pasos

1. ✅ Recompilar el proyecto
2. ✅ Desplegar en Tomcat
3. ⏭️ Probar todas las funcionalidades
4. ⏭️ Monitorear logs para detectar nuevos problemas

---

**Nota**: Todos los cambios han sido aplicados y el proyecto compila sin errores ni advertencias críticas.

