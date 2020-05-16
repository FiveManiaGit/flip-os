local pretty = require("cc.pretty")

local runState = true

local commandHistory = {}
local promptEnv = {
  ["exit"] = setmetatable({}, {
      __tostring = function() runState = false end,
      __call = function() runState = false end,
  }),
  ["_echo"] = function(...)
      return ...
  end,
}
setmetatable(promptEnv, { __index = _ENV })

term.clear()
term.setCursorPos(1, 1)

term.setTextColor(colors.lightBlue)
print("Lua Shell")
term.setTextColor(colors.white)
term.write("Type in a Lua statement. Type exit() to quit.")

for i = 1, 2 do
  print('')
end

while runState do
  term.setTextColor(colors.blue)
  if not os.getComputerLabel() then
    term.write("user#" .. os.getComputerID())
  else
    term.write(os.getComputerLabel() .. "#" .. os.getComputerID())
  end
  term.setTextColor(colors.lightBlue)
  print('')
  term.write("\26 ")
  term.setTextColor(colors.white)

  local s = read(nil, commandHistory, function(line)
    if settings.get("lua.autocomplete") then
        local startPosition = string.find(line, "[a-zA-Z0-9_%.:]+$")
        if startPosition then
            line = string.sub(line, startPosition)
        end
        if #line > 0 then
            return textutils.complete(line, promptEnv)
        end
    end
    return nil
  end)
  if s:match("%S") and commandHistory[#commandHistory] ~= s then
    table.insert(commandHistory, s)
  end

  local forcePrint = 0

  local func, e = load(s, "=lua", "t", promptEnv)
  local func2 = load("return _echo(" .. s .. ");", "=lua", "t", promptEnv)

  if not func then
    if func2 then
      func = func2
      e = nil
      forcePrint = 1
    end
  else
    if func2 then
      func = func2
    end
  end

  local result = table.pack(pcall(func))
  if result[1] then
    local n = 1
    while n < result.n or n <= forcePrint do
      local value = result[n + 1]
      local ok, serialised = pcall(pretty.pretty, value)
      if ok then
        pretty.print(serialised)
      else
        print(tostring(value))
      end
      n = n + 1
    end
  else
    term.setTextColor(colors.red)
    print('')
    for i = 1, string.len(result[2])+4 do
      term.write("\127")
    end
    print('')
    print("\127 " .. result[2] .. " \127")
    for i = 1, string.len(result[2])+4 do
      term.write("\127")
    end
    term.setTextColor(colors.white)
    print('')
  end

  print('')
end
