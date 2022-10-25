local VORPcore = {}
TriggerEvent("getCore", function(core)
	VORPcore = core
end)

RegisterNetEvent('bccblindfold:toggleblindfold')
AddEventHandler('bccblindfold:toggleblindfold', function(player, toggle)
	local Character = VORPcore.getUser(player).getUsedCharacter
	local skin = json.decode(Character.skin)
	local comps = Character.comps
    local playerSex = string.gsub(tostring(skin["sex"]), "mp_", "")

	TriggerClientEvent('bccblindfold:togblindfold', player, playerSex, comps, toggle)
end)
