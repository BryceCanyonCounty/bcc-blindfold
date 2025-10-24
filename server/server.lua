local Core = exports.vorp_core:GetCore()
local BccUtils = exports['bcc-utils'].initiate()
---@type BCCBlindfoldDebugLib
local DBG = BCCBlindfoldDebug


RegisterNetEvent('bcc-blindfold:ManageBlindfold', function(player, toggle)
	local src = source
    local user = Core.getUser(src)

	if not user then
		DBG.Error('No user found for source: ' .. tostring(src))
		return
	end

	local passed = true
	local shouldConsume = false
    local blindfoldItem = Config.blindfoldItem.itemName or 'blindfold'
	if player ~= nil then
		-- If using an item, check source player's inventory 
		if Config.blindfoldItem.active and toggle == true then
			local itemCount = exports.vorp_inventory:getItemCount(src, nil, blindfoldItem)
			DBG.Info('Inventory check src=' .. tostring(src) .. ' item=' .. tostring(blindfoldItem) .. ' count=' .. tostring(itemCount))
			if itemCount > 0 then
				shouldConsume = true
			else
				passed = false
				Core.NotifyRightTip(src, Config.lang.noItem, 4000)
			end
		end

		if passed then
			if player == 'self' then
				player = src
			elseif type(player) == 'string' then
				local asNum = tonumber(player)
				if asNum then
					player = asNum
				end
			end

			local targetUser = Core.getUser(player)
			if not targetUser then
				DBG.Error('No target user for player=' .. tostring(player) .. ' (src=' .. tostring(src) .. ')')
				Core.NotifyRightTip(src, Config.lang.noPlayers, 4000)
				return
			end

			local character = targetUser.getUsedCharacter
			local skin = json.decode(character.skin)
			local comps = character.comps
			local playerSex = string.gsub(tostring(skin['sex']), 'mp_', '')

			DBG.Info('Triggering SetBlindfold for player=' .. tostring(player) .. ' sex=' .. tostring(playerSex) .. ' toggle=' .. tostring(toggle) .. ' (src=' .. tostring(src) .. ')')
			TriggerClientEvent('bcc-blindfold:SetBlindfold', player, playerSex, comps, toggle)

			-- consume the blindfold from the source only after successfully triggering
			if shouldConsume then
				exports.vorp_inventory:subItem(src, blindfoldItem, 1)
				DBG.Info('Consumed item ' .. tostring(blindfoldItem) .. ' from src=' .. tostring(src))
			end
		end
	else
		Core.NotifyRightTip(src, Config.lang.noPlayers, 4000)
	end
end)

if Config.blindfoldItem.active then
	-- Register blindfold item as usable from inventory
	exports.vorp_inventory:registerUsableItem(Config.blindfoldItem.itemName, function(data)
		TriggerClientEvent('bcc-blindfold:GetPlayerToBlindfold', data.source)
		exports.vorp_inventory:closeInventory(data.source)
	end)
end

BccUtils.Versioner.checkFile(GetCurrentResourceName(), 'https://github.com/BryceCanyonCounty/bcc-blindfold')
