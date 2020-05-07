shell.run("core/system/bios.lua")

if fs.exists("/autoexec.lua") then
  multishell.launch({
    ['shell'] = shell,
    ['multishell'] = multishell,
  }, "/autoexec.lua")
  multishell.setFocus(multishell.getCount())
end

shell.run("core/system/os.lua")