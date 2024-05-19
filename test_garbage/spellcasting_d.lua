local _ = wesnoth.textdomain "wesnoth-tdg"


-- to make code shorter
local wml_actions = wesnoth.wml_actions

-- metatable for GUI tags
local T = wml.tag

-- helpful debug function for printing a table
function tprint (tbl, indent)
	if not indent then indent = 0 end
	local toprint = string.rep(" ", indent) .. "{\r\n"
	indent = indent + 2 
	for k, v in pairs(tbl) do
		toprint = toprint .. string.rep(" ", indent)
		if (type(k) == "number") then
			toprint = toprint .. "[" .. k .. "] = "
		elseif (type(k) == "string") then
			toprint = toprint  .. k ..  "= "   
		end
		if (type(v) == "number") then
			toprint = toprint .. v .. ",\r\n"
		elseif (type(v) == "string") then
			toprint = toprint .. "\"" .. v .. "\",\r\n"
		elseif (type(v) == "table") then
			toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
		else
			toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
		end
	end
	toprint = toprint .. string.rep(" ", indent-2) .. "}"
	return toprint
end



























--###########################################################################################################################################################
--                                                                  DEFINE SKILLS
--###########################################################################################################################################################
function label(text)     return "<span size='1000'> \n</span><span size='large'>"..text.."</span><span size='8000'>\n </span>"  end
local skills = {
	--###############################
	-- GROUP 0 SKILLS
	--###############################
	[0] = {
		-------------------------
		-- MAGIC MISSILE
		-------------------------
		[1] = {
			id          = "skill_magic_missile_d",
			label       = label(_"Magic Missile"),
			image       = "attacks/magic-missile.png",
			description = _"<span color='#ad6a61'><i><b>Attack:</b></i></span> Ranged 7x3 fire, <i>magical</i>.",
		},
		
	},
	--###############################
	-- GROUP 1 SKILLS
	--###############################
	[1] = {
		
		-------------------------
		-- LEVITATE
		-------------------------
		[2] = {
			id          = "skill_levitate_d",
			label       = label(_"Levitate"),
			image       = "icons/levitate.png",
			description = _"<span color='#6ca364'><i><b>Spell:</b></i></span> Spend <span color='#00bbe6'><i>8xp</i></span> to gain <i>flight</i> and the <i>skirmisher</i> ability until the start of your next turn or until cancelled.",
			xp_cost=8, --XP=8 is also used in S04
		},
		
	},		

}
--###############################
-- LOCKED INDICATOR
--###############################
local locked = {
	id          = "skill_locked",
	label       = label("<span color='grey'>Locked</span>"),
	image       = "icons/locked.png", 
	description = "<span color='grey'>This option is not available yet.</span>",
}






























--###########################################################################################################################################################
--                                                                  SKILL DIALOG
--###########################################################################################################################################################
function display_skills_dialog(selecting)
	local result_table = {} -- table used to return selected skills
	local daeola   = ( wesnoth.units.find_on_map({ id="daeola"      }) )[1]
	local apprentice = ( wesnoth.units.find_on_map({ type="daeola L1" }) )[1]
	
	--###############################
	-- CREATE DIALOG
	--###############################
	local dialog = {
		T.helptip{ id="tooltip_large" }, -- mandatory field
		T.tooltip{ id="tooltip_large" }, -- mandatory field
		T.grid{} }
	local grid = dialog[3]
	
	-------------------------
	-- HEADER
	-------------------------
	local spacer = "                                                                  "
	local                title_text = selecting and _"Select Daeola’s Spells"       or _"Cast Daeola’s Spells"
	if (apprentice) then title_text = selecting and _"Select The Apprentice’s Spells" or _"Cast The Apprentice’s Spells" end
	table.insert( grid[2], T.row{ T.column{ T.label{
		definition="title",
		horizontal_alignment="center",
		label = spacer..title_text..spacer,
	}}} )
	local                help_text = _"<span size='2000'> \n</span><span size='small'><i>Daeola knows many useful spells, and will learn more as he levels-up automatically throughout the campaign. Daeola does not use XP to level-up.\nInstead, Daeola uses XP to cast certain spells. If you select spells that cost XP, <b>double-click on Daeola to cast them</b>. You can only cast 1 spell per turn.</i></span>"
	if (apprentice) then help_text = _"<span size='2000'> \n</span><span size='small'><i>The apprentice knows several useful spells, and will learn more as he levels-up automatically throughout the campaign. The apprentice does not use XP to level-up.\nInstead, he uses XP to cast certain spells. If you select spells that cost XP, <b>double-click on the apprentice to cast them</b>. You can only cast 1 spell per turn.</i></span>" end
	table.insert( grid[2], T.row{ T.column{T.label{ use_markup=true, label=help_text }}} )
	table.insert( grid[2], T.row{ T.column{T.label{label="  "}}} )
	
	-------------------------
	-- SKILL GROUPS
	-------------------------
	-- each button/image/label id ends with the index of the skill group it corresponds to
	-- put all these in 1 big grid, so they can have their own table-layout
	local skill_grid = T.grid{}
	for i=0,#skills,1 do if (i>daeola.level) then skills[i]=nil end end -- don't show skill groups if underleveled
	for i=0,#skills,1 do
		-- lock skills
		for j=1,#skills[i],1 do
			if (not wml.variables[ "unlock_"..string.sub(skills[i][j].id,7,-1) ]) then skills[i][j]=locked end
		end
		
		local button
		local subskill_row
		if (selecting) then
			-- menu button for selecting skills
			button = T.menu_button{  id="button"..i, use_markup=true  }
			for j=1,#skills[i],1 do
				table.insert( button[2], T.option{label=skills[i][j].label} )
			end
		else -- button for casting spells, or label for displaying skills
			for j=1,#skills[i],1 do
				local skill = skills[i][j]
				if (wml.variables[skill.id]) then
					if (not skill.xp_cost) then button=T.label{  id="button"..i, use_markup=true, label=skill.label }
					else                        button=T.button{ id="button"..i, use_markup=true, label=skill.label } end
					-- handle one skill with multiple buttons
					if (skill.subskills) then
						subskill_row = T.row{}
						for k=1,#skill.subskills,1 do
							local subskill = skill.subskills[k]
							table.insert( subskill_row[2], T.column{T.button{id=subskill.id,use_markup=true,label=subskill.label}} );
						end
					end
				end
			end
			if (not button) then button=T.label{id="button"..i} end -- dummy button
		end
		
		-- skill row
		table.insert( skill_grid[2], T.row{ 
			T.column{button},
			T.column{T.label{label="  "}},  T.column{  horizontal_alignment="left", T.image{id="image"..i                }  },
			T.column{T.label{label="  "}},  T.column{  horizontal_alignment="left", T.label{id="label"..i,use_markup=true}  },
		} )
		
		-- subskill row
		if (subskill_row) then table.insert( skill_grid[2], T.row{ 
			T.column{T.label{}}, T.column{T.label{}},
			T.column{T.label{}}, T.column{T.label{}},
			T.column{T.grid{subskill_row}},
		} ) end
		
		-- spacer row
		table.insert( skill_grid[2], T.row{ 
			T.column{T.label{label="  "}},
			T.column{T.label{}}, T.column{T.label{}},
			T.column{T.label{}}, T.column{T.label{}}
		} )
		::continue::
	end
	table.insert( grid[2], T.row{T.column{ horizontal_alignment="left", skill_grid }} )
	
	-------------------------
	-- CONFIRM BUTTON
	-------------------------
	table.insert( grid[2], T.row{ T.column{T.label{label="  "}}} )
	table.insert( grid[2], T.row{  T.column{  T.button{
		id="confirm_button", use_markup=true, return_value=1,
		label=(selecting and _"Confirm Spells <small><i>(can be changed every scenario)</i></small>" or "Cancel"),
	}}})
	
	
	
	
	
	--###############################
	-- POPULATE DIALOG
	--###############################
	-------------------------
	-- PRESHOW
	-------------------------
	local function preshow(dialog)
		-- for the button corresponding to each skill group
		for i,group in pairs(skills) do
			button = dialog["button"..i]
			
			-- menu callbacks for selecting skills
			if (selecting) then
				-- default to whatever skill we had selected last time
				for j,skill in pairs(skills[i]) do
					if (wml.variables[skill.id]) then button.selected_index=j end
				end
				
				-- whenever we refresh the menu, update the image and label
				refresh = function(button)
					if (not skills[i][1]) then return end
					dialog["image"..i].label = skills[i][button.selected_index].image
					dialog["label"..i].label = skills[i][button.selected_index].description
					
					-- also update variables
					for j,skill in pairs(skills[i]) do
						result_table[skill.id] = (j==button.selected_index) and "yes" or "no"
						if (skill.id=="skill_locked") then result_table[skill.id]="no" end
					end
				end
				
				-- refresh immediately, and after any change
				refresh(button)
				button.on_modified = refresh
			
			-- fixed labels for casting/displaying skills/spells
			else dialog["button"..i].visible = false
				for j,skill in pairs(skills[i]) do
					if (not wml.variables[skill.id]) then goto continue end
					
					-- if we know this skill, reveal and initialize the UI
					dialog["button"..i].visible = true
					dialog["image" ..i].label = skill.image
					dialog["label" ..i].label = skill.description
					
					-- if the button is clickable (i.e. a castable spell), set on_button_click
					local function initialize_button( buttonid, skill, small )
						if (dialog[buttonid].type=="button") then
							-- cancel spell
							local function daeola_has_object(object_id) return wesnoth.units.find_on_map{ id='daeola', T.filter_wml{T.modifications{T.object{id=object_id}}} }[1] end
							if (daeola_has_object(skill.id)) then
								dialog[buttonid].label = small and "<span size='small'>Cancel</span>" or label('Cancel')
								dialog[buttonid].on_button_click = function()
									wml.variables['skill_id'] = skill.id.."_cancel"
									gui.widget.close(dialog)
								end
							
							-- errors (extra spaces are to center the text)
							elseif (wml.variables['spellcasted_this_turn']) then
								dialog[buttonid].label = small and _"<span size='small'>1 spell/turn</span>" or _"<span> Can only cast\n1 spell per turn</span>"
								dialog[buttonid].enabled = false
							elseif (not (daeola.race=='human')) then
								dialog[buttonid].label = small and _"<span size='small'>Polymorphed</span>" or _"<span>  Blocked by\n  Polymorph</span>"
								dialog[buttonid].enabled = false
							elseif (wesnoth.units.find_on_map{ id='daeola', T.filter_location{radius=3, T.filter{id='daeola_mirror3'}} }[1]) then   -- mirror daeola counterspell
								dialog[buttonid].label = small and _"<span size='small'>Counterspelled</span>" or _"<span>  Blocked by\n Counterspell</span>"
								dialog[buttonid].enabled = false
							elseif (wml.variables['counterspell_active']) then -- daeola counterspell
								dialog[buttonid].label = small and _"<span size='small'>Counterspelled</span>" or _"<span>  Blocked by\n Counterspell</span>"
								dialog[buttonid].enabled = false
							
							elseif (skill.xp_cost and skill.xp_cost>daeola.experience) then
								dialog[buttonid].label = small and _"<span size='small'>No XP</span>" or label('Insufficient XP')
								dialog[buttonid].enabled = false
							elseif (skill.atk_cost and skill.atk_cost>daeola.attacks_left) then
								dialog[buttonid].label = small and _"<span size='small'>No Attack</span>" or label('No Attack')
								dialog[buttonid].enabled = false
							
							-- cast spell
							else
								dialog[buttonid].on_button_click = function()
									if (skill.xp_cost)  then daeola.experience  =daeola.experience  -skill.xp_cost  end
									if (skill.atk_cost) then daeola.attacks_left=daeola.attacks_left-skill.atk_cost end
									wml.variables['skill_id'] = skill.id
									wml.variables['spellcasted_this_turn'] = skill.id
									gui.widget.close(dialog)
								end
							end
						end
					end
					initialize_button("button"..i, skill);
					
					-- if this skill has subskills, initialize each button
					if (skill.subskills) then
						for k,subskill in pairs(skill.subskills) do
							initialize_button(subskill.id, subskill, true);
						end
					end
					::continue::
				end
			end
			
		end
	end
	
	-------------------------
	-- SHOW DIALOG
	-------------------------
	wml.variables['skill_id'] = nil
	wesnoth.interface.select_unit() -- deselect daeola
	
	-- select spell, synced
	if (selecting) then
		dialog_result = wesnoth.sync.evaluate_single(function()
			gui.show_dialog( dialog, preshow )
			return result_table;
		end)
		for skill_id,skill_value in pairs(dialog_result) do wml.variables[skill_id]=skill_value end
	
	-- cast spells, synced
	else
		dialog_result = wesnoth.sync.evaluate_single(function()
			gui.show_dialog( dialog, preshow )
			if (wml.variables['skill_id']) then wesnoth.game_events.fire('cast_skill_synced', daeola.x, daeola.y) end
			wml.variables['skill_id'] = nil
		end)
	end
end




























--###########################################################################################################################################################
--                                                                      "MAIN"
--###########################################################################################################################################################
-------------------------
-- DEFINE WML TAGS
-------------------------
function wml_actions.select_daeola_skills(cfg)
	display_skills_dialog(true)
end

-------------------------
-- DETECT DOUBLECLICKS
-------------------------
local last_click = os.clock()
wesnoth.game_events.on_mouse_action = function(x,y)
	local selected_unit = wesnoth.units.find_on_map{ x=x, y=y }
	if (not selected_unit[1] or selected_unit[1].id~='daeola') then return end
	if (wml.variables['is_during_attack']) then return end
	if (wml.variables['not_player_turn'] ) then return end
	
	if (os.clock()-last_click<0.25) then
		wesnoth.audio.play("miss-2.ogg")
		if (wml.variables['no_spellcasting_event_d']) then
			wesnoth.game_events.fire(wml.variables['no_spellcasting_event_d'], x, y)
		else
			display_skills_dialog()
		end
		last_click = 0 -- prevent accidentally immediately re-opening the dialog
	else
		last_click = os.clock()
	end
end

-------------------------
-- DETECT MOUSEMOVES
-------------------------
function wml_actions.listen_for_mousemove(cfg)
	wesnoth.game_events.on_mouse_move = function(x,y)
		 wesnoth.game_events.fire('mousemove_synced', x, y)
		 wesnoth.game_events.on_mouse_move = nil --only trigger once
	end
end


