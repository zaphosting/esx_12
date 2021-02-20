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

-- Namespaces
self.game = self.game or {}
self.ui   = self.ui   or {}

-- Locals
local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local EnumerateEntities = function(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)
		local next = true

		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

-- Game
self.game.enumerateObjects = function()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

enumerateObjects = self.game.enumerateObjects -- Make it global for convenience

self.game.enumeratePeds = function()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

enumeratePeds = self.game.enumeratePeds -- Make it global for convenience

self.game.enumerateVehicles = function()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

enumerateVehicles = self.game.enumerateVehicles -- Make it global for convenience

self.game.enumeratePickups = function()
	return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

enumeratePickups = self.game.enumeratePickups -- Make it global for convenience

self.game.requestModel = function(model, cb)

  if type(model) == 'string' then
    model = GetHashKey(model)
  end

  local interval

  interval = ESX.SetInterval(50, function()

    if HasModelLoaded(model) then

      ESX.ClearInterval(interval)

      if cb ~= nil then
        cb(obj)
      end

    end

  end)

end

self.game.createObject = function(model, coords, cb)

  if type(model) == 'string' then
    model = GetHashKey(model)
  end

  self.game.requestModel(model, function()

    local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)
    SetModelAsNoLongerNeeded(model)

    if cb ~= nil then
      cb(obj)
    end

  end)

end

self.game.createLocalObject = function(model, coords, cb)

  if type(model) == 'string' then
    model = GetHashKey(model)
  end

  self.game.requestModel(model, function()

    local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)
    SetModelAsNoLongerNeeded(model)

    if cb ~= nil then
      cb(obj)
    end

  end)

end

self.game.createVehicle = function(model, coords, heading, cb)

  if type(model) == 'string' then
    model = GetHashKey(model)
  end

  self.game.requestModel(model, function()

		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		local vehicle   = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
		local networkId = NetworkGetNetworkIdFromEntity(vehicle)
		local timeout   = 0

		SetNetworkIdCanMigrate(networkId, true)
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetVehRadioStation(vehicle, 'OFF')
		SetModelAsNoLongerNeeded(model)

		if cb ~= nil then
      cb(vehicle)
    end

  end)

end

self.game.createLocalVehicle = function(model, coords, heading, cb)

  if type(model) == 'string' then
    model = GetHashKey(model)
  end

  self.game.requestModel(model, function()

		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		local vehicle   = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, false)
		local networkId = NetworkGetNetworkIdFromEntity(vehicle)
		local timeout   = 0

		SetNetworkIdCanMigrate(networkId, true)
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetVehRadioStation(vehicle, 'OFF')
		SetModelAsNoLongerNeeded(model)

		if cb ~= nil then
      cb(vehicle)
    end

  end)

end

self.game.isVehicleEmpty = function(vehicle)

	local passengers     = GetVehicleNumberOfPassengers(vehicle)
	local driverSeatFree = IsVehicleSeatFree(vehicle, -1)

  return (passengers == 0) and driverSeatFree

end

self.game.getVehicleProperties = function(vehicle)

  if DoesEntityExist(vehicle) then

    local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		local extras = {}

		for extraId=0, 12 do
			if DoesExtraExist(vehicle, extraId) then
				local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
				extras[tostring(extraId)] = state
			end
		end

		return {

      model             = GetEntityModel(vehicle),

			plate             = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)),
			plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

			bodyHealth        = ESX.Math.Round(GetVehicleBodyHealth(vehicle), 1),
			engineHealth      = ESX.Math.Round(GetVehicleEngineHealth(vehicle), 1),

			fuelLevel         = ESX.Math.Round(GetVehicleFuelLevel(vehicle), 1),
			dirtLevel         = ESX.Math.Round(GetVehicleDirtLevel(vehicle), 1),
			color1            = colorPrimary,
			color2            = colorSecondary,

			pearlescentColor  = pearlescentColor,
			wheelColor        = wheelColor,

			wheels            = GetVehicleWheelType(vehicle),
			windowTint        = GetVehicleWindowTint(vehicle),
			xenonColor        = GetVehicleXenonLightsColour(vehicle),

			neonEnabled       = {
				IsVehicleNeonLightEnabled(vehicle, 0),
				IsVehicleNeonLightEnabled(vehicle, 1),
				IsVehicleNeonLightEnabled(vehicle, 2),
				IsVehicleNeonLightEnabled(vehicle, 3)
			},

			neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
			extras            = extras,
			tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

			modSpoilers       = GetVehicleMod(vehicle, 0),
			modFrontBumper    = GetVehicleMod(vehicle, 1),
			modRearBumper     = GetVehicleMod(vehicle, 2),
			modSideSkirt      = GetVehicleMod(vehicle, 3),
			modExhaust        = GetVehicleMod(vehicle, 4),
			modFrame          = GetVehicleMod(vehicle, 5),
			modGrille         = GetVehicleMod(vehicle, 6),
			modHood           = GetVehicleMod(vehicle, 7),
			modFender         = GetVehicleMod(vehicle, 8),
			modRightFender    = GetVehicleMod(vehicle, 9),
			modRoof           = GetVehicleMod(vehicle, 10),

			modEngine         = GetVehicleMod(vehicle, 11),
			modBrakes         = GetVehicleMod(vehicle, 12),
			modTransmission   = GetVehicleMod(vehicle, 13),
			modHorns          = GetVehicleMod(vehicle, 14),
			modSuspension     = GetVehicleMod(vehicle, 15),
			modArmor          = GetVehicleMod(vehicle, 16),

			modTurbo          = IsToggleModOn(vehicle, 18),
			modSmokeEnabled   = IsToggleModOn(vehicle, 20),
			modXenon          = IsToggleModOn(vehicle, 22),

			modFrontWheels    = GetVehicleMod(vehicle, 23),
			modBackWheels     = GetVehicleMod(vehicle, 24),

			modPlateHolder    = GetVehicleMod(vehicle, 25),
			modVanityPlate    = GetVehicleMod(vehicle, 26),
			modTrimA          = GetVehicleMod(vehicle, 27),
			modOrnaments      = GetVehicleMod(vehicle, 28),
			modDashboard      = GetVehicleMod(vehicle, 29),
			modDial           = GetVehicleMod(vehicle, 30),
			modDoorSpeaker    = GetVehicleMod(vehicle, 31),
			modSeats          = GetVehicleMod(vehicle, 32),
			modSteeringWheel  = GetVehicleMod(vehicle, 33),
			modShifterLeavers = GetVehicleMod(vehicle, 34),
			modAPlate         = GetVehicleMod(vehicle, 35),
			modSpeakers       = GetVehicleMod(vehicle, 36),
			modTrunk          = GetVehicleMod(vehicle, 37),
			modHydrolic       = GetVehicleMod(vehicle, 38),
			modEngineBlock    = GetVehicleMod(vehicle, 39),
			modAirFilter      = GetVehicleMod(vehicle, 40),
			modStruts         = GetVehicleMod(vehicle, 41),
			modArchCover      = GetVehicleMod(vehicle, 42),
			modAerials        = GetVehicleMod(vehicle, 43),
			modTrimB          = GetVehicleMod(vehicle, 44),
			modTank           = GetVehicleMod(vehicle, 45),
			modWindows        = GetVehicleMod(vehicle, 46),
			modLivery         = GetVehicleLivery(vehicle)
    }
  end

end

self.game.setVehicleProperties = function(vehicle, props)

  if DoesEntityExist(vehicle) then

		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)

    SetVehicleModKit(vehicle, 0)

    if props.plate             then SetVehicleNumberPlateText(vehicle, props.plate) end
    if props.plateIndex        then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
    if props.bodyHealth        then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
    if props.engineHealth      then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
    if props.fuelLevel         then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) end
    if props.dirtLevel         then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end
    if props.color1            then SetVehicleColours(vehicle, props.color1, colorSecondary) end
    if props.color2            then SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2) end
    if props.pearlescentColor  then SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor) end
    if props.wheelColor        then SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor) end
    if props.wheels            then SetVehicleWheelType(vehicle, props.wheels) end
    if props.windowTint        then SetVehicleWindowTint(vehicle, props.windowTint) end

		if props.neonEnabled then
			SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
			SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
			SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
			SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
		end

		if props.extras then
			for extraId,enabled in pairs(props.extras) do
				if enabled then
					SetVehicleExtra(vehicle, tonumber(extraId), 0)
				else
					SetVehicleExtra(vehicle, tonumber(extraId), 1)
				end
			end
		end

  if props.neonColor          then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end
  if props.xenonColor         then SetVehicleXenonLightsColour(vehicle, props.xenonColor) end
  if props.modSmokeEnabled    then ToggleVehicleMod(vehicle, 20, true) end
  if props.tyreSmokeColor     then SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3]) end
  if props.modSpoilers        then SetVehicleMod(vehicle, 0, props.modSpoilers, false) end
  if props.modFrontBumper     then SetVehicleMod(vehicle, 1, props.modFrontBumper, false) end
  if props.modRearBumper      then SetVehicleMod(vehicle, 2, props.modRearBumper, false) end
  if props.modSideSkirt       then SetVehicleMod(vehicle, 3, props.modSideSkirt, false) end
  if props.modExhaust         then SetVehicleMod(vehicle, 4, props.modExhaust, false) end
  if props.modFrame           then SetVehicleMod(vehicle, 5, props.modFrame, false) end
  if props.modGrille          then SetVehicleMod(vehicle, 6, props.modGrille, false) end
  if props.modHood            then SetVehicleMod(vehicle, 7, props.modHood, false) end
  if props.modFender          then SetVehicleMod(vehicle, 8, props.modFender, false) end
  if props.modRightFender     then SetVehicleMod(vehicle, 9, props.modRightFender, false) end
  if props.modRoof            then SetVehicleMod(vehicle, 10, props.modRoof, false) end
  if props.modEngine          then SetVehicleMod(vehicle, 11, props.modEngine, false) end
  if props.modBrakes          then SetVehicleMod(vehicle, 12, props.modBrakes, false) end
  if props.modTransmission    then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
  if props.modHorns           then SetVehicleMod(vehicle, 14, props.modHorns, false) end
  if props.modSuspension      then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
  if props.modArmor           then SetVehicleMod(vehicle, 16, props.modArmor, false) end
  if props.modTurbo           then ToggleVehicleMod(vehicle, 18, props.modTurbo) end
  if props.modXenon           then ToggleVehicleMod(vehicle, 22, props.modXenon) end
  if props.modFrontWheels     then SetVehicleMod(vehicle, 23, props.modFrontWheels, false) end
  if props.modBackWheels      then SetVehicleMod(vehicle, 24, props.modBackWheels, false) end
  if props.modPlateHolder     then SetVehicleMod(vehicle, 25, props.modPlateHolder, false) end
  if props.modVanityPlate     then SetVehicleMod(vehicle, 26, props.modVanityPlate, false) end
  if props.modTrimA           then SetVehicleMod(vehicle, 27, props.modTrimA, false) end
  if props.modOrnaments       then SetVehicleMod(vehicle, 28, props.modOrnaments, false) end
  if props.modDashboard       then SetVehicleMod(vehicle, 29, props.modDashboard, false) end
  if props.modDial            then SetVehicleMod(vehicle, 30, props.modDial, false) end
  if props.modDoorSpeaker     then SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false) end
  if props.modSeats           then SetVehicleMod(vehicle, 32, props.modSeats, false) end
  if props.modSteeringWheel   then SetVehicleMod(vehicle, 33, props.modSteeringWheel, false) end
  if props.modShifterLeavers  then SetVehicleMod(vehicle, 34, props.modShifterLeavers, false) end
  if props.modAPlate          then SetVehicleMod(vehicle, 35, props.modAPlate, false) end
  if props.modSpeakers        then SetVehicleMod(vehicle, 36, props.modSpeakers, false) end
  if props.modTrunk           then SetVehicleMod(vehicle, 37, props.modTrunk, false) end
  if props.modHydrolic        then SetVehicleMod(vehicle, 38, props.modHydrolic, false) end
  if props.modEngineBlock     then SetVehicleMod(vehicle, 39, props.modEngineBlock, false) end
  if props.modAirFilter       then SetVehicleMod(vehicle, 40, props.modAirFilter, false) end
  if props.modStruts          then SetVehicleMod(vehicle, 41, props.modStruts, false) end
  if props.modArchCover       then SetVehicleMod(vehicle, 42, props.modArchCover, false) end
  if props.modAerials         then SetVehicleMod(vehicle, 43, props.modAerials, false) end
  if props.modTrimB           then SetVehicleMod(vehicle, 44, props.modTrimB, false) end
  if props.modTank            then SetVehicleMod(vehicle, 45, props.modTank, false) end
  if props.modWindows         then SetVehicleMod(vehicle, 46, props.modWindows, false) end

		if props.modLivery then
			SetVehicleMod(vehicle, 48, props.modLivery, false)
			SetVehicleLivery(vehicle, props.modLivery)
		end
	end
end

-- UI
self.ui.showNotification = function(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(msg)
	DrawNotification(false, true)
end

self.ui.showAdvancedNotification = function(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)

  if saveToBrief == nil then
    saveToBrief = true
  end

  BeginTextCommandThefeedPost('STRING')
  AddTextComponentSubstringPlayerName(msg)

  if hudColorIndex then
    ThefeedNextPostBackgroundColor(hudColorIndex)
  end

	EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
  EndTextCommandThefeedPostTicker(flash or false, saveToBrief)

end

self.ui.showHelpNotification = function(msg, thisFrame, beep, duration)

  BeginTextCommandDisplayHelp('STRING')
  AddTextComponentSubstringPlayerName(msg)

	if thisFrame then
		DisplayHelpTextThisFrame(msg, false)
	else
		if beep == nil then beep = true end
		BeginTextCommandDisplayHelp('esxHelpNotification')
		EndTextCommandDisplayHelp(0, false, beep, duration or -1)
  end

end

self.ui.howFloatingHelpNotification = function(msg, coords, timeout)

  timeout     = timeout or 5000
  local start = GetGameTimer()

  Citizen.CreateThread(function()

    while (GetGameTimer() - start) < timeout do

      SetFloatingHelpTextWorldPosition(1, coords.x, coords.y, coords.z)
      SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
      BeginTextCommandDisplayHelp('STRING')
      AddTextComponentSubstringPlayerName(msg)
      EndTextCommandDisplayHelp(2, false, true, -1)

      Citizen.Wait(0)

    end

  end)

end
