local awful = require("awful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local PATH_TO_ICONS = "/usr/share/icons/Arc/devices/24/"
local ICON_DISCONNECTED="/usr/share/icons/Arc/status/24/network-wired-disconnected.png"
local ICON_CONNECTED="/usr/share/icons/Arc/devices/24/network-wireless.png"

--wifi_widget = wibox.widget.textbox()
--wifi_widget:set_font("Play 9")

wifi_icon = wibox.widget.imagebox()
-- wifi_icon:set_image(ICON_DISCONNECTED)
--wifi_icon:set_image(path_to_icons .. "")


--watch(
--  -- "nmcli -t -f active,ssid dev wifi ", 3,
--  "/homes/manjaro/giao/bin/wifi_status.sh ", 3,
--  function(widget, stdout, stderr, exitreason, exitcode)
--    --local wifi = string.match(stdout, "yes:.*\n")
--    --local index_1 = string.find(stdout, "yes:[a-z]*")
--    --local index_2 = string.len(wifi)-1
--    local wifi = string.sub(stdout,1,string.len(stdout)-1)
--    if(wifi == '' or wifi==nil ) then
--        widget.text= "| No wifi |"
--    else
--        --wifi= string.sub(stdout, index_1+4, index_2)
--        widget.text=" [" .. wifi .. "] "
--    end
--  end,
--  wifi_widget
--)

local wifi_widget = wibox.widget {
  {
    id = "icon",
    widget = wibox.widget.imagebox,
    resize = false
  },
  layout = wibox.container.margin(_, 0, 0, 3)
}

-- Popup with info
local notification
local function show_wifi_status()
  awful.spawn.easy_async([[bash -c '/homes/manjaro/giao/bin/wifi_status.sh']],
    function(stdout, _, _, _)
      naughty.destroy(notification)
      notification = naughty.notify {
        text = stdout,
        title = "Wifi status",
        timeout = 5, hover_timeout = 0.5,
        width = 200,
      }
  end)
end

--local wifi_details = ""
watch("/homes/manjaro/giao/bin/wifi_status.sh ", 3,
  function(widget, stdout, stderr, exitreason, exitcode)
    local wifi = string.sub(stdout,1,string.len(stdout)-1)
    if(wifi == '' or wifi==nil ) then
        --wifi_icon:set_image(icon_disconnected)
        --wifi_widget:set_text("Disconnected")
        wifi_icon:set_image(ICON_DISCONNECTED)
        widget.icon:set_image(ICON_DISCONNECTED)
    else
        wifi_icon:set_image(ICON_CONNECTED)
        widget.icon:set_image(ICON_CONNECTED)
        --wifi_icon:set_image(icon_connected)
        --wifi_widget:set_text(wifi)
        --wifi_details = wifi
    end
  end,
  wifi_widget)

wifi_widget:connect_signal("mouse:enter", function() show_wifi_status() end)
wifi_widget:connect_signal("mouse:leave", function() naughty.destroy(notification) end)

return wifi_widget

