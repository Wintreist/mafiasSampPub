script_name("Mafias")
script_author("Wintreist")
script_version("18.11.2019")

local sampev = require('lib.samp.events')
local vkeys = require('lib.vkeys')
local inicfg = require('inicfg')
local cfg = inicfg.load(nil, 'moonloader\\config\\mafias.ini')
local legit = false
local boxest = false
local airdrop = {['nark'] = cfg.config.nark, ['mater'] = cfg.config.mater, ['money'] = cfg.config.money, ['brone'] = cfg.config.brone}
local vars = {}
local bools = {['nark'] = true, ['mater'] = true, ['money'] = true, ['brone'] = true}
local offset = 0
local peresID = nil
local refresh = false
local onesave = true





function main()
	while not isOpcodesAvailable() or not isSampfuncsLoaded() or not isSampAvailable() do wait(0) end
	autoupdate("https://github.com/Wintreist/mafiasSampPub/blob/master/autoupdate.json", '['..string.upper(thisScript().name)..']: ', "https://blast.hk/threads/47805/")
	sampRegisterChatCommand('mafias', function() legit = not legit if legit then print('Legit: On') else print('Legit: Off') end end)
	lua_thread.create(function()
		while true do
			count = 0
			for val, key in pairs(bools) do
				if key ~= 0 then
					count = count + 1
				end
			end
			if count == 0 then
				bools = {['nark'] = true, ['mater'] = true, ['money'] = true, ['brone'] = true}
			end
			wait(100000)
		end
	end)

	for i = 0, 2048 do
		if sampIs3dTextDefined(i) then
			textobj, color, X, Y, Z, distance, ignoreWalls, playerId, vehicleId = sampGet3dTextInfoById(i)
			lua_thread.create(function()
			local id = i
			local text = textobj
			if textobj:find('Используйте {75F45B}ALT{FFFFFF} для', 1, true) then
				while not sampIs3dTextDefined(id) do wait(0) end
				while sampIs3dTextDefined(id) do
				while sampIsDialogActive do wait(5000) end
					_, _, X, Y, Z, _, _, _, _ = sampGet3dTextInfoById(id)
					x, y, z = getCharCoordinates(playerPed)
				if getDistanceBetweenCoords3d(x, y, z, X, Y, Z) <= 2 and (bools['mater'] == true or bools['nark'] == true or bools['brone'] == true or bools['money'] == true) then
					setVirtualKeyDown(vkeys.VK_MENU, true)
					wait(100)
					setVirtualKeyDown(vkeys.VK_MENU, false)
					wait(10)
				end
				if legit then wait(1000) end
				wait(0)
				end
			end
			end)
		end
	end
	wait(-1)
end





function sampev.onCreate3DText(idObject, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, textObject)
	lua_thread.create(function()
		local id = idObject
		local text = textObject
		if text:find('Используйте {75F45B}ALT{FFFFFF} для', 1, true) then
			while not sampIs3dTextDefined(id) do
				wait(0)
			end
			while sampIs3dTextDefined(id) do
				while sampIsDialogActive do wait(5000) end
				_, _, X, Y, Z, _, _, _, _ = sampGet3dTextInfoById(id)
				x, y, z = getCharCoordinates(playerPed)
				if getDistanceBetweenCoords3d(x, y, z, X, Y, Z) <= 2 and (bools['mater'] == true or bools['nark'] == true or bools['brone'] == true or bools['money'] == true) then
					setVirtualKeyDown(vkeys.VK_MENU, true)
					wait(100)
					setVirtualKeyDown(vkeys.VK_MENU, false)
					wait(10)
				end
				if legit then wait(1000) end
				wait(0)
			end
		end
	end)
end





function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
	sampAddChatMessage(dialogId, -1)
	sampAddChatMessage(text, color)
	if dialogId == 4777 and onesave then
	inicfg.save({dialog = {text}}, 'moonloader\\config\\AirDialog.ini')
	onesave = false
	end
	if dialogId == 4777 then
		if text:find('{FFFFFF}Материалы', 1, true) then
			matervall = tonumber(text:match('{FFFFFF}Материалы:	{9CEA5C}(%d*)'))
			table.insert(vars, airdrop['mater'])
		elseif text:find('Материалы', 1, true) then
			bools['mater'] = false
		else
			bools['mater'] = 0
		end
		if text:find('{FFFFFF}Наркотики', 1, true) then
			narkovall = tonumber(text:match('{FFFFFF}Наркотики:	{9CEA5C}(%d*)'))
			table.insert(vars, airdrop['nark'])
		elseif text:find('Наркотики', 1, true) then
			bools['nark'] = false
		else
			bools['nark'] = 0
		end
		
		if text:find('{FFFFFF}Бронежилет', 1, true) then
			bronevall = tonumber(text:match('{FFFFFF}Бронежилет:	{9CEA5C}(%d*)'))
			table.insert(vars, airdrop['brone'])
		elseif text:find('Бронежилет', 1, true) then
			bools['brone'] = false
		else
			bools['brone'] = 0
		end
		if text:find('{9CEA5C}Деньги', 1, true) then
			moneyvall = tonumber(text:match('{9CEA5C}Деньги:	{9CEA5C}(%d*)'))
			if moneyvall ~= 0 and bools['money'] then
				table.insert(vars, airdrop['money'])
			else
				bools['money'] = 0
			end
		end
		if bools['mater'] == false and bools['nark'] == false and bools['brone'] == false and bools['money'] == false then
			sampSendDialogResponse(dialogId, 0, -1, nil)
			return false
		end
		count = 0
		for val, key in pairs(bools) do
			if key ~= 0 then
				count = count + 1
			end
		end
		if count ~= 0 then
			run = math.max(unpack(vars))
			for key, val in pairs(airdrop) do
				if val == run then
					run = key
					break
				end
			end
			vars = {}
		else
			return true
		end
		sampAddChatMessage(run, color)
		if legit then
			sampAddChatMessage('ЛЕГИТНАЯ ХЕРНЯ ЕЩЁ НЕ ГОТОВА', 0xFFFFFF)
		else
			if run == 'nark' then
				if narkovall < 50 then
					send = tostring(narkovall)
				else
					send = '50'
				end
				if bools['mater'] == 0 then
					sampSendDialogResponse(dialogId, 1, 0, nil)
				else
					sampSendDialogResponse(dialogId, 1, 1, nil)
				end
				return false
			elseif run == 'mater' then
				if matervall < 300 then
					send = tostring(matervall)
				else
					send = '300'
				end
				sampSendDialogResponse(dialogId, 1, 0, nil)
				return false
			elseif run == 'money' then
				for key, val in pairs(bools) do
					if val == 0 then
						offset = offset + 1
					end
				end
				sampSendDialogResponse(dialogId, 1, 3 - offset, nil)
				return false
			elseif run == 'brone' then
				if bronevall < 5 then
					send = tostring(bronevall)
				else
					send = '5'
				end
				if bools['mater'] == 0 and bools['nark'] == 0 then
					sampSendDialogResponse(dialogId, 1, 0, nil)
				elseif bools['mater'] == 0 or bools['nark'] == 0 then
					sampSendDialogResponse(dialogId, 1, 1, nil)
				else
					sampSendDialogResponse(dialogId, 1, 2, nil)
				end
				return false
			end
		offset = 0
		end
	end
	
	if dialogId == 4778 then
		lua_thread.create(function()
		local runin = run
			if legit then
				
			else
				sampSendDialogResponse(dialogId, 1, -1, send)
				bools[runin] = false
				lua_thread.create(function()
					wait(60010)
					bools[runin] = true
				end)
				return false
			end
		end)
	end
end





function sampev.onServerMessage(colormsg, textmessage)
	if textmessage:find('Убив его, вы сможете получить деньги', 1, true) then return false end
end





--	Этот крутой чувак сделал для вас автообновление
--     _   _   _ _____ ___  _   _ ____  ____    _  _____ _____   ______   __   ___  ____  _     _  __
--    / \ | | | |_   _/ _ \| | | |  _ \|  _ \  / \|_   _| ____| | __ ) \ / /  / _ \|  _ \| |   | |/ /
--   / _ \| | | | | || | | | | | | |_) | | | |/ _ \ | | |  _|   |  _ \\ V /  | | | | |_) | |   | ' /
--  / ___ \ |_| | | || |_| | |_| |  __/| |_| / ___ \| | | |___  | |_) || |   | |_| |  _ <| |___| . \ 
-- /_/   \_\___/  |_| \___/ \___/|_|   |____/_/   \_\_| |_____| |____/ |_|    \__\_\_| \_\_____|_|\_\                                                                                                                                                                                                                  
--
-- Author: http://qrlk.me/samp
--
function autoupdate(json_url, prefix, url)
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  downloadUrlToFile(json_url, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(prefix)
                local dlstatus = require('moonloader').download_status
                local color = -1
                sampAddChatMessage((prefix..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('Загрузка обновления завершена.')
                      sampAddChatMessage((prefix..'Обновление завершено!'), color)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..thisScript().version..': Обновление не требуется.')
            end
          end
        else
          print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end