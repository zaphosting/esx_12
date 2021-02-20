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

M('class')
M('events')

local HUD = M('ui.hud')

Menu = Extends(nil)

function Menu:constructor(name, data, focus)

  self.name     = name
  self.float    = data.float or 'top|left'
  self.title    = data.title or 'Untitled ESX Menu'
  self.items    = {}
  self.frame    = nil
  self.handlers = {}

  if focus == nil then
    focus = true
  end

  local _items = data.items or {}

  for i=1, #_items, 1 do

    local scope = function(i)

      local item = _items[i]

      if item.visible == nil then
        item.visible = true
      end

      if item.type == nil then

        item.type = 'default'

      elseif item.type == 'slider' then

        if item.min == nil then
          item.min = 0
        end

        if item.max == nil then
          item.max = 100
        end

        if item.value == nil then
          item.value = 0
        end

      elseif item.type == 'check' then

        if item.value == nil then
          item.value = false
        end

      elseif item.type == 'text' then

        if item.value == nil then
          item.value = ''
        end

      end

      self.items[i] = setmetatable({}, {

        __index = function(t, k)
          return item[k]
        end,

        __newindex = function(t, k, v)
          item[k] = v
          self.frame:postMessage({action = 'set_item', index = i - 1, prop = k, val = v})
        end,

      })

    end

    scope(i)

  end

  self.frame = Frame:create('ui:menu:' .. self.name, 'nui://' .. __RESOURCE__ .. '/modules/__core__/ui.menu/data/html/index.html', true)

  self.frame:on('message', function(msg)

    if msg.action == 'ready' then
      self:emit('internal:ready')
    elseif msg.action == 'item.change' then
      self:emit('internal:item.change', msg.prop, msg.val, msg.index + 1)
    elseif msg.action == 'item.click' then
      self:emit('internal:item.click', msg.index + 1)
    end

  end)

  self:on('internal:ready', function()

    self.frame:postMessage({action = 'set', data = {
      float = self.float,
      title = self.title,
      items = _items,
    }})

    if focus then
      self.frame:focus(true)
    end

    self:emit('ready')

  end)

  self:on('internal:item.change', function(prop, val, index)

    local prev = {}

    for k,v in pairs(_items[index]) do
      prev[k] = v
    end

    _items[index][prop] = val

    self:emit('item.change', self.items[index], prop, val, index)

  end)

  self:on('internal:item.click', function(index)
    self:emit('item.click', self.items[index], index)
  end)

end

function Menu:on(name, fn)
  self.handlers[name]     = self.handlers[name] or {}
  local handlers          = self.handlers[name]
  handlers[#handlers + 1] = fn
end

function Menu:emit(name, ...)

  self.handlers[name] = self.handlers[name] or {}
  local handlers      = self.handlers[name]

  for i=1, #handlers, 1 do
    handlers[i](...)
  end

end

function Menu:by(k)
  return table.by(self.items, k)
end

function Menu:kvp(kName, vName)

  if kName == nil then
    kName = 'name'
  end

  if vName == nil then
    vName = 'value'
  end

  local kvp = {}

  for k,v in pairs(self.items) do
    kvp[v[kName]] = v[vName]
  end

  return kvp

end

function Menu:destroy()
  self.frame:destroy()
end
