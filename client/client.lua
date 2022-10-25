RegisterNetEvent('bccblindfold:togblindfold')
AddEventHandler('bccblindfold:togblindfold', function(playerSex, comps, toggle)
    local playerPed = PlayerPedId()

    local pcomps = json.decode(comps)
    
    if toggle == true then
        if playerSex == "male" then
            pcomps['EyeWear'] = 0x10464C0B
        else
            pcomps['EyeWear'] = 0xDA872AED
        end
    end

    SetWearable(pcomps, playerSex, playerPed, toggle)
end)

function SetWearable(pcomps, playerSex, playerPed, toggle)
    for k, v in pairs(pcomps) do
		local catHash = CategoryDBName[k]
		if playerSex == "male" then
			if v <= 0 then
				if catHash == 0xE06D30CE then
					Citizen.InvokeNative(0xD710A5007C2AC539, playerPed, 0x662AC34, 0)
				end
				Citizen.InvokeNative(0xD710A5007C2AC539, playerPed, catHash, 0);
				Citizen.InvokeNative(0xCC8CA3E88256E58F, playerPed, 0, 1, 1, 1, 0);
			else
				if catHash == 0xE06D30CE then
					Citizen.InvokeNative(0xD710A5007C2AC539, playerPed, 0x662AC34, 0)
					Citizen.InvokeNative(0xCC8CA3E88256E58F, playerPed, 0, 1, 1, 1, 0);
				end
				Citizen.InvokeNative(0x59BD177A1A48600A, playerPed, catHash);
				Citizen.InvokeNative(0xD3A7B003ED343FD9, playerPed, v, true, false, false);
				Citizen.InvokeNative(0xD3A7B003ED343FD9, playerPed, v, true, true, false);
			end
		else
			if v <= 0 then
				Citizen.InvokeNative(0xD710A5007C2AC539, playerPed, catHash, 0);
				Citizen.InvokeNative(0xCC8CA3E88256E58F, playerPed, 0, 1, 1, 1, 0);
			else
				Citizen.InvokeNative(0x59BD177A1A48600A, playerPed, catHash);
				Citizen.InvokeNative(0xD3A7B003ED343FD9, playerPed, v, true, false, true);
				Citizen.InvokeNative(0xD3A7B003ED343FD9, playerPed, v, true, true, true);
			end
		end
		Citizen.Wait(5)
	end
    SendNUIMessage({
        type = 'toggle',
        visible = toggle
    })
end

function GetClosestPlayer()
    local players, closestDistance, closestPlayer = GetActivePlayers(), -1, -1
    local playerPed, playerId = PlayerPedId(), PlayerId()
    local coords, usePlayerPed = coords, false
    
    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        usePlayerPed = true
        coords = GetEntityCoords(playerPed)
    end
    
    for i=1, #players, 1 do
        local tgt = GetPlayerPed(players[i])

        if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then

            local targetCoords = GetEntityCoords(tgt)
            local distance = #(coords - targetCoords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = players[i]
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end

RegisterCommand("blindfold", function(source, args, rawCommand)
    local closestPlayer, closestDistance = GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('bccblindfold:toggleblindfold', closestPlayer, true)
    end
end, false)

RegisterCommand("unblindfold", function(source, args, rawCommand)
    local closestPlayer, closestDistance = GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        TriggerServerEvent('bccblindfold:toggleblindfold', closestPlayer, false)
    end
end, false)

RegisterCommand("cutblindfold", function(source, args, rawCommand)
    -- TODO: Randomizer for a small chance to be able to break out of the blindfold
end, false)