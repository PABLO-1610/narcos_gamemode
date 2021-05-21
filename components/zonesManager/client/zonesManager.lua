---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.

  File [main] created at [21/05/2021 16:06]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local zones = {}
zones.cooldown = false
zones.list = {}

Narcos.netHandle("esxloaded", function()
    NarcosClient.toServer("requestPredefinedZones")
    while true do
        local interval = 500
        local pos = GetEntityCoords(PlayerPedId())
        local closeToMarker = false
        for zoneId, zone in pairs(zones.list) do
            local zoneCoords = zone.position
            local dist = #(pos - zoneCoords)
            if dist <= zone.distances[1] then
                closeToMarker = true
                DrawMarker(zone.type, zoneCoords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, zone.color.r, zone.color.g, zone.color.b, zone.color.a, 55555, false, true, 2, false, false, false, false)
                if dist <= zone.distances[2] then
                    AddTextEntry("ZONES", (zone.help or "Appuyez sur ~INPUT_CONTEXT~ pour intéragir"))
                    DisplayHelpTextThisFrame("ZONES", false)
                    if IsControlJustPressed(0, 51) then
                        if not zones.cooldown then
                            zones.cooldown = true
                            NarcosClient.toServer("interactWithZone", zone.id)
                            Narcos.newWaitingThread(450, function()
                                zones.cooldown = false
                            end)
                        end
                    end
                end
            end
        end
        if closeToMarker then
            interval = 0
        end
        Wait(interval)
    end
end)


Narcos.netRegisterAndHandle("newMarker", function(zone)
    zones.list[zone.id] = zone
end)

Narcos.netRegisterAndHandle("delMarker", function(zoneID)
    zones.list[zoneID] = nil
end)

Narcos.netRegisterAndHandle("cbZones", function(zoneInfos)
    zones.list = zoneInfos
end)