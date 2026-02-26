# Sistema de Gestión de Tareas

Sistema web para la gestión integral de tareas y actividades, desarrollado con Java, JSP y MySQL.

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
- **Base de Datos**: MySQL
- **Servidor**: Apache Tomcat
- **Build Tool**: Maven
- **IDE**: IntelliJ IDEA / Eclipse

## 📦 Requisitos Previos

- Java JDK 8 o superior
- Apache Tomcat 9.x o superior
- MySQL 5.7 o superior
- Maven 3.6 o superior

## 🚀 Instalación

### 1. Clonar el Repositorio
```bash
git clone https://github.com/tu-usuario/sistema-gestion-tareas.git
cd sistema-gestion-tareas
```

### 2. Configurar la Base de Datos

1. Crear la base de datos:
```sql
CREATE DATABASE gestion_tareas;
USE gestion_tareas;
```

2. Ejecutar los scripts SQL en orden:
   - `crear_tabla_actividades.sql`
   - `crear_tabla_subtareas.sql`
   - `agregar_borrado_logico.sql`
   - Otros scripts según necesidad

### 3. Configurar la Conexión

Editar el archivo de configuración de base de datos en:
```
src/main/java/com/sena/gestion/repository/Conexion.java
```

Actualizar las credenciales:
```java
private static final String URL = "jdbc:mysql://localhost:3306/gestion_tareas";
private static final String USER = "tu_usuario";
private static final String PASSWORD = "tu_contraseña";
```

### 4. Compilar el Proyecto

```bash
mvn clean install
```

### 5. Desplegar en Tomcat

#### Opción A: Manual
1. Copiar el archivo `target/SistemaGestionTareas.war` a la carpeta `webapps` de Tomcat
2. Iniciar Tomcat
3. Acceder a `http://localhost:8080/SistemaGestionTareas`

#### Opción B: Script
```bash
compilar_desplegar.bat
```

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

