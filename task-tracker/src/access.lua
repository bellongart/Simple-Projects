-- access.lua

local json = require("src.vendor.json2")

local access = {}

--- Check if a json file exists
--- @see https://stackoverflow.com/questions/4990990/check-if-a-file-exists-with-lua
--- @return boolean True if exists
local function file_exists()
  local file = false
  local f = io.open(TASK_FILE, "r")
  if f ~= nil then
    io.close(f)
    file = true
  end
  return file
end

--- Write a data in json file
--- @see https://www.family-historian.co.uk/help/fh7-plugins/lua/readingandwritingfiles.html
--- @param data string
--- @return boolean
local function write_file(data)
  local file = io.open(TASK_FILE, "w")
  if file == nil then
    return false
  end
  file:write(data)
  file:close()
  return true
end

--- Read file json
--- @see https://stackoverflow.com/questions/11201262/how-to-read-data-from-a-file-in-lua
--- @return string|table
local function read_file()
  if not file_exists() then
    write_file(TEMPLATE)
  end
  local lines = {}
  for line in io.lines(TASK_FILE) do
    lines[#lines + 1] = line
  end
  return table.concat(lines, "\n")
end

--- Get quantity of elements in a table
--- @see https://stackoverflow.com/questions/2705793/how-to-get-number-of-entries-in-a-lua-table
--- @param T table
--- @return integer Quanatity of elements
local function table_len(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

--- Convert a lua table into a lua syntactically correct string
--- @see https://gist.github.com/justnom/9816256
--- @param tbl table
--- @return string|unknown
local function table_to_string(tbl)
  local result = "{"
  for k, v in pairs(tbl) do
    -- Check the key type (ignore any numerical keys - assume its an array)
    if type(k) == "string" then
      result = result .. "[\"" .. k .. "\"]" .. "="
    end

    -- Check the value type
    if type(v) == "table" then
      result = result .. table_to_string(v)
    elseif type(v) == "boolean" then
      result = result .. tostring(v)
    else
      result = result .. "\"" .. v .. "\""
    end
    result = result .. ","
  end
  -- Remove leading commas from the result
  if result ~= "" then
    result = result:sub(1, result:len() - 1)
  end
  return result .. "}"
end


--- Create a new task
--- @param description string Description of the task
--- @return boolean Status
--- @return string Error status
function access.create_task(description)
  if not description then
    return false, ERROR_CODES['1'] -- 'A description is required'
  end
  local data = json.decode(read_file())
  if type(data) == 'table' then
    local last_task = table_len(data['tasks'])
    data['tasks'][tostring(last_task + 1)] = {
      id          = tostring(last_task + 1),
      description = description,
      status      = "todo", -- inital value for a new task
      created_at  = os.date(DATE_FORMAT),
      updated_at  = '-'
    }
    write_file(json.encode(data))
  end
  return true, ERROR_CODES['0'] -- 'Successful'
end

--- Delete a task
--- @param id_task integer|string Task id
--- @return boolean Status
--- @return string Error status
function access.delete_task(id_task)
  -- @TODO AQUÍ UN PCALL POR SI EL JSON NO ES VÁLIDO
  local data = json.decode(read_file())

  if not id_task then
    return false, ERROR_CODES['3'] -- 'The id_task is required'
  end
  if not tonumber(id_task) then
    return false, ERROR_CODES['5'] -- 'id_task should be a number'
  end
  if not data['tasks'][tostring(id_task)] then
    return false, ERROR_CODES['4']
  end

  local new_table = {}

  -- new_table = table.remove(data['tasks'], id_task)
  data['tasks'][tostring(id_task)] = nil
  -- print(util.print_r(data))
  write_file(json.encode(data))
  return true, ERROR_CODES['0'] -- 'Successful'
end

--- Update a task description
--- @param id_task integer|string Task id
--- @param new_description string New description
--- @return boolean Status
--- @return string Error status
function access.update_task(id_task, new_description)
  local data = json.decode(read_file())

  if not id_task then
    return false, ERROR_CODES['3'] -- 'The id_task is required'
  end
  if not tonumber(id_task) then
    return false, ERROR_CODES['5'] -- 'id_task should be a number'
  end
  if not data['tasks'][tostring(id_task)] then
    return false, ERROR_CODES['4']
  end


  -- Update properties of the task
  data['tasks'][tostring(id_task)]['description'] = new_description
  data['tasks'][tostring(id_task)]['updated_at']  = os.date(DATE_FORMAT)


  -- overwrite the json
  local ok = write_file(json.encode(data))
  if ok == false then
    return false, ERROR_CODES['2']
  end

  return true, ERROR_CODES['0']
end

--- Update a task status
--- @param id_task integer|string Task id
--- @param task_status integer|string New status
--- @return boolean Status
--- @return string Error status
function access.update_status(id_task, task_status)
  local data = json.decode(read_file())

  if not id_task then
    return false, ERROR_CODES['3'] -- 'The id_task is required'
  end
  if not tonumber(id_task) then
    return false, ERROR_CODES['5'] -- 'id_task should be a number'
  end
  if not data['tasks'][tostring(id_task)] then
    return false, ERROR_CODES['4']
  end

  -- Update properties of the task
  data['tasks'][tostring(id_task)]['status']     = TASKS_STATUS[tostring(task_status)]
  data['tasks'][tostring(id_task)]['updated_at'] = os.date(DATE_FORMAT)


  -- overwrite the json
  local ok = write_file(json.encode(data))
  if ok == false then
    return false, ERROR_CODES['2']
  end

  return true, ERROR_CODES['0']
end

--- Return all tasks in a table
--- @param flag string Tasks status to filter
--- @return table Tasks
--- @return string Error status
function access.get_tasks(flag)
  local data = json.decode(read_file())
  local status = flag or nil
  local tasks = {}

  -- print(util.print_r(data))

  for index, value in pairs(data['tasks']) do
    -- print(('Index %s, Value: %s'):format(index, value))
    if status == nil then
      table.insert(tasks, {
        id          = value['id'],
        description = value['description'],
        status      = value['status'],
        created_at  = value['created_at'],
        updated_at  = value['updated_at']
      })
    else
      if value['status'] == status then
        table.insert(tasks, {
          id          = value['id'],
          description = value['description'],
          status      = value['status'],
          created_at  = value['created_at'],
          updated_at  = value['updated_at']
        })
      end
    end
  end
  return tasks, ERROR_CODES['0']
end

--- Get last task id
--- @return integer
function access.get_last_task()
  local data = json.decode(read_file())
  return table_len(data['tasks'])
end

--- Get a task data
--- @param id_task integer|string
--- @return table Task data
--- @return string Error status
function access.get_task(id_task)
  local data = json.decode(read_file())
  local result = {}

  if not id_task then
    return {}, ERROR_CODES['3'] -- 'The id_task is required'
  end
  if not tonumber(id_task) then
    return {}, ERROR_CODES['5'] -- 'id_task should be a number'
  end
  if not data['tasks'][tostring(id_task)] then
    return {}, ERROR_CODES['4'] -- 'Task doesn't exists
  end

  if type(data['tasks'][tostring(id_task)]) == 'table' then
    table.insert(result, {
      id          = data['tasks'][tostring(id_task)]['id'],
      description = data['tasks'][tostring(id_task)]['description'],
      status      = data['tasks'][tostring(id_task)]['status'],
      created_at  = data['tasks'][tostring(id_task)]['created_at'],
      updated_at  = data['tasks'][tostring(id_task)]['updated_at']
    })
  end

  return result[1], ERROR_CODES['4']
end

return access
