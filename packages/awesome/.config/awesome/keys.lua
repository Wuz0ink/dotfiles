--      ██╗  ██╗███████╗██╗   ██╗███████╗
--      ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔════╝
--      █████╔╝ █████╗   ╚████╔╝ ███████╗
--      ██╔═██╗ ██╔══╝    ╚██╔╝  ╚════██║
--      ██║  ██╗███████╗   ██║   ███████║
--      ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝


-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Define mod keys
local modkey = "Mod4"
local altkey = "Mod1"

-- define module table
local keys = {}


-- ===================================================================
-- Movement Functions (Called by some keybinds)
-- ===================================================================

-- Resize client in given direction
local floating_resize_amount = dpi(20)
local tiling_resize_factor = 0.05

local function resize_client(c, direction)
   if awful.layout.get(mouse.screen) == awful.layout.suit.floating or (c and c.floating) then
      if direction == "up" then
         c:relative_move(0, 0, 0, -floating_resize_amount)
      elseif direction == "down" then
         c:relative_move(0, 0, 0, floating_resize_amount)
      elseif direction == "left" then
         c:relative_move(0, 0, -floating_resize_amount, 0)
      elseif direction == "right" then
         c:relative_move(0, 0, floating_resize_amount, 0)
      end
   else
      if direction == "up" then
         awful.client.incwfact(-tiling_resize_factor)
      elseif direction == "down" then
         awful.client.incwfact(tiling_resize_factor)
      elseif direction == "left" then
         awful.tag.incmwfact(-tiling_resize_factor)
      elseif direction == "right" then
         awful.tag.incmwfact(tiling_resize_factor)
      end
   end
end


-- raise focused client
local function raise_client()
   if client.focus then
      client.focus:raise()
   end
end


-- ===================================================================
-- Mouse bindings
-- ===================================================================


-- Mouse buttons on the desktop
keys.desktopbuttons = gears.table.join(
   -- left click on desktop to hide notification
   awful.button({}, 1,
      function ()
         naughty.destroy_all_notifications()
      end
   )
)

-- Mouse buttons on the client
keys.clientbuttons = gears.table.join(
   -- Raise client
   awful.button({}, 1,
      function(c)
         client.focus = c
         c:raise()
      end
   ),

   -- Move and Resize Client
   awful.button({modkey}, 1, awful.mouse.client.move),
   awful.button({modkey}, 3, awful.mouse.client.resize)
)


-- ===================================================================
-- Desktop Key bindings
-- ===================================================================


keys.globalkeys = gears.table.join(
   -- =========================================
   -- SPAWN APPLICATION KEY BINDINGS
   -- =========================================

   -- Spawn terminal
   awful.key({modkey, "Shift"}, "Return",
      function()
         awful.spawn(apps.terminal)
      end,
      {description = "open a terminal", group = "launcher"}
   ),
   -- Spawn browser
   awful.key({modkey, "Shift"}, "p",
      function()
         awful.spawn(apps.browser)
      end,
      {description = "open a browser", group = "launcher"}
   ),
   -- launch rofi
   awful.key({modkey}, "d",
      function()
         awful.spawn(apps.launcher)
      end,
      {description = "application launcher", group = "launcher"}
   ),
   -- launch rofi (p)
   awful.key({modkey}, "p",
      function()
         awful.spawn("rofi -show drun")
      end,
      {description = "application launcher", group = "launcher"}
   ),

   -- =========================================
   -- FUNCTION KEYS
   -- =========================================

   -- Brightness
   awful.key({}, "XF86MonBrightnessUp",
      function()
         awful.spawn("xbacklight -inc 10", false)
      end,
      {description = "+10%", group = "hotkeys"}
   ),
   awful.key({}, "XF86MonBrightnessDown",
      function()
         awful.spawn("xbacklight -dec 10", false)
      end,
      {description = "-10%", group = "hotkeys"}
   ),

   -- ALSA volume control
   awful.key({}, "XF86AudioRaiseVolume",
      function()
         awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%", false)
         awesome.emit_signal("volume_change")
      end,
      {description = "volume up", group = "hotkeys"}
   ),
   awful.key({}, "XF86AudioLowerVolume",
      function()
         awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%", false)
         awesome.emit_signal("volume_change")
      end,
      {description = "volume down", group = "hotkeys"}
   ),
   awful.key({}, "XF86AudioMute",
      function()
         awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle", false)
         awesome.emit_signal("volume_change")
      end,
      {description = "toggle mute", group = "hotkeys"}
   ),
   awful.key({}, "XF86AudioNext",
      function()
         awful.spawn("playerctl next", false)
      end,
      {description = "next music", group = "hotkeys"}
   ),
   awful.key({}, "XF86AudioPrev",
      function()
         awful.spawn("playerctl previous", false)
      end,
      {description = "previous music", group = "hotkeys"}
   ),
   awful.key({}, "XF86AudioPlay",
      function()
         awful.spawn("playerctl play-pause", false)
      end,
      {description = "play/pause music", group = "hotkeys"}
   ),

   -- Switch keyboard layout
   awful.key({modkey}, "space",
      function()
         awful.spawn("bash -c $HOME/.local/bin/toggle-layout.sh", false)
      end,
      {description = "play/pause music", group = "hotkeys"}
   ),

   -- Toggle systray
   awful.key({modkey}, "=",
      function()
         awful.screen.focused().systray.visible = not awful.screen.focused().systray.visible
      end,
      {description = "play/pause music", group = "hotkeys"}
   ),
   -- Screenshot on prtscn using scrot
   awful.key({}, "Print",
      function()
         awful.util.spawn(apps.screenshot, false)
      end
   ),

   awful.key({modkey}, "Print",
      function()
         awful.util.spawn(apps.screenshot_mod, false)
      end
   ),

   -- =========================================
   -- RELOAD / QUIT AWESOME
   -- =========================================

   -- Reload Awesome
   awful.key({modkey, "Shift"}, "r",
      awesome.restart,
      {description = "reload awesome", group = "awesome"}
   ),

   -- Quit Awesome
   awful.key({modkey}, "Escape",
      function()
         -- emit signal to show the exit screen
         awesome.emit_signal("show_exit_screen")
      end,
      {description = "toggle exit screen", group = "hotkeys"}
   ),

   awful.key({}, "XF86PowerOff",
      function()
         -- emit signal to show the exit screen
         awesome.emit_signal("show_exit_screen")
      end,
      {description = "toggle exit screen", group = "hotkeys"}
   ),

   -- =========================================
   -- CLIENT FOCUSING
   -- =========================================

   -- Focus client by direction (hjkl keys)
   awful.key({ modkey }, "j", function ()
     awful.client.focus.byidx( 1)
   end),

   awful.key({ modkey }, "k", function ()
     awful.client.focus.byidx(-1)
   end),
   -- Focus client by direction (hjkl keys)

   -- Focus client by index (cycle through clients)
   awful.key({modkey}, "Tab",
      function()
         awful.client.focus.byidx(1)
      end,
      {description = "focus next by index", group = "client"}
   ),
   awful.key({modkey, "Shift"}, "Tab",
      function()
         awful.client.focus.byidx(-1)
      end,
      {description = "focus previous by index", group = "client"}
   ),

   -- =========================================
   -- TAG FOCUSING
   -- =========================================

   -- Focus previous tag
   awful.key({modkey}, "Tab",
      function()
         awful.tag.history.restore(mouse.screen)
      end
   ),
   -- =========================================
   -- SCREEN FOCUSING
   -- =========================================

   -- Focus screen by index (cycle through screens)
   awful.key({modkey}, "s",
      function()
         awful.screen.focus_relative(1)
      end
   ),

   -- =========================================
   -- CLIENT RESIZING
   -- =========================================

   awful.key({modkey, "Control"}, "Down",
      function(c)
         resize_client(client.focus, "down")
      end
   ),
   awful.key({modkey, "Control"}, "Up",
      function(c)
         resize_client(client.focus, "up")
      end
   ),
   awful.key({modkey, "Control"}, "Left",
      function(c)
         resize_client(client.focus, "left")
      end
   ),
   awful.key({modkey, "Control"}, "Right",
      function(c)
         resize_client(client.focus, "right")
      end
   ),
   awful.key({modkey, "Control"}, "j",
      function(c)
         resize_client(client.focus, "down")
      end
   ),
   awful.key({ modkey, "Control" }, "k",
      function(c)
         resize_client(client.focus, "up")
      end
   ),
   awful.key({modkey, "Control"}, "h",
      function(c)
         resize_client(client.focus, "left")
      end
   ),
   awful.key({modkey, "Control"}, "l",
      function(c)
         resize_client(client.focus, "right")
      end
   ),

   -- =========================================
   -- NUMBER OF MASTER / COLUMN CLIENTS
   -- =========================================

   -- Number of master clients
   awful.key({modkey, altkey}, "h",
      function()
         awful.tag.incnmaster( 1, nil, true)
      end,
      {description = "increase the number of master clients", group = "layout"}
   ),
   awful.key({ modkey, altkey }, "l",
      function()
         awful.tag.incnmaster(-1, nil, true)
      end,
      {description = "decrease the number of master clients", group = "layout"}
   ),
   awful.key({ modkey, altkey }, "Left",
      function()
         awful.tag.incnmaster( 1, nil, true)
      end,
      {description = "increase the number of master clients", group = "layout"}
   ),
   awful.key({ modkey, altkey }, "Right",
      function()
         awful.tag.incnmaster(-1, nil, true)
      end,
      {description = "decrease the number of master clients", group = "layout"}
   ),

   -- Number of columns
   awful.key({modkey, altkey}, "k",
      function()
         awful.tag.incncol(1, nil, true)
      end,
      {description = "increase the number of columns", group = "layout"}
   ),
   awful.key({modkey, altkey}, "j",
      function()
         awful.tag.incncol(-1, nil, true)
      end,
      {description = "decrease the number of columns", group = "layout"}
   ),
   awful.key({modkey, altkey}, "Up",
      function()
         awful.tag.incncol(1, nil, true)
      end,
      {description = "increase the number of columns", group = "layout"}
   ),
   awful.key({modkey, altkey}, "Down",
      function()
         awful.tag.incncol(-1, nil, true)
      end,
      {description = "decrease the number of columns", group = "layout"}
   ),

   -- =========================================
   -- GAP CONTROL
   -- =========================================

   -- Gap control
   awful.key({modkey, "Shift"}, "minus",
      function()
         awful.tag.incgap(5, nil)
      end,
      {description = "increment gaps size for the current tag", group = "gaps"}
   ),
   awful.key({modkey}, "minus",
      function()
         awful.tag.incgap(-5, nil)
      end,
      {description = "decrement gap size for the current tag", group = "gaps"}
   ),

   -- =========================================
   -- LAYOUT SELECTION
   -- =========================================

   -- select next layout
   -- awful.key({modkey}, "space",
   --    function()
   --       awful.layout.inc(1)
   --    end,
   --    {description = "select next", group = "layout"}
   -- ),
   -- select previous layout
   awful.key({modkey, "Shift"}, "space",
      function()
         awful.layout.inc(-1)
      end,
      {description = "select previous", group = "layout"}
   ),

   -- =========================================
   -- CLIENT MINIMIZATION
   -- =========================================

   -- restore minimized client
   awful.key({modkey, "Shift"}, "n",
      function()
         local c = awful.client.restore()
         -- Focus restored client
         if c then
            client.focus = c
            c:raise()
         end
      end,
      {description = "restore minimized", group = "client"}
   )
)


-- ===================================================================
-- Client Key bindings
-- ===================================================================


keys.clientkeys = gears.table.join(

   awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
   awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),

   -- toggle fullscreen
   awful.key({modkey}, "f",
      function(c)
         c.fullscreen = not c.fullscreen
      end,
      {description = "toggle fullscreen", group = "client"}
   ),

   -- close client
   awful.key({modkey}, "q",
      function(c)
         c:kill()
      end,
      {description = "close", group = "client"}
   ),

   -- Minimize
   awful.key({modkey}, "n",
      function(c)
         c.minimized = true
      end,
      {description = "minimize", group = "client"}
   ),

   -- Maximize
   awful.key({modkey}, "m",
      function(c)
         c.maximized = not c.maximized
         c:raise()
      end,
      {description = "(un)maximize", group = "client"}
   )
)

-- Bind all key numbers to tags
for i = 1, 9 do
   keys.globalkeys = gears.table.join(keys.globalkeys,
      -- Switch to tag
      awful.key({modkey}, "#" .. i + 9,
         function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
               tag:view_only()
            end
         end,
         {description = "view tag #"..i, group = "tag"}
      ),
      -- Move client to tag
      awful.key({modkey, "Shift"}, "#" .. i + 9,
         function()
            if client.focus then
               local tag = client.focus.screen.tags[i]
               if tag then
                  client.focus:move_to_tag(tag)
               end
            end
         end,
         {description = "move focused client to tag #"..i, group = "tag"}
      )
   )
end

return keys
