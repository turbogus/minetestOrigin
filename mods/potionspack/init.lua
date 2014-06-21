potions.register_potion("Anti Gravity", "purple", 60,
function(itemstack, user, pointed_thing) 
	user:set_physics_override(nil, 1.5, 0.5)
end,

function(itemstack, user, pointed_thing)
	user:set_physics_override(nil,1,1)
end)


potions.register_potion("Anti Gravity II", "pink", 60,
function(itemstack, user, pointed_thing) 
	user:set_physics_override(3, nil, 0.1)
end,

function(itemstack, user, pointed_thing)
	user:set_physics_override(1,nil,1)
end)

potions.register_potion("Speed", "lightgrey", 60, --/ok
function(itemstack, user, pointed_thing) 
	user:set_physics_override(3, 1, 1)
end,

function(itemstack, user, pointed_thing)
	user:set_physics_override(1,nil,nil)
end)

potions.register_potion("Speed II", "cyan", 60,
function(itemstack, user, pointed_thing) 
	user:set_physics_override(5, 1, 1)
end,

function(itemstack, user, pointed_thing)
	user:set_physics_override(1,nil,nil)
end)

potions.register_potion("Inversion", "dull", 60,
function(itemstack, user, pointed_thing) 
	user:set_physics_override(1, -1, -0.2)
end,

function(itemstack, user, pointed_thing)
	user:set_physics_override(1,1,1)
end)

potions.register_potion("Confusion", "dull", 60,
function(itemstack, user, pointed_thing) 
	user:set_physics_override(-1, nil, nil)
end,

function(itemstack, user, pointed_thing)
	user:set_physics_override(1,1,1)
end)

potions.register_potion("What will this do", "white", 60,
function(itemstack, user, pointed_thing) 
	user:set_physics_override(math.random(1, 20), math.random(1, 20), math.random(-4, 2))
end,

function(itemstack, user, pointed_thing)
	user:set_physics_override(1,1,1)
end)

potions.register_potion("Health I", "red", 1, -- /ok
function(itemstack, user, pointed_thing) 
	user:set_hp(user:get_hp()+6)
end,

function(itemstack, user, pointed_thing)
	return true;
end)

potions.register_potion("Health II", "darkred", 1,
function(itemstack, user, pointed_thing) 
	user:set_hp(user:get_hp()+10)
end,

function(itemstack, user, pointed_thing)
	return true;
end)

potions.register_potion("Harming I", "green", 1,
function(itemstack, user, pointed_thing) 
	user:set_hp(user:get_hp()-6)
end,

function(itemstack, user, pointed_thing)
	return true;
end)

potions.register_potion("Harming II", "darkgreen", 1,
function(itemstack, user, pointed_thing) 
	user:set_hp(user:get_hp()-10)
end,

function(itemstack, user, pointed_thing)
	return true;
end)
