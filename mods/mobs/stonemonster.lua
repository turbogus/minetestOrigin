
-- Stone Monster

mobs:register_mob("mobs:stone_monster", {
	type = "monster",
	hp_min = 60,
	hp_max = 70,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1.9, 0.4},
	visual = "mesh",
	mesh = "mobs_stone_monster.x",
	textures = {"mobs_stone_monster.png"},
	visual_size = {x=3, y=2.6},
	makes_footstep_sound = true,
	view_range = 10,
	walk_velocity = 0.5,
	run_velocity = 2,
	damage = 3,
	drops = {
		{name = "experience:orb_five",
		chance = 2,
		min = 1,
		max = 1,},
		{name = "experience:orb_one",
		chance = 1,
		min = 1,
		max = 1,},
		{name = "default:iron_lump",
		chance= 5,
		min=1,
		max=2,},
		{name = "default:coal_lump",
		chance=3,
		min=2,
		max=5,},
		{name = "runes:mineral",
		chance = 5,
		min = 1,
		max= 1,
		},
	},
	light_resistant = true,
	armor = 80,
	drawtype = "front",
	water_damage = 0,
	lava_damage = 0,
	light_damage = 0,
	attack_type = "dogfight",
	animation = {
		speed_normal = 15,
		speed_run = 15,
		stand_start = 0,
		stand_end = 14,
		walk_start = 15,
		walk_end = 38,
		run_start = 40,
		run_end = 63,
		punch_start = 40,
		punch_end = 63,
	},
	jump = true,
	step = 0.5,
	blood_texture = "mobs_blood.png",
})
mobs:register_spawn("mobs:stone_monster", {"default:stone"}, 3, -1, 7000, 1, 0)