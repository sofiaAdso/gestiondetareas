# Sistema de Gestión de Tareas

Sistema web para la gestión integral de tareas y actividades, desarrollado con Java, JSP y PostgreSQL.

## 📋 Descripción

Sistema de gestión de tareas empresarial que permite a los usuarios crear, organizar y dar seguimiento a sus tareas y actividades diarias. Incluye funcionalidades de categorización, priorización, reportes y gestión de subtareas.

## ✨ Características Principales

- 🔐 **Autenticación de Usuarios**: Sistema de login y registro seguro
- 📝 **Gestión de Tareas**: Crear, editar, eliminar y listar tareas
- 🎯 **Gestión de Actividades**: Módulo completo para actividades con subtareas
- 📊 **Categorías**: Organización de tareas por categorías personalizadas
- 🔄 **Estados**: Seguimiento del progreso (Pendiente, En Proceso, Completada)
- ⚡ **Prioridades**: Clasificación por nivel de prioridad (Baja, Media, Alta)
- 📈 **Reportes**: Generación de reportes y estadísticas
- 🗂️ **Subtareas**: Desglose de actividades en subtareas
- 🔍 **Borrado Lógico**: Recuperación de tareas eliminadas
- 📌 **Tareas Ancladas**: Destacar tareas importantes

## 🛠️ Tecnologías Utilizadas

- **Backend**: Java (Servlets, JSP)
- **Frontend**: HTML5, CSS3, JavaScript
- **Base de Datos**: PostgreSQL 12+
- **Servidor**: Apache Tomcat 9.x
- **Build Tool**: Maven 3.6+
- **IDE**: IntelliJ IDEA / Eclipse

## 📦 Requisitos Previos

- Java JDK 17
- Apache Tomcat 9.0.115 o superior
- PostgreSQL 12 o superior
- Maven 3.6 o superior

## 🚀 Instalación

### 1. Clonar el Repositorio
```bash
git clone https://github.com/tu-usuario/sistema-gestion-tareas.git
cd sistema-gestion-tareas
```

### 2. Configurar la Base de Datos PostgreSQL

#### Opción A: Usando pgAdmin (GUI)
1. Abre pgAdmin
2. Conéctate con tu usuario de PostgreSQL
3. Crea una base de datos llamada `Gestiondetareas`
4. Ejecuta el script SQL desde: `src/main/resources/sql/crear-actividades.sql`

#### Opción B: Usando psql (Línea de comandos)
```bash
# Crear la base de datos
createdb -U postgres Gestiondetareas

# Ejecutar los scripts SQL
psql -U postgres -d Gestiondetareas -f src/main/resources/sql/crear-actividades.sql
```

#### Opción C: Ejecutar el script de instalación (Windows)
```bash
crear-tabla-actividades.bat
```

### 3. Verificar la Conexión

Editar el archivo de configuración en:
```
src/main/java/com/sena/gestion/repository/Conexion.java
```

Verificar que los datos sean correctos:
```java
private static final String DB_URL = "jdbc:postgresql://localhost:5432/Gestiondetareas";
private static final String DB_USER = "postgres";
private static final String DB_PASSWORD = "Mia1924.";
```

### 4. Compilar el Proyecto

```bash
mvn clean package
```

### 5. Desplegar en Tomcat

#### Opción A: Usando el script (Windows)
```bash
start-tomcat.bat
```

#### Opción B: Manual
1. Copiar `target/SistemaGestionTareas.war` a `apache-tomcat-9.0.115/webapps/`
2. Iniciar Tomcat desde `apache-tomcat-9.0.115/bin/startup.bat`
3. Acceder a `http://localhost:8080/SistemaGestionTareas`

## 📁 Estructura del Proyecto

```
SistemaGestionTareas/
├── src/
│   ├── main/
│   │   ├── java/com/sena/gestion/
│   │   │   ├── controller/     # Servlets
│   │   │   ├── model/          # Modelos de datos
│   │   │   ├── repository/     # DAO y conexión BD
│   │   │   └── service/        # Lógica de negocio
│   │   ├── resources/
│   │   │   └── application.properties
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       ├── css/
│   │       ├── js/
│   │       └── *.jsp           # Vistas
├── pom.xml                     # Configuración Maven
├── *.sql                       # Scripts de base de datos
└── *.md                        # Documentación

```

## 🎯 Uso

### Crear una Nueva Actividad

1. **Inicia sesión** con tu cuenta de administrador
2. **Navega a**: Módulo de Actividades → Nueva Actividad
3. **Completa el formulario**:
   - **Título**: Nombre descriptivo de la actividad
   - **Descripción**: Detalles y propósito
   - **Instructor/Usuario**: Persona responsable
   - **Prioridad**: Baja / Media / Alta
   - **Fecha de Inicio**: Cuándo comienza
   - **Fecha de Vencimiento**: Cuándo vence

4. **Haz clic en "Crear"**

Para más detalles, consulta: [GUIA-CREAR-ACTIVIDADES.md](GUIA-CREAR-ACTIVIDADES.md)

### Registro de Usuario
1. Acceder a la página principal
2. Hacer clic en "Registrarse"
3. Completar el formulario con los datos requeridos

### Gestión de Tareas
1. Iniciar sesión con tus credenciales
2. Desde el dashboard, seleccionar "Tareas"
3. Crear, editar o eliminar tareas según necesidad
4. Asignar categorías y prioridades

### Generación de Reportes
1. Navegar a la sección "Reportes"
2. Seleccionar el tipo de reporte deseado
3. Visualizar estadísticas y métricas

## 📚 Documentación Adicional

- [Guía de Actividades](GUIA_ACTIVIDADES.md)
- [Guía de Migración](GUIA_MIGRACION_FINAL.md)
- [Implementación de Tareas Ancladas](IMPLEMENTACION_TAREAS_ANCLADAS.md)
- [Instrucciones de Subtareas](INSTRUCCIONES_SUBTAREAS.md)
- [Inicio Rápido](INICIO_RAPIDO.md)

## 🔧 Scripts de Utilidad

- `compilar_desplegar.bat`: Compila y despliega automáticamente
- `instalar_actividades.bat`: Instala el módulo de actividades
- `instalar_subtareas.bat`: Instala el módulo de subtareas
- `ejecutar_migracion_final.bat`: Ejecuta la migración de datos

## 🐛 Solución de Problemas

Consultar los siguientes archivos para resolver problemas comunes:
- [Solución de Problemas Actividades](GUIA_SOLUCION_PROBLEMAS_ACTIVIDADES.md)
- [Solución Rápida](SOLUCION_RAPIDA.md)
- [Solución Crear Actividades](SOLUCION_CREAR_ACTIVIDADES.md)

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:
1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -m 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia [Especificar Licencia]

## 👥 Autores

- [Tu Nombre] - Desarrollo inicial

## 🙏 Agradecimientos

- SENA - Por el apoyo en el desarrollo del proyecto
- [Otros agradecimientos]

## 📞 Contacto

Para preguntas o sugerencias:
- Email: [tu-email@ejemplo.com]
- GitHub: [@tu-usuario]

---

⭐ Si este proyecto te ha sido útil, considera darle una estrella en GitHub

