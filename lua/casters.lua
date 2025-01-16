local _ = wesnoth.textdomain "wesnoth-chasing_the_light"

--###########################################################################################################################################################
--                                                                  DEFINE SKILLS
--###########################################################################################################################################################
function label(text)     return "<span size='1000'> \n</span><span size='large'>"..text.."</span><span size='8000'>\n </span>"  end
local skills_haralin = {
	--###############################
	-- GROUP 0 SKILLS
	--###############################
	[0] = {
	-------------------------
		-- MAGIC BLAST
		-------------------------
		[1] = {
			id          = "skill_magic_blast",
			label       = label(_"Magic Blast"),
			image       = "attacks/mud-missile.png",
			description = _"<span color='#ad6a61'><i><b>Attack:</b></i></span> Ranged 9x2 impact, <i>magical</i>.",
		},
		-------------------------
		-- SUMMON
		-------------------------
		[2] = {
			id          = "skill_summon",
			label       = label(_"Summon"),
			image       = "icons/summon.png",
			description = _"<span color='#6ca364'><i><b>Spell:</b></i></span> Закличте духа природи до себе на допомогу, навіть знаходячись за межами цитаделі.\n            Для цього закляття використовується <span color='#FFD700'><i >золото</i></span> та <span color='#00bbe6'><i>досвід</i></span>.",
			subskills   = {
				[1]={ id="skill_summon_mud",     xp_cost=6, gold_cost=8,  label="  <span>Mud (<span color='#FFD700'><i >8g</i></span> <span color='#00bbe6'><i>6xp</i></span>)</span>   " },
				[2]={ id="skill_summon_rock",    xp_cost=8, gold_cost=14,  label="   <span>Stone (<span  color='#FFD700'><i >14g</i></span> <span color='#00bbe6'><i>8xp</i></span>)</span>   " },
				[3]={ id="skill_summon_water",   xp_cost=8, gold_cost=10,  label="   <span>Water (<span  color='#FFD700'><i>10g</i></span> <span color='#00bbe6'><i>8xp</i></span>)</span>   " },
				[4]={ id="skill_summon_air",     xp_cost=8, gold_cost=10,  label="   <span>Air (<span   color='#FFD700'><i>10g</i></span> <span color='#00bbe6'><i>8xp</i></span>)</span>   " },
                [5]={ id="skill_summon_fire",    xp_cost=8, gold_cost=12,  label="   <span>Fire (<span   color='#FFD700'><i>12g</i></span> <span color='#00bbe6'><i>8xp</i></span>)</span>   " }, },
		},
		-------------------------
		-- SHIELD
		-------------------------
		[3] = {
			id          = "skill_shield",
			label       = label(_"Shield"),
			image       = "icons/shield.png",
			description = _"<span color='#6ca364'><i><b>Spell:</b></i></span> Spend <span color='#00bbe6'><i>8xp</i></span> to gain <i>+20% dodge chance</i> until the start of your next turn or until cancelled.",
			xp_cost=8,
		},
 		------------------------- 
 		-- STASIS
 		-------------------------
 		[4] = {
 			id          = "skill_stasis",
 			label       = label("Stasis"),
 			image       = "icons/stasis.png",
 			description = _"<span color='#6ca364'><i><b>Spell:</b></i></span> Spend <span color='#00bbe6'><i>8xp</i></span> and <span color='#c06a61'><i>your attack</i></span> to <i>petrify</i> yourself and adjacent units until the start of your next turn.",
 			xp_cost=12, 
 		},
		-------------------------
		-- PANACEA
		-------------------------
		[5] = {
			id          = "skill_panacea",
			label       = label(_"Panacea"),
			image       = "icons/potion_green_small.png",
			description = _"<span color='#6ca364'><i><b>Spell:</b></i></span> Spend <span color='#00bbe6'><i>8xp</i></span><span color='#00bbe6'><i>8xp</i></span> to fully heal the lowest-health adjacent ally, and increase\n           its attacks, strikes, and damage by its level. <span color='#bb0000'><b>Next turn, it dies.</b></span>",
			xp_cost=8,
		},
	},
	--###############################
	-- GROUP 1 SKILLS
	--###############################
	[1] = {
		-------------------------
		-- CHILL TOUCH
		-------------------------
		[1] = {
			id          = "skill_chill_touch",
			label       = label(_"Chill Touch"),
			image       = "icons/chill-touch.png",
			description = _"<span color='#ad6a61'><i><b>Attack:</b></i></span> Melee 6x3 cold, <i>slows</i>.",
		},
		-------------------------
		-- LEVITATE
		-------------------------
		[2] = {
			id          = "skill_levitate",
			label       = label(_"Levitate"),
			image       = "icons/levitate.png",
			description = _"<span color='#6ca364'><i><b>Spell:</b></i></span> Spend <span color='#00bbe6'><i>8xp</i></span> to gain <i>flight</i> and the <i>skirmisher</i> ability until the start of your next turn or until cancelled.",
			xp_cost=8,
		},
		-------------------------
		-- MNEMONIC
		-------------------------
		[3] = {
			id          = "skill_mnemonic",
			label       = label(_"Mnemonic"),
			image       = "icons/mnemonic.png",
			description = _"<span color='#a9a150'><i><b>Passive:</b></i></span> Whenever an adjacent ally gains xp, you gain the same amount of xp.",
		},
		-------------------------
		-- FIND FAMILIAR
		-------------------------
		[4] = {
			id          = "skill_find_familiar",
			label       = label(_"Find Familiar"),
			image       = "icons/find-familiar.png",
			description = _"<span color='#a9a150'><i><b>Passive:</b></i></span> Begin each scenario with your trusty pet raven.\n               Your familiar’s level and xp persist across scenarios, but reset if it dies.",
		},
		-------------------------
		-- BEND NATURE(?)
		-------------------------
		[5] = {
			id          = "skill_bend",
			label       = label(_"Bend Nature"),
			image       = "icons/landmass.png",
			description = _"<span color='#6ca364'><i><b>Spell:</b></i></span> Керуйте самою природою, створюючи та направляючи її елементи — землю, воду та лаву — туди, куди вам заманеться.\n            Для цього закляття використовується <span color='#00bbe6'><i>досвід</i></span> та <span color='#FFD700'><i >золото</i></span>.",
			subskills   = {
				[1]={ id="skill_bend_earth",     xp_cost=16, gold_cost=10,  label="  <span>Earth (<span color='#00bbe6'><i>16xp</i></span> <span color='#FFD700'><i>10g</i></span>)</span>   " },
				[2]={ id="skill_bend_water",    xp_cost=8,  gold_cost=10, label="   <span>Water (<span color='#00bbe6'><i>8xp</i></span> <span color='#FFD700'><i>10g</i></span>)</span>   " },
				[3]={ id="skill_bend_lava",   xp_cost=32,  gold_cost=10, label="   <span>Lava (<span color='#00bbe6'><i>32xp</i></span> <span color='#FFD700'><i>10g</i></span>)</span>   " }, },
		},
		
	},
	--###############################
	-- GROUP 2 SKILLS
	--###############################
	[2] = {
		-------------------------
		-- FIREBALL2
		-------------------------
		[1] = {
			id          = "skill_fireball2",
			label       = label(_"Lesser Fireball"),
			image       = "attacks/fireball.png",
			description = _"<span color='#ad6a61'><i><b>Attack:</b></i></span> Ranged 8x4 fire, <i>magical</i>.",
		},
		-------------------------
		-- GLAMOUR
		-------------------------
		[2] = {
			id          = "skill_glamour",
			label       = label(_"Glamour"),
			image       = "icons/glamour.png", 
			description = _"<span color='#a9a150'><i><b>Passive:</b></i></span> Gain the <i>leadership</i> ability.",
		},
		-------------------------
		-- ENERVATE
		-------------------------
		[3] = {
			id          = "skill_enervate",
			label       = label(_"Siphon"),
			image       = "icons/enervate.png", -- better than fireball2 vs orcs or undead, but sarians resist arcane and are vulnerable to fire. You also get this a few scenarios later than fireball2.
			description = _"<span color='#ad6a61'><i><b>Attack:</b></i></span> Ranged 8x4 arcane, <i>magical</i>, <i>drains</i>.", 
		},
		-------------------------
		-- BLIZZARD
		-------------------------
		[4] = {
			id          = "skill_blizzard",
			label       = label(_"Blizzard"),
			image       = "icons/blizzard.png",
			description = _"<span color='#6ca364'><i><b>Spell:</b></i></span> Spend <span color='#00bbe6'><i>16xp</i></span> and <span color='#c06a61'><i>your attack</i></span> to slow enemy units and freeze terrain in a 3-hex radius.",
			xp_cost=16, atk_cost=1, 
		},
		-------------------------
		-- COUNTERSPELL
		-------------------------
		[5] = {
			id          = "skill_counterspell",
			label       = label(_"Counterspell"),
			image       = "icons/counterspell.png",
			description = _"<span color='#6ca364'><i><b>Spell:</b></i></span> Spend <span color='#00bbe6'><i>16xp</i></span> to <i>disallow magical attacks</i> in a 3-hex radius, until cancelled.\n           Prevents spellcasting, but not passive skills.",
			xp_cost=16,
		},
		-------------------------
		-- POLYMORPH
		-------------------------
		[6] = {
			id          = "skill_polymorph",
			label       = label(_"Polymorph"),
			image       = "icons/polymorph.png",
			description = _"<span color='#6ca364'><i><b>Spell:</b></i></span> Transform into a stoat (<span color='#00bbe6'><i>1xp</i></span>), bear (<span color='#00bbe6'><i>8xp</i></span>), crab (<span color='#00bbe6'><i>16xp</i></span>), or roc (<span color='#00bbe6'><i>32xp</i></span>). Lasts until cancelled.\n            Replaces Haralin’s attacks, spells, and passives, but does not affect hitpoints.",
			subskills   = {
				[1]={ id="skill_polymorph_stoat",  xp_cost=1,  label="   <span>Stoat (<span color='#00bbe6'><i >1xp</i></span>)</span>   " },
				[2]={ id="skill_polymorph_bear",   xp_cost=8,  label="   <span>Bear (<span  color='#00bbe6'><i >8xp</i></span>)</span>   " },
				[3]={ id="skill_polymorph_crab",   xp_cost=16, label="   <span>Crab (<span  color='#00bbe6'><i>16xp</i></span>)</span>   " },
				[4]={ id="skill_polymorph_roc",    xp_cost=32, label="   <span>Roc (<span   color='#00bbe6'><i>32xp</i></span>)</span>   " }, },
		},
	},
	--###############################
	-- GROUP 3 SKILLS
	--###############################
	[3] = {
		-------------------------
		-- FIREBALL3
		-------------------------
		[1] = {
			id          = "skill_fireball3",
			label       = label(_"Fireball"),
			image       = "attacks/fireball.png",
			description = _"<span color='#ad6a61'><i><b>Attack:</b></i></span> Ranged 12x4 fire, <i>magical</i>.",
		},
		-------------------------
		-- DANCING DAGGERS
		-------------------------
		[2] = {
			id          = "skill_dancing_daggers",
			label       = label(_"Dancing Daggers"),
			image       = "icons/dancing-daggers.png",
			description = _"<span color='#ad6a61'><i><b>Attack:</b></i></span> Ranged 5x8 blade, <i>backstab</i>.",
		},
		-------------------------
		-- ILLUSION
		-------------------------
		[3] = {
			id          = "skill_illusion",
			label       = label(_"Enthrall"),
			image       = "icons/illusion.png",
			description = _"<span color='#6ca364'><i><b>Spell:</b></i></span> Spend <span color='#00bbe6'><i>48xp</i></span> and <span color='#c06a61'><i>your attack</i></span> to magically disguise yourself as an awe-inspiring drake,\n           reducing accuracy and dodge by 10% for enemies in a 2 hex radius.", --Ends if you take damage.
			xp_cost=48, atk_cost=1, 
		},
		-------------------------
		-- ANIMATE FIRE
		-------------------------
		[4] = {
			id          = "skill_animate_fire",
			label       = label(_"Animate Fire"),
			image       = "icons/animate-fire.png", 
			description = _"<span color='#a9a150'><i><b>Passive:</b></i></span> Learn to recruit <i>Fire Guardians</i>. Fire Guardians gain +100% damage and XP\n               while adjacent to you, but dissipate at the end of each scenario.",
		},
		-------------------------
		-- CONTINGENCY
		-------------------------
		[5] = {
			id          = "skill_contingency",
			label       = label(_"Contingency"),
			image       = "icons/contingency.png",
			description = _"<span color='#a9a150'><i><b>Passive:</b></i></span> Whenever one of your soldiers dies, they are instead safely returned to your recall list.",
		},
	},
	--###############################
	-- GROUP 4 SKILLS
	--###############################
	[4] = {
		-------------------------
		-- FIREBALL4
		-------------------------
		[1] = {
			id          = "skill_fireball4",
			label       = label(_"Fireball"),
			image       = "attacks/fireball.png",
			description = _"<span color='#ad6a61'><i><b>Attack:</b></i></span> Ranged 17x4 fire, <i>magical</i>.",
		},
		-------------------------
		-- LIGHTNING
		-------------------------
		[2] = {
			id          = "skill_lightning",
			label       = label(_"Chain Lightning"),
			image       = "attacks/lightning.png",
			description = _"<span color='#ad6a61'><i><b>Attack:</b></i></span> Ranged 14x4 fire, <i>magical</i>. If this attack kills an enemy, you may attack again.",
		},
		-------------------------
		-- TIME DILATION
		-------------------------
		[3] = {
			id          = "skill_time_dilation",
			label       = label(_"Time Dilation"),
			image       = "icons/time-dilation.png",
			description = _"<span color='#6ca364'><i><b>Spell:</b></i></span> Spend <span color='#00bbe6'><i>48xp</i></span> to grant yourself and all allies double movement and a second attack this turn.\n           When this turn ends, affected units become slowed.",
			xp_cost=48,
		},
		-------------------------
		-- CATACLYSM
		-------------------------
		[4] = {
			id          = "skill_cataclysm",
			label       = label(_"Cataclysm"),
			image       = "icons/cataclysm.png",
			description = _"<span color='#6ca364'><i><b>Spell:</b></i></span> Spend <span color='#00bbe6'><i>99xp</i></span> and <span color='#c06a61'><i>your attack</i></span> to injure everyone in a 4-hex radius for 40%-90%\n           of their current HP. Melts snow, burns forest, and levels castles/villages.",
			xp_cost=99, atk_cost=1, 
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


local skills_daeola = {

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
		-------------------------
		-- DISTANT ATTACK
		-------------------------
		[2] = {
			id          = "skill_disattack_d",
			label       = label(_"Lightbeam"),
			image       = "attacks/lightbeam.png",
			description = _"<span color='#6ca364'><i><b>Spell:</b></i></span> Використайте <span color='#00bbe6'><i>8xp</i></span>, щоб атакувати ворога дальньою містичною атакою <b>9x3</b>. \n<span color='#ad6a61'><i><b>Radius:</b></i></span> <i>6 клітинок.</i>",
			xp_cost=8,
		},
	},
	[1] = {
		-------------------------
		-- SWAP
		-------------------------
		[1] = {
			id          = "skill_swap_d",
			label       = label(_"Swap"),
			image       = "icons/swap.png",
			description = _"<span color='#6ca364'><i><b>Spell:</b></i></span> Використайте <span color='#00bbe6'><i>8xp</i></span>, щоб миттєво обмінятися місцями з будь-яким юнітом. \n<span color='#ad6a61'><i><b>Radius:</b></i></span> <i>4 клітинки.</i>",
			xp_cost=8,
		},
		-------------------------
		-- LEVITATE
		-------------------------
		[2] = {
			id          = "skill_levitate_d",
			label       = label(_"Levitate"),
			image       = "icons/levitate.png",
			description = _"<span color='#6ca364'><i><b>Spell:</b></i></span> Spend <span color='#00bbe6'><i>8xp</i></span> to gain <i>flight</i> and the <i>skirmisher</i> ability until the start of your next turn or until cancelled.",
			xp_cost=8,
		},
	},
	[2] = {
		
		-------------------------
		-- DISTANT HEAL
		-------------------------
		[1] = {
			id          = "skill_disheal_d",
			label       = label(_"Distant Heal"),
			image       = "icons/disheal.png",
			description = _"<span color='#6ca364'><i><b>Spell:</b></i></span> Використайте <span color='#00bbe6'><i>6xp</i></span>, щоб вилікувати себе або дружнього юніта на +8 ОЗ. \n<span color='#ad6a61'><i><b>Radius:</b></i></span> <i>7 клітинок.</i>",
			xp_cost=6,
		},
		-------------------------
		-- WARD
		-------------------------
		[2] = {
			id          = "skill_ward_d",
			label       = label(_"Holy Ward"),
			image       = "icons/ward.png",
			description = _"<span color='#6ca364'><i><b>Spell:</b></i></span> Використайте <span color='#00bbe6'><i>10xp</i></span>, щоб на кілька ходів розмістити на мапі <i>Оберіг</i>.\n          Кожного ходу він завдаватиме навколишнім мерцям <b>10</b> містичної шкоди. \n<span color='#ad6a61'><i><b>Radius:</b></i></span> <i>2 клітинки.</i>",
			xp_cost=10,
		},
	},
	
}


local casters = {

		-------------------------
		-- HARALIN
		-------------------------
		[0] = {
			id          = "haralin",
			title_select = _"Select Haralin’s Spells",
			title_cast   = _"Cast Haralin’s Spells",
			description = _"<span size='2000'> \n</span><span size='small'><i>Haralin knows many useful spells, and will learn more as he levels-up automatically throughout the campaign. Haralin does not use XP to level-up.\nInstead, Haralin uses XP to cast certain spells. If you select spells that cost XP, <b>double-click on Haralin to cast them</b>. You can only cast 1 spell per turn.</i></span>",
		    groups_plus = 0,
			spell_table = skills_haralin,  --can't be reused for others
		},
		-------------------------
		-- DAEOLA
		-------------------------
		[1] = {
			id          = "daeola",
			title_select = _"Select Daeola’s Spells",
			title_cast   = _"Cast Daeola’s Spells",
			description = _"<span size='2000'> \n</span><span size='small'><i>Daeola knows many useful spells, and will learn more as she levels-up automatically throughout the campaign. Daeola does not use XP to level-up.\nInstead, Daeola uses XP to cast certain spells. If you select spells that cost XP, <b>double-click on Daeola to cast them</b>. You can only cast 1 spell per turn.</i></span>",
		    groups_plus = 2,
			spell_table = skills_daeola,  --can't be reused for others
		},
	}
	
	return {
    casters = casters,
	locked = locked,
}