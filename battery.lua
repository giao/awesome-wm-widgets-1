local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")

local path_to_icons = "/path/to/icon/folder/"

battery_widget = wibox.widget { 
    {
        id = "icon",
        widget = wibox.widget.imagebox, 
        resize = false
    },
    layout = wibox.container.margin(brightness_icon, 0, 0, 3),
    set_image = function(self, path)
        self.icon.image = path
    end
}

battery_popup = awful.tooltip({objects = {battery_widget}})


         
watch(
   "acpi", 2,
         function(widget, stdout, stderr, exitreason, exitcode)
        local batteryType
        local _, status, charge_str, time = string.match(stdout, '(.+): (%a+), (%d?%d%d)%%,? ?.*')
        local charge = tonumber(charge_str)
        if (charge >= 0 and charge <= 2 and status ~= 'Charging') then
            batteryType="battery-empty%s-symbolic"
            show_battery_warning(tonumber(charge_str))
        elseif (charge >= 0 and charge < 15 and status ~= 'Charging') then 
            batteryType="battery-empty%s-symbolic"
            --show_battery_warning(charge_str)
        elseif (charge >= 15 and charge < 40) then batteryType="battery-caution%s-symbolic"
        elseif (charge >= 40 and charge < 60) then batteryType="battery-low%s-symbolic"
	    elseif (charge >= 60 and charge < 80) then batteryType="battery-good%s-symbolic"
        elseif (charge >= 80 and charge <= 100) then batteryType="battery-full%s-symbolic"
        end
            
         if status == 'Charging' or status == 'Unknown' then 
            batteryType = string.format(batteryType,'-charging')
         else
            batteryType = string.format(batteryType,'')
         end
         widget.image = path_to_icons .. batteryType ..".svg"
         battery_popup.text = string.gsub(stdout, "\n$", "")
end,
         
battery_widget
)
function show_battery_warning(Value)
    naughty.notify{
    icon = "/path/to/charge_me/icon",
    icon_size=100,
    text = "Please feed me by connecting me to the next available socket!\n"..Value .. "% left!",
    title = "I am hungry!",
    timeout = 1, hover_timeout = 0.5,
    position = "top_right",
    bg = "#FF0000",
    fg = "#EEE9EF",
    width = 500,
}
end
