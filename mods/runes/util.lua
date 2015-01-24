-------- Useful functions for RUNES mod -----------

if rawget(_G, "runes") then
	runes = runes
else
	runes = {}
end

-- XP function
function runes.get_xp(playername)
	local xp = io.open(minetest.get_worldpath().."/"..playername.."_experience", "r")
	local experience = xp:read("*l")+0
	xp:close()
	return experience
end

function runes.set_xp(playername, value)
	local xp = io.open(minetest.get_worldpath().."/"..playername.."_experience", "w")
	xp:write(value)
	xp:close()
	
	--Mise à jour du HUD avec les nouveaux points d'XP
	if xpHUD[playername] then
		minetest.get_player_by_name(playername):hud_change(xpHUD[playername].id, "text","XP :"..value.."")
	end
end
