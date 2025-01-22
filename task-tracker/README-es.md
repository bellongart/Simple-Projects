# Task Tracker

Este es un proyecto simple de [Rastreador de Tareas](https://roadmap.sh/projects/task-tracker)

Este es un proyecto que he realizado para refrescar mis conocimientos. También es una afición entretenida.

## Requisitos

- Solo Lua 5.4.

## Ejemplo de Estructura JSON

```json
{
  "tasks": {
    "id_task": {
      "id": "1",
      "description": "descripción de la tarea",
      "status": "por hacer",
      "create_at": "2025-01-21 19:58",
      "update_at": "-"
    },
    "id_task": {
      "id": "2",
      "description": "descripción de la tarea",
      "status": "en progreso",
      "create_at": "2025-01-21 19:58",
      "update_at": "2025-01-21 19:59"
    }
  }
}
```

## Uso

Puedes ejecutar `task-cli` para ver cómo se usa.

## Hoja de Ruta

- [ ] Formato de salida mejorado.
- [ ] Agregar color al estado.
- [ ] Devolver un fallo con `pcall` cuando el JSON no tiene un formato válido.
- [ ] Devolver la lista de tareas en orden.
