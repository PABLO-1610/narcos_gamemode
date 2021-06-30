---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [main] created at [21/06/2021 04:29]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosServer_JobsManager = {}
NarcosServer_JobsManager.list = {}
NarcosServer_JobsManager.precise = {}

NarcosServer_JobsManager.exists = function(jobName)
    return (NarcosServer_JobsManager.list[jobName] ~= nil)
end

NarcosServer_JobsManager.get = function(jobName)
    if not NarcosServer_JobsManager.exists(jobName) then
        return
    end
    return NarcosServer_JobsManager.list[jobName]
end

NarcosServer_JobsManager.createJob = function(name, label)
    local ranks = {}
    local positions = NarcosConfig_Server.baseBuilderPositions
    for position, rankLabel in pairs(NarcosConfig_Server.baseBuilderRank) do
        local rankPerms = {}
        for k,v in pairs(NarcosEnums.Permissions) do
            rankPerms[k] = false
        end
        if position == 1 then
            for k, v in pairs(rankPerms) do
                rankPerms[k] = true
            end
        end
        ranks[position] = {label = rankLabel.label, permissions = rankPerms, outfit = {}}
    end
    NarcosServer_MySQL.insert("INSERT INTO jobs (name, label, money, history, ranks, positions, type) VALUES(@a, @b, @c, @hist, @d, @e, @f)", {
        ['a'] = name,
        ['b'] = label,
        ['c'] = NarcosConfig_Server.baseBuilderMoney,
        ['hist'] = json.encode({}),
        ['d'] = json.encode(ranks),
        ['e'] = json.encode(positions),
        ['f'] = 3
    }, function()
        NarcosServer.trace(("Job créé avec succès (^2%s^7)"):format(label), Narcos.prefixes.succes)
        Job(name, label, NarcosConfig_Server.baseBuilderMoney, ranks, positions, 3)
        local labels = {}
        for k, v in pairs(NarcosServer_JobsManager.list) do
            labels[k] = v.label
        end
        NarcosServer.toAll("clientCacheSetCache", "jobsLabels", labels)
    end)
end

Narcos.netRegisterAndHandle("requestJobsLabels", function()
    local _src = source
    local labels = {}
    for k, v in pairs(NarcosServer_JobsManager.list) do
        labels[k] = v.label
    end
    NarcosServer.toClient("clientCacheSetCache", _src, "jobsLabels", labels)
end)

Narcos.netRegisterAndHandle("jobGarageOut", function(model)
    local _src = source
    if not NarcosServer_PlayersManager.exists(_src) then
        NarcosServer_ErrorsManager.diePlayer(NarcosEnums.Errors.PLAYER_NO_EXISTS, ("jobGarageOut sur le model %s"):format(model), _src)
    end
    ---@type Player
    local player = NarcosServer_PlayersManager.get(_src)
    ---@type Job
    local job = NarcosServer_JobsManager.get(player.cityInfos["job"].id)
    if not job then
        NarcosServer_ErrorsManager.diePlayer(NarcosEnums.Errors.MAJOR_VAR_NO_EXISTS, ("job est nul sur jobGarageOut model %s"):format(model), _src)
    end
    if not NarcosServer_JobsManager.precise[job.name] or not NarcosServer_JobsManager.precise[job.name].garageVehicles[model:lower()] then
        NarcosServer_ErrorsManager.diePlayer(NarcosEnums.Errors.MAJOR_VAR_NO_EXISTS, ("aucun veh sur jobGarageOut model %s"):format(model), _src)
    end
    local out = NarcosServer_JobsManager.precise[job.name].vehiclesOut[math.random(1, #NarcosServer_JobsManager.precise[job.name].vehiclesOut)]
    local veh = CreateVehicle(GetHashKey(model:lower()), out.pos, out.heading, true, true)
    while veh == nil do Wait(1) end
    local rgb = NarcosServer_JobsManager.precise[job.name].garageVehicles[model:lower()].color
    SetVehicleCustomPrimaryColour(veh, rgb[1], rgb[2], rgb[3])
    SetVehicleCustomSecondaryColour(veh, rgb[1], rgb[2], rgb[3])
    TaskWarpPedIntoVehicle(GetPlayerPed(_src), veh, -1)
    NarcosServer.toClient("serverReturnedCb", _src)
end)

Narcos.netHandle("sideLoaded", function()
    NarcosServer_MySQL.query("SELECT * FROM jobs", {}, function(result)
        local tot = 0
        for k,v in pairs(result) do
            tot = (tot + 1)
            Job(v.name, v.label, v.money, json.decode(v.ranks), json.decode(v.positions), v.type)
        end
        NarcosServer.trace(("Enregistrement de ^3%s ^7jobs"):format(tot), Narcos.prefixes.dev)
        Narcos.toInternal("jobsLoaded")
    end)
end)