-- This is not included on v1.2.1 and above

local w, h = term.getSize()
local middle = math.floor(h/2)

term.setBackgroundColor(colors.lightGray)
for i = 1, 3 do
  term.setCursorPos(1, i)
  term.clearLine()
end
term.setTextColor(colors.black)
term.setCursorPos(2, 2)
term.write("FlipOS Update Patch")
term.setCursorPos(2, 4)
term.setBackgroundColor(colors.black)
term.clearLine()
term.setBackgroundColor(colors.white)
term.setCursorPos(1, 6)
print("Welcome to FlipOS 1.2.5!")
print('')
print("This version of FlipOS comes with new applications and improvements. Before experiencing the new update, we need to patch some system files.")
print('')
print("[1] Patch files")
print("[2] Reset my settings")
print('')

local _, key = os.pullEvent("key")

if key == keys.one then
  print('Applying new file format...')
  local file = fs.open('core/apps.cfg', 'w')
  local fileRead = fs.open('core/apps.cfg', 'r').readAll()
  local setsCfg = textutils.unserialise(fileRead)

  table.insert(setsCfg, listMaxItem, 3)

  file.write(textutils.serialise(setsCfg))
  file.flush()
  file.close()
  fs.delete('autoexec.lua')
  print('-----------------------')
  print('Press any key to reboot')
  print('-----------------------')
elseif key == keys.two then
  fs.delete('core/settings.cfg')
  fs.delete('core/apps.cfg')
  fs.delete('autoexec.lua')
end

os.reboot()
