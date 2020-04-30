os.loadAPI("multishell.lua")
multishell.setMenuVisible(true)

local sysFiles = {
  "core/apis/blittle",
  "multishell.lua",
  "shell.lua",
  "core/apps/luaide",
  "core/apps/npaintpro",
  "core/apps/opedit",
  "core/apps/sketch",
  "core/apps/strafe",
  "core/apps/addapp",
  "core/apps/updater",
  "core/apps/changelog",
  "core/apps/enchat3",
  "core/apps/themes",
  "core/apps/kiosk",
  "core/apps/cloudcatcher",
  "core/apps/clock",
  "core/apps/settings",
  "core/apps/stdgui",
  "core/apps/cloud.lua",
  "core/apps/skynet.lua",
  "core/apps/luashell.lua",
  "core/changelog",
  "startup/os.lua"
}

shell.setDir('')

term.setCursorPos(1, 1)
term.clear()

print("Starting system filecheck...")
for _, file in pairs(sysFiles) do
  local existing = fs.exists(file)

  if not existing then
    term.setTextColor(colors.red)
    term.write("[FAIL] ")
    term.setTextColor(colors.white)
    term.write(file)
    sleep(0.1)
  else
    term.setTextColor(colors.lime)
    term.write("[PASS] ")
    term.setTextColor(colors.white)
    term.write(file)
  end

  print()
end

print("Filecheck complete, booting...")
sleep(0.5)