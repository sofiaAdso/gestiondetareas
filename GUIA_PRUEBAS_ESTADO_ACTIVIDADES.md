# 🧪 GUÍA DE PRUEBAS RÁPIDAS - Control de Estado en Actividades

## ✅ Lista de Verificación (Checklist)

### 🔐 Pruebas como ADMINISTRADOR

#### Crear Nueva Actividad
- [ ] Login como administrador
- [ ] Ir a "Actividades" → "Nueva Actividad"
- [ ] Llenar el formulario
- [ ] **VERIFICAR**: El campo "Estado" aparece como solo lectura (fondo gris)
- [ ] **VERIFICAR**: Muestra "En Progreso" por defecto
- [ ] **VERIFICAR**: Aparece mensaje: "Solo los usuarios asignados pueden modificar el estado"
- [ ] Guardar actividad
- [ ] **RESULTADO ESPERADO**: ✅ Actividad creada con estado "En Progreso"

#### Editar Actividad Existente
- [ ] Ir al listado de actividades
- [ ] Clic en "Editar" (ícono de lápiz) en cualquier actividad
- [ ] **VERIFICAR**: El campo "Estado" está deshabilitado (no se puede cambiar)
- [ ] **VERIFICAR**: Muestra el estado actual de la actividad
- [ ] Intentar cambiar otros campos (título, fechas, etc.)
- [ ] Guardar cambios
- [ ] **RESULTADO ESPERADO**: ✅ Cambios guardados, estado permanece igual

#### Intentar Modificar Estado (Prueba de Seguridad)
- [ ] Abrir herramientas de desarrollador (F12)
- [ ] En "Editar Actividad", inspeccionar el campo Estado
- [ ] Intentar cambiar el atributo `readonly` o el valor del campo
- [ ] Guardar el formulario
- [ ] **RESULTADO ESPERADO**: ✅ El backend ignora el cambio, mantiene estado original

---

### 👤 Pruebas como USUARIO

#### Crear Nueva Actividad
- [ ] Login como usuario normal (no admin)
- [ ] Ir a "Actividades" → "Nueva Actividad"
- [ ] Llenar el formulario
- [ ] **VERIFICAR**: El campo "Estado" es un selector (dropdown) editable
- [ ] **VERIFICAR**: Opciones disponibles: Planificada, En Progreso, Pausada, Completada
- [ ] Seleccionar un estado específico (ej: "Planificada")
- [ ] Guardar actividad
- [ ] **RESULTADO ESPERADO**: ✅ Actividad creada con el estado seleccionado

#### Editar y Cambiar Estado
- [ ] Ir al listado de actividades
- [ ] Clic en "Editar" en una actividad propia
- [ ] **VERIFICAR**: El campo "Estado" es un selector editable
- [ ] Cambiar el estado (ej: de "En Progreso" a "Completada")
- [ ] Guardar cambios
- [ ] Volver al listado
- [ ] **RESULTADO ESPERADO**: ✅ El estado se actualizó correctamente en la lista

#### Cambiar Estado Múltiples Veces
- [ ] Editar una actividad
- [ ] Cambiar estado a "Pausada"
- [ ] Guardar
- [ ] Editar nuevamente
- [ ] Cambiar estado a "En Progreso"
- [ ] Guardar
- [ ] Editar nuevamente
- [ ] Cambiar estado a "Completada"
- [ ] Guardar
- [ ] **RESULTADO ESPERADO**: ✅ Todos los cambios se guardan correctamente

---

### 📅 Pruebas de Validación de Fechas (Ambos Roles)

#### Fecha de Inicio No Puede Ser Pasada
- [ ] Ir a "Nueva Actividad"
- [ ] Clic en el campo "Fecha Inicio"
- [ ] **VERIFICAR**: Los días anteriores a hoy están deshabilitados en el calendario
- [ ] Intentar escribir manualmente una fecha pasada (ej: 2026-01-01)
- [ ] Pasar al siguiente campo
- [ ] **RESULTADO ESPERADO**: ⚠️ Alerta SweetAlert: "La fecha de inicio no puede ser anterior al día actual"

#### Fecha Final Debe Ser Mayor
- [ ] Seleccionar Fecha Inicio: 2026-03-01
- [ ] Seleccionar Fecha Fin: 2026-03-01 (mismo día)
- [ ] **RESULTADO ESPERADO**: ⚠️ Alerta: "La fecha de fin debe ser posterior a la fecha de inicio"
- [ ] Campo se limpia automáticamente

#### Fecha Final Automática
- [ ] Seleccionar Fecha Inicio: 2026-03-01
- [ ] Clic en campo "Fecha Fin"
- [ ] **VERIFICAR**: El calendario solo permite seleccionar desde 2026-03-02 en adelante
- [ ] Seleccionar Fecha Fin: 2026-03-10
- [ ] **RESULTADO ESPERADO**: ✅ Ambas fechas válidas

#### Cambiar Fecha de Inicio Después
- [ ] Fecha Inicio: 2026-03-01, Fecha Fin: 2026-03-10
- [ ] Cambiar Fecha Inicio a: 2026-03-15 (después de la fecha fin)
- [ ] **RESULTADO ESPERADO**: ⚠️ Alerta de error, campo Fecha Fin se limpia

---

### 🎨 Pruebas Visuales

#### Estilos del Formulario
- [ ] **Campo Estado (Admin)**: Fondo gris (#f0f0f0), borde morado, cursor "not-allowed"
- [ ] **Campo Estado (Usuario)**: Selector normal, borde morado al hacer focus
- [ ] **Mensaje Informativo**: Icono ℹ️, color gris #666
- [ ] **Alertas**: SweetAlert2 con colores bonitos y animaciones

#### Responsive Design
- [ ] Probar en pantalla completa
- [ ] Probar en ventana pequeña
- [ ] **VERIFICAR**: Formulario se adapta correctamente

---

### 🔄 Pruebas de Integración

#### Flujo Completo: Admin Crea, Usuario Actualiza
1. [ ] **Admin**: Crear actividad "Proyecto X" (estado: "En Progreso")
2. [ ] **Admin**: Asignar a usuario "juan"
3. [ ] **Usuario juan**: Login
4. [ ] **Usuario juan**: Ver "Proyecto X" en su lista
5. [ ] **Usuario juan**: Editar "Proyecto X"
6. [ ] **Usuario juan**: Cambiar estado a "Completada"
7. [ ] **Admin**: Verificar que el estado cambió a "Completada"
8. [ ] **Admin**: Intentar cambiar estado (debe estar bloqueado)
9. [ ] **RESULTADO ESPERADO**: ✅ Admin puede ver pero no modificar

#### Flujo con Tareas
1. [ ] Crear actividad con estado "Planificada"
2. [ ] Crear 3 tareas dentro de esa actividad
3. [ ] Cambiar estado de actividad a "En Progreso"
4. [ ] Completar las 3 tareas
5. [ ] Cambiar estado de actividad a "Completada"
6. [ ] **VERIFICAR**: Progreso 100%, todas las tareas completadas

---

### ⚠️ Pruebas de Casos Extremos

#### Editar en Modo Edición (Fechas Pasadas)
- [ ] Crear actividad con fecha inicio: hoy
- [ ] Esperar 1 día
- [ ] Editar la actividad
- [ ] **VERIFICAR**: Fecha de inicio pasada se mantiene (no se limpia)
- [ ] **RESULTADO ESPERADO**: ✅ Permite mantener fechas pasadas en edición

#### Formulario con Errores
- [ ] Llenar formulario incompleto (sin título)
- [ ] Intentar guardar
- [ ] **RESULTADO ESPERADO**: ⚠️ Mensaje de error claro
- [ ] Completar título
- [ ] Dejar fechas vacías
- [ ] Intentar guardar
- [ ] **RESULTADO ESPERADO**: ⚠️ Error: "Las fechas de inicio y fin son obligatorias"

#### Múltiples Usuarios Editando
- [ ] Usuario A: Abrir actividad en edición
- [ ] Usuario B: Editar la misma actividad
- [ ] Usuario B: Cambiar estado a "Completada" y guardar
- [ ] Usuario A: Intentar guardar sus cambios
- [ ] **RESULTADO ESPERADO**: ✅ Último cambio prevalece

---

## 📊 Resumen de Resultados

### Pruebas Pasadas: ____ / ____
### Pruebas Fallidas: ____ / ____

### Errores Encontrados:
```
1. _____________________________________
2. _____________________________________
3. _____________________________________
```

### Observaciones:
```
__________________________________________
__________________________________________
__________________________________________
```

---

## 🎯 Criterios de Aceptación

Para considerar la implementación exitosa, TODAS estas condiciones deben cumplirse:

✅ **Funcionalidad Core:**
- [ ] Admin NO puede cambiar estado en actividades
- [ ] Admin PUEDE ver el estado actual
- [ ] Usuario SÍ puede cambiar estado libremente
- [ ] Los cambios de estado se guardan correctamente

✅ **Validaciones:**
- [ ] Fecha inicio >= hoy (en creación)
- [ ] Fecha fin > fecha inicio
- [ ] Mensajes de error claros

✅ **Seguridad:**
- [ ] Validación en frontend (UI)
- [ ] Validación en backend (Servlet)
- [ ] No hay bypass posible con inspector

✅ **Experiencia de Usuario:**
- [ ] Mensajes informativos claros
- [ ] Alertas bonitas (SweetAlert2)
- [ ] Formularios intuitivos

✅ **Sin Regresiones:**
- [ ] Crear actividades funciona
- [ ] Editar actividades funciona
- [ ] Listar actividades funciona
- [ ] Crear tareas funciona
- [ ] Todo lo demás sigue funcionando

---

## 🚀 ¿Todo Funciona?

Si todas las pruebas pasaron:
```
✅ ¡IMPLEMENTACIÓN EXITOSA!
🎉 Lista para producción
📦 Puedes desplegar con confianza
```

Si hay problemas:
```
⚠️ Revisar los errores encontrados
🔧 Ajustar según sea necesario
🧪 Re-ejecutar las pruebas
```

---

**Fecha de Pruebas**: _________________
**Testeador**: _________________
**Versión**: 1.0.0
**Estado Final**: ☐ APROBADO  ☐ REQUIERE AJUSTES

