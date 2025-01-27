-- #textdomain wesnoth-ctl

local T = wml.tag
local wml_actions = wesnoth.wml_actions
local _ = wesnoth.textdomain "Chasing_the_Light"
local utils = wesnoth.require "wml-utils"

function wml_actions.caves_map(cfg)

	local map_wml = wml.load "~add-ons/Chasing_the_Light/gui/map.cfg"
	
	local map_window = wml.load("~add-ons/Chasing_the_Light/gui/widget/window_transparent.cfg")
    gui.add_widget_definition("window", "transparent", wml.get_child(map_window, 'window_definition'))
	
	local character_selection_dialog = wml.load "campaigns/tutorial/gui/character_selection.cfg"
	local dialog_wml = wml.get_child(map_wml, 'resolution')

	local result = wesnoth.sync.evaluate_single(function()
		return { value = gui.show_dialog(dialog_wml) }
	end)

	wesnoth.redraw {}
end