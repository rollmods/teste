local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

MasTer = Tunnel.getInterface("master-hunting")

local process = false

local animalsHunting = {}

local faca = 0
local ceifar = 0
local deletarentidade = false
local mochila = false

local animals = {}

local source = source
local user_id = vRP.getUserId(source)
local player = vRP.getUserSource(user_id)

emservico = false

local AnimalsPostions = {

	[2] = { ['id'] = 2, ['x'] = -1598.09, ['y'] = 4603.5, ['z'] = 36.11 },
	[3] = { ['id'] = 3, ['x'] = -1530.24, ['y'] = 4610.54, ['z'] = 29.48 },
	[4] = { ['id'] = 4, ['x'] = -1475.88, ['y'] = 4632.86, ['z'] = 49.49 },
	[5] = { ['id'] = 5, ['x'] = -1447.43, ['y'] = 4666.47, ['z'] = 53.09 },
	[6] = { ['id'] = 6, ['x'] = -1389.83, ['y'] = 4642.0, ['z'] = 76.04 },
	[7] = { ['id'] = 7, ['x'] = -1354.69, ['y'] = 4652.12, ['z'] = 107.04 },
	[8] = { ['id'] = 8, ['x'] = -1543.33, ['y'] = 4444.84, ['z'] = 12.39 },
	[9] = { ['id'] = 9, ['x'] = -1488.05, ['y'] = 4414.69, ['z'] = 21.13 },
	[10] = { ['id'] = 10, ['x'] = -1560.16, ['y'] = 4378.62, ['z'] = 4.44},
	[11] = { ['id'] = 11, ['x'] = -1501.58, ['y'] = 4395.9, ['z'] = 20.72 },
	[12] = { ['id'] = 12, ['x'] = -1448.47, ['y'] = 4440.96, ['z'] = 23.26 },
	[13] = { ['id'] = 13, ['x'] = -1315.63, ['y'] = 4469.22, ['z'] = 20.08 },
	[14] = { ['id'] = 14, ['x'] = -1705.12, ['y'] = 4296.28, ['z'] = 69.97 },
	[15] = { ['id'] = 15, ['x'] = -1532.15, ['y'] = 4221.77, ['z'] = 67.53 }
}


RegisterNetEvent('master-hunting:permissao')
AddEventHandler('master-hunting:permissao',function()
	if true then
		emservico = true
		parte = 0
		destino = math.random(1,15)
		TriggerEvent("Notify","sucesso","Voce entrou em <b>Serviço</b>!")
	end
end)

Citizen.CreateThread(function()
	while true do
		if not servico then
			if IsControlJustPressed(0,168) and emservico then
				TriggerEvent('master-hunting:cancelar')
			end
		end
	Citizen.Wait(1)
	end
end)

RegisterNetEvent('master-hunting:cancelar')
AddEventHandler('master-hunting:cancelar',function()
	local source = source
	if nveh then
		TriggerServerEvent("trydeleteveh",VehToNet(nveh))
		nveh = nil
		end
		for i = 1,#animalsHunting do
			DeletePed(animalsHunting[i])
		end
		animalsHunting = {}
		emservico = false
		TriggerServerEvent('master-hunting:armas')
		TriggerEvent('cancelando',false)
		RemoveBlip(AnimalBlip)
		vRP.playSound("Oneshot_Final","MP_MISSION_COUNTDOWN_SOUNDSET")
		TriggerEvent("Notify","negado","Você <b>saiu</b> de serviço!")
		parte = 0
end)

--[ THREAD ]----------------------------------------------------------------------------------------------------------------



Citizen.CreateThread(function()
	while true do
		local idle = 1000
		local ped = PlayerPedId()
		if emservico == false then
		if not IsPedInAnyVehicle(ped) then
			local x,y,z = table.unpack(GetEntityCoords(ped))
			if Vdist(config.pontoHunt[1],config.pontoHunt[2],config.pontoHunt[3],x,y,z) < 5.1 then
				idle = 5
					DrawMarker(23, config.pontoHunt[1],config.pontoHunt[2],config.pontoHunt[3]-0.98, 0, 0, 0, 0, 0, 0, 0.7, 0.7, 0.5, 136, 96, 240, 180, 0, 0, 0, 0)
				if Vdist(config.pontoHunt[1],config.pontoHunt[2],config.pontoHunt[3],x,y,z) <= 1.2 then
					if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), config.pontoHunt[1],config.pontoHunt[2],config.pontoHunt[3], true ) <= 1.1  then
						DrawText3D(config.pontoHunt[1],config.pontoHunt[2],config.pontoHunt[3], "[~r~E~w~] INICIAR ~r~CAÇA~w~  .")
					end
					if IsControlJustPressed(1,38) then
						mochila = true
							if MasTer.checkWeight(mochila) then
								if not process then
								faca = 1
								ceifar = 1
								mochila = true
								deletarentidade = true
								process = true
								TriggerEvent('cancelando',true)
								TriggerEvent("progress",8000,"Coletando")
								FreezeEntityPosition(ped,true)
								vRP._playAnim(false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
									SetTimeout(8000,function()
									process = false
									TriggerEvent('cancelando',false)
									FreezeEntityPosition(ped,false)
									TriggerServerEvent('master-hunting:itens')
									vRP._stopAnim(false)
									Fade(1200)
									TriggerServerEvent('master-hunting:permissao')
									emservico = true
									TriggerEvent("Notify","sucesso","Pegue seu veículo de trabalho e bom serviço!")
									spawnVehicle()
									TriggerEvent('master-hunting:spawnanimal')
									end)
								end
							else
								TriggerEvent("Notify","negado","<b>Mochila</b> cheia ou <b>itens insuficientes</b> para o trabalho.",10000)
							end
						end
					end
				end
			end
	end
		Citizen.Wait(idle)
	end
end)

RegisterNetEvent('master-hunting:spawnanimal')
AddEventHandler('master-hunting:spawnanimal', function()
	local animals = {}
	for i = 1, #config.animals do
		table.insert(animals, {
			model = config.animals[i].model,
			blipSprite = 433,
			blipColor = config.animals[i].blipColor,
			hash = config.animals[i].hash,
			item = config.animals[i].item,
			item2 = config.animals[i].item2,
			item3 = config.animals[i].item3,
			id = config.animals[i].id
		})
	end

	for i = 1, #animals do
		modelRequest(animals[i].model)
		for j = 1, 15 do
			local Animal = CreatePed(5, GetHashKey(animals[i].model), AnimalsPostions[j].x, AnimalsPostions[j].y, AnimalsPostions[j].z, 0.0, true, false)
			TaskWanderStandard(Animal, true, true)
			SetEntityAsMissionEntity(Animal, true, true)
			local AnimalBlip = AddBlipForEntity(Animal)
			SetBlipSprite(AnimalBlip, animals[i].blipSprite)
			SetBlipColour(AnimalBlip, animals[i].blipColor)
			SetBlipAlpha(AnimalBlip, 30)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Animal')
			EndTextCommandSetBlipName(AnimalBlip)
			table.insert(animalsHunting, i, Animal)
			TriggerEvent('master-hunting:ceifar')
		end
	end
end)

function getAnimalMatch(hash)
    for _, v in pairs(config.animals) do if (v.hash == hash) then return v end end
end


--[[RegisterNetEvent('master-hunting:spawnanimal')
AddEventHandler('master-hunting:spawnanimal', function()
	local animals = {
		{model = 'a_c_deer', blipSprite = 433, blipColor = 1, hash = config.animals[i].hash, item = config.animals[i].item, item2 = config.animals[i].item2, item3 = config.animals[i].item3, id = config.animals[i].id},
		{model = 'a_c_mtlion', blipSprite = 433, blipColor = 5, hash = config.animals[i].hash, item = config.animals[i].item, item2 = config.animals[i].item2, item3 = config.animals[i].item3, id = config.animals[i].id},
		{model = 'a_c_coyote', blipSprite = 433, blipColor = 3, hash = config.animals[i].hash, item = config.animals[i].item, item2 = config.animals[i].item2, item3 = config.animals[i].item3, id = config.animals[i].id},
		{model = 'a_c_rabbit_01', blipSprite = 433, blipColor = 4, hash = config.animals[i].hash, item = config.animals[i].item, item2 = config.animals[i].item2, item3 = config.animals[i].item3, id = config.animals[i].id},
		
}

	for i = 1, #animals do
		modelRequest(animals[i].model)
		for j = 1, 15 do
			
			local Animal = CreatePed(5, GetHashKey(animals[i].model), AnimalsPostions[j].x, AnimalsPostions[j].y, AnimalsPostions[j].z, 0.0, true, false)
			TaskWanderStandard(Animal, true, true)
			SetEntityAsMissionEntity(Animal, true, true)
			local AnimalBlip = AddBlipForEntity(Animal)
			SetBlipSprite(AnimalBlip, animals[i].blipSprite)
			SetBlipColour(AnimalBlip, animals[i].blipColor)
			SetBlipAlpha(AnimalBlip, 30)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Animal')
			EndTextCommandSetBlipName(AnimalBlip)
			table.insert(animalsHunting, i, Animal)
			TriggerEvent('master-hunting:ceifar')
		end
	end
end)
	
function getAnimalMatch(hash)
    for _, v in pairs(animals) do if (config.animals[i].hash == hash) then return v end end
end--]]

local MASTER = true

Citizen.CreateThread(function()
	while true do
		local idle = 750
		if emservico then
			for i = 1,#animalsHunting do
				CdsAnimal = GetEntityCoords(animalsHunting[i])
				vidaAnimal = GetEntityHealth(animalsHunting[i])
				local model = GetEntityModel()
                local animal = getAnimalMatch(model)
				local user_id = vRP.getUserId(source)
				local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
				local distanciaanimal = GetDistanceBetweenCoords(x,y,z,CdsAnimal.x,CdsAnimal.y,CdsAnimal.z,false)
				if distanciaanimal <= 1.3 and vidaAnimal <= 0 then
					if not IsPedInAnyVehicle(ped) then
						idle = 5

						DrawText3Ds(CdsAnimal.x,CdsAnimal.y,CdsAnimal.z+0.35,"[~r~E~w~] para ~r~CEIFAR~w~ o animal.")
						if IsControlJustPressed(0,38) then
							idle = 750
							TriggerEvent('cancelando',false)
							if DoesEntityExist(animalsHunting[i]) == 1 then
								if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_KNIFE')  then
									if MasTer.checkWeight(mochila) then
									SetEntityAsMissionEntity(animalsHunting[i], false, false)
										if DoesEntityExist(animalsHunting[i]) then
											deletarentidade = true
										end
										vRP._playAnim(false,{{"amb@medic@standing@kneel@base","base"}},true)
										vRP._playAnim(false,{{"anim@gangops@facility@servers@bodysearch@","player_search"}},true)
										SetTimeout(6000,function()
										vRP._stopAnim(false)
										if ceifar == 1 then
											TriggerServerEvent("master-hunting:ceifar",ceifar)
											ceifar = 0
										end
											TriggerEvent("master-hunting:deletarentidade",animalsHunting[i])
											if deletarentidade == true then
												table.remove(animalsHunting,i)
												deletarentidade = false
												mochila = true
												MASTER = true
												SetTimeout(1000,function()
												ceifar = 1
												end)
											end
										end)
									elseif not mochila == false then
										TriggerEvent("Notify","negado","<b>Mochila</b> cheia ou <b>itens insuficientes</b> para o trabalho.",10000)
										mochila = false
									end
								elseif faca == 1 then
									TriggerEvent("Notify","negado","Você precisa pegar uma <b>Faca</b>!")
									faca = 0
								end
							end
						end	
					end
				elseif distanciaanimal > 1900 then
					TriggerEvent("Notify","negado","Você está se <b>distanciando</b> dos animais!")
					if distanciaanimal > 2500 then
						TriggerEvent('master-hunting:cancelar')
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

RegisterNetEvent("master-hunting:deletarentidade")
AddEventHandler("master-hunting:deletarentidade", function(Entity)
	if deletarentidade == true then
		DeletePed(Entity)
	end
end)

function Fade(time)
	DoScreenFadeOut(800)
	Wait(time)
	DoScreenFadeIn(800)
end

--[ VEICULO ]-----------------------------------------------------------------------------------------------------------

function spawnVehicle()
	local mhash = config.VehHunt
	if not nveh then
	 while not HasModelLoaded(mhash) do
	  RequestModel(mhash)
		Citizen.Wait(10)
	 end
		local ped = PlayerPedId()
		local x,y,z = vRP.getPosition()
		nveh = CreateVehicle(mhash,config.SpawnVehHunt+0.5,258.31,true,false)
		SetVehicleIsStolen(nveh,false)
		SetVehicleOnGroundProperly(nveh)
		SetVehicleAsNoLongerNeeded(nveh)
		SetEntityInvincible(nveh,false)
		SetVehicleNumberPlateText(nveh,vRP.getRegistrationNumber())
		Citizen.InvokeNative(0xAD738C3085FE7E11,nveh,true,true)
		SetVehicleHasBeenOwnedByPlayer(nveh,true)
		SetVehicleDirtLevel(nveh,0.0)
		SetVehRadioStation(nveh,"OFF")
		SetVehicleNeedsToBeHotwired(nveh,false)
		SetVehicleEngineOn(GetVehiclePedIsIn(ped,false),true)
		SetModelAsNoLongerNeeded(mhash)
		SetVehicleFuelLevel(nveh, 50.0)
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ACAMPAMENTO
-----------------------------------------------------------------------------------------------------------------------------------------
local a = {title="Acampamento", colour=5, id=417, x=2948.568, y=5326.274, z=101.27}

RegisterNetEvent('master-hunting:acampamento')
AddEventHandler('master-hunting:acampamento', function()
    local b = PlayerPedId()
    local c = GetEntityCoords(b)
    local d = GetDistanceBetweenCoords(2952.8, 5325.69, 101.02, c.x, c.y, c.z)

    if IsPedInAnyVehicle(b) then 
        TriggerEvent("Notify", "sucesso", "Não é possível montar um acampamento dentro de um veículo")
    else 
        if d < 100 then 
            crouch()
            TriggerEvent("progress", 8000, "Montando acampamento")
            TriggerServerEvent('master-hunting:campcontrol')
            TriggerEvent("Notify", "sucesso", "Acampamento montado!")
        end 
    end
    ClearPedTasks(PlayerPedId(-1))
    Citizen.Wait(13000)
    TriggerEvent("Notify", "sucesso", "Só um!")
end)


RegisterNetEvent("master-hunting:createobject")
AddEventHandler("master-hunting:createobject", function(f,g,h)
    local i = PlayerPedId()
    local j = GetEntityCoords(i)
    local k = ObjToNet(CreateObject(GetHashKey(f), j.x-1, j.y-1.5, j.z-1.6, true, false))
    local l = ObjToNet(CreateObjectNoOffset(GetHashKey(g), j.x-1.5, j.y-3.5, j.z-0.5, true, false))
    local m = ObjToNet(CreateObjectNoOffset(GetHashKey(h), j.x-2.5, j.y+0.3, j.z-0.6, true, false))
    local n = ObjToNet(CreateObjectNoOffset(GetHashKey(h), j.x+1.0, j.y+0.3, j.z-0.6, true, false))
end) 

function crouch()
    TaskStartScenarioInPlace(GetPlayerPed(-1), 'world_human_gardener_plant', 0, false)
end

local isindim = false
local isinmadim = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local ped = PlayerPedId()
		local pcoords = GetEntityCoords(ped)
		local entity = GetClosestObjectOfType(pcoords, 1.0, GetHashKey("prop_beach_fire"), false, false, false)
		local entityCoords = GetEntityCoords(entity)
		if DoesEntityExist(entity) and #(pcoords-entityCoords) < 3.5 then
			if isindim == false then
				startAnim()
				TriggerEvent("Notify","sucesso","Você está se aquecendo!")
				Citizen.Wait(1000)
				isindim = true
				isinmadim = false
			end
		else
			if isindim == true and isinmadim == false then
				TriggerEvent("Notify","error","Você se afastou da fogueira!")
				ClearPedTasks(ped)
				isindim = false
				isinmadim = true
			end
		end
	end
end)

function startAnim()
	Citizen.CreateThread(function()
	RequestAnimDict("bs_2a_mcs_10-6")
		while not HasAnimDictLoaded("bs_2a_mcs_10-6") do
		Citizen.Wait(0)
		end
		TaskPlayAnim(GetPlayerPed(-1),"bs_2a_mcs_10-6","hc_hacker_dual-6",8.0,-8.0,-1,50,0,false,false,false)
	end)
end

Citizen.CreateThread(function()
	for i=1, #a do
	local b = a[i]
	b.blip = AddBlipForCoord(b.x,b.y,b.z)
	SetBlipSprite(b.blip,b.id)
	SetBlipDisplay(b.blip,4)
	SetBlipScale(b.blip,0.7)
	SetBlipColour(b.blip,b.colour)
	SetBlipAsShortRange(b.blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(b.title)
	EndTextCommandSetBlipName(b.blip)
	end
end)
	
		


--[ FUNÇÃO TEXTO ]-----------------------------------------------------------------------------------------------------------



function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.28, 0.28)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 41, 11, 41, 68)
end

function DrawText3Ds(x,y,z,text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.34, 0.34)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.001+ factor, 0.028, 0, 0, 0, 20)
end

function modelRequest(model)
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do
		Citizen.Wait(10)
	end
end

