--[[
          _                     _     _
         | |   _   _  __ _  ___| |__ (_)
         | |  | | | |/ _` |/ __| '_ \| |
         | |__| |_| | (_| | (__| | | | |
         |_____\__,_|\__,_|\___|_| |_|_|
Copyright (c) 2020  Díaz  Víctor  aka  (Máster Vitronic)
<vitronic2@gmail.com>   <mastervitronic@vitronic.com.ve>
]] --

local util = {}

--- Return all table data
--- @param tbl any
--- @param indent any
--- @return string
function util.print_r(tbl, indent)
  if type(tbl) ~= "table" then return tostring(tbl) end
  indent = indent or 0
  local toprint = "{\n"
  local indent_str = string.rep(" ", indent + 2)
  for k, v in pairs(tbl) do
    toprint = toprint .. indent_str .. '['
    toprint = toprint .. (type(k) == "number" and k or '"' .. k .. '"') .. '] = '
    if type(v) == "table" then
      toprint = toprint .. util.print_r(v, indent + 2) .. ",\n"
    else
      toprint = toprint .. (type(v) == "number" and v or '"' .. tostring(v) .. '"') .. ",\n"
    end
  end
  toprint = toprint .. string.rep(" ", indent) .. "}"
  return toprint
end

return util
