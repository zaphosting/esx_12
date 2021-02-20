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

local self     = ESX.Modules['boot']
local hasError = false

for i=1, #self.CoreEntries, 1 do

  local name = self.CoreEntries[i]

  if self.ModuleHasEntryPoint(name, true) then

    local module, _error = self.LoadModule(name, true)

    if _error then
      hasError = true
      break
    end

  end

end

if not hasError then

  for i=1, #self.Entries, 1 do

    local name = self.Entries[i]

    if Config.Modules[name] and self.ModuleHasEntryPoint(name, false) then

      local module, _error = self.LoadModule(name, false)

      if _error then
        break
      end

    end

  end

end

ESX.Loaded = true

emit('esx:load')

if not IsDuplicityVersion() then
  Citizen.CreateThread(function()
    AddTextEntry('FE_THDR_GTAO', 'ESX')
  end)
end
