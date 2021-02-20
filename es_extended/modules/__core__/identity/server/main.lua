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

xPlayer.createDBAccessor('firstName', {name = 'first_name', type = 'VARCHAR', length = 32,  default = 'NULL', extra = nil})
xPlayer.createDBAccessor('lastName',  {name = 'last_name',  type = 'VARCHAR', length = 32,  default = 'NULL', extra = nil})
xPlayer.createDBAccessor('DOB',       {name = 'dob',        type = 'VARCHAR', length = 10,  default = 'NULL', extra = nil})
xPlayer.createDBAccessor('isMale',    {name = 'is_male',    type = 'INT',     length = nil, default = 1,      extra = nil})
