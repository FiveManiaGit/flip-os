-- Unload original CraftOS APIs
os.unloadAPI("multishell")
os.unloadAPI("shell")

-- Load custom Flip APIs
os.loadAPI("/core/apis/aeslua")
os.loadAPI("/core/apis/shell.lua")
os.loadAPI("/core/apis/multishell.lua")

-- Force show the multishell menu
multishell.setMenuVisible(true)

-- Define all system files
-- Also used on repo data (for installing and updating) and on repo remove (for uninstalling)
local sysFiles = {
  "/core/apis/blittle",
  "/core/apis/multishell.lua",
  "/core/apis/shell.lua",
  "/core/apis/aeslua",
  "/core/apps/luaide",
  "/core/apps/npaintpro",
  "/core/apps/opedit",
  "/core/apps/sketch",
  "/core/apps/strafe",
  "/core/apps/addapp",
  "/core/apps/updater",
  "/core/apps/changelog",
  "/core/apps/enchat3",
  "/core/apps/themes",
  "/core/apps/kiosk",
  "/core/apps/cloudcatcher",
  "/core/apps/clock",
  "/core/apps/uninstall",
  "/core/apps/settings",
  "/core/apps/stdgui",
  "/core/apps/cloud.lua",
  "/core/apps/skynet.lua",
  "/core/apps/lua.lua",
  "/core/changelog",
  "/core/logo.nfp",
  "/core/system/os.lua",
  "/core/system/bios.lua",
  "/startup.lua",
}

local criticalFiles = {
  "/core/system/os.lua",
  "/core/system/bios.lua",
  "/startup.lua",
  "/core/apis/multishell.lua",
  "/core/apis/shell.lua",
}

local optionalFiles = {
  "/core/apis/blittle",
  "/core/apis/aeslua",
  "/core/apps/luaide",
  "/core/apps/npaintpro",
  "/core/apps/opedit",
  "/core/apps/sketch",
  "/core/apps/strafe",
  "/core/apps/addapp",
  "/core/apps/updater",
  "/core/apps/changelog",
  "/core/apps/enchat3",
  "/core/apps/themes",
  "/core/apps/kiosk",
  "/core/apps/cloudcatcher",
  "/core/apps/clock",
  "/core/apps/settings",
  "/core/apps/uninstall",
  "/core/apps/stdgui",
  "/core/apps/cloud.lua",
  "/core/apps/skynet.lua",
  "/core/apps/lua.lua",
  "/core/changelog",
  "/core/logo.nfp",
}

-- Path commands for custom shell
local path = {
  {"edit", "/core/apps/opedit"},
  {"lua", "/core/apps/lua.lua"},
  {"shell", "shell.lua"},
  {"list", "/core/commands/list"},
  {"ls", "/core/commands/list"},
  {"delete", "/core/commands/delete"},
  {"rm", "/core/commands/delete"},
  {"move", "/core/commands/move"},
  {"mv", "/core/commands/move"},
  {"rename", "/core/commands/rename"},
  {"rn", "/core/commands/rename"},
}

for _, program in pairs(path) do
  shell.setAlias(program[1], program[2])
end

local criticalMissing = false
local optionalMissing = false

shell.setDir('')

term.setCursorPos(1, 1)
term.clear()

if fs.exists("core/logo.nfp") and term.isColor() then
  paintutils.drawImage(paintutils.loadImage("core/logo.nfp"), 2, 2)
  term.setBackgroundColor(colors.black)
  term.setTextColor(colors.white)
end

term.setCursorPos(1, 13)
sleep(0.2)

print("Starting system filecheck...")
for _, file in pairs(sysFiles) do
  local existing = fs.exists(file)

  if not existing then
    term.setTextColor(colors.red)
    term.write("[FAIL] ")
    term.setTextColor(colors.white)
    term.write(file)
    sleep(0.1)
    for _, critical in pairs(criticalFiles) do
      if file == critical then
        print('')
        term.setTextColor(colors.red)
        term.write("[FATAL] ")
        term.setTextColor(colors.white)
        term.write("Missing critical system file: " .. file)
        criticalMissing = true
      end
    end

    for _, optional in pairs(optionalFiles) do
      if file == optional then
        print('')
        term.setTextColor(colors.orange)
        term.write("[WARN] ")
        term.setTextColor(colors.white)
        term.write("Missing optional system file: " .. file)
        optionalMissing = true
      end
    end
  else
    term.setTextColor(colors.lime)
    term.write("[PASS] ")
    term.setTextColor(colors.white)
    term.write(file)
    sleep(0.05)
  end

  print()
end

if optionalMissing then
  print("An optional system file is missing. Flip will boot but some apps and/or settings may not work correctly. Try reinstalling Flip if a problem persists.")
  sleep(3)
end

if criticalMissing then
  print("A critical system file is missing and Flip could not boot. Try reinstalling Flip or contact FiveMania.")
else
  print("Filecheck complete, booting...")
  sleep(0.5)
end