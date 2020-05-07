if not fs.exists("settings.cfg") or not fs.exists("password.cfg") then
  local lines = {
    "Welcome to Flip 1.4!",
    "This version comes with new improvements and features but before getting started, we need to patch some things.",
    "",
    "[1] Patch settings",
    "[2] Reset my settings",
  }
  
  for _, line in pairs(lines) do
    print(line)
  end
  
  local _, key = os.pullEvent("key")
  
  if key == keys.one then
    print("Insert a password for your user:")
    sleep(0.05)
    local password = read("*")
  
    local passwordFile = fs.open("/core/password.cfg", "w")
    local passwordTable = {
      hash = {},
      enc = ""
    }
  
    os.loadAPI("/core/apis/aeslua")
    local iv = {}
    for i = 1, 16 do iv[i] = math.random(1, 255) end
    passwordTable.hash = iv
    passwordTable.enc = aeslua.encrypt(table.concat(iv), password, aeslua.AES128, aeslua.CBCMODE, iv)
  
    passwordFile.write(textutils.serialise(passwordTable))
    passwordFile.flush()
    passwordFile.close()
    fs.delete("/autoexec.lua")
    os.reboot()
  elseif key == keys.two then
    fs.delete("/core/settings.cfg")
    if fs.exists("/core/password.cfg") then
      fs.delete("/core/password.cfg")
    end
    fs.delete("/autoexec.lua")
    os.reboot()
  else
    os.reboot()
  end
end