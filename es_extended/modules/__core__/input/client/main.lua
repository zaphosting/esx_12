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

M('events')

self.InitESX()

Citizen.CreateThread(function()
  while true do

    local pressed   = {}
    local released  = {}
    local dpressed  = {}
    local dreleased = {}

    for group, ids in pairs(self.RegisteredControls) do

      for i=1, #ids, 1 do

        local id = ids[i]

        if self.IsControlEnabled(group, id) then

          if IsControlJustPressed(group, id) then
            pressed[#pressed + 1] = {group, id, self.LastPressed[group][id]}
          elseif IsControlJustReleased(group, id) then
            released[#released + 1] = {group, id, self.LastReleased[group][id]}
          end

        else

          DisableControlAction(group, id, true);

          if IsDisabledControlJustPressed(group, id) then
            dpressed[#dpressed + 1] = {group, id, self.LastDisabledPressed[group][id]}
            self.LastDisabledPressed[group][id] = GetGameTimer()
          elseif IsDisabledControlJustReleased(group, id) then
            dreleased[#dreleased + 1] = {group, id, self.LastDisabledReleased[group][id]}
            self.LastDisabledReleased[group][id] = GetGameTimer()
          end

        end

      end
    end

    for i=1, #pressed, 1 do
      emit('esx:input:pressed:' .. pressed[i][1] .. ':' .. pressed[i][2], pressed[i][3])
    end

    for i=1, #released, 1 do
      emit('esx:input:released:' .. released[i][1] .. ':' .. released[i][2], released[i][3])
    end

    for i=1, #dpressed, 1 do
      emit('esx:input:disabled:pressed:' .. dpressed[i][1] .. ':' .. dpressed[i][2], dpressed[i][3])
    end

    for i=1, #dreleased, 1 do
      emit('esx:input:disabled:released:' .. dreleased[i][1] .. ':' .. dreleased[i][2], dreleased[i][3])
    end

    Citizen.Wait(0)

  end
end)
