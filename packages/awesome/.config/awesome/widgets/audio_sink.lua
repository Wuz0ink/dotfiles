local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require("widgets.clickable-container")

local audio_sink_widget = wibox.widget {
    widget = wibox.widget.textbox,
    text = "󰓃",
    align = "center",
    valign = "center"
}

local function update_sink()
    awful.spawn.easy_async_with_shell([[
        default_sink=$(pactl info | grep "Default Sink" | cut -d ":" -f2 | xargs)
        pactl list sinks | awk -v sink="$default_sink" '
        $0 ~ "Name: "sink {
                found=1
            }
            found && $0 ~ "Description:" {
                desc = substr($0, index($0, "Description:") + length("Description:") + 1)
                print desc
                exit
            }
        '
    ]], function(stdout)
        local description = stdout:gsub("\n", ""):gsub("^%s+", ""):gsub("%s+$", "")
        audio_sink_widget.tooltip.text = "" .. (description ~= "" and description or "Okänd")
    end)
end

audio_sink_widget.tooltip = awful.tooltip {
    objects = { audio_sink_widget },
    timer_function = function()
        return audio_sink_widget.tooltip.text
    end
}



local function change_audio_sink()
    awful.spawn.easy_async_with_shell([[
        pactl list sinks | awk '
            BEGIN { RS = ""; FS = "\n" }
            {
                desc = ""; name = ""
                for (i = 1; i <= NF; i++) {
                    if ($i ~ /Name:/) {
                        name = $i
                        sub(/^.*Name: /, "", name)
                    }
                    if ($i ~ /Description:/) {
                        desc = $i
                        sub(/^.*Description: /, "", desc)
                    }
                }
                if (desc != "" && name != "")
                    print desc "|" name
            }
        '
    ]], function(stdout)
        local description_to_name = {}
        local descriptions = {}

        for line in stdout:gmatch("[^\r\n]+") do
            local desc, name = line:match("^(.-)%s*|%s*(.+)$")
            if desc and name then
                description_to_name[desc] = name
                table.insert(descriptions, desc)
            end
        end

        -- Format descriptions to feed into rofi
        local choices = table.concat(descriptions, "\n")

        awful.spawn.easy_async_with_shell(string.format("echo '%s' | rofi -dmenu -p 'Select Audio Output:'", choices), function(selected)
            selected = selected:gsub("\n", "")
            local sink_name = description_to_name[selected]
            if sink_name then
                awful.spawn("pactl set-default-sink " .. sink_name, false)
            end
        end)
    end)
end

local clickable_widget = clickable_container(wibox.container.margin(audio_sink_widget, dpi(7), dpi(7), dpi(7), dpi(7)))

clickable_widget:buttons(
    gears.table.join(
        awful.button({}, 1, nil, function()
            change_audio_sink()
        end)
    )
)

update_sink()

return clickable_widget

