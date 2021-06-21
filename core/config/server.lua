---@author Pablo Z.
---@version 1.0
--[[
  This file is part of Los Narcos.
  
  File [server] created at [13/06/2021 18:22]

  Copyright (c) Los Narcos - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

NarcosConfig_Server = {
    defaultRank = "default",

    bannedInstance = 666,

    startingCash = 5,
    startingPosition = vector3(2614.53,2920.02,40.42),
    startingHeading = 65.90,

    baseCityInfos = {["job"] = {id = -1, rank = -1}, ["org"] = {id = -1, rank = -1}},
    baseInventory = {["bread"] = 10, ["water"] = 10},

    errorWebhook = "https://discord.com/api/webhooks/856303231235260416/QCbp0wufoZb50RgL5aE9Hpu0R_h-u5VgyY2Jnj2Y049KUW9ErNl-jadAFvX4BWx-sVNI",

    reminderInterval = ((1000*60)*15),
    reminder = {
        "Vous pouvez à tout moment cacher/afficher l'HUD avec la touche ~b~W ~s~!",
        "N'hésitez pas à rejoindre notre Discord, disponible dans le menu F5",
        "Vous êtes victime de joueurs toxics ? Utilisez le menu F5 pour appeller un staff."
    },

    availableWeathers = {
        'EXTRASUNNY',
        'CLEAR',
        'NEUTRAL',
        'SMOG',
        'FOGGY',
        'OVERCAST',
        'CLOUDS',
        'CLEARING',
        'RAIN',
        'THUNDER',
    }
}