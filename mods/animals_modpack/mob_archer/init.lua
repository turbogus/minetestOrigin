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
minetest.log("action","MOD: mob_archer mod loading ...")

local version = "0.0.5"
local archer_groups = {
						not_in_creative_inventory=1
					}

archer_prototype = {
		name="archer",
		modname="mob_archer",
		
		factions = {
			member = {
				"npc",
				"hireling"
				}
			},
	
		generic = {
					description="Archer",
					base_health=40,
					kill_result="",
					armor_groups= {
						fleshy=75,
					},
					groups = archer_groups,
					envid="on_ground_1",
				},
		movement =  {
					guardspawnpoint = true,
					teleportdelay = 60,
					min_accel=0.3,
					max_accel=0.7,
					max_speed=1.5,
					min_speed=0.01,
					pattern="stop_and_go",
					canfly=false,
					max_distance=0.1,
					},
		catching = {
					tool="animalmaterials:contract",
					consumed=true,
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
		combat = {
					angryness=0.99,
					starts_attack=true,
					sun_sensitive=false,
					attack_hostile_mobs = true,
					melee = {
						maxdamage=1,
						range=2, 
						speed=1,
						},
					distance = {
						attack="mobf:arrow_entity",
						range=17,
						min_range=5,
						speed = 1,
						balistic = true,
						},
					self_destruct = nil,
					},
		states = {
				{ 
				name = "combat_distance",
				movgen = "none",
				typical_state_time = 9999,
				chance = 0.0,
				animation = "shoot",
				state_mode = "combat",
				},
				{ 
				name = "combat",
				movgen = "none",
				typical_state_time = 9999,
				chance = 0.0,
				animation = "punch",
				state_mode = "combat",
				},
				{ 
				name = "default",
				movgen = "follow_mov_gen",
				typical_state_time = 180,
				chance = 1.00,
				animation = "stand",
				state_mode = "auto",
				graphics_3d = {
					visual = "mesh",
					mesh = "mob_archer_archer.b3d",
					textures = {"mob_archer_archer_mesh.png"},
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
				punch = {
					start_frame = 189,
					end_frame = 199,
					},
				shoot = {
					start_frame = 221,
					end_frame = 250,
					},
			},
		sound = {
				shoot_distance = {
					name="mob_archer_shoot",
					gain = 0.5,
					max_hear_distance = 17,
					},
				},
		}

minetest.log("action","\tadding mob "..archer_prototype.name)
mobf_add_mob(archer_prototype)
minetest.log("action","MOD: mob_archer mod                version " .. version .. " loaded")