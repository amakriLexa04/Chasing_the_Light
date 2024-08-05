-- #textdomain wesnoth-chasing_the_light

local T = wml.tag
local wml_actions = wesnoth.wml_actions
local _ = wesnoth.textdomain "wesnoth-chasing_the_light"
local utils = wesnoth.require "wml-utils"

function wml_actions.caves_map(cfg)

	local map_wml = wml.load "~add-ons/Chasing_the_Light/gui/map.cfg"
	
	local character_selection_dialog = wml.load "campaigns/tutorial/gui/character_selection.cfg"
	local dialog_wml = wml.get_child(map_wml, 'resolution')

	local result = wesnoth.sync.evaluate_single(function()
		return { value = gui.show_dialog(dialog_wml) }
	end)

	wesnoth.redraw {}
end