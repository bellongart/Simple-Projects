-- Here are all common variables

TASK_FILE = 'tasks.json'
DATE_FORMAT = '%Y-%m-%d %H:%M:%S'
TEMPLATE = ([[
{
  "tasks": {
    "1": {
      "id": "1",
      "description": "This a template to tasks json file db",
      "status": "done",
      "created_at": "%s",
      "updated_at": "-"
    }
  }
}
]]):format(os.date(DATE_FORMAT))

TASKS_STATUS = {
  ['1'] = 'todo',
  ['2'] = 'in-progress',
  ['3'] = 'done'
}
ERROR_CODES = {
  ['0'] = 'Successful',
  ['1'] = 'A description is required',
  ['2'] = 'Can\'t write json file',
  ['3'] = 'The id_task is required',
  ['4'] = 'Task not exists',
  ['5'] = 'id_task should be a number'
}
