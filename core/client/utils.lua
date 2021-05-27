---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [client] created at [21/05/2021 16:18]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosClient = {}

-- MenuHelper
NarcosClient.MenuHelper = {
    alert = nil,

    defineLabelString = function(valueToCheck)
        if valueToCheck ~= nil and valueToCheck ~= "" then
            return ("~g~%s"):format(valueToCheck)
        else
            return "~b~Définir ~s~→→"
        end
    end,

    defineLabelInt = function(valueToCheck, currency)
        if valueToCheck ~= nil then
            return ("~g~%s%s"):format(valueToCheck,(currency or ""))
        else
            return "~b~Définir ~s~→→"
        end
    end
}

-- InputHelper
NarcosClient.InputHelper = {
    showBox = function(TextEntry, ExampleText, MaxStringLenght, isValueInt)
        AddTextEntry('FMMC_KEY_TIP1', TextEntry)
        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
        blockinput = true
        while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
            Wait(0)
        end
        if UpdateOnscreenKeyboard() ~= 2 then
            local result = GetOnscreenKeyboardResult()
            Wait(500)
            blockinput = false
            if isValueInt then
                local isNumber = tonumber(result)
                if isNumber then
                    return result
                else
                    return nil
                end
            end

            return result
        else
            Wait(500)
            blockinput = false
            return nil
        end
    end,

    validateInputStringDefinition = function(valueToCheck)
        return (valueToCheck ~= nil and valueToCheck ~= "")
    end,

    validateInputStringRegex = function(valueToCheck, regex)
        return string.match(valueToCheck, regex)
    end,

    validateInputIntDefinition = function(valueToCheck, positive)
        local checkPositivity = true
        if positive then
            if valueToCheck < 0 then
                checkPositivity = false
            end
        end
        return (valueToCheck ~= nil and checkPositivity)
    end
}

-- Other
NarcosClient.warnVariator = "~r~"
NarcosClient.dangerVariator = "~y~"

Narcos.newRepeatingTask(function()
    if NarcosClient.warnVariator == "~r~" then
        NarcosClient.warnVariator = "~s~"
    else
        NarcosClient.warnVariator = "~r~"
    end
    if NarcosClient.dangerVariator == "~y~" then
        NarcosClient.dangerVariator = "~o~"
    else
        NarcosClient.dangerVariator = "~y~"
    end
end, nil, 0, 650)

NarcosClient.toServer = function(eventName, ...)
    TriggerServerEvent("narcos:" .. Narcos.hash(eventName), ...)
end

NarcosClient.requestModel = function(model)
    model = GetHashKey(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
end

NarcosClient.trace = function(message)
    print(("[^1Los Narcos^7] ^7%s"):format(message))
end

NarcosClient.advancedNotification = function(sender, subject, msg, textureDict, iconType)
    AddTextEntry('AutoEventAdvNotif', msg)
    BeginTextCommandThefeedPost('AutoEventAdvNotif')
    EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
end

NarcosClient.freezePlayer = function(id, bool)
    local player = id
    SetPlayerControl(player, not bool, false)

    local ped = GetPlayerPed(player)

    if not bool then
        if not IsEntityVisible(ped) then
            SetEntityVisible(ped, true)
        end
        if not IsPedInAnyVehicle(ped) then
            SetEntityCollision(ped, true)
        end
        FreezeEntityPosition(ped, false)
        SetPlayerInvincible(player, false)
    else
        if IsEntityVisible(ped) then
            SetEntityVisible(ped, false)
        end
        SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        SetPlayerInvincible(player, true)
        if not IsPedFatallyInjured(ped) then
            ClearPedTasksImmediately(ped)
        end
    end
end

NarcosClient.playAnim = function(dict, anim, flag, blendin, blendout, playbackRate, duration)
    if blendin == nil then
        blendin = 1.0
    end
    if blendout == nil then
        blendout = 1.0
    end
    if playbackRate == nil then
        playbackRate = 1.0
    end
    if duration == nil then
        duration = -1
    end
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(1)
    end
    TaskPlayAnim(GetPlayerPed(-1), dict, anim, blendin, blendout, duration, flag, playbackRate, 0, 0, 0)
    RemoveAnimDict(dict)
end