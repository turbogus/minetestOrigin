-------------------------------------------------------------------------------
-- name: printpos(pos)
--
--! @brief convert pos to string of type "(X,Y,Z)"
--! @param position to convert
--
--! @return string with coordinates of pos
-------------------------------------------------------------------------------
function printpos(pos)
    if pos ~= nil then
	   return "("..pos.x..","..pos.y..","..pos.z..")"
	end

	return ""
end

-------------------------------------------------------------------------------
-- name: printpos(pos)
--
--! @brief convert pos to string of type "(X,Y,Z)"
--! @param position to convert
--
--! @return string with coordinates of pos
-------------------------------------------------------------------------------
function monorail_calc_distance(pos1,pos2)
	return math.sqrt(   math.pow(pos1.x-pos2.x,2) +
					math.pow(pos1.y-pos2.y,2) +
					math.pow(pos1.z-pos2.z,2))
end

-------------------------------------------------------------------------------
-- name: monorail_samepos(pos1,pos2)
--
--! @brief check if two positions are equal
--! @param pos1 first position to check
--! @param pos2 second position to check
--
--! @return true/false
-------------------------------------------------------------------------------
function monorail_samepos(pos1,pos2)
	if pos1 == nil then return false end
	if pos2 == nil then return false end
	if pos1.x ~= pos2.x then return false end
	if pos1.y ~= pos2.y then return false end
	if pos1.z ~= pos2.z then return false end
	return true
end

-------------------------------------------------------------------------------
-- name: monorail_pos_is_null(pos1)
--
--! @brief check if pos is 0
--! @param position to check
--
--! @return true/false
-------------------------------------------------------------------------------
function monorail_pos_is_null(pos1)
	if pos1 == nil then return false end
	if pos1.x ~= 0 then return false end
	if pos1.y ~= 0 then return false end
	if pos1.z ~= 0 then return false end
	return true
end

pb_debug_lvl1 = function() end
pb_debug_lvl2 = function() end
pb_debug_lvl3 = function() end