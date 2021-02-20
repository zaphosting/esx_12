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

self.Frame              = nil
self.RegisteredElements = {}

self.SetDisplay = function(opacity)

	self.Frame:postMessage({
		action  = 'setHUDDisplay',
		opacity = opacity
  })

end

self.RegisterElement = function(name, index, priority, html, data)
	local found = false

	for i=1, #self.RegisteredElements, 1 do
		if self.RegisteredElements[i] == name then
			found = true
			break
		end
	end

	if found then
		return
	end

	table.insert(self.RegisteredElements, name)

  self.Frame:postMessage({
		action    = 'insertHUDElement',
		name      = name,
		index     = index,
		priority  = priority,
		html      = html,
		data      = data
	})

  self.UpdateElement(name, data)

end

self.RemoveElement = function(name)

  for i=1, #self.RegisteredElements, 1 do
		if self.RegisteredElements[i] == name then
			table.remove(self.RegisteredElements, i)
			break
		end
	end

	self.Frame:postMessage({
		action    = 'deleteHUDElement',
		name      = name
  })

end

self.UpdateElement = function(name, data)
	self.Frame:postMessage({
		action = 'updateHUDElement',
		name   = name,
		data   = data
	})
end
