-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
require("rodentbane")
vicious = require("vicious")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/usr/share/awesome/themes/obscur/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
--    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags ={
--   names  = { "term", "web", "chat", "video", 5, 6, 7, 8, 9 },
   names = { "☠", "☢", "☣", "☫", "☬", "☸", "⚔", "☿", "♐" },
   layout = { layouts[2], layouts[2], layouts[2], layouts[5], layouts[6],
              layouts[1], layouts[1], layouts[3], layouts[7]
}}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
				    { "firefox", "/usr/bin/firefox" },
   				    { "pidgin", "/usr/bin/pidgin" },
				    { "skype", "/usr/bin/skype" },
				    { "thunar", "thunar"},
   				    { "mcomix", "/usr/bin/mcomix" },	
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
require("blingbling")
-- Volume icon
  volicon = widget({ type = "imagebox" })
  volicon.image = image(beautiful.widget_vol)
-- Blingbling volume widget
  myvolumelabel = widget({ type = "textbox" })
  myvolumelabel.text='<span color ="#1793D1">Vol: </span>'
  myvolume=blingbling.volume.new()
  myvolume:set_height(18)
  myvolume:set_width(15)
  myvolume:set_v_margin(3)
  myvolume:update_master()
  myvolume:set_master_control()
  myvolume:set_bar(true)   
--  myvolume:set_show_text(true)
  myvolume:set_graph_color("#1793D1AA")
  myvolume:set_background_graph_color("#1793D199")
-- vicious.register(myvolume, vicious.widgets.volume, '<span color= "#1793D1">Vol: </span> $1, 0.5, Master')  

-- Initialize widget
--volwidget = widget({ type = "textbox" })
-- Register widget
--vicious.register(volwidget, vicious.widgets.volume, "$1 $2" , 2, "PCM")
--volwidget:buttons(awful.util.table.join(
--    awful.button({ }, 1, function () awful.util.spawn("amixer -q set Master toggle", false) end),
--    awful.button({ }, 3, function () awful.util.spawn("xterm -e alsamixer", true) end),
--    awful.button({ }, 4, function () awful.util.spawn("amixer -q set PCM 1dB+", false) end),
--    awful.button({ }, 5, function () awful.util.spawn("amixer -q set PCM 1dB-", false) end)
--))

-- Initialize widget
rootfswidget = widget({ type = "textbox"})
-- Register widget
vicious.register(rootfswidget, vicious.widgets.fs, '<span color = "#1793D1">ROOT:</span> ${/ used_gb}<span color = "#1793D1">GB</span>  | ${/ size_gb}<span color = "#1793D1">GB</span> :: <span color = "#1793D1">HOME:</span> ${/home used_gb}<span color = "#1793D1">GB</span> | ${/home size_gb}<span color = "#1793D1">GB</span>')

-- Initialize widget
gmailwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(gmailwidget, vicious.widgets.gmail, '<span color = "#1793D1">Unread:</span> ${count}', 121)
				   
-- Initialize widget
pacwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(pacwidget, vicious.widgets.pkg, '<span color = "#1793D1">Updates:</span> $1' , 600, "Arch")

-- Initialize widget
weatherwidget = widget({ type = "textbox"})
weather_t = awful.tooltip({ objects = { weatherwidget },})
--Register widget
vicious.register(weatherwidget, vicious.widgets.weather,
		function (widget, args)
		   weather_t:set_text("City: " .. args["{city}"] .. "\nWind: " .. args["{windmph}"] .. "mp/h " .. args["{wind}"] .. "\nSky: " .. args["{sky}"] .. "\nHumidity: " .. args["{humid}"] .. "%")
		   return args["{tempf}"] .. '<span color = "#1793D1">F</span>'
		end, 1800, "KLXT")

-- Initialize widget
oswidget = widget({ type = "textbox" })
-- Register widget
vicious.register(oswidget, vicious.widgets.os, '<span color = "#1793D1">OS:</span> $1 <span color = "#1793D1">$2</span> $4')

-- Initialize widget
uptimewidget = widget({ type = "textbox" })
-- Register widget
vicious.register(uptimewidget, vicious.widgets.uptime, '<span color = "#1793D1">UPTIME:</span> $1 <span color = "#1793D1">D</span> $2 <span color = "#1793D1">Hr</span> $3 <span color = "#1793D1">Min</span>', 61)

-- Initialize widget
mpdwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(mpdwidget, vicious.widgets.mpd,
	function (widget, args)
	   if args["{state}"] == "Stop" then
		return " - "
	   else
		return args["{Artist}"]..' - '.. args["{Title}"]
	   end
	end, 10)

-- Cpu widget
-- Initialize widget
cpuwidget = widget({ type = "textbox"})
vicious.cache(vicious.widgets.cpu)
-- Register widget
vicious.register(cpuwidget, vicious.widgets.cpu, '<span color = "#1793D1">CPU:</span> $1%', 13)

-- Network usage widget
-- Initialize widget
netwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(netwidget, vicious.widgets.net, '<span color ="#1793D1">${eth0 down_kb}</span> <span color="#CC9393">${eth0 up_kb}</span>', 3)

-- Separator
separator = widget({ type = "textbox" })
separator.text = " │ "

-- Memory widget
-- Initialize widget
memwidget = widget({ type = "textbox" })
vicious.cache(vicious.widgets.mem)
-- Register widget
vicious.register(memwidget, vicious.widgets.mem, '<span color = "#1793D1">MEM:</span> $2<span color = "#1793D1">MB</span>|$3<span color = "#1793D1">MB</span>', 13)

-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Calendar widget to attach to text clock
require('calendar2')
calendar2.addCalendarToWidget(mytextclock)

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
	separator , myvolume.widget,
	volicon,
	myvolumelabel,
	separator , weatherwidget,
	separator , gmailwidget,
	separator , pacwidget, separator,
        s == 1 and mysystray or nil,
	mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end

    -- Create statusbar
    mystatusbar = awful.wibox({ position = "bottom" , screen = s})
    -- Add widgets to the status bar
    mystatusbar.widgets={
	{
	    separator , oswidget,
	    separator , rootfswidget,
	    layout = awful.widget.layout.horizontal.leftright
	},
	separator , memwidget,
	separator , netwidget,
	separator , cpuwidget,
	separator , uptimewidget,
	separator , mpdwidget,
	layout = awful.widget.layout.horizontal.rightleft
    }  
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
--  awful.button({ }, 2, function (c) c:kill()            end),
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),
    awful.key({ modkey, "a"       }, "q",     function () awful.util.spawn("firefox")   end),
    awful.key({ modkey, "a"       }, "c",     function () awful.util.spawn("chromium")  end), 
    awful.key({ modkey,           }, "u",     function () awful.util.spawn("uzbl-tabbed") end),
    awful.key({ modkey,           }, "b",     function () rodentbane.start()            end),
    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
		     size_hints_honor = false } },
    { rule = { class = "MPlayer" },
      properties = { tag = tags[1][4], floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][2], switchtotag = true } },
    {rule = { class = "Chromium"},
      properties = { tag = tags[1][2] } },
    {rule = { class = "uzbl"},
      properties = { tag = tags[1][2] } } ,
    {rule = { class = "Ncmpc++" , instance = "urxvtd"},
      properties = { tag = tags[1][1] } },
    {rule = { class = "htop" , instance = "urxvtd"},
      properties = { tag = tags[1][1] } },
    {rule = { class = "Pidgin"},
      properties = { tag = tags[1][3] } },
    {rule = { name = "finch" , instance = "urxvt"},
      properties = { tag = tags[1][3] } },
    { rule = { instance = "plugin-container" },
      properties = { floating = true } },
}

-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
