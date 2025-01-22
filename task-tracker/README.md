# Task Tracker

This is a simple project from [Task Tracker](https://roadmap.sh/projects/task-tracker)

This is a project I have done to refresh my knowledge. It is also an entertaining hobby.

## Requeriments

- Lua 5.4 only.

## Json Struct Example

```json
{
  "tasks": {
    "id_task": {
      "id": "1",
      "description": "task description",
      "status": "todo",
      "create_at": "2025-01-21 19:58",
      "update_at": "-"
    },
    "id_task": {
      "id": "2",
      "description": "task description",
      "status": "in-progress",
      "create_at": "2025-01-21 19:58",
      "update_at": "2025-01-21 19:59"
    }
  }
}
```

## Usage

You can run `task-cli` to see how usage this.

## RoadMap

- [ ] Beauty Format to output.
- [ ] Add color to status.
- [ ] Return fail with pcall when json is no valid format.
- [ ] Return list task in order.
