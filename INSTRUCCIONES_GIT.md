# Instrucciones para Subir el Proyecto al Repositorio

## Estado Actual
✅ El repositorio Git ha sido inicializado
✅ Todos los archivos han sido agregados (git add .)
⚠️ Necesitas completar los siguientes pasos

## Pasos para Completar la Configuración

### 1. Configurar Git con tu información (solo primera vez)
```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu.email@ejemplo.com"
```

### 2. Crear el commit inicial
```bash
cd C:\Users\sofsh\Desktop\Gestiondetareas\SistemaGestionTareas
git commit -m "Initial commit: Sistema de Gestión de Tareas"
```

### 3. Crear un Repositorio en GitHub/GitLab/Bitbucket

#### Opción A: GitHub
1. Ve a https://github.com/new
2. Crea un nuevo repositorio (ejemplo: `sistema-gestion-tareas`)
3. NO inicialices con README, .gitignore o licencia (ya los tienes)
4. Copia la URL del repositorio (ejemplo: `https://github.com/tu-usuario/sistema-gestion-tareas.git`)

#### Opción B: GitLab
1. Ve a https://gitlab.com/projects/new
2. Crea un nuevo proyecto
3. Copia la URL del repositorio

#### Opción C: Bitbucket
1. Ve a https://bitbucket.org/repo/create
2. Crea un nuevo repositorio
3. Copia la URL del repositorio

### 4. Conectar el Repositorio Remoto
Reemplaza `URL_DEL_REPOSITORIO` con la URL que copiaste:

```bash
cd C:\Users\sofsh\Desktop\Gestiondetareas\SistemaGestionTareas
git remote add origin URL_DEL_REPOSITORIO
```

Ejemplo:
```bash
git remote add origin https://github.com/tu-usuario/sistema-gestion-tareas.git
```

### 5. Cambiar a la Rama Principal (main)
```bash
git branch -M main
```

### 6. Subir el Proyecto al Repositorio
```bash
git push -u origin main
```

Si es tu primera vez, te pedirá autenticación:
- **GitHub**: Usa un Personal Access Token (no tu contraseña)
  - Genera uno en: https://github.com/settings/tokens
  - Selecciona scope: `repo`
- **GitLab/Bitbucket**: Usa tus credenciales normales o token

## Comandos Rápidos (después de configurar)

Una vez configurado todo, para subir cambios futuros:

```bash
cd C:\Users\sofsh\Desktop\Gestiondetareas\SistemaGestionTareas
git add .
git commit -m "Descripción de los cambios"
git push
```

## Verificar el Estado del Repositorio
```bash
git status
git log --oneline
git remote -v
```

## Archivos Importantes del Proyecto

El proyecto incluye:
- ✅ `.gitignore` - Ya configurado para proyectos Java/Maven
- ✅ `pom.xml` - Configuración de Maven
- ✅ Código fuente en `src/`
- ✅ Documentación (varios archivos .md)
- ✅ Scripts SQL de migración

**Nota**: La carpeta `target/` NO se sube al repositorio (está en .gitignore) porque contiene archivos compilados que se generan automáticamente.

## ¿Necesitas Ayuda?

Si encuentras algún error:
1. Verifica que Git esté instalado: `git --version`
2. Verifica tu configuración: `git config --list`
3. Verifica el estado: `git status`
4. Verifica los remotos: `git remote -v`

## Crear un README.md

Es recomendable crear un archivo README.md descriptivo para tu repositorio. Aquí tienes una plantilla básica que puedes usar.

