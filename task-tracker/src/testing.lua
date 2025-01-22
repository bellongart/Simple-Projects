package.path = package.path .. "./?.lua"
--- @see https://leafo.net/guides/customizing-the-luarocks-tree.html
local json = require("vendor.json2")
local util = require("vendor.utils")

local a = [[
  {
    "glossary": {
      "title": "example glossary",
  	"GlossDiv": {
        "title": "S",
  		"GlossList": {
          "GlossEntry": {
            "ID": "SGML",
  		"SortAs": "SGML",
  		"GlossTerm": "Standard Generalized Markup Language",
  		"Acronym": "SGML",
  		"Abbrev": "ISO 8879:1986",
  		"GlossDef": {
        "para": "A meta-markup language, used to create markup languages such as DocBook.",
       	"GlossSeeAlso": ["GML", "XML"]
      },
     	"GlossSee": "markup"
            }
        }
      }
    }
  }
]]


a = [[
{
  "tasks": {
    "1": {
      "id": "id taks",
      "description": "task description",
      "status": "task status",
      "create_at": "creation date of the task",
      "update_at": "last update date of the task"
    },
    "2": {
      "id": "id taks",
      "description": "task description",
      "status": "task status",
      "create_at": "creation date of the task",
      "update_at": "last update date of the task"
    },
    "3": {
      "id": "id taks",
      "description": "task description",
      "status": "task status",
      "create_at": "creation date of the task",
      "update_at": "last update date of the task"
    },
    "4": {
      "id": "id taks",
      "description": "task description",
      "status": "task status",
      "create_at": "creation date of the task",
      "update_at": "last update date of the task"
    },
    "5": {
      "id": "id taks",
      "description": "task description",
      "status": "task status",
      "create_at": "creation date of the task",
      "update_at": "last update date of the task"
    }
  }
}
]]

-- local result = json.parse(a)
-- print(util.print_r(result))


--- Check if a json file exists
--- @see https://stackoverflow.com/questions/4990990/check-if-a-file-exists-with-lua
--- @param path string File path
--- @return boolean True if exists
local function file_exists(path)
  local file = false
  local f = io.open(path, "r")
  if f ~= nil then
    io.close(f)
    file = true
  end
  return file
end

local function lines_from(file)
  if not file_exists(file) then return {} end
  local lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  -- local output
  return table.concat(lines, "\n")
end

-- tests the functions above
-- local file = 'json.json'
-- local lines = lines_from(file)


local filepath = '../tasks.json'

--- Write a data in json file
--- @param data string
--- @return boolean
local function write_file(data)
  local f = io.open(filepath, "w")
  if f == nil then
    return false
  end
  f:write(data)
  f:close()
  return true
end


if write_file(a) then
  print('ok')
else
  print('fail')
end





-- print(util.print_r(lines))
-- print(lines)


-- print all line numbers and their contents
-- for k, v in pairs(lines) do
--   print('line[' .. k .. ']', v)
-- end



-- if file_exists('json.json') then
--   print('ok')
-- else
--   print('no exists')
-- end
