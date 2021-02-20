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

AddEventHandler('esx:module:load:before', function(name, isCore)

  if isCore then
    print('[^3@' .. name .. '^7] ^5load^7')
  else
    print('[^3'  .. name .. '^7] ^5load^7')
  end

end)

AddEventHandler('esx:module:load:error', function(name, isCore)

  if isCore then
    print('[^3@' .. name .. '^7] ^1load error^7')
  else
    print('[^3'  .. name .. '^7] ^1load error^7')
  end

end)

AddEventHandler('luaconsole:getHandlers', function(cb)

  if GetResourceState('luaconsole') ~= 'started' then
    return
  end

  local name = GetCurrentResourceName()

  cb(name, function(code, env)
    if env ~= nil then
      for k,v in pairs(env) do _ENV[k] = v end
      return load(code, 'lc:' .. name, 'bt', _ENV)
    else
      return load(code, 'lc:' .. name, 'bt')
    end
  end)

end)
