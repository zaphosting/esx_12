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


M('player')

onRequest('esx:identity:check', function(source, cb)
  local player = xPlayer.fromId(source)
  cb(player:getFirstName() and player:getLastName() and player:getDOB())
end)

onClient('esx:identity:register', function(data)

  local source = source
  local player = xPlayer.fromId(source)

  player:setFirstName(data.firstName)
  player:setLastName (data.lastName)
  player:setDOB      (data.dob)
  player:setIsMale   (data.isMale)

end)
