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

-- Immediate definitions

local _print = print

print = function(...)

  local args = {...}
  local str  = '[^4esx^7]'

  for i=1, #args, 1 do
    str = str .. ' ' .. tostring(args[i])
  end

  _print(str)

end

local tableIndexOf = function(t, val)

  for i=1, #t, 1 do
    if t[i] == val then
      return i
    end
  end

  return -1

end

-- ESX base
ESX                   = {}
ESX.Loaded            = false
ESX.Ready             = false
ESX.Modules           = {}
ESX.TimeoutCount      = 1
ESX.CancelledTimeouts = {}

ESX.GetConfig = function()
  return Config
end

ESX.LogError = function(err, loc)
  loc = loc or '<unknown location>'
  print(debug.traceback('^1[error] in ^5' .. loc .. '^7\n\n^5message: ^1' .. err .. '^7\n'))
end

ESX.EvalFile = function(resource, file, env)

  env           = env or {}
  env._G        = env
  local code    = LoadResourceFile(resource, file)
  local fn      = load(code, '@' .. resource .. ':' .. file, 't', env)
  local success = true

  local status, result = xpcall(fn, function(err)
    success = false
    ESX.LogError(err, trace, '@' .. resource .. ':' .. file)
  end)

  return env, success

end

ESX.SetTimeout = function(msec, cb)

  local id = (ESX.TimeoutCount + 1 < 65635) and (ESX.TimeoutCount + 1) or 1

  SetTimeout(msec, function()

    if ESX.CancelledTimeouts[id] then
      ESX.CancelledTimeouts[id] = nil
    else
      cb()
    end

  end)

  ESX.TimeoutCount = id;

  return id

end

ESX.ClearTimeout = function(id)
  ESX.CancelledTimeouts[id] = true
end

ESX.SetInterval = function(msec, cb)

  local id = (ESX.TimeoutCount + 1 < 65635) and (ESX.TimeoutCount + 1) or 1

  local run

  run = function()

    ESX.SetTimeout(msec, function()

      if ESX.CancelledTimeouts[id] then
        ESX.CancelledTimeouts[id] = nil
      else
        cb()
        run()
      end

    end)

  end

  ESX.TimeoutCount = id;

  run()

  return id

end

ESX.ClearInterval = function(id)
  ESX.CancelledTimeouts[id] = true
end

-- ESX main module
ESX.Modules['boot'] = {}
local self              = ESX.Modules['boot']

local resName = GetCurrentResourceName()
local modType = IsDuplicityVersion() and 'server' or 'client'

self.CoreEntries = json.decode(LoadResourceFile(resName, 'modules/__core__/modules.json'))
self.Entries     = json.decode(LoadResourceFile(resName, 'modules.json'))

self.CoreOrder   = {}
self.Order       = {}

self.GetModuleEntryPoints = function(name)

  local isCore          = self.IsCoreModule(name)
  local prefix          = isCore and '__core__/' or ''
  local shared, current = false, false

  if LoadResourceFile(resName, 'modules/' .. prefix .. name .. '/shared/module.lua') ~= nil then
    shared = true
  end

  if LoadResourceFile(resName, 'modules/' .. prefix .. name .. '/' .. modType .. '/module.lua') ~= nil then
    current = true
  end

  return shared, current

end

self.IsCoreModule = function(name)
  return tableIndexOf(self.CoreEntries, name) ~= -1
end

self.IsUserModule = function(name)
  return tableIndexOf(self.Entries, name) ~= -1
end

self.DoesModuleExist = function(name)
  return self.IsCoreModule(name) or self.IsUserModule(name)
end

self.ModuleHasEntryPoint = function(name)

  local isCore          = self.IsCoreModule(name)
  local shared, current = self.GetModuleEntryPoints(name, isCore)

  return shared or current

end

self.createModuleEnv = function(name, isCore)

  local env = {}

  for k,v in pairs(env) do
    env[k] = v
  end

  env.__RESOURCE__ = resName
  env.__ISCORE__   = isCore
  env.__MODULE__   = name
  env.module       = {}
  env.self         = env.module
  env.M            = self.LoadModule

  env.print = function(...)

    local args = {...}
    local str  = '[^3' .. name .. '^7]'

    for i=1, #args, 1 do
      str = str .. ' ' .. tostring(args[i])
    end

    print(str)

  end

  local menv         = setmetatable(env, {__index = _G, __newindex = _G})
  env._ENV           = menv
  env.module.__ENV__ = menv

  return env

end

self.LoadModule = function(name)

  local isCore = self.IsCoreModule(name)
  local prefix = isCore and '__core__/' or ''

  if ESX.Modules[name] == nil then

    if not self.DoesModuleExist(name) then
      ESX.LogError('module [' .. name .. '] is not declared in modules.json', '@' .. resName .. ':modules/__core__/__main__/module.lua')
    end

    TriggerEvent('esx:module:load:before', name, isCore)

    local menv            = self.createModuleEnv(name, isCore)
    local shared, current = self.GetModuleEntryPoints(name, isCore)

    local env, success = nil, true
    local _env, _success

    if shared then

      env, _success = ESX.EvalFile(resName, 'modules/' .. prefix .. name .. '/shared/module.lua', menv)

      if _success then
        env, _success = ESX.EvalFile(resName, 'modules/' .. prefix .. name .. '/shared/events.lua', env)
      else
        success = false
      end

      if _success then
        env, _success = ESX.EvalFile(resName, 'modules/' .. prefix .. name .. '/shared/main.lua', env)
      else
        success = false
      end

    end

    if current then

      if env then
        env, _success = ESX.EvalFile(resName, 'modules/' .. prefix .. name .. '/' .. modType .. '/module.lua', env)
      else
        env, _success = ESX.EvalFile(resName, 'modules/' .. prefix .. name .. '/' .. modType .. '/module.lua', menv)
      end

      if _success then
        env, _success = ESX.EvalFile(resName, 'modules/' .. prefix .. name .. '/' .. modType .. '/events.lua', env)
      else
        success = false
      end

      if _success then
        env, _success = ESX.EvalFile(resName, 'modules/' .. prefix .. name .. '/' .. modType .. '/main.lua', env)
      else
        success = false
      end

    end

    if success then

      ESX.Modules[name] = env['module']

      if isCore then
        self.CoreOrder[#self.CoreOrder + 1] = name
      else
        self.Order[#self.Order + 1] = name
      end

      TriggerEvent('esx:module:load:done', name, isCore)

    else

      ESX.LogError('module [' .. name .. '] does not exist', '@' .. resName .. ':modules/__core__/__main__/module.lua')
      TriggerEvent('esx:module:load:error', name, isCore)

      return nil, true

    end

  end

  return ESX.Modules[name], false

end

M = self.LoadModule
