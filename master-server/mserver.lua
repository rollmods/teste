local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
MasTer = {}
Tunnel.bindInterface("master-hunting",MasTer)

RegisterServerEvent('master-hunting:permissao')
AddEventHandler('master-hunting:permissao',function()
	local source = source
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	TriggerClientEvent('master-hunting:permissao',player)
end)

function MasTer.checkWeight(mochila)
	local source = source
	local user_id = vRP.getUserId(source)
	if true then
		if user_id then
			numPele = math.random(1,6)
			numCarne = math.random(1,14)
			if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(v.animals[i].item)*numPele+vRP.getItemWeight(v.animals[i].item2)*numCarne+vRP.getItemWeight(v.animals[i].item3)*1 <= vRP.getInventoryMaxWeight(user_id) then
				return true
			else
				return false
			end
		end
	end
end

RegisterServerEvent('master-hunting:ceifar')
AddEventHandler('master-hunting:ceifar', function(ceifar)
	local source = source
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	if true then
        for i = 1, #config.animals do
            if ceifar == config.animals[i].id then
                local numPele = math.random(1, 6)
                local numCarne = math.random(1, 14)
                vRP.giveInventoryItem(user_id, config.animals[i].item, numCarne)
                vRP.giveInventoryItem(user_id, config.animals[i].item2, numPele)
                vRP.giveInventoryItem(user_id, config.animals[i].item3, 1)
                break
            end
        end
    end
end)



RegisterServerEvent('master-hunting:itens')
AddEventHandler('master-hunting:itens',function()
	local source = source
	local user_id = vRP.getUserId(source)

	vRP.giveInventoryItem(user_id,"wbody|WEAPON_MUSKET",1)
	TriggerClientEvent("itensNotify",source,"sucesso","Coletou","wbody|WEAPON_MUSKET",1,vRP.format(vRP.getItemWeight("wbody|WEAPON_MUSKET")*parseInt(1)))

    vRP.giveInventoryItem(user_id,"wammo|WEAPON_MUSKET",20)
	TriggerClientEvent("itensNotify",source,"sucesso","Coletou","wammo|WEAPON_MUSKET",1,vRP.format(vRP.getItemWeight("wammo|WEAPON_MUSKET")*parseInt(20)))

	vRP.giveInventoryItem(user_id,"wbody|WEAPON_KNIFE",1)
	TriggerClientEvent("itensNotify",source,"sucesso","Coletou","wbody|WEAPON_KNIFE",1,vRP.format(vRP.getItemWeight("wbody|WEAPON_KNIFE")*parseInt(1)))
	
end)

RegisterServerEvent('master-hunting:coletararmas')
AddEventHandler('master-hunting:coletararmas',function()
	local source = source
	local user_id = vRP.getUserId(source)
	vRPclient.replaceWeapons(source,{})
	vRP.tryGetInventoryItem(user_id,"wammo|WEAPON_MUSKET",15)
	vRP.tryGetInventoryItem(user_id,"wbody|WEAPON_KNIFE",1)
	vRP.tryGetInventoryItem(user_id,"wbody|WEAPON_MUSKET",1)
end)

RegisterCommand('acampamento',function(source,rawCommand)
    local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryItemAmount(user_id,config.itemCampCarvao)+vRP.getInventoryItemAmount(user_id,config.itemCampLenha) >= 1 then
			TriggerClientEvent('master-hunting:acampamento', source)  
		else
			TriggerClientEvent("Notify",source,"negado","Você não possui um kit de acampamento",8000)
		end	
	end
end)

RegisterServerEvent('master-hunting:campcontrol')
AddEventHandler('master-hunting:campcontrol',function()
	TriggerClientEvent("master-hunting:createobject",source,'prop_beach_fire','prop_skid_tent_01','prop_skid_chair_02')
end)


