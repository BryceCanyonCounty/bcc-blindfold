---@type BCCBlindfoldDebugLib
local DBG = BCCBlindfoldDebug
local Active = false
local SelfBlinded = false
local SavedEyeWear = nil

if Config.escape.active then
    CreateThread(function()
        Active = true
        local escapeButton = Config.escape.button
        local escapeNumbers = Config.escape.numList
        local escapeMax = Config.escape.maxRange
        while true do
            if Active then
                if IsControlJustPressed(0, escapeButton) then
                    SendNUIMessage({
                        type = 'escapekeypress',
                        state = true
                    })

                    local rando = math.random(0, escapeMax)

                    if escapeNumbers[rando] then
                        TriggerServerEvent('bcc-blindfold:ManageBlindfold', 'self', false)
                        Active = false
                    end
                end

                if IsControlJustReleased(0, escapeButton) then
                    SendNUIMessage({
                        type = 'escapekeypress',
                        state = false
                    })
                end
            end
            Wait(0)
        end
    end)
end

local function SetWearable(pcomps, playerSex, playerPed, toggle)
    local eyewear = pcomps and pcomps['EyeWear']
    if eyewear ~= nil then
        local catHash = CategoryDBName['EyeWear']
        if playerSex == 'male' then
            if eyewear <= 0 then
                if catHash == 0xE06D30CE then
                    Citizen.InvokeNative(0xD710A5007C2AC539, playerPed, 0x662AC34, 0) -- RemoveTagFromMetaPed
                end
                Citizen.InvokeNative(0xD710A5007C2AC539, playerPed, catHash, 0);      -- RemoveTagFromMetaPed
                Citizen.InvokeNative(0xCC8CA3E88256E58F, playerPed, 0, 1, 1, 1, 0)    -- UpdatePedVariation
            else
                if catHash == 0xE06D30CE then
                    Citizen.InvokeNative(0xD710A5007C2AC539, playerPed, 0x662AC34, 0)            -- RemoveTagFromMetaPed
                    Citizen.InvokeNative(0xCC8CA3E88256E58F, playerPed, 0, 1, 1, 1, 0)           -- UpdatePedVariation
                end
                Citizen.InvokeNative(0x59BD177A1A48600A, playerPed, catHash)                     -- RefreshMetaPedShopItems
                Citizen.InvokeNative(0xD3A7B003ED343FD9, playerPed, eyewear, true, false, false) -- ApplyShopItemToPed
                Citizen.InvokeNative(0xD3A7B003ED343FD9, playerPed, eyewear, true, true, false)  -- ApplyShopItemToPed
            end
        else
            if eyewear <= 0 then
                Citizen.InvokeNative(0xD710A5007C2AC539, playerPed, catHash, 0)                 -- RemoveTagFromMetaPed
                Citizen.InvokeNative(0xCC8CA3E88256E58F, playerPed, 0, 1, 1, 1, 0)              -- UpdatePedVariation
            else
                Citizen.InvokeNative(0x59BD177A1A48600A, playerPed, catHash)                    -- RefreshMetaPedShopItems
                Citizen.InvokeNative(0xD3A7B003ED343FD9, playerPed, eyewear, true, false, true) -- ApplyShopItemToPed
                Citizen.InvokeNative(0xD3A7B003ED343FD9, playerPed, eyewear, true, true, true)  -- ApplyShopItemToPed
            end
        end
        Wait(5)
    end

    SendNUIMessage({
        type = 'toggle',
        visible = toggle,
        config = Config
    })
end

-- Returns the closest active player to the local player
local function GetClosestPlayer()
    local players = GetActivePlayers()
    local player = PlayerId()
    local coords = GetEntityCoords(PlayerPedId())

    local closestPlayer = { client = -1, server = -1 }
    local closestDistance = -1

    for _, playerId in ipairs(players) do
        if playerId ~= player then
            if NetworkIsPlayerActive(playerId) then
                local targetPed = GetPlayerPed(playerId)
                if targetPed and targetPed ~= 0 then
                    local targetCoords = GetEntityCoords(targetPed)
                    local distance = #(coords - targetCoords)

                    if closestDistance == -1 or distance < closestDistance then
                        closestPlayer.client = playerId
                        closestPlayer.server = GetPlayerServerId(playerId)
                        closestDistance = distance
                    end
                end
            end
        end
    end

    return closestPlayer, closestDistance
end

RegisterNetEvent('bcc-blindfold:SetBlindfold', function(playerSex, comps, toggle)
    local playerPed = PlayerPedId()
    local pcomps = json.decode(comps)

    if toggle == true then
        -- Save the player's current eyewear so we can restore it later
        SavedEyeWear = pcomps and pcomps['EyeWear'] or nil
        DBG.Info('Saving EyeWear=' .. tostring(SavedEyeWear) .. ' before apply')

        if playerSex == 'male' then
            pcomps['EyeWear'] = 0x10464C0B
        else
            pcomps['EyeWear'] = 0xDA872AED
        end
    else
        -- Restoring: prefer the saved value; if none saved, explicitly remove eyewear (set to 0)
        if SavedEyeWear ~= nil then
            pcomps['EyeWear'] = SavedEyeWear
            DBG.Info('Restoring saved EyeWear=' .. tostring(SavedEyeWear))
            SavedEyeWear = nil
        else
            pcomps['EyeWear'] = 0
            DBG.Info('No saved EyeWear, setting EyeWear=0')
        end
    end

    Active = true
    SetWearable(pcomps, playerSex, playerPed, toggle)
end)

RegisterNetEvent('bcc-blindfold:GetPlayerToBlindfold', function()
    SelfBlinded = false
    local closestPlayer, closestDistance = GetClosestPlayer()
    if closestPlayer.client ~= -1 and closestDistance <= 3.0 then
    DBG.Info('Requesting server blind for serverId=' .. tostring(closestPlayer.server) .. ' distance=' .. tostring(closestDistance))
        TriggerServerEvent('bcc-blindfold:ManageBlindfold', tonumber(closestPlayer.server) or closestPlayer.server, true)
    end
end)

-----------------------------------------------------
--- Commands
-----------------------------------------------------

-- Commands for blindfolding other players
if Config.commands.blindPlayer.active then
    RegisterCommand(Config.commands.blindPlayer.name, function(source, args, rawCommand)
        SelfBlinded = false
        local closestPlayer, closestDistance = GetClosestPlayer()
        if closestPlayer.client ~= -1 and closestDistance <= 3.0 then
            DBG.Info('Command ' .. tostring(Config.commands.blindPlayer.name) .. ' -> blind serverId=' .. tostring(closestPlayer.server) .. ' distance=' .. tostring(closestDistance))
            TriggerServerEvent('bcc-blindfold:ManageBlindfold', tonumber(closestPlayer.server) or closestPlayer.server, true)
        end
    end, false)
end

RegisterCommand(Config.commands.unBlindPlayer.name, function(source, args, rawCommand)
    local closestPlayer, closestDistance = GetClosestPlayer()
    if closestPlayer.client ~= -1 and closestDistance <= 3.0 then
        DBG.Info('Command ' .. tostring(Config.commands.unBlindPlayer.name) .. ' -> unblind serverId=' .. tostring(closestPlayer.server) .. ' distance=' .. tostring(closestDistance))
        TriggerServerEvent('bcc-blindfold:ManageBlindfold', tonumber(closestPlayer.server) or closestPlayer.server, false)
    end
end, false)

-- Commands for blindfolding yourself
if Config.commands.blindSelf.active then
    RegisterCommand(Config.commands.blindSelf.name, function(source, args, rawCommand)
        SelfBlinded = true
        DBG.Info('Command ' .. tostring(Config.commands.blindSelf.name) .. ' -> blind self')
        TriggerServerEvent('bcc-blindfold:ManageBlindfold', 'self', true)
    end, false)

    RegisterCommand(Config.commands.unBlindSelf.name, function(source, args, rawCommand)
        if SelfBlinded then
            DBG.Info('Command ' .. tostring(Config.commands.unBlindSelf.name) .. ' -> unblind self')
            TriggerServerEvent('bcc-blindfold:ManageBlindfold', 'self', false)
        end
    end, false)
end
