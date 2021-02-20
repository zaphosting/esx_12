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

local createFrame = function(name, url, visible)

  if visible == nil then
    visible = true
  end

  SendNUIMessage({action = 'create_frame', name = name, url = url, visible = visible})

end

local destroyFrame = function(name)
	SendNUIMessage({action = 'destroy_frame', name = name})
end

local sendFrameMessage = function(name, msg)
	SendNUIMessage({target = name, data = msg})
end

local focusFrame = function(name, cursor)
	SendNUIMessage({action = 'focus_frame', name = name})
	SetNuiFocus(true, cursor)
end

self.Ready        = false
self.Frames       = {}
module.FocusOrder = {}

Frame = Extends(nil)

Frame.unfocusAll = function()
  module.FocusOrder = {}
  SetNuiFocus(false)
end

function Frame:constructor(name, url, visible)

  self.name      = name
  self.url       = url
  self.handlers  = {}
  self.loaded    = false
  self.destroyed = false
  self.hasFocus  = false
  self.hasCursor = false

  self:on('load', function()
    self.loaded = true
  end)

  createFrame(name, url, visible)

  module.Frames[self.name] = self

end

function Frame:destroy(name)
  self:unfocus()
  self.destroyed = true
  destroyFrame(self.name)
  self:emit('destroy')
end

function Frame:postMessage(msg)
  sendFrameMessage(self.name, msg)
end

function Frame:focus(cursor)

  local newFocusOrder = {}

  for i=1, #module.FocusOrder, 1 do

    local frame = module.FocusOrder[i]

    if frame ~= self then
      newFocusOrder[#newFocusOrder + 1] = frame
    end

  end

  newFocusOrder[#newFocusOrder + 1] = self

  self.hasFocus  = true
  self.hasCursor = cursor

  focusFrame(self.name, self.hasCursor)

  self:emit('focus')

end

function Frame:unfocus()

  local newFocusOrder = {}

  for i=1, #module.FocusOrder, 1 do

    local frame = module.FocusOrder[i]

    if frame ~= self then
      newFocusOrder[#newFocusOrder + 1] = frame
    end

  end

  if #newFocusOrder > 0 then
    local previousFrame = newFocusOrder[#newFocusOrder]
    SetNuiFocus(true, previousFrame.hasCursor)
  else
    SetNuiFocus(false, false)
  end

  self:emit('unfocus')

end

function Frame:on(name, fn)
  self.handlers[name]     = self.handlers[name] or {}
  local handlers          = self.handlers[name]
  handlers[#handlers + 1] = fn
end

function Frame:emit(name, ...)

  self.handlers[name] = self.handlers[name] or {}
  local handlers      = self.handlers[name]

  for i=1, #handlers, 1 do
    handlers[i](...)
  end

end
