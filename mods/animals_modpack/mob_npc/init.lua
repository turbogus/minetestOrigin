-------------------------------------------------------------------------------
-- Mob Framework Mod by Sapier
-- 
-- You may copy, use, modify or do nearly anything except removing this
-- copyright notice. 
-- And of course you are NOT allow to pretend you have written it.
--
--! @file init.lua
--! @brief npc implementation
--! @copyright Sapier
--! @author Sapier
--! @date 2013-01-27
--
-- Contact sapier a t gmx net
-------------------------------------------------------------------------------
minetest.log("action","MOD: mob_npc mod loading ...")

local version = "0.0.14"
local npc_groups = {
						not_in_creative_inventory=1
					}

local modpath = minetest.get_modpath("mob_npc")

dofile (modpath .. "/spawn_building.lua")

npc_prototype = {
		name="npc",
		modname="mob_npc",
		
		factions = {
			member = {
				"npc",
				}
			},
	
		generic = {
					description="NPC",
					base_health=40,
					kill_result="",
					armor_groups= {
						fleshy=90,
					},
					groups = npc_groups,
					envid="on_ground_1",
				},
		movement =  {
					min_accel=0.3,
					max_accel=0.7,
					max_speed=1.5,
					min_speed=0.01,
					pattern="stop_and_go",
					canfly=false,
					},
		
		spawning = {
					primary_algorithms = {
						{
						rate=0,
						density=0,
						algorithm="none",
						height=2
						},
					}
				},
		states = {
				{ 
				name = "walking",
				movgen = "probab_mov_gen",
				typical_state_time = 180,
				chance = 0.50,
				animation = "walk",
				},
				{ 
				name = "default",
				movgen = "none",
				typical_state_time = 180,
				chance = 0.00,
				animation = "stand",
				graphics_3d = {
					visual = "mesh",
					mesh = "npc_character.b3d",
					textures = {"zombie.png"},
					collisionbox = {-0.3,-1.0,-0.3, 0.3,0.8,0.3},
					visual_size= {x=1, y=1},
					},
				},
			},
		animation = {
				walk = {
					start_frame = 168,
					end_frame   = 187,
					},
				stand = {
					start_frame = 0,
					end_frame   = 79,
					},
			},
		}
		
npc_trader_prototype = {
		name="npc_trader",
		modname="mob_npc",
		
		factions = {
			member = {
				"npc",
				}
			},
	
		generic = {
					description="Trader",
					base_health=200,
					kill_result="",
					armor_groups= {
						fleshy=60,
					},
					groups = npc_groups,
					envid="on_ground_1",
					custom_on_activate_handler=mob_inventory.init_trader_inventory,
				},
		movement =  {
					min_accel=0.3,
					max_accel=0.7,
					max_speed=1.5,
					min_speed=0.01,
					pattern="stop_and_go",
					canfly=false,
					},
		
		spawning = {
					primary_algorithms = {
						{
						rate=0,
						density=750,
						algorithm="building_spawner",
						height=2
						},
					}
				},
		states = {
				{ 
				name = "default",
				movgen = "none",
				chance = 0,
				animation = "stand",
				graphics = {
					visual = "upright_sprite",
					sprite_scale={x=1.5,y=2},
					sprite_div = {x=1,y=1},
					visible_height = 2,
					visible_width = 1,
					},
				graphics_3d = {
					visual = "mesh",
					mesh = "npc_character.b3d",
					textures = {"mob_npc_trader_mesh.png"},
					collisionbox = {-0.3,-1.0,-0.3, 0.3,0.8,0.3},
					visual_size= {x=1, y=1},
					},
				},
			},
		animation = {
				walk = {
					start_frame = 168,
					end_frame   = 187,
					},
				stand = {
					start_frame = 0,
					end_frame   = 79,
					},
			},
		attention = {
				hear_distance = 3,
				hear_distance_value = 0.5,
				view_angle = nil,
				own_view_value = 0,
				remote_view = false,
				remote_view_value = 0,
				attention_distance_value = 0.2,
				watch_threshold = 2,
				attack_threshold = nil,
				attention_distance = 7.5,
				attention_max = 10,
		},
		trader_inventory = {
				goods = {
							{ "default:mese 1", "default:iron_lump 30",},
							{ "doors:door_wood 1", "default:mese_crystal 1", "default:cobble 10"},
							{ "default:fence_wood 20", "default:mese_crystal 5", "default:cobble 25"},
							{ "animalmaterials:saddle 1", "default:mese 1", "default:cobble 50"},
							{ "default:sword_steel 1", "default:mese_crystal 4", "default:stone 20"},
							{ "default:iron_lump 1", "default:dirt 99", "default:cobble 50"},
							{ "default:pick_mese 1", "default:mese_crystal 12", "default:stone 60"},
							{ "default:shovel_steel 1", "default:mese_crystal 2", "default:stone 10"},
							{ "default:axe_steel 1", "default:mese_crystal 2", "default:stone 22"},
							{ "default:torch 33", "default:mese_crystal 2", "default:stone 10"},
							{ "default:ladder 12", "default:mese 1", "default:cobble 50"},
							{ "default:paper 12", "default:mese_crystal 2", "default:stone 10"},
							{ "default:chest_locked 1", "default:mese_crystal 5", "default:cobble 25"},
							{ "mob_archer:archer 1","default:mese_crystal 10",nil},
							{ "mob_guard:guard 1","default:mese_crystal 10",nil},
							{ "doors:door_steel 1","default:mese_crystal 3","default:cobble 20"},
						},
				random_names = { "Hans","Franz","Xaver","Fritz","Thomas","Martin"},
			}
		}
		
--register with animals mod
minetest.log("action","\tadding mob "..npc_trader_prototype.name)
mobf_add_mob(npc_trader_prototype)
minetest.log("action","\tadding mob "..npc_prototype.name)
mobf_add_mob(npc_prototype)
minetest.log("action","MOD: mob_npc mod                version " .. version .. " loaded")