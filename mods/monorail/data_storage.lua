-------------------------------------------------------------------------------
-- Monorail Mod by Sapier
--
-- You may copy, use, modify or do nearly anything except removing this
-- copyright notice.
-- And of course you are NOT allow to pretend you have written it.
--
--! @file data_storage.lua
--! @brief generic functions used in many different places
--! @copyright Sapier
--! @author Sapier
--! @date 2013-02-04
--!
-- Contact sapier a t gmx net
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- name: monorail_get_current_time()
--
--! @brief alias to get current time
--
--! @return current time in seconds
-------------------------------------------------------------------------------
function monorail_get_current_time()
	return os.time(os.date('*t'))
	--return minetest.get_time()
end
-------------------------------------------------------------------------------
-- name: monorail_global_data_store(value)
--
--! @brief save data and return unique identifier
--
--! @param value to save
--
--! @return unique identifier
-------------------------------------------------------------------------------
monorail_global_data_identifier = 0
monorail_global_data = {}
monorail_global_data.cleanup_index = 0
monorail_global_data.last_cleanup = monorail_get_current_time()
function monorail_global_data_store(value)

	local current_id = monorail_global_data_identifier

	monorail_global_data_identifier = monorail_global_data_identifier + 1

	monorail_global_data[current_id] = {
									value = value,
									added = monorail_get_current_time(),
									}
	return current_id
end


-------------------------------------------------------------------------------
-- name: monorail_global_data_store(value)
--
--! @brief pop data from global store
--
--! @param id to pop
--
--! @return stored value
-------------------------------------------------------------------------------
function monorail_global_data_get(id)

	local dataid = tonumber(id)

	if dataid == nil or
		monorail_global_data[dataid] == nil then
		return nil
	end

	local retval = monorail_global_data[dataid].value
	monorail_global_data[dataid] = nil
	return retval
end

-------------------------------------------------------------------------------
-- name: monorail_global_data_store(value)
--
--! @brief pop data from global store
--
--! @param id to pop
--
--! @return stored value
-------------------------------------------------------------------------------
function monorail_global_data_cleanup(id)

	if monorail_global_data.last_cleanup + 500 <
											monorail_get_current_time() then

		for i=1,50,1 do
			if monorail_global_data[monorail_global_data.cleanup_index] ~= nil then
				if monorail_global_data[monorail_global_data.cleanup_index].added <
						monorail_get_current_time() - 300 then

					monorail_global_data[monorail_global_data.cleanup_index] = nil
				end
				monorail_global_data.cleanup_index = monorail_global_data.cleanup_index +1

				if monorail_global_data.cleanup_index > #monorail_global_data then
					monorail_global_data.cleanup_index = 0
					break
				end
			end
		end

		monorail_global_data.last_cleanup = monorail_get_current_time()
	end
end
