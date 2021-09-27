ESX = nil
local playersProcessingCannabis = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local itemsList = {}

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM items', {}, function(itemsResult)
		for i=1, #itemsResult, 1 do
			itemsList[i] = {
				label = itemsResult[i].label,
				name  = itemsResult[i].name,
				price = itemsResult[i].price
			}
		end
	end)
end)


RegisterServerEvent('esx_allrounddealer:fetch')
AddEventHandler('esx_allrounddealer:fetch', function()
	TriggerClientEvent('esx_allrounddealer:fetchitems', source, itemsList)
end)



RegisterServerEvent('esx_oranges:sellOrange')
AddEventHandler('esx_oranges:sellOrange', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(itemName)
	local price = nil
	if(Config.useSql) then
		for k,v in pairs(itemsList) do
			if v.name == itemName then
				price = v.price
			end
		end
	else
		price = Config.Allrounditems[itemName]
	end

	--if not price then
	--	print(('esx_drugs: %s hat versucht ein Item zu verkaufen was er nicht hat'):format(xPlayer.identifier)) --Edit this. Thats show you a Notification in your console when someone try to sell  a item that he doenst have
	--	return
	--end

	if xItem.count < amount then
		TriggerClientEvent('esx:showNotification', source, _U('allrounddealer_notenough'))
		return
	end

	price = ESX.Math.Round(price * amount)

	if Config.BlackMoney then
		xPlayer.addAccountMoney('black_money', price)
	else
		xPlayer.addMoney(price)
	end

	xPlayer.removeInventoryItem(xItem.name, amount)

	TriggerClientEvent('esx:showNotification', source, _U('allrounddeal_sold', amount, xItem.label, ESX.Math.GroupDigits(price)))
end)














