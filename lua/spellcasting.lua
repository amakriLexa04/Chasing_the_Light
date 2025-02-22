local _ = wesnoth.textdomain "wesnoth-ctl"

local caster_data = wesnoth.dofile(wml.variables["path_to_casters"])
local casters = caster_data.casters
local locked = caster_data.locked

local selected_unit_id
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

function deep_copy(original)
    local copy = {}
    for g, v in pairs(original) do
        if type(v) == "table" then
            copy[g] = deep_copy(v)
        else
            copy[g] = v
        end
    end
    return copy
end


--###########################################################################################################################################################
--                                                                  SKILL DIALOG
--###########################################################################################################################################################
function display_skills_dialog(selecting)
	local result_table = {} -- table used to return selected skills
	
	--###############################
	-- CREATE DIALOG
	--###############################
	local dialog = {
	    definition="menu",
		T.helptip{ id="tooltip_large" }, -- mandatory field
		T.tooltip{ id="tooltip_large" }, -- mandatory field
		T.grid{} }
	local grid = dialog[3]
	
	
	for k=0,#casters,1 do
	if (casters[k].id == selected_unit_id) then
	
		local caster   = ( wesnoth.units.find_on_map({ id=casters[k].id      }) )[1]
		local skills_copy = deep_copy(casters[k].spell_table)
	
	-------------------------
	-- HEADER
	-------------------------
	table.insert( grid[2], T.row{ T.column{ border="bottom", border_size=15, T.image{  label="icons/banner1.png"  }}} )
	local spacer = "                                                                  "
<<<<<<< Updated upstream
	local                title_text = selecting and casters[k].title_select       or casters[k].title_cast
	
	table.insert( grid[2], T.row{ T.column{ T.label{
		definition="title",
		horizontal_alignment="center",
		label = spacer..title_text..spacer,
	}}} )
	local                help_text = casters[k].description
	table.insert( grid[2], T.row{ T.column{T.label{ use_markup=true, label=help_text }}} )
	table.insert( grid[2], T.row{ T.column{T.label{label="  "}}} )
=======
	local                title_text = selecting and wml.variables["caster_" .. selected_unit_id .. ".u_title_select"]  or wml.variables["caster_" .. selected_unit_id .. ".u_title_cast"]
	table.insert( grid[2], T.row{ T.column{ T.label{
        definition="title",
        horizontal_alignment="center",
        label = spacer..title_text..spacer,
    }}} )
	local                help_text = wml.variables["caster_" .. selected_unit_id .. ".u_description"]
	--table.insert( grid[2], T.row{ T.column{T.label{ use_markup=true, label=help_text }}} )
	--table.insert( grid[2], T.row{ T.column{T.label{label="  "}}} )
	table.insert( grid[2], T.row{ T.column{ border="top", border_size=15, T.label{ use_markup=true, label=help_text }}} )
	table.insert( grid[2], T.row{ T.column{ border="top", border_size=15, T.image{  label="icons/banner2.png"  }}} )
>>>>>>> Stashed changes
	
	-------------------------
	-- SKILL GROUPS
	-------------------------
	-- each button/image/label id ends with the index of the skill group it corresponds to
	-- put all these in 1 big grid, so they can have their own table-layout
	
	local skill_grid = T.grid{}
	for i=0,#skills_copy,1 do if (i>(caster.level + casters[k].groups_plus)) then skills_copy[i]=nil end end -- don't show skill groups if underleveled
	for i=0,#skills_copy,1 do
		-- lock skills
		for j=1,#skills_copy[i],1 do
			if (not wml.variables[ "unlock_"..string.sub(skills_copy[i][j].id,7,-1) ]) then skills_copy[i][j]=locked end
		end
		
		local button
		local subskill_row
		if (selecting) then
			-- menu button for selecting skills
			button = T.menu_button{  id="button"..i, use_markup=true  }
			for j=1,#skills_copy[i],1 do
			    if not wml.variables["unlock_" .. string.sub(skills_copy[i][j].id, 7, -1)] then
                       skills_copy[i][j] = locked
                   else
                       skills_copy[i][j] = casters[k].spell_table[i][j]
                   end
				table.insert( button[2], T.option{label=skills_copy[i][j].label} )
			end
		else -- button for casting spells, or label for displaying skills
			for j=1,#skills_copy[i],1 do
				local skill = skills_copy[i][j]
				if (wml.variables[skill.id]) then
					if (not skill.xp_cost) then button=T.label{  id="button"..i, use_markup=true, label=skill.label }
					else                        button=T.button{ id="button"..i, use_markup=true, label=skill.label } end
					-- handle one skill with multiple buttons
					if (skill.subskills) then
						subskill_row = T.row{}
						for k=1,#skill.subskills,1 do
							local subskill = skill.subskills[k]
							if (not wml.variables[ "unlock_"..string.sub(skill.subskills[k].id,7,-1) ]) then
							table.insert( subskill_row[2], T.column{T.button{id=subskill.id,use_markup=true,enabled=false,label=_"<span>Locked</span>"}} );
							else
							table.insert( subskill_row[2], T.column{T.button{id=subskill.id,use_markup=true,label=subskill.label}} );
							end
						end
					end
				end
			end
			if (not button) then button=T.label{id="button"..i} end -- dummy button
		end
		
		-- skill row
		table.insert( skill_grid[2], T.row{ 
			--T.column{button},
			--T.column{T.label{label="  "}},  T.column{  horizontal_alignment="left", T.image{id="image"..i                }  },
			--T.column{T.label{label="  "}},  T.column{  horizontal_alignment="left", T.label{id="label"..i,use_markup=true}  },
			T.column{ border="left",  border_size=15, button},
            T.column{                                 T.label{label="  "}},  T.column{  horizontal_alignment="left", T.image{id="image"..i                }  },
            T.column{ border="right", border_size=15, T.label{label="  "}},  T.column{  horizontal_alignment="left", T.label{id="label"..i,use_markup=true}  },
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
	table.insert( grid[2], T.row{ T.column{T.image{  label="icons/banner2.png"  }}} )
	--table.insert( grid[2], T.row{ T.column{T.label{label="  "}}} )
	--table.insert( grid[2], T.row{  T.column{  T.button{
	--	id="confirm_button", use_markup=true, return_value=1,
	--	label=(selecting and _"Confirm Spells <small><i>(can be changed every scenario)</i></small>" or "Cancel"),
	--}}})
	
	if (selecting) then
        table.insert( grid[2], T.row{ T.column{ T.grid{ T.row{ T.column{
            border="top,right", border_size=10,
            T.button{  id="confirm_button", use_markup=true, return_value=1, label=_"Confirm Spells <small><i>(can be changed every scenario)</i></small>"  }
        }, T.column{
            border="top,left",  border_size=10,
            T.button{  id="wait_button",    use_markup=true, return_value=2, label=_"Choose Later"  }
        }}}}})
    else
        table.insert( grid[2], T.row{ T.column{
            border="top", border_size=10,
            T.button{  id="confirm_button", use_markup=true, return_value=1, label="Cancel"  }
        }})
    end
	
	table.insert( grid[2], T.row{ T.column{ border="top", border_size=15,  T.image{  label="icons/banner4.png"  }}} )
	
	
	
	--###############################
	-- POPULATE DIALOG
	--###############################
	-------------------------
	-- PRESHOW
	-------------------------
	local function preshow(dialog)
		-- for the button corresponding to each skill group
		
		for i,group in pairs(skills_copy) do
			button = dialog["button"..i]
			
			-- menu callbacks for selecting skills
			if (selecting) then
				-- default to whatever skill we had selected last time
				for j,skill in pairs(skills_copy[i]) do
					if (wml.variables[skill.id]) then button.selected_index=j end
				end
				
				-- whenever we refresh the menu, update the image and label
				refresh = function(button)
					if (not skills_copy[i][1]) then return end
					dialog["image"..i].label = skills_copy[i][button.selected_index].image
					dialog["label"..i].label = skills_copy[i][button.selected_index].description
					
					-- also update variables
					for j,skill in pairs(skills_copy[i]) do
						result_table[skill.id] = (j==button.selected_index) and "yes" or "no"
						if (skill.id=="skill_locked") then result_table[skill.id]="no" end
					end
				end
				
				-- refresh immediately, and after any change
				refresh(button)
				button.on_modified = refresh
			
			-- fixed labels for casting/displaying skills/spells
			else dialog["button"..i].visible = false
				for j,skill in pairs(skills_copy[i]) do
					if (not wml.variables[skill.id]) then goto continue end
					
					-- if we know this skill, reveal and initialize the UI
					dialog["button"..i].visible = true
					dialog["image" ..i].label = skill.image
					dialog["label" ..i].label = skill.description
					
					-- if the button is clickable (i.e. a castable spell), set on_button_click
					local function initialize_button( buttonid, skill, small )
					
					
					    local function is_race_in_list(race_list, race)
                            if not race_list then return false end
                            for _, r in ipairs(race_list) do
                                if r == race then
                                    return true
                                end
                            end
                            return false
                        end
					
						if (dialog[buttonid].type=="button") then
							-- cancel spell
							local function caster_has_object(object_id) return wesnoth.units.find_on_map{ id=casters[k].id, T.filter_wml{T.modifications{T.object{id=object_id}}} }[1] end
							if (caster_has_object(skill.id)) then
								dialog[buttonid].label = small and "<span size='small'>Cancel</span>" or label('Cancel')
								dialog[buttonid].on_button_click = function()
									wml.variables['skill_id'] = skill.id.."_cancel"
									gui.widget.close(dialog)
								end
							
							-- errors (extra spaces are to center the text)
							elseif (not wml.variables[ "unlock_"..string.sub(skill.id,7,-1) ]) then
								dialog[buttonid].enabled = false
							elseif (wml.variables['spellcasted_this_turn_' .. caster.id]) then
								dialog[buttonid].label = small and _"<span size='small'>1 spell/turn</span>" or _"<span> Can only cast\n1 spell per turn</span>"
								dialog[buttonid].enabled = false
							elseif (not is_race_in_list(casters[k].race, caster.race)) then
								dialog[buttonid].label = small and _"<span size='small'>Polymorphed</span>" or _"<span>  Blocked by\n  Polymorph</span>"
								dialog[buttonid].enabled = false
							elseif (wesnoth.units.find_on_map{ id=caster.id, T.filter_location{radius=3, T.filter{id='haralin_mirror3'}} }[1]) then   -- mirror haralin counterspell. Переробити, щоб працювало з усіма
								dialog[buttonid].label = small and _"<span size='small'>Counterspelled</span>" or _"<span>  Blocked by\n Counterspell</span>"
								dialog[buttonid].enabled = false
							elseif (wml.variables['counterspell_active']) then -- counterspell
								dialog[buttonid].label = small and _"<span size='small'>Counterspelled</span>" or _"<span>  Blocked by\n Counterspell</span>"
								dialog[buttonid].enabled = false
							elseif (skill.xp_cost and skill.xp_cost>caster.experience) then
								dialog[buttonid].label = small and _"<span size='small'>No XP</span>" or label('Insufficient XP')
								dialog[buttonid].enabled = false
					     	elseif (skill.gold_cost and skill.gold_cost>wesnoth.sides[caster.side].gold) then
								dialog[buttonid].label = small and _"<span size='small'>No Gold</span>" or label('Insufficient Gold')
								dialog[buttonid].enabled = false
							elseif (skill.atk_cost and skill.atk_cost>caster.attacks_left) then
								dialog[buttonid].label = small and _"<span size='small'>No Attack</span>" or label('No Attack')
								dialog[buttonid].enabled = false
							
							-- cast spell
							else
								dialog[buttonid].on_button_click = function()
									if (skill.xp_cost)  then caster.experience  =caster.experience  -skill.xp_cost  end
									if (skill.gold_cost)  then wesnoth.sides[caster.side].gold =wesnoth.sides[caster.side].gold  -skill.gold_cost  end
									if (skill.atk_cost) then haralin.attacks_left=caster.attacks_left-skill.atk_cost end
									wml.variables['skill_id'] = skill.id
									wml.variables['spellcasted_this_turn_' .. caster.id] = skill.id
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

	wesnoth.interface.game_display.selected_unit = nil
	wesnoth.interface.delay(300)
	
    wesnoth.units.select()
	wesnoth.interface.deselect_hex()
    wml.fire("redraw") -- deselect caster

	-- select spell, synced
	if (selecting) then
		dialog_result = wesnoth.sync.evaluate_single(function()
<<<<<<< Updated upstream
			gui.show_dialog( dialog, preshow )
			return result_table;
		end)
		for skill_id,skill_value in pairs(dialog_result) do wml.variables[skill_id]=skill_value end
=======
            retval = gui.show_dialog( dialog, preshow )
            result_table.wait_to_select_spells = retval==2 and 'yes' or 'no' --not nil, or else the key appears blank
            return result_table;
        end)
        wml.variables["wait_to_select_spells_" .. caster.id] = result_table.wait_to_select_spells; --set wait_to_select_spells manually, since it often gets overwritten to 'no' above
		
		skills_equipped = {}
		for skill_id,skill_value in pairs(dialog_result) do
		wml.variables[skill_id]=skill_value
		    if skill_value == true then
			    table.insert(skills_equipped, skill_id)
			end
		end
		wml.variables["caster_" .. caster.id .. ".spell_equipped"] = table.concat(skills_equipped, ",")
>>>>>>> Stashed changes
	
	-- cast spells, synced
	else
		dialog_result = wesnoth.sync.evaluate_single(function()
			gui.show_dialog( dialog, preshow )
			if (wml.variables['skill_id']) then wesnoth.game_events.fire('cast_skill_synced', caster.x, caster.y) end
			wml.variables['skill_id'] = nil
		end)
	end

return end

 end

end




--###########################################################################################################################################################
--                                                                      "MAIN"
--###########################################################################################################################################################
-------------------------
-- DEFINE WML TAGS
-------------------------
	wml_actions["select_caster_skills"] = function(cfg)
        selected_unit_id = cfg.id
        display_skills_dialog(true)
    end
<<<<<<< Updated upstream
=======
	
	wml_actions["assign_caster"] = function(cfg)
		local filter = wml.get_child(cfg, "filter") or
        wml.error "[assign_caster] missing required [filter] tag"
		local units = wesnoth.units.find(filter)
		local basic_description

        for i,u in ipairs(units) do
		
		local writer = utils.vwriter.init(cfg, ("caster_" .. u.id ))
		
		if u.gender == "male" then
		    basic_description = _"<span size='2000'> \n</span><span size='small'><i>" .. u.name .. " knows many useful spells, and will learn more as he levels-up automatically throughout the campaign. " .. u.name .. " does not use XP to level-up.\nInstead, " .. u.name .. " uses XP to cast certain spells. If you select spells that cost XP, <b>double-click on " .. u.name .. " to cast them</b>. You can only cast 1 spell per turn.</i></span>"
		else
		    basic_description = _"<span size='2000'> \n</span><span size='small'><i>" .. u.name .. " knows many useful spells, and will learn more as she levels-up automatically throughout the campaign. " .. u.name .. " does not use XP to level-up.\nInstead, " .. u.name .. " uses XP to cast certain spells. If you select spells that cost XP, <b>double-click on " .. u.name .. " to cast them</b>. You can only cast 1 spell per turn.</i></span>"
		end

        local caster_data_temp = {
            id = u.id,
            u_title_select = cfg.title_select or ("Select " .. u.name .. "’s Spells"),
            u_title_cast = cfg.title_cast or ("Cast " .. u.name .. "’s Spells"),
            u_description = cfg.description or basic_description,
			spell_unlocked = cfg.unlocked_spells or "",
			spell_equipped = cfg.equipped_spells or "",
            spell_group_1 = cfg.spell_group_1,
			spell_group_2 = cfg.spell_group_2,
			spell_group_3 = cfg.spell_group_3,
			spell_group_4 = cfg.spell_group_4,
			spell_group_5 = cfg.spell_group_5,
			spell_group_6 = cfg.spell_group_6,
			spell_group_7 = cfg.spell_group_7,
			spell_group_8 = cfg.spell_group_8,
			spell_group_9 = cfg.spell_group_9,
			spell_group_10 =cfg.spell_group_10,
			utils_spellcasted_this_turn = cfg.spellcasted_this_turn or nil,
			utils_spellcasting_allowed = tostring(cfg.spellcasting_allowed) or true,
			utils_not_casters_turn = cfg.utils_not_casters_turn,
        }
		
		utils.vwriter.write(writer, caster_data_temp)
		
		wml.fire("refresh_skills", ({id = u.id}))
		
		caster_data_temp, writer = nil
		
		end
    end
	
	
	wml_actions["modify_caster"] = function(cfg)
		local filter = wml.get_child(cfg, "filter") or
        wml.error "[modify_caster] missing required [filter] tag"
		local units = wesnoth.units.find(filter)
		local basic_description

        for i,u in ipairs(units) do
		    if wml.variables["caster_" .. u.id] then
		        wml.variables["caster_" .. u.id .. ".u_title_select"] = cfg.title_select or wml.variables["caster_" .. u.id .. ".u_title_select"]
		    	wml.variables["caster_" .. u.id .. ".u_title_cast"] = cfg.title_cast or wml.variables["caster_" .. u.id .. ".u_title_cast"]
		    	wml.variables["caster_" .. u.id .. ".u_description"] = cfg.description or wml.variables["caster_" .. u.id .. ".u_description"]
		    	wml.variables["caster_" .. u.id .. ".spell_unlocked"] = cfg.unlocked_spells or wml.variables["caster_" .. u.id .. ".spell_unlocked"]
		    	wml.variables["caster_" .. u.id .. ".spell_equipped"] = cfg.equipped_spells or wml.variables["caster_" .. u.id .. ".spell_equipped"]
		    	wml.variables["caster_" .. u.id .. ".spell_group_1"] = cfg.spell_group_1 or wml.variables["caster_" .. u.id .. ".spell_group_1"]
		    	wml.variables["caster_" .. u.id .. ".spell_group_2"] = cfg.spell_group_2 or wml.variables["caster_" .. u.id .. ".spell_group_2"]
		    	wml.variables["caster_" .. u.id .. ".spell_group_3"] = cfg.spell_group_3 or wml.variables["caster_" .. u.id .. ".spell_group_3"]
		    	wml.variables["caster_" .. u.id .. ".spell_group_4"] = cfg.spell_group_4 or wml.variables["caster_" .. u.id .. ".spell_group_4"]
		    	wml.variables["caster_" .. u.id .. ".spell_group_5"] = cfg.spell_group_5 or wml.variables["caster_" .. u.id .. ".spell_group_5"]
		    	wml.variables["caster_" .. u.id .. ".spell_group_6"] = cfg.spell_group_6 or wml.variables["caster_" .. u.id .. ".spell_group_6"]
		    	wml.variables["caster_" .. u.id .. ".spell_group_7"] = cfg.spell_group_7 or wml.variables["caster_" .. u.id .. ".spell_group_7"]
		    	wml.variables["caster_" .. u.id .. ".spell_group_8"] = cfg.spell_group_8 or wml.variables["caster_" .. u.id .. ".spell_group_8"]
		    	wml.variables["caster_" .. u.id .. ".spell_group_9"] = cfg.spell_group_9 or wml.variables["caster_" .. u.id .. ".spell_group_9"]
		    	wml.variables["caster_" .. u.id .. ".spell_group_10"] = cfg.spell_group_10 or wml.variables["caster_" .. u.id .. ".spell_group_10"]
		    	wml.variables["caster_" .. u.id .. ".utils_spellcasted_this_turn"] = cfg.spellcasted_this_turn or wml.variables["caster_" .. u.id .. ".utils_spellcasted_this_turn"]
		    	wml.variables["caster_" .. u.id .. ".utils_spellcasting_allowed"] = cfg.spellcasting_allowed or wml.variables["caster_" .. u.id .. ".utils_spellcasting_allowed"]
		    	wml.variables["caster_" .. u.id .. ".utils_not_casters_turn"] = cfg.utils_not_casters_turn or wml.variables["caster_" .. u.id .. ".utils_not_casters_turn"]
		    	
		        wml.fire("refresh_skills", ({id = u.id}))
		    else
		        wml.fire("assign_caster", cfg)
		    end
		end
    end
	
	
	wml_actions["unlock_spell"] = function(cfg)
	    if cfg.spell_id then
            local spell_to_modify = {}
		    local filter = wml.get_child(cfg, "filter") or
            wml.error "[unlocked_spell] missing required [filter] tag"
		    local units = wesnoth.units.find(filter)
            for spell in cfg.spell_id:gmatch("[^,]+") do
                table.insert(spell_to_modify, spell)
            end
		    
            for i,u in ipairs(units) do
		    
		        if wml.variables["caster_" .. u.id] then
		    	
		    	    local already_unlocked_list = {}
		    	    for spell in wml.variables["caster_" .. u.id .. ".spell_unlocked"]:gmatch("[^,]+") do
                        table.insert(already_unlocked_list, spell)
                    end
		    				
		            for _, spell in ipairs(spell_to_modify) do
                        local already_unlocked = false
                        for _, unlocked_spell in ipairs(already_unlocked_list) do
                            if spell == unlocked_spell then
                                already_unlocked = true
                                break
                            end
                        end
                        if not already_unlocked then
		            		wml.variables["unlock_" .. spell] = "yes"  -- чи треба?
		    				wml.variables["caster_" .. u.id .. ".spell_unlocked"] = wml.variables["caster_" .. u.id .. ".spell_unlocked"] .. "," .. spell
                        end
                    end
		        end
		    
		    end
		end
    end
	
	wml_actions["lock_spell"] = function(cfg)
	    if cfg.spell_id then
            local spell_to_modify = {}
		    local filter = wml.get_child(cfg, "filter") or
            wml.error "[lock_spell] missing required [filter] tag"
		    local units = wesnoth.units.find(filter)
            for spell in cfg.spell_id:gmatch("[^,]+") do
                table.insert(spell_to_modify, spell)
            end
		    
	        for i,u in ipairs(units) do
		        if wml.variables["caster_" .. u.id] then
		            local already_unlocked_list = {}
		            for spell in wml.variables["caster_" .. u.id .. ".spell_unlocked"]:gmatch("[^,]+") do
                        table.insert(already_unlocked_list, spell)
                    end
		            
                    for _, spell in ipairs(spell_to_modify) do
                    for i = #already_unlocked_list, 1, -1 do -- Видаляємо заклинання зі списку
                        if already_unlocked_list[i] == spell then
                            table.remove(already_unlocked_list, i)
                            wesnoth.interface.add_chat_message("Locked spell", spell)
                            wml.variables["unlock_" .. spell] = nil -- чи треба?
                        end
                    end
                end
                
                -- Оновлюємо змінну в WML, збираючи рядок назад
                wml.variables["caster_" .. u.id .. ".spell_unlocked"] = table.concat(already_unlocked_list, ",")
		        end
		    end
		end
    end
	
	wml_actions["caster_status"] = function(cfg)
		local filter = wml.get_child(cfg, "filter") or
        wml.error "[caster_status] missing required [filter] tag"
		local units = wesnoth.units.find(filter)
	
	    for i,u in ipairs(units) do
		    if wml.variables["caster_" .. u.id] then
			    if cfg.spellcasting_allowed == true then
				    wml.variables["caster_" .. u.id .. ".utils_spellcasting_allowed"] = true
				elseif cfg.spellcasting_allowed == false then
				    wml.variables["caster_" .. u.id .. ".utils_spellcasting_allowed"] = false
				end 
            end
		end
    end
	
wml_actions["equip_spell"] = function(cfg)
    if not cfg.spell_id then return end
    
    local filter = wml.get_child(cfg, "filter") or wml.error "[equip_spell] missing required [filter] tag"
    local units = wesnoth.units.find(filter)
    local spell_to_modify = {}
    
    for spell in cfg.spell_id:gmatch("[^,]+") do
        table.insert(spell_to_modify, spell)
    end
    
    for _, u in ipairs(units) do
        local spell_to_equip = {}
        local equipped_var = wml.variables["caster_" .. u.id .. ".spell_equipped"] or ""
        
        for spell in equipped_var:gmatch("[^,]+") do
            table.insert(spell_to_equip, spell)
        end
        
        for i = 1, 10 do
            local group_var = wml.variables["caster_" .. u.id .. ".spell_group_" .. i]
            if group_var then
                local spell_to_compare = {}
                
                for spell in group_var:gmatch("[^,]+") do
                    table.insert(spell_to_compare, spell)
                end
                
                for _, spell in ipairs(spell_to_modify) do
                    local found = false
                    for _, s in ipairs(spell_to_compare) do
                        if s == spell then
                            found = true
                            break
                        end
                    end
                    if found then
                        for j = #spell_to_equip, 1, -1 do
                            local remove_spell = false
                            for _, s in ipairs(spell_to_compare) do
                                if s == spell_to_equip[j] then
                                    remove_spell = true
                                    break
                                end
                            end
                            if remove_spell then
                                table.remove(spell_to_equip, j)
                            end
                        end
                        table.insert(spell_to_equip, spell)
                    end
                end
            end
        end
        
        wml.variables["caster_" .. u.id .. ".spell_equipped"] = table.concat(spell_to_equip, ",")
        wml.fire("refresh_skills", { id = u.id })
    end
end
	
	wml_actions["remove_caster"] = function(cfg)
		local filter = wml.get_child(cfg, "filter") or
        wml.error "[remove_caster] missing required [filter] tag"
		local units = wesnoth.units.find(filter)
	
	    for i,u in ipairs(units) do
		    if wml.variables["caster_" .. u.id] then
			    wml.variables["caster_" .. u.id] = nil
            end
		end
    end
	
	
	
	
	
	
>>>>>>> Stashed changes

-------------------------
-- DETECT DOUBLECLICKS
-------------------------
local last_click = os.clock()
wesnoth.game_events.on_mouse_action = function(x,y)
	local selected_unit = wesnoth.units.find_on_map{ x=x, y=y }
	for k=0,#casters,1 do
	if (not selected_unit[1]) then return end
	if (selected_unit[1].id == casters[k].id) then
	
	if (wml.variables['is_during_attack']) then return end
	if (wml.variables['not_player_turn'] ) then return end
	
	selected_unit_id = selected_unit[1].id
	
	if (os.clock()-last_click<0.25) then
		wesnoth.audio.play("miss-2.ogg")
<<<<<<< Updated upstream
		
		if (wml.variables["no_spellcasting_event_" .. selected_unit_id]) then
			wesnoth.game_events.fire(wml.variables["no_spellcasting_event_" .. selected_unit_id], x, y)
		else
			display_skills_dialog()
=======

		if wml.variables["caster_" .. selected_unit_id .. ".utils_spellcasting_allowed"] == true then
		    if (wml.variables["wait_to_select_spells_" .. selected_unit_id]) then
                display_skills_dialog(true)
            else
                display_skills_dialog()
            end
>>>>>>> Stashed changes
		end
		
		last_click = 0 -- prevent accidentally immediately re-opening the dialog
	else
		last_click = os.clock()
	end
	
	end
	
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