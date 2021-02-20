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

local Input = M('input')
local Menu  = M('ui.menu')

on('esx:db:init', function(initTable, extendTable)

  extendTable('users', {
    {name = 'accessories', type = 'TEXT', length = nil, default = nil, extra = nil},
  })

end)

on('esx_accessories:hasEnteredMarker', function(zone)
	self.CurrentAction     = 'shop_menu'
	self.CurrentActionMsg  = _U('accessories:press_access')
	self.CurrentActionData = { accessory = zone }
end)

on('esx_accessories:hasExitedMarker', function(zone)
	Menu.CloseAll()
	self.CurrentAction = nil
end)

-- Key Controls
Input.On('released', Input.Groups.MOVE, Input.Controls.PICKUP, function(lastPressed)

  if self.CurrentAction and (not ESX.IsDead) then
    self.CurrentAction()
    self.CurrentAction = nil
  end

end)

if self.Config.EnableControls then

  Input.On('released', Input.Groups.MOVE, Input.Controls.REPLAY_SHOWHOTKEY, function(lastPressed)

    if not ESX.IsDead then
      self.OpenAccessoryMenu()
    end

  end)

end
