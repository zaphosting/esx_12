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

on('esx:db:ready', function()

	print('ensuring migrations')

  	local boot = ESX.Modules['boot']
	local index    = 0
	local results  = {}
	local start
	local manifest = LoadResourceFile(GetCurrentResourceName(), 'fxmanifest.lua')

	self.Ensure('base')

	for i=1, #boot.CoreOrder, 1 do

    	local module = boot.CoreOrder[i]
		self.Ensure(module, true)

	end

	for i=1, #boot.Order, 1 do

    	local module = boot.Order[i]
		self.Ensure(module, false)

	end

  emit('esx:migrations:done')

end)
