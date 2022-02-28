UT = {}

UT.settings = {}
UT.tempSettings = {}
UT.tempSettings.mission = {}
UT.tempSettings.construction = {}
UT.tempSettings.construction.spawnedUnits = {}

UT.saveFilesNames = {}
UT.saveFilesNames.settings = "ut-settings.json"

UT.colors = {
    white = Color("ffffff"),
    success = Color("00ff00"),
    warning = Color("ffff00"),
    danger = Color("ff0000")
}

function UT:loadSettings()
    UT.settings = UT.Utils:getSaveTable(UT.saveFilesNames.settings)
    return true
end

function UT:saveSettings()
    return UT.Utils:setSaveTable(UT.saveFilesNames.settings, UT.settings)
end

function UT:log(data)
    log(UT.Utils:toString(data))
end

function UT:getLocalizedText(stringId)
    return managers.localization:text(stringId)
end

function UT:addAlert(message, color, localized)
    if localized or localized == nil then
        message = UT:getLocalizedText(message)
    end
    managers.mission._fading_debug_output:script().log(message, color or UT.colors.white)
end

function UT:isUnitLoaded(name)
    return PackageManager:has(Idstring("unit"), name)
end

function UT:spawnUnit(name, position, rotation)
    if not UT:isUnitLoaded(name) then
        return false
    end
    return World:spawn_unit(name, position, rotation)
end

function UT:removeUnit(unit)
    if not alive(unit) then
        return
    end
    World:delete_unit(unit)
    managers.network:session():send_to_peers_synched("remove_unit", unit)
end

function UT:enableUnlimitedConversions()
    _G.CloneClass(PlayerManager)
    function PlayerManager:upgrade_value(category, upgrade, default)
        if category == "player" and upgrade == "convert_enemies" then
            return true
        elseif category == "player" and upgrade == "convert_enemies_max_minions" then
            return 1000000000
        else
            return PlayerManager.orig.upgrade_value(self, category, upgrade, default)
        end
    end
end

function UT:isHost()
    return Network:is_server()
end

function UT:isInGame()
    return Utils:IsInGameState()
end

function UT:isInHeist()
    return Utils:IsInHeist()
end

function UT:getCrosshairRay()
    return Utils:GetCrosshairRay()
end

function UT:getPlayerCameraRotation()
    return managers.player:player_unit():camera():rotation()
end

function UT:getPlayerCameraRotationFlat()
    return Rotation(UT:getPlayerCameraRotation():yaw(), 0, 0)
end

function UT:showHitMarker()
    managers.hud:on_crit_confirmed()
end

function UT:playSound(name)
    managers.menu_component:post_event(name)
end