-- Copyright (c) Jérémie N'gadi
--
-- All rights reserved.
--
-- Even if 'All rights reserved' is very clear :
--
--   You shall not use any piece of this software in a commercial product / service
--   You shall not resell this software
--   You shall not provide any facility to install this particular software in a commercial product / service
--   If you redistribute this software, you must link to ORIGINAL repository at https://github.com/ESX-Org/es_extended
--   This copyright should appear in every part of the project code

local self = ESX.Modules['boot']

local HUD = self.LoadModule('game.hud', true)

-- Join
Citizen.CreateThread(function()

  while true do
		Citizen.Wait(0)

		if NetworkIsPlayerActive(PlayerId()) then
			emitServer('esx:onPlayerJoined')
			break
		end
  end

end)

-- Pause menu disables HUD display
if Config.EnableHud then

  ESX.SetInterval(300, function()

    if IsPauseMenuActive() and not ESX.IsPaused then
      ESX.IsPaused = true
      HUD.SetDisplay(0.0)
    elseif not IsPauseMenuActive() and ESX.IsPaused then
      ESX.IsPaused = false
      HUD.SetDisplay(1.0)
    end

  end)

end

local shootTimeout = nil

ESX.SetInterval(300, function()

  if ESX.PlayerLoaded and (not ESX.IsDead) then

    local playerPed = PlayerPedId()

    if IsPedShooting(playerPed) then

      if shootTimeout ~= nil then
        ESX.ClearTimeout(shootTimeout)
      end

      shootTimeout = ESX.SetTimeout(1000, function()

        local _,weaponHash = GetCurrentPedWeapon(playerPed, true)
        local weapon = ESX.GetWeaponFromHash(weaponHash)

        if weapon then
          local ammoCount = GetAmmoInPedWeapon(playerPed, weaponHash)
          emitServer('esx:updateWeaponAmmo', weapon.name, ammoCount)
        end

      end)

    end

  end

end)

local previousCoords

ESX.SetInterval(1000, function()

  if ESX.PlayerLoaded and (not ESX.IsDead) then

    local playerPed = PlayerPedId()

    if DoesEntityExist(playerPed) then

      local playerCoords = GetEntityCoords(playerPed)
      previousCoords     = previousCoords or playerCoords
      local distance     = #(playerCoords - previousCoords)

      if distance > 1 then
        previousCoords = playerCoords
        local playerHeading = math.round(GetEntityHeading(playerPed), 1)
        local formattedCoords = {x = math.round(playerCoords.x, 1), y = math.round(playerCoords.y, 1), z = math.round(playerCoords.z, 1), heading = playerHeading}
        emitServer('esx:updateCoords', formattedCoords)
      end

    end

  end

end)

-- Disable wanted level
if Config.DisableWantedLevel then

  Citizen.CreateThread(function()

    local playerId = PlayerId()

    if GetPlayerWantedLevel(playerId) ~= 0 then
      SetPlayerWantedLevel(playerId, 0, false)
      SetPlayerWantedLevelNow(playerId, false)
    end

    Citizen.Wait(0)

  end)

end

-- Pickups
local pickupsInRange      = {}
local closestUsablePickup = nil

ESX.SetInterval(500, function()

  local playerPed    = PlayerPedId()
  local playerCoords = GetEntityCoords(playerPed)

  pickupsInRange      = {}
  closestUsablePickup = nil

  for pickupId, pickup in pairs(ESX.Pickups) do

    local distance = #(playerCoords - pickup.coords)

    if distance < 5.0 then

      pickupsInRange[#pickupsInRange + 1] = pickup

      if distance < 1.0 then
        closestUsablePickup = pickup
      end

    end

  end

end)

Citizen.CreateThread(function()

  local playerPed    = PlayerPedId()
  local playerCoords = GetEntityCoords(playerPed)

  for i=1, #pickupsInRange, 1 do

    local pickup = pickupsInRange[i]

    ESX.ShowFloatingHelpNotification(pickup.label, {
      x = pickup.coords.x,
      y = pickup.coords.y,
      z = pickup.coords.z + 0.25
    }, 100)

  end

  Citizen.Wait(0)

end)

Citizen.CreateThread(function()

  if closestUsablePickup ~= nil then

    local playerPed = PlayerPedId()
    local pickup    = closestUsablePickup

    if IsControlJustReleased(0, 38) then
      if IsPedOnFoot(playerPed) then

        Citizen.CreateThread(function()

          local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
          ESX.Streaming.RequestAnimDict(dict)
          TaskPlayAnim(playerPed, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
          Citizen.Wait(1000)
          emitServer('esx:onPickup', pickup.id)
          PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)

        end)

      end
    end

  end

  Citizen.Wait(0)

end)
