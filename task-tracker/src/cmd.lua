-- cmd-lua

local access = require("src.access")
require('src.common')
local cmd = {}


local buffer            = ''

--- Help
local help              = [[
Usage:
  task-cli [option] <id> [value]

Options:
  - add: add a new task.
  - delete: delete a exists task. Id is required.
  - update: update description to exists task. Id is required.
  - mark-todo: mark a task as to do.
  - mark-in-progress: mark a task as in progress.
  - mark-done: mark a task as done.
  - list:
      - done.
      - in-progress.
      - todo.

Examples:
  - task-cli add "This a new task"
  - task-cli delete 1
  - task-cli update 1 "New description"
  - task-cli mark-done 1
  - task-cli list
  - task-cli list done
]]

local detail_task       = [[

---
Id: %s
Status: %s
Description: %s
Created at: %s
Last Update: %s
---
]]

local list_tasks_header = [[

| -- | -------------------- | --------- | ------------- | ------------- |
| Id | Description          |   Status  |   Created at  |   Update at   |
]]

local list_tasks        = [[
| %s | %s | %s | %s | %s |
]]


--- Cmd options
local options = {
  ['add']              = 'add',
  ['update']           = 'update',
  ['delete']           = 'delete',
  ['mark-todo']        = 'todo',
  ['mark-done']        = 'done',
  ['mark-in-progress'] = 'in-progress',
  ['list']             = 'list'
}


local function is_valid_option(option)
  return options[option] and true or false
end


local function print_task(id_task)
  local task = access.get_task(id_task)

  buffer = buffer .. (detail_task):format(
    task['id'], task['status'], task['description'], task['created_at'],
    task['updated_at']
  )
end

function cmd.init(...)
  local args = ...
  local ok
  local success = is_valid_option(args[1])
  if not success then
    buffer = help
    return
  end

  if args[1] == 'add' then
    ok, buffer = access.create_task(args[2])
  elseif args[1] == 'delete' then
    ok, buffer = access.delete_task(args[2])
  elseif args[1] == 'update' then
    ok, buffer = access.update_task(args[2], args[3])
  elseif args[1] == 'mark-todo' then
    ok, buffer = access.update_status(args[2], 1)
  elseif args[1] == 'mark-in-progress' then
    ok, buffer = access.update_status(args[2], 2)
  elseif args[1] == 'mark-done' then
    ok, buffer = access.update_status(args[2], 3)
  elseif args[1] == 'list' then
    local tasks = access.get_tasks(args[2])
    buffer = buffer .. list_tasks_header
    for index, value in pairs(tasks) do
      buffer = buffer .. (list_tasks):format(
        value['id'], value['description'], value['status'],
        value['created_at'], value['updated_at']
      )
      -- buffer = buffer .. (detail_task):format(
      --   value['id'], value['status'], value['description'], value['created_at'],
      --   value['updated_at']
      -- )
    end
  end

  if ok then
    print_task(tonumber(args[2]) or access.get_last_task())
  end
end

function cmd.render()
  -- print("\027[31mTexto en rojo\027[0m")
  print(buffer)
  return true
end

return cmd
