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

local weapons          = json.decode(LoadResourceFile(GetCurrentResourceName(), 'data/weapons.json'))
local weaponComponents = json.decode(LoadResourceFile(GetCurrentResourceName(), 'data/weapon_components.json'))

local weaponComponentsByName = {}

for i=1, #weaponComponents, 1 do
  local component = weaponComponents[i]
  weaponComponentsByName[component.nameHash] = component
end

Config.DefaultWeaponTints = {
	[0] = _U('tint_default'),
	[1] = _U('tint_green'),
	[2] = _U('tint_gold'),
	[3] = _U('tint_pink'),
	[4] = _U('tint_army'),
	[5] = _U('tint_lspd'),
	[6] = _U('tint_orange'),
	[7] = _U('tint_platinum')
}

Config.Weapons = {}

for i=1, #weapons, 1 do

  local weapon = weapons[i]
  local entry  = {}

  entry.name  = weapon.nameHash
  entry.hash  = GetHashKey(weapon.nameHash)

  if not IsDuplicityVersion() then
    entry.label       = GetLabelText(weapon.gxtName)
    entry.description = GetLabelText(weapon.gxtDescription)
  end

  entry.ammo = {
    hash = GetHashKey(weapon.ammo)
  }

  if not IsDuplicityVersion() then
    entry.ammo.label = GetLabelText(weapon.ammo)
  end

  entry.tints = Config.DefaultWeaponTints

  entry.components = {}

  for j=1, #weapon.components, 1 do

    local component     = weapon.components[j]
    local componentFull = weaponComponentsByName[component.nameHash]

    local compEntry = {
      name       = component.nameHash,
      hash       = GetHashKey(component.nameHash),
      isDefault  = component.isDefault,
      attachBone = component.attachBone,
      clipSize   = componentFull.clipSize,
      model      = componentFull.model,
    }

    if not IsDuplicityVersion() then
      compEntry.label       = GetLabelText(componentFull.gxtName)
      compEntry.description = GetLabelText(componentFull.gxtDescription)
    end

    entry.components[#entry.components + 1] = compEntry

  end

  Config.Weapons[#Config.Weapons + 1] = entry

end

