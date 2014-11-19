local version = "0.1.2"

SLIDERS_GRAVITY    = -9.81
MIN_SPEED_JITTER   = 0.05
MAXIMUM_CART_SPEED = 7.5
MESE_ACCEL_VALUE = 7.5

local monorail_modpath = minetest.get_modpath("monorail")

monorail_basic_slider = "monorail:slider"
if minetest.is_yes(minetest.setting_get("monorail_carts_mimicry")) then
	monorail_basic_slider = ":default:rail"
	minetest.register_alias("monorail:slider","default:rail")
end

dofile (monorail_modpath .. "/generic_functions.lua")
dofile (monorail_modpath .. "/data_storage.lua")
dofile (monorail_modpath .. "/nodes_crafts.lua")
dofile (monorail_modpath .. "/physics.lua")
dofile (monorail_modpath .. "/slider.lua")
dofile (monorail_modpath .. "/player_interaction.lua")
dofile (monorail_modpath .. "/generic_functions.lua")
dofile (monorail_modpath .. "/workarounds.lua")
dofile (monorail_modpath .. "/cart_generic.lua")
dofile (monorail_modpath .. "/transport_cart.lua")
dofile (monorail_modpath .. "/cart.lua")
dofile (monorail_modpath .. "/switch.lua")

if minetest.is_yes(minetest.setting_get("monorail_carts_mimicry")) then
	minetest.log("error","**********************************************************************")
	minetest.log("error","* Monorail mod carts mimicry mode enabled!!!                         *")
	minetest.log("error","**********************************************************************")
end
print("monorail mod " .. version .. " loaded")