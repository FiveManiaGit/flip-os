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
print("Welcome to FlipOS 1.2!")
print('')
print("This version of FlipOS comes with new applications and improvements. Before experiencing the new update, we need to patch some system files. Note that this will remove all of your custom application configuration but it is necessary. You can still manually patch the new applink format.")
print('')
print("[1] Patch files")
print("[2] Do not patch files")
print('')

local _, key = os.pullEvent("key")

if key == keys.one then
  print('Deleting: core/apps.cfg')
  fs.delete('core/apps.cfg')
  print('Applying new file format...')
  local file = fs.open('core/apps.cfg', 'w')
  file.write(textutils.serialise({}))
  file.flush()
  file.close()
  fs.delete('autoexec.lua')
  print('-----------------------')
  print('Press any key to reboot')
  print('-----------------------')
elseif key == keys.two then
  fs.delete('autoexec.lua')
end

os.reboot()
