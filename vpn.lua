local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")

vpn_widget = wibox.widget.textbox()
vpn_widget:set_font("Play 9")
--watch(
--    "ip addr show tun0", 2,
--    function(widget, stdout, stderr, exitreason, exitcode)
--    if(stdout == '' or stdout==nil or stdout=='Device "tun0" does not exist.') then
--        widget.text= "| Disconnected |"
--    else
--        widget.text= "| Connected | " 
--    end
--end,
--vpn_widget
--)
watch(
  "/homes/manjaro/giao/bin/opvn_status.sh", 3,
  function(widget, stdout, stderr, exitreason, exitcode)
    local vpn = string.sub(stdout,1,string.len(stdout)-1)
    if(vpn == '' or vpn == nil) then
      widget.text = ""
    else
      widget.text = " [" .. vpn .. "] "
    end
  end,
  vpn_widget
)
