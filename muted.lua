local wibox = require("wibox")
local awful = require("awful")
local naughty = require("awful")
local watch = require("awful.widget.watch")

muted_widget = wibox.widget.textbox()
watch(
	"amixer get Master", 5,
	function(widget, stdout, stderr, exitreason, exitcode)
		if(stdout == '' or stdout==nil) then
			widget.text = "| ERROR |"
		else
			widget.text =  string.sub(stdout,string.find(stdout, "%[off%]")).. " ||"
		end
	end,
	muted_widget )
