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

local Menu  = M('ui.menu')

self.Open = function(name, title, restrict)

  ESX.TriggerServerCallback('esx:container:get', function(items)

    local elements = {
      {type = 'submenu', value = 'user_inventory', label = '<b>[ My inventory ]</b>'}
    }

    for i=1, #items, 1 do

      local item = items[i]

      if item.count > 0 then

        if item.type == 'account' then
          elements[#elements + 1] = {type = 'account', name = 'money', label = '<span style="color: green; font-weight: bold;">$' .. item.count .. '</span>', rawLabel = 'money'}
        elseif item.type == 'item' then
          elements[#elements + 1] = {type = 'item', name = item.name, label = item.label .. ' x' .. item.count, rawLabel = item.label}
        elseif item.type == 'weapon' then
          elements[#elements + 1] = {type = 'weapon', name = item.name, label = ESX.GetWeaponLabel(item.name) .. ' x' .. item.count, rawLabel = ESX.GetWeaponLabel(item.name)}
        end

      end

    end

    Menu.Open('default', GetCurrentResourceName(), 'container_' .. name, {
      title    = title,
      align    = 'top-left',
      elements = elements
    }, function(data, menu)

      if data.current.type == 'submenu' then

        if data.current.value == 'user_inventory' then
          menu.close()
          self.OpenUser(name, title, restrict)
        end

      elseif data.current.type == 'weapon' then

        local count = 1

        if HasPedGotWeapon(PlayerPedId(), GetHashKey(data.current.name), 0) then

          ESX.ShowNotification('You already have that weapon')

        else

          ESX.TriggerServerCallback('esx:container:pull', function(success)

            if success then
              self.Open(name, title, restrict)
            else
              ESX.ShowNotification('Cannot pull x' .. count .. ' ' .. data.current.rawLabel .. ' from ' .. title)
            end

          end, name, data.current.type, data.current.name, count)

        end

      else

        Menu.Open('dialog', GetCurrentResourceName(), 'container_item_pull_' .. name, {
          title = 'Pull ' .. data.current.rawLabel .. ' from ' .. title,
        }, function(data2, menu2)

          local count = tonumber(data2.value)

          ESX.TriggerServerCallback('esx:container:pull', function(success)

            if success then

              menu.close()
              menu2.close()

              self.Open(name, title, restrict)

            else
              ESX.ShowNotification('Cannot pull x' .. count .. ' ' .. data.current.rawLabel .. ' from ' .. title)
            end

          end, name, data.current.type, data.current.name, count)

        end, function(data2, menu2)
          menu2.close()
        end)

      end

    end, function(data, menu)
      menu.close()
    end)

  end, name, restrict)

end

self.OpenUser = function(targetContainerName, targetContainerTitle, restrict)

  ESX.TriggerServerCallback('esx:container:get:user', function(items)

    local elements = {}

    for i=1, #items, 1 do

      local item = items[i]

      if item.count > 0 then

        if item.type == 'account' then
          elements[#elements + 1] = {type = 'account', name = 'money', label = '<span style="color: green; font-weight: bold;">$' .. item.count .. '</span>', rawLabel = 'money'}
        elseif item.type == 'item' then
          elements[#elements + 1] = {type = 'item', name = item.name, label = item.label .. ' x' .. item.count, rawLabel = item.label}
        elseif item.type == 'weapon' then
          elements[#elements + 1] = {type = 'weapon', name = item.name, label = ESX.GetWeaponLabel(item.name) .. ' x' .. item.count, rawLabel = ESX.GetWeaponLabel(item.name)}
        end

      end

    end

    Menu.Open('default', GetCurrentResourceName(), 'container_user_' .. targetContainerName, {
      title    = 'My inventory',
      align    = 'top-left',
      elements = elements
    }, function(data, menu)

      if data.current.type == 'weapon' then

        local count = 1

        ESX.TriggerServerCallback('esx:container:put', function(success)

          if success then
            self.OpenUser(targetContainerName, targetContainerTitle, restrict)
          else
            ESX.ShowNotification('Cannot put x' .. count .. ' ' .. data.current.rawLabel .. ' to ' .. targetContainerTitle)
          end

        end, targetContainerName, data.current.type, data.current.name, count)

      else

        Menu.Open('dialog', GetCurrentResourceName(), 'container_item_put_' .. targetContainerName, {
          title = 'Put ' .. data.current.rawLabel .. ' to ' .. targetContainerTitle,
        }, function(data2, menu2)

          local count = tonumber(data2.value)

          ESX.TriggerServerCallback('esx:container:put', function(success)

            if success then

              menu.close()
              menu2.close()

              self.OpenUser(targetContainerName, targetContainerTitle, restrict)

            else
              ESX.ShowNotification('Cannot put x' .. count .. ' ' .. data.current.rawLabel .. ' to ' .. targetContainerTitle)
            end

          end, targetContainerName, data.current.type, data.current.name, count)

        end, function(data2, menu2)
          menu2.close()
        end)

      end

    end, function(data, menu)
      menu.close()
      self.Open(targetContainerName, targetContainerTitle, restrict)
    end)

  end, restrict)

end
