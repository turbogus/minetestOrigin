-------------------------------------------------------------------------------
-- Mob Framework Mod by Sapier
-- 
-- You may copy, use, modify or do nearly anything except removing this
-- copyright notice. 
-- And of course you are NOT allow to pretend you have written it.
--
--! @file init.lua
--! @brief animalmaterials
--! @copyright Sapier
--! @author Sapier
--! @date 2013-01-27
--
-- Contact sapier a t gmx net
-------------------------------------------------------------------------------
minetest.log("action","MOD: animalmaterials loading ...")
local version = "0.1.0"


animalmaterialsdata = {}
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Node definitions
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Item definitions
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- deamondeath sword
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
minetest.register_tool("animalmaterials:sword_deamondeath", {
	description = "Sword (Deamondeath)",
	inventory_image = "default_tool_steelsword.png",
	tool_capabilities = {
		full_punch_interval = 0.50,
		max_drop_level=1,
		groupcaps={
			fleshy={times={[1]=2.00, [2]=0.80, [3]=0.40}, uses=10, maxlevel=1},
			snappy={times={[2]=0.70, [3]=0.30}, uses=40, maxlevel=1},
			choppy={times={[3]=0.70}, uses=40, maxlevel=0},
			deamon={times={[1]=0.25, [2]=0.10, [3]=0.05}, uses=20, maxlevel=3},
		}
	}
	})
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- scissors
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
minetest.register_tool("animalmaterials:scissors", {
	description = "Scissors",
	inventory_image = "animalmaterials_scissors.png",
	tool_capabilities = {
		max_drop_level=0,
		groupcaps={
			wool  = {uses=40,maxlevel=1}
		}
	},
})
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- lasso
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
minetest.register_craftitem("animalmaterials:lasso", {
	description = "Lasso",
	image = "animalmaterials_lasso.png",
	stack_max=10,
})
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- net
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
minetest.register_craftitem("animalmaterials:net", {
	description = "Net",
	image = "animalmaterials_net.png",
	stack_max=10,
})
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- saddle
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
minetest.register_craftitem("animalmaterials:saddle", {
	description = "Saddle",
	image = "animalmaterials_saddle.png",
	stack_max=99
})
minetest.register_craft({
	output = "animalmaterials:saddle",
	recipe = {
		{"animalmaterials:fur","animalmaterials:fur","animalmaterials:fur"},
		{"","group:wool",""},
		{"", "default:steel_ingot",""},
	}
})

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- contract
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
minetest.register_craftitem("animalmaterials:contract", {
	description = "Contract",
	image = "animalmaterials_contract.png",
	stack_max=10,
})

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- meat
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
minetest.register_craftitem("animalmaterials:meat_raw", { --1
	description = "Raw meat",
	image = "animalmaterials_meat_raw.png",
	on_use = minetest.item_eat(1),
	groups = { meat=1, eatable=1 },
	stack_max=25
})
minetest.register_craftitem("animalmaterials:meat_pork", { --2
	description = "Pork (raw)",
	image = "animalmaterials_meat_raw.png",
	on_use = minetest.item_eat(1),
	groups = { meat=1, eatable=1 },
	stack_max=25
})
minetest.register_craftitem("animalmaterials:meat_beef", {  --3
	description = "Beef (raw)",
	image = "animalmaterials_meat_raw.png",
	on_use = minetest.item_eat(1),
	groups = { meat=1, eatable=1 },
	stack_max=25
})
minetest.register_craftitem("animalmaterials:meat_chicken", {  --4
	description = "Chicken (raw)",
	image = "animalmaterials_meat_raw.png",
	on_use = minetest.item_eat(1),
	groups = { meat=1, eatable=1 },
	stack_max=25
})
minetest.register_craftitem("animalmaterials:meat_lamb", { --5
	description = "Lamb (raw)",
	image = "animalmaterials_meat_raw.png",
	on_use = minetest.item_eat(1),
	groups = { meat=1, eatable=1 },
	stack_max=25
})
minetest.register_craftitem("animalmaterials:meat_venison", { --6
	description = "Venison (raw)",
	image = "animalmaterials_meat_raw.png",
	on_use = minetest.item_eat(1),
	groups = { meat=1, eatable=1 },
	stack_max=25
})
minetest.register_craftitem("animalmaterials:meat_undead", {	-- A changer
	description = "Meat (not quite dead)",
	image = "animalmaterials_meat_raw.png",
	on_use = minetest.item_eat(-2),
	groups = { meat=1, eatable=1 },
	stack_max=5
})
minetest.register_craftitem("animalmaterials:meat_toxic", {		-- A changer
	description = "Toxic Meat",
	image = "animalmaterials_meat_raw.png",
	on_use = minetest.item_eat(-5),
	groups = { meat=1, eatable=1 },
	stack_max=5
})
minetest.register_craftitem("animalmaterials:meat_ostrich", { --7
	description = "Ostrich Meat",
	image = "animalmaterials_meat_raw.png",
	on_use = minetest.item_eat(3),
	groups = { meat=1, eatable=1 },
	stack_max=5
})

minetest.register_craftitem("animalmaterials:fish_bluewhite", { --8
	description = "Fish (bluewhite)",
	image = "animalmaterials_meat_raw.png",
	on_use = minetest.item_eat(0),
	groups = { meat=1, eatable=1 },
	stack_max=25
})

minetest.register_craftitem("animalmaterials:fish_clownfish", { --9
	description = "Fish (clownfish)",
	image = "animalmaterials_meat_raw.png",
	on_use = minetest.item_eat(0),
	groups = { meat=1, eatable=1 },
	stack_max=25
})

--===========================


-- Cooked meat 
--
-- Déclaration de l'item (nb : donne 4 points d'Xp) 
--
minetest.register_craftitem("animalmaterials:cooked_meat", {
	description = "Monster cooked meat",
	image = "animalmaterials_meat_cooked.png",
	on_use = minetest.item_eat(4),
	groups = { meat=1, eatable=1 },
	stack_max = 99
})

-- Déclaration des cuissons
--
minetest.register_craft({
	type = "cooking",
	output = "animalmaterials:cooked_meat",
	recipe = "animalmaterials:meat_undead",
})
minetest.register_craft({
	type = "cooking",
	output = "animalmaterials:cooked_meat",
	recipe = "animalmaterials:meat_toxic",
})
--1
minetest.register_craft({
	type = "cooking",
	output = "animalmaterials:cooked_meat",
	recipe = "animalmaterials:meat_raw",
})
--2
minetest.register_craft({
	type = "cooking",
	output = "animalmaterials:cooked_meat",
	recipe = "animalmaterials:meat_pork",
})
--3
minetest.register_craft({
	type = "cooking",
	output = "animalmaterials:cooked_meat",
	recipe = "animalmaterials:meat_beef",
})
--4
minetest.register_craft({
	type = "cooking",
	output = "animalmaterials:cooked_meat",
	recipe = "animalmaterials:meat_chicken",
})
--5
minetest.register_craft({
	type = "cooking",
	output = "animalmaterials:cooked_meat",
	recipe = "animalmaterials:meat_lamb",
})
--6
minetest.register_craft({
	type = "cooking",
	output = "animalmaterials:cooked_meat",
	recipe = "animalmaterials:meat_venison",
})
--7
minetest.register_craft({
	type = "cooking",
	output = "animalmaterials:cooked_meat",
	recipe = "animalmaterials:meat_ostrich",
})
--8
minetest.register_craft({
	type = "cooking",
	output = "animalmaterials:cooked_meat",
	recipe = "animalmaterials:fish_bluewhite",
})
--9
minetest.register_craft({
	type = "cooking",
	output = "animalmaterials:cooked_meat",
	recipe = "animalmaterials:fish_clownfish",
})

--==========================

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- feather
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
minetest.register_craftitem("animalmaterials:feather", {
	description = "Feather",
	image = "animalmaterials_feather.png",
	stack_max=25
})
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- milk
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
minetest.register_craftitem("animalmaterials:milk", {
	description = "Milk",
	image = "animalmaterials_milk.png",
	on_use = minetest.item_eat(1),
	groups = { eatable=1 },
	stack_max=10
})
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- egg
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
minetest.register_craftitem("animalmaterials:egg", {
	description = "Egg",
	image = "animalmaterials_egg.png",
	stack_max=10
})

minetest.register_craftitem("animalmaterials:egg_big", {
	description = "Egg (big)",
	image = "animalmaterials_egg_big.png",
	stack_max=5
})

animalmaterialsdata["animalmaterials_egg"] = {
			graphics_3d = {
				visual = "mesh",
				mesh   = "animalmaterials_egg_ent.b3d",
				textures = { "animalmaterials_egg_ent_mesh.png" },
				collisionbox = { -0.12,-0.125,-0.12,0.12,0.125,0.12 },
				visual_size     = {x=1,y=1,z=1},
				}
	}
	
animalmaterialsdata["animalmaterials_egg_big"] = {
			graphics_3d = {
				visual = "mesh",
				mesh   = "animalmaterials_egg_ent.b3d",
				textures = { "animalmaterials_egg_ent_mesh.png" },
				collisionbox = { -0.24,-0.25,-0.24,0.24,0.25,0.24 },
				visual_size     = {x=2,y=2,z=2},
				}
	}

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- bone
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
minetest.register_craftitem("animalmaterials:bone", {
	description = "Bone",
	image = "animalmaterials_bone.png",
	stack_max=25
})
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- furs
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
minetest.register_craftitem("animalmaterials:fur", {
	description = "Fur",
	image = "animalmaterials_fur.png",
	stack_max=25
})

minetest.register_craftitem("animalmaterials:fur_deer", {
	description = "Deer fur",
	image = "animalmaterials_deer_fur.png",
	stack_max=10
})

minetest.register_craftitem("animalmaterials:coat_cattle", {
	description = "Cattle coat",
	image = "animalmaterials_cattle_coat.png",
	stack_max=10
})

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- horns
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
minetest.register_craftitem("animalmaterials:deer_horns", {
	description = "Deer horns",
	image = "animalmaterials_deer_horns.png",
	stack_max=20
})

minetest.register_craftitem("animalmaterials:ivory", {
	description = "Ivory",
	image = "animalmaterials_ivory.png",
	stack_max=20
})

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- scale
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
minetest.register_craftitem("animalmaterials:scale_golden", {
	description = "Scale (golden)",
	image = "animalmaterials_scale_golden.png",
	stack_max=25
})
minetest.register_craftitem("animalmaterials:scale_white", {
	description = "Scale (white)",
	image = "animalmaterials_scale_white.png",
	stack_max=25
})
minetest.register_craftitem("animalmaterials:scale_grey", {
	description = "Scale (grey)",
	image = "animalmaterials_scale_grey.png",
	stack_max=25
})
minetest.register_craftitem("animalmaterials:scale_blue", {
	description = "Scale (blue)",
	image = "animalmaterials_scale_blue.png",
	stack_max=25
})

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- recipes
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
minetest.register_craft({
	output = "wool:white",
	recipe = {
		{"animalmaterials:feather","animalmaterials:feather","animalmaterials:feather"},
		{"animalmaterials:feather", "animalmaterials:feather","animalmaterials:feather"},
		{"animalmaterials:feather","animalmaterials:feather","animalmaterials:feather"},
	}
})

minetest.register_craft({
	output = "animalmaterials:contract",
	recipe = {
		{"default:paper"},
		{"default:paper"},
	}
})

minetest.log("action","MOD: animalmaterials mod version " .. version .. " loaded")
