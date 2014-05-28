local version = "0.1.0"

minetest.log("action","MOD: animal_fish_blue_white loading ...")

local selectionbox_fish_blue_white = {-0.25, -0.25, -0.25, 0.25, 0.25, 0.25}

local fish_blue_white_groups = {
                        not_in_creative_inventory=1
                    }

function fish_blue_white_drop()
	local result = {}
	
	if math.random() < 0.01 then
		table.insert(result,"animalmaterials:scale_blue 1")
	end
	
	if math.random() < 0.01 then
		table.insert(result,"animalmaterials:scale_white 1")
	end
	
	table.insert(result,"animalmaterials:fish_bluewhite 3")
	
	return result
end

fish_blue_white_prototype = {
		name="fish_blue_white",
		modname="animal_fish_blue_white",
		
		factions = {
			member = {
				"animals",
				"fish"
				}
			},
	
		generic = {
					description="Blue white fish",
					base_health=5,
					kill_result=fish_blue_white_drop,
					armor_groups= {
						fleshy=80,
					},
					groups = fish_blue_white_groups,
					envid="shallow_waters",
				},
		movement =  { 
					default_gen="probab_mov_gen",
					min_accel=0.1,
					max_accel=0.3,
					max_speed=0.8,
					pattern="swim_pattern1",
					canfly=true,
				},
		catching = {
					tool="animalmaterials:net",
					consumed=true,
				},
		spawning = {
					primary_algorithms = {
						{
							rate=0.02,
							density=150,
							algorithm="in_shallow_water_spawner",
							height=-1,
							respawndelay = 60,
						},
					}
				},
		animation = {
				swim = {
					start_frame = 81,
					end_frame   = 155,
					},
				stand = {
					start_frame = 1,
					end_frame   = 80,
					},
				},
		states = {
				{ 
					name = "default",
					movgen = "none",
					chance = 0,
					animation = "stand",
					graphics_3d = {
						visual = "mesh",
						mesh = "fish_blue_white.b3d",
						textures = {"fish_blue_white_mesh.png"},
						collisionbox = selectionbox_fish_blue_white,
						visual_size= {x=1,y=1,z=1},
						},
					graphics = {
						sprite_scale={x=2,y=1},
						sprite_div = {x=1,y=1},
						visible_height = 1,
						visible_width = 1,
						},
					typical_state_time = 5,
				},
				{ 
					name = "swiming",
					movgen = "probab_mov_gen",
					chance = 0.45,
					animation = "swim",
					typical_state_time = 30,
				},
				},
		hunger = {
			target_entities = {
					"fishing:bobber_entity"
					},
			range = 15,
			chance = 0.5,
			typical_walk_time = 30,
			keep_food = true,
		},
		}


--register with animals mod
minetest.log("action","\tadding mob "..fish_blue_white_prototype.name)
mobf_add_mob(fish_blue_white_prototype)
minetest.log("action","MOD: animal_fish_blue_white mod version " .. version .. " loaded")