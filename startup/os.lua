local path = {
  {"edit", "core/apps/opedit"}
}

local colors = colors;

local function flip()
  local w, h = term.getSize()
  local middle = math.floor(h/2)
  local fadeColors = {colors.white, colors.lightGray, colors.gray, colors.black}
  local fadeReverseColors = {colors.black, colors.gray, colors.lightGray, colors.white}

  local flapis = {
    external = {
      blittle = os.loadAPI("core/apis/blittle")
    },
    text = {
      fadeIn = function (text, x, y, delay)
        for _, color in pairs(fadeColors) do
          term.setCursorPos(x, y)
          term.setTextColor(color)
          term.clearLine()
          term.write(text)
          sleep(delay)
        end
      end,
      fadeOut = function (text, x, y, delay)
        for _, color in pairs(fadeReverseColors) do
          term.setCursorPos(x, y)
          term.setTextColor(color)
          term.clearLine()
          term.write(text)
          sleep(delay)
        end
      end
    }
  }

  term.setCursorBlink(false)

  local flconfig = {
    menuPosition = 1,
    menuOptions = {
      -- Add custom app
      {text = "Add custom app", script = "core/apps/addapp", luaCode = false, colors = {colors.white, colors.gray}},

      -- Apps
      {text = "LuaIDE", script = "core/apps/luaide", useBlit = false, luaCode = false, colors = {colors.white, colors.purple}},
      {text = "NPaintPro", script = "core/apps/npaintpro", useBlit = false, luaCode = false, colors = {colors.white, colors.blue}},
      {text = "Sketch", script = "core/apps/sketch", useBlit = false, luaCode = false, colors = {colors.black, colors.lightBlue}},
      {text = "STD-GUI", script = "core/apps/stdgui", useBlit = false, luaCode = false, colors = {colors.orange, colors.gray}},
      {text = "Enchat 3", script = "core/apps/enchat3", useBlit = true, blit = "e145db7a", blitBg = "ffffffff", luaCode = false, colors = {colors.lightBlue, colors.black}},
      {text = "Shell", script = "fg", useBlit = false, luaCode = false, colors = {colors.yellow, colors.black}},
      {text = "Lua", script = "fg lua", useBlit = false, luaCode = false, colors = {colors.blue, colors.lightBlue}},
      {text = "Clock", script = "core/apps/clock", useBlit = false, luaCode = false, colors = {colors.lightGray, colors.gray}},
      {text = "Cloud Catcher", script = "core/apps/cloudcatcher", useBlit = false, luaCode = false, colors = {colors.lightBlue, colors.blue}},

      -- Games
      {text = "Redirection", script = "rom/programs/fun/advanced/redirection.lua", useBlit = false, luaCode = false, colors = {colors.lightBlue, colors.gray}},
      {text = "Strafe", script = "core/apps/strafe", useBlit = false, luaCode = false, colors = {colors.white, colors.black}},

      -- System options
      {text = "Shutdown", script = "os.shutdown()", useBlit = false, luaCode = true, colors = {colors.white, colors.red}},
      {text = "Reboot", script = "os.reboot()", useBlit = false, luaCode = true, colors = {colors.black, colors.orange}},
      {text = "Settings", script = "core/apps/settings", useBlit = false, luaCode = false, colors = {colors.black, colors.lightGray}},
      {text = "Themes", script = "core/apps/themes", useBlit = false, luaCode = false, colors = {colors.white, colors.magenta}},
      {text = "Kiosk Mode", script = "core/apps/kiosk", useBlit = false, luaCode = false, colors = {colors.gray, colors.yellow}},
      {text = "Update", script = "core/apps/updater", useBlit = false, luaCode = false, colors = {colors.white, colors.lime}},
      {text = "Changelog", script = "core/apps/changelog", useBlit = false, luaCode = false, colors = {colors.black, colors.pink}},
      {text = "Exit to CraftOS", script = "os.queueEvent('terminate')", useBlit = false, luaCode = true, colors = {colors.black, colors.yellow}}
    },
    tourMenuOptions = {
      {text = "Option 1", colors = {colors.white, colors.red}},
      {text = "Option 2", colors = {colors.white, colors.orange}},
      {text = "Option 3", colors = {colors.black, colors.yellow}},
      {text = "Option 4", colors = {colors.black, colors.lime}},
      {text = "Option 5", colors = {colors.white, colors.green}},
      {text = "Option 6", colors = {colors.black, colors.lightBlue}},
      {text = "Option 7", colors = {colors.white, colors.blue}},
      {text = "Option 8", colors = {colors.white, colors.magenta}},
      {text = "Option 9", colors = {colors.white, colors.purple}},
    },
    userconfigs = {
      bg = colors.white,
      fg = colors.black,
      pfg = colors.gray,
      username = "FlipOS Guest",
      passedIntro = false,
      customPath = {}
    }
  }

  if fs.exists("core/settings.cfg.bak") then
    if not fs.exists("core/settings.cfg") or type(textutils.unserialise(fs.open("core/settings.cfg", "r").readAll())) ~= "table" then
      local cfgFile = fs.open("core/settings.cfg", "w")
      cfgFile.write(fs.open("core/settings.cfg.bak", "r").readAll())      
      term.setCursorPos(2, middle)
      term.setBackgroundColor(colors.green)
      term.setTextColor(colors.white)
      term.clear()
      term.write("Backup settings restored!")
      sleep(2)
      os.reboot()
    end
    fs.delete("core/settings.cfg.bak")
  end

  if not fs.exists("core/settings.cfg") or type(textutils.unserialise(fs.open("core/settings.cfg", "r").readAll())) ~= "table" then
    local configFile = fs.open("core/settings.cfg", "w")
    configFile.write(textutils.serialise({
      bg = colors.white,
      fg = colors.black,
      pfg = colors.lightGray,
      username = flconfig.userconfigs.username,
      passedIntro = false,
      listMaxItem = 3,
      customPath = {}
    }))
    configFile.flush()
    configFile.close()
  end

  if not fs.exists("core/apps.cfg") or type(textutils.unserialise(fs.open("core/apps.cfg", "r").readAll())) ~= "table" then
    local configFile = fs.open("core/apps.cfg", "w");
    configFile.write(textutils.serialise({}))
    configFile.flush()
    configFile.close()
  end

  local configFile = fs.open("core/settings.cfg", "r").readAll()
  flconfig.userconfigs = textutils.unserialise(configFile)

  if not textutils.unserialise(configFile).passedIntro then
    term.setBackgroundColor(flconfig.userconfigs.bg)
    term.setTextColor(flconfig.userconfigs.fg)
    term.clear()

    flapis.text.fadeIn("Setting up...", 2, middle, 0.15)
    sleep(2)
    flapis.text.fadeOut("Setting up...", 2, middle, 0.15)
    flapis.text.fadeIn("What is your computer name? ", 2, middle, 0.15)
    local pclabel = read()
    flapis.text.fadeOut("What is your computer name? " .. pclabel, 2, middle, 0.15)
    
    flapis.text.fadeIn("What is your name? ", 2, middle, 0.15)
    local uname = read()
    flapis.text.fadeOut("What is your name? " .. uname, 2, middle, 0.15)
    flapis.text.fadeIn("Hello, " .. uname .. "!", 2, middle, 0.15)
    sleep(2.5)
    flapis.text.fadeOut("Hello, " .. uname .. "!", 2, middle, 0.15)
    flapis.text.fadeIn("Before we get started, you can skip this", 2, middle-1, 0.15)
    flapis.text.fadeIn("tutorial by pressing the Home key", 2, middle, 0.15)
    flapis.text.fadeIn("at any moment of this tutorial.", 2, middle+1, 0.15)
    sleep(3.5)
    flapis.text.fadeOut("Before we get started, you can skip this", 2, middle-1, 0.15)
    flapis.text.fadeOut("tutorial by pressing the Home key", 2, middle, 0.15)
    flapis.text.fadeOut("at any moment of this tutorial.", 2, middle+1, 0.15)
    
    parallel.waitForAny(function()
      flapis.text.fadeIn("Welcome to FlipOS!", 2, middle, 0.15)
      sleep(2)
      flapis.text.fadeOut("Welcome to FlipOS!", 2, middle, 0.15)
      flapis.text.fadeIn("FlipOS is an operating system made in Lua", 2, middle, 0.15)
      sleep(2)
      flapis.text.fadeOut("FlipOS is an operating system made in Lua", 2, middle, 0.15)
      flapis.text.fadeIn("It has been created to provide...", 2, middle, 0.15)
      sleep(2)
      flapis.text.fadeOut("It has been created to provide...", 2, middle, 0.15)

      flapis.text.fadeIn("Simple use", 2, middle, 0.15)
      sleep(1)
      flapis.text.fadeOut("Simple use", 2, middle, 0.15)

      flapis.text.fadeIn("Minimalist interface", 2, middle, 0.15)
      sleep(1)
      flapis.text.fadeOut("Minimalist interface", 2, middle, 0.15)

      flapis.text.fadeIn("Amazing applications", 2, middle, 0.15)
      sleep(1)
      flapis.text.fadeOut("Amazing applications", 2, middle, 0.15)

      flapis.text.fadeIn("Good experiences", 2, middle, 0.15)
      sleep(1)
      flapis.text.fadeOut("Good experiences", 2, middle, 0.15)

      flapis.text.fadeIn("Education", 2, middle, 0.15)
      sleep(1)
      flapis.text.fadeOut("Education", 2, middle, 0.15)

      flapis.text.fadeIn("Work (specially for home office)", 2, middle, 0.15)
      sleep(1)
      flapis.text.fadeOut("Work (specially for home office)", 2, middle, 0.15)

      flapis.text.fadeIn("And fun.", 2, middle, 0.15)
      sleep(1)
      flapis.text.fadeOut("And fun.", 2, middle, 0.15)

      flapis.text.fadeIn("Let's take a quick tour.", 2, middle, 0.15)
      sleep(2.5)
      flapis.text.fadeOut("Let's take a quick tour.", 2, middle, 0.15)

      flapis.text.fadeIn("Press your arrow keys (\24 and \25) to move around", 2, middle-3, 0.15)
      flapis.text.fadeIn("Press ENTER to proceed", 2, middle+3, 0.15)

      -- Get Input Start
        while true do
          term.setCursorPos(2, middle)
          term.setTextColor(flconfig.tourMenuOptions[flconfig.menuPosition].colors[1])
          term.setBackgroundColor(flconfig.tourMenuOptions[flconfig.menuPosition].colors[2])
          term.clearLine()
          term.write(flconfig.tourMenuOptions[flconfig.menuPosition].text)
          term.setTextColor(flconfig.userconfigs.pfg)
          term.setBackgroundColor(flconfig.userconfigs.bg)

          if flconfig.tourMenuOptions[flconfig.menuPosition-1] ~= nil then
            term.setCursorPos(2, middle-1)
            term.write(flconfig.tourMenuOptions[flconfig.menuPosition-1].text)
          else
            term.setCursorPos(2, middle-1)
            term.write(flconfig.tourMenuOptions[table.getn(flconfig.tourMenuOptions)].text)
          end

          if flconfig.tourMenuOptions[flconfig.menuPosition+1] ~= nil then
            term.setCursorPos(2, middle+1)
            term.write(flconfig.tourMenuOptions[flconfig.menuPosition+1].text)
          else
            term.setCursorPos(2, middle+1)
            term.write(flconfig.tourMenuOptions[1].text)
          end

          local _, key = os.pullEvent("key")
          if key == keys.up then
            flconfig.menuPosition = flconfig.menuPosition - 1
            if flconfig.menuPosition <= 0 then
              flconfig.menuPosition = table.getn(flconfig.tourMenuOptions)
            end
          elseif key == keys.down then
            flconfig.menuPosition = flconfig.menuPosition + 1
            if flconfig.menuPosition > table.getn(flconfig.tourMenuOptions) then
              flconfig.menuPosition = 1
            end
          elseif key == keys.enter then
            break
          end
        end
      -- Get Input End

      flapis.text.fadeOut("Press your arrow keys (\24 and \25) to move around", 2, middle-3, 0.15)
      flapis.text.fadeOut("Press ENTER to proceed", 2, middle+3, 0.15)
    end, function()
      local _, skipkey = os.pullEvent("key")

      if skipkey == keys.home then
        term.clear()
        flapis.text.fadeIn("Tutorial skipped!", 2, middle, 0.05)
        sleep(1)
        flapis.text.fadeOut("Tutorial skipped!", 2, middle, 0.05)

        local configFile = fs.open("core/settings.cfg", "w")
        configFile.write(textutils.serialise({
          bg = colors.white,
          fg = colors.black,
          pfg = colors.lightGray,
          username = uname,
          passedIntro = true,
          customPath = {}
        }))
        configFile.flush()
        configFile.close()

        os.setComputerLabel(pclabel)

        os.reboot()
      end
    end)

    term.clear()

    flapis.text.fadeIn("That's how you use most of FlipOS.", 2, middle, 0.15)
    sleep(2.5)
    flapis.text.fadeOut("That's how you use most of FlipOS.", 2, middle, 0.15)

    flapis.text.fadeIn("We hope you enjoy FlipOS!", 2, middle, 0.15)
    sleep(2.5)
    flapis.text.fadeOut("We hope you enjoy FlipOS!", 2, middle, 0.15)

    local configFile = fs.open("core/settings.cfg", "w")
    configFile.write(textutils.serialise({
      bg = colors.white,
      fg = colors.black,
      pfg = colors.lightGray,
      username = uname,
      passedIntro = true,
      listMaxItem = 3,
      customPath = {}
    }))
    configFile.flush()
    configFile.close()

    os.setComputerLabel(pclabel)

    os.reboot()
  else
    term.setBackgroundColor(flconfig.userconfigs.bg)
    term.setTextColor(flconfig.userconfigs.fg)
    term.clear()

    for i = -1, 1 do
      term.setBackgroundColor(colors.white)
      term.setCursorPos(2, middle+i)
      term.clearLine()
    end

    flapis.text.fadeIn("FlipOS", 2, middle, 0.15)
    sleep(2)
    flapis.text.fadeOut("FlipOS", 2, middle, 0.15)
  end
  
  if fs.exists('autoexec.lua') then
    dofile('autoexec.lua')
  end

  term.setBackgroundColor(flconfig.userconfigs.bg)
  term.setTextColor(flconfig.userconfigs.fg)
  term.clear()
  term.setCursorPos(2, 2)
  term.write("FlipOS")
  term.setTextColor(flconfig.userconfigs.pfg)
  term.write(" by FiveMania ")
  term.setCursorPos((w-string.len(flconfig.userconfigs.username)), 2)
  term.write(flconfig.userconfigs.username)
  term.setCursorPos(2, h-1)
  term.write("Version 1.2.5")
  term.setCursorBlink(false)

  for _, program in pairs(flconfig.userconfigs.customPath) do
    table.insert(path, program)
  end

  for _, program in pairs(path) do
    shell.setAlias(program[1], program[2])
  end

  for _, program in pairs(textutils.unserialise(fs.open("core/apps.cfg", "r").readAll())) do
    local isFgValid = false
    local isBgValid = false
    
    for _, color in pairs(colors) do      
      if type(color) == "number" then
        if program.colors.fg == color then
          isFgValid = true
        end

        if program.colors.bg == color then
          isBgValid = true
        end
      end
    end
    if isFgValid and isBgValid then
      table.insert(flconfig.menuOptions, {text = program.name, script = program.path, colors = {program.colors.fg, program.colors.bg}})
    else
      table.insert(flconfig.menuOptions, {text = program.name .. " \7", script = program.path, colors = {flconfig.userconfigs.bg, flconfig.userconfigs.fg}})
    end
  end

  while true do
    -- Draw Menu Start
      term.setCursorPos(2, middle)
      
      if not flconfig.menuOptions[flconfig.menuPosition].useBlit then
        term.setTextColor(flconfig.menuOptions[flconfig.menuPosition].colors[1])
        term.setBackgroundColor(flconfig.menuOptions[flconfig.menuPosition].colors[2])
        term.clearLine()
        term.write(flconfig.menuOptions[flconfig.menuPosition].text)
      else
        term.setTextColor(colors.white)
        term.setBackgroundColor(flconfig.menuOptions[flconfig.menuPosition].colors[2])
        term.clearLine()
        term.blit(flconfig.menuOptions[flconfig.menuPosition].text, flconfig.menuOptions[flconfig.menuPosition].blit, flconfig.menuOptions[flconfig.menuPosition].blitBg)
      end

      term.setTextColor(flconfig.userconfigs.pfg)
      term.setBackgroundColor(flconfig.userconfigs.bg)

      if flconfig.userconfigs.listMaxItem == 3 then
        if flconfig.menuOptions[flconfig.menuPosition-1] ~= nil then
          term.setCursorPos(2, middle-1)
          term.write(flconfig.menuOptions[flconfig.menuPosition-1].text)
        else
          term.setCursorPos(2, middle-1)
          term.write(flconfig.menuOptions[table.getn(flconfig.menuOptions)].text)
        end
  
        if flconfig.menuOptions[flconfig.menuPosition+1] ~= nil then
          term.setCursorPos(2, middle+1)
          term.write(flconfig.menuOptions[flconfig.menuPosition+1].text)
        else
          term.setCursorPos(2, middle+1)
          term.write(flconfig.menuOptions[1].text)
        end

        term.setCursorPos(w-1, middle-1)
        term.write("\24")

        term.setCursorPos(w-1, middle+1)
        term.write("\25")
      elseif flconfig.userconfigs.listMaxItem == 5 then
        if flconfig.menuOptions[flconfig.menuPosition-1] ~= nil then
          term.setCursorPos(2, middle-1)
          term.write(flconfig.menuOptions[flconfig.menuPosition-1].text)
        else
          term.setCursorPos(2, middle-1)
          term.write(flconfig.menuOptions[table.getn(flconfig.menuOptions)].text)
        end

        if flconfig.menuOptions[flconfig.menuPosition-2] ~= nil then
          term.setCursorPos(2, middle-2)
          term.write(flconfig.menuOptions[flconfig.menuPosition-2].text)
        else
          term.setCursorPos(2, middle-2)
          term.write(flconfig.menuOptions[table.getn(flconfig.menuOptions)-1].text)
        end
  
        if flconfig.menuOptions[flconfig.menuPosition+1] ~= nil then
          term.setCursorPos(2, middle+1)
          term.write(flconfig.menuOptions[flconfig.menuPosition+1].text)
        else
          term.setCursorPos(2, middle+1)
          term.write(flconfig.menuOptions[1].text)
        end

        if flconfig.menuOptions[flconfig.menuPosition+2] ~= nil then
          term.setCursorPos(2, middle+2)
          term.write(flconfig.menuOptions[flconfig.menuPosition+2].text)
        else
          term.setCursorPos(2, middle+2)
          term.write(flconfig.menuOptions[2].text)
        end

        term.setCursorPos(w-1, middle-2)
        term.write("\24")

        term.setCursorPos(w-1, middle+2)
        term.write("\25")
      elseif flconfig.userconfigs.listMaxItem == 7 then
        if flconfig.menuOptions[flconfig.menuPosition-1] ~= nil then
          term.setCursorPos(2, middle-1)
          term.write(flconfig.menuOptions[flconfig.menuPosition-1].text)
        else
          term.setCursorPos(2, middle-1)
          term.write(flconfig.menuOptions[table.getn(flconfig.menuOptions)].text)
        end

        if flconfig.menuOptions[flconfig.menuPosition-2] ~= nil then
          term.setCursorPos(2, middle-2)
          term.write(flconfig.menuOptions[flconfig.menuPosition-2].text)
        else
          term.setCursorPos(2, middle-2)
          term.write(flconfig.menuOptions[table.getn(flconfig.menuOptions)-1].text)
        end

        if flconfig.menuOptions[flconfig.menuPosition-3] ~= nil then
          term.setCursorPos(2, middle-3)
          term.write(flconfig.menuOptions[flconfig.menuPosition-3].text)
        else
          term.setCursorPos(2, middle-3)
          term.write(flconfig.menuOptions[table.getn(flconfig.menuOptions)-2].text)
        end
  
        if flconfig.menuOptions[flconfig.menuPosition+1] ~= nil then
          term.setCursorPos(2, middle+1)
          term.write(flconfig.menuOptions[flconfig.menuPosition+1].text)
        else
          term.setCursorPos(2, middle+1)
          term.write(flconfig.menuOptions[1].text)
        end

        if flconfig.menuOptions[flconfig.menuPosition+2] ~= nil then
          term.setCursorPos(2, middle+2)
          term.write(flconfig.menuOptions[flconfig.menuPosition+2].text)
        else
          term.setCursorPos(2, middle+2)
          term.write(flconfig.menuOptions[2].text)
        end

        if flconfig.menuOptions[flconfig.menuPosition+3] ~= nil then
          term.setCursorPos(2, middle+3)
          term.write(flconfig.menuOptions[flconfig.menuPosition+3].text)
        else
          term.setCursorPos(2, middle+3)
          term.write(flconfig.menuOptions[3].text)
        end

        term.setCursorPos(w-1, middle-3)
        term.write("\24")

        term.setCursorPos(w-1, middle+3)
        term.write("\25")
      end
      term.setCursorBlink(false)
    -- Draw Menu End

    -- Get Input Start
      local e, a = os.pullEvent()
      if e == "key" then
        if a == keys.up then
          flconfig.menuPosition = flconfig.menuPosition - 1
          if flconfig.menuPosition <= 0 then
            flconfig.menuPosition = table.getn(flconfig.menuOptions)
          end
        elseif a == keys.down then
          flconfig.menuPosition = flconfig.menuPosition + 1
          if flconfig.menuPosition > table.getn(flconfig.menuOptions) then
            flconfig.menuPosition = 1
          end
        elseif a == keys.enter then
          if flconfig.menuOptions[flconfig.menuPosition].luaCode then
            load(flconfig.menuOptions[flconfig.menuPosition].script)()
          else
            shell.run(flconfig.menuOptions[flconfig.menuPosition].script)
          end
        end
      elseif e == "mouse_scroll" then
        flconfig.menuPosition = flconfig.menuPosition + a
        if flconfig.menuPosition <= 0 then
          flconfig.menuPosition = table.getn(flconfig.menuOptions)
        end
        
        if flconfig.menuPosition > table.getn(flconfig.menuOptions) then
          flconfig.menuPosition = 1
        end
      elseif e == "mouse_click" or e == "monitor_touch" then
        if flconfig.menuOptions[flconfig.menuPosition].luaCode then
          load(flconfig.menuOptions[flconfig.menuPosition].script)()
        else
          shell.run(flconfig.menuOptions[flconfig.menuPosition].script)
        end
        term.setCursorBlink(false)
      elseif e == "term_resize" or e == "monitor_resize" then
        w, h = term.getSize()
        middle = math.floor(h/2)
      end

      w, h = term.getSize()
      middle = math.floor(h/2)
    -- Get Input End

    -- Refresh Menu Start
      term.setBackgroundColor(flconfig.userconfigs.bg)
      term.setTextColor(flconfig.userconfigs.fg)
      term.clear()
      term.setCursorPos(2, 2)
      term.write("FlipOS")
      term.setTextColor(flconfig.userconfigs.pfg)
      term.write(" by FiveMania ")
      term.setCursorPos((w-string.len(flconfig.userconfigs.username)), 2)
      term.write(flconfig.userconfigs.username)
      term.setCursorPos(2, h-1)
      term.write("Version 1.2.5")
      term.setCursorBlink(false)
    -- Refresh Menu End
  end
end

local function bios()
  if not term.isColor() then
    print("FlipOS does not work on Basic Computers, please upgrade to an Advanced Computer.")
    print("Press any key to close")
    os.pullEvent("key")
    os.queueEvent("terminate")
  else
    flip()
  end
end

local status, err = pcall(bios)

if status then
else
  if err ~= "Terminated" then
    term.setBackgroundColor(colors.blue)
    term.setTextColor(colors.white)
    term.clear()

    term.setCursorPos(2, 2)
    term.write("Oops! Looks like FlipOS crashed.")
    term.setCursorPos(2, 3)
    term.write("This could be caused by an system error or an application.")

    term.setCursorPos(2, 5)
    term.write("If this error has been caused while executing an action")
    term.setCursorPos(2, 6)
    term.write("in an application, contact the app developer.")

    term.setCursorPos(2, 8)
    term.write("If this error has been caused while executing an action")
    term.setCursorPos(2, 9)
    term.write("on FlipOS, contact FiveMania.")

    term.setCursorPos(2, 11)
    term.write("Lua Error Code: " .. err)

    term.setCursorPos(2, 12)
    term.write("The system will reboot in a few seconds...")

    for i = 10, 1, -1 do
      term.setCursorPos(2, 12)
      term.clearLine()
      term.write("The system will reboot in " .. i .. " second(s)...")
      sleep(1)
    end
    
    os.reboot()
  else
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.clear()
    term.setCursorPos(1, 1)
  end
end