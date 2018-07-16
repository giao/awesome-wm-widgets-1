local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")

sound_widget = wibox.widget.textbox()
watch(
	"amixer -D pulse get Master", 2,
	function(widget, stdout, stderr, exitreason, exitcode)
		if(stdout == '' or stdout==nil) then
			widget.text = "| ERROR |"
		else
			widget.text = "|| " .. string.sub(stdout,string.find(stdout, "[0-9]+%%")).."  " .. string.sub(stdout, string.find(stdout, "%[%a+%]")) .. " ||"
		end
	end,
	sound_widget )
