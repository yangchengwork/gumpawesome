-- {{{2 Volume Control
volume_widget = widget({ type = "textbox", name = "tb_volume", align = "right" })

volume_cardid  = 1
volume_channel = "Master"
function volume (mode, widget)
  if mode == "update" then
    local fd = io.popen("amixer -c " .. volume_cardid .. " -- sget " .. volume_channel)
    local status = fd:read("*all")
    fd:close()
 
	-- local volume = tonumber(string.match(status, "(%d?%d?%d)%%"))
    local volume = string.match(status, "(%d?%d?%d)%%")
    volume = string.format("%3d", volume)
 
    status = string.match(status, "%[(o[^%]]*)%]")
 
    if string.find(status, "on", 1, true) then
      volume = '𝅘𝅥𝅮' .. volume .. "%"
    else
      volume = '𝅘𝅥𝅮' .. volume .. '<span color="red">M</span>'
    end
    widget.text = volume
  elseif mode == "up" then
    io.popen("amixer -q -c " .. volume_cardid .. " sset " .. volume_channel .. " 5%+"):read("*all")
    volume("update", widget)
  elseif mode == "down" then
    io.popen("amixer -q -c " .. volume_cardid .. " sset " .. volume_channel .. " 5%-"):read("*all")
    volume("update", widget)
  else
    io.popen("amixer -c " .. volume_cardid .. " sset " .. volume_channel .. " toggle"):read("*all")
    volume("update", widget)
  end
end
volume_clock = timer({ timeout = 10 })
volume_clock:add_signal("timeout", function () volume("update", volume_widget) end)
volume_clock:start()
 
volume_widget.width = 35
volume_widget:buttons(awful.util.table.join(
  awful.button({ }, 4, function () volume("up", volume_widget) end),
  awful.button({ }, 5, function () volume("down", volume_widget) end),
  awful.button({ }, 1, function () volume("mute", volume_widget) end)
))
volume("update", volume_widget)
