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

self.Containers = {}

local DataStore      = M('datastore')
local AddonAccount   = M('addonaccount')
local AddonInventory = M('addoninventory')

self.MissingDeps = 3

self.OnDependencyReady = function()

  self.MissingDeps = self.MissingDeps - 1

  if self.MissingDeps == 0 then
    emit('esx:container:ready')
  end

end

self.Ensure = function(name, label, owner, data)
  self.Containers[name] = self.Create(name, label, owner, data)
end

self.Get = function(name)
  return self.Containers[name]
end

self.Create = function(name, label, owner, data)

  local _self = {}

  data = data or {}

  for k,v in pairs(data) do
    _self[k] = v
  end

  _self._datastore = nil
  _self._account   = nil
  _self._inventory = nil

  _self.modified = {
    datastore = false,
    account   = false,
    inventory = false,
  }

  _self.name     = name
  _self.label    = label
  _self.owner    = owner

  _self.Init = function()

    if _self.owner == nil then

      _self._datastore = DataStore.GetSharedDataStore(name)
      _self._account   = AddonAccount.GetSharedAccount(name)
      _self._inventory = AddonInventory.GetSharedInventory(name)

    else

      _self._datastore = DataStore.GetDataStore(name, owner)
      _self._account   = AddonAccount.GetAccount(name, owner)
      _self._inventory = AddonInventory.GetInventory(name, owner)

    end

    _self._datastore.set('weapons', _self._datastore.get('weapons') or {})
    -- _self._datastore.set('clothes', _self._datastore.get('clothes') or {})

  end

  -- all
  _self.getAll = function()

    local data = {}

    local money   = _self.getMoney()
    local items   = _self.getItems()
    local weapons = _self.getWeapons()

    data[#data + 1] = {type = 'account', name = _self.name, count = money}

    for i=1, #items, 1 do
      data[#data + 1] = items[i]
    end

    for i=1, #weapons, 1 do

      local _data = {}

      for k,v in pairs(weapons[i]) do
        _data[k] = v
      end

      data[#data + 1] = _data

    end

    return data

  end

  _self.get = function(itemType, itemName)

    if itemType == 'account' then
      return {type = 'account', name = _self.name, count = _self.getMoney()}
    elseif itemType == 'item' then
      return _self.getItem(itemName)
    elseif itemType == 'weapon' then
      return _self.getWeapon(itemName)
    end

  end

  _self.set = function(itemType, itemName, itemCount)

    if itemType == 'account' then
      return _self.setMoney(itemCount)
    elseif itemType == 'item' then
      return _self.setItem(itemName, itemCount)
    elseif itemType == 'weapon' then
      return _self.setWeapon(itemName, itemCount)
    end

  end

  _self.add = function(itemType, itemName, itemCount)

    if itemType == 'account' then
      return _self.addMoney(itemCount)
    elseif itemType == 'item' then
      return _self.addItem(itemName, itemCount)
    elseif itemType == 'weapon' then
      return _self.addWeapon(itemName, itemCount)
    end

  end

  _self.remove = function(itemType, itemName, itemCount)

    if itemType == 'account' then
      return _self.removeMoney(itemCount)
    elseif itemType == 'item' then
      return _self.removeItem(itemName, itemCount)
    elseif itemType == 'weapon' then
      return _self.removeWeapon(itemName, itemCount)
    end

  end

  -- weapon
  _self.getWeapon = function(name)

    local weapons = _self._datastore.get('weapons')

    if weapons[name] == nil then
      weapons[name] = {count = 0}
    end

    return weapons[name]

  end

  _self.getWeapons = function()

    local weapons = _self._datastore.get('weapons')
    local data    = {}

    for k,v in pairs(weapons) do
      data[#data + 1] = {type = 'weapon', name = k, count = v.count}
    end

    return data

  end

  _self.setWeapon = function(name, count)

    local weapon = _self.getWeapon(name)
    weapon.count = 0

    _self.modified.datastore = true

  end

  _self.addWeapon = function(name, count)

    local weapon = _self.getWeapon(name)
    weapon.count = weapon.count + count

    _self.modified.datastore = true

  end

  _self.removeWeapon = function(name, count)

    local weapon = _self.getWeapon(name)

    weapon.count = weapon.count - count

    if weapon.count < 0 then
      weapon.count = 0
    end

    _self.modified.datastore = true

  end

  -- account
  _self.getMoney = function()
    return _self._account.getMoney()
  end

  _self.setMoney = function(amount)

    _self._account.setMoney(amount)
    _self.modified.account = true

  end

  _self.addMoney = function(amount)

    _self._account.addMoney(amount)
    _self.modified.account = true

  end

  _self.removeMoney = function(amount)

    _self._account.removeMoney(amount)
    _self.modified.account = true

  end

  -- inventory
	_self.getItem = function(name)
    return _self._inventory.getItem(name)
	end

  _self.getItems = function()

    local items = _self._inventory.getItems()
    local data  = {}

    for i=1, #items, 1 do
      data[#data + 1] = {type = 'item', name = items[i].name, count = items[i].count, label = items[i].label}
    end

    return data

  end

	_self.setItem = function(name, count)
    _self._inventory.setItem(name, count)
    _self.modified.inventory = true
  end

	_self.addItem = function(name, count)
    _self._inventory.addItem(name, count)
    _self.modified.inventory = true
	end

	_self.removeItem = function(name, count)
    _self._inventory.removeItem(name, count)
    _self.modified.inventory = true
  end

  _self.save = function()

    if _self.modified.datastore then
      _self._datastore.save()
    end

    if _self.modified.account then
      _self._account.save()
    end

    if _self.modified.inventory then
      -- _self._inventory.save()
    end

  end

  _self.Init()

  return _self

end
