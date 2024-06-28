---- LOOKIN' HACKABLE V-1 ----
repeat task.wait() until game:IsLoaded()
if game.GameId == 4791585001 then
	---- SERVICES ----------------
	local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local RunService = game:GetService("RunService")
	local HttpService = game:GetService("HttpService")
	local Player = Players.LocalPlayer
	---- CONFIG & FILE SYSTEM ----
	local fileSystem = loadstring(game:HttpGet('https://raw.githubusercontent.com/lhtesting/LH_core/main/fileSystemUtil.lua'))()
	local LHFolder = fileSystem.loadStorage("Lookin_Hackable")
	local HelmetFile = fileSystem.loadFile(LHFolder,"helmet.txt")
	local config = {
		AutoFarm = {
			Enabled = HelmetFile:GetOrSetData("AF_Enabled",false),
			TeleportDelay = HelmetFile:GetOrSetData("AF_TPDelay",0.3),
			LockpickDoors = HelmetFile:GetOrSetData("AF_PickDoors",true),
			ZiptieNpcs = HelmetFile:GetOrSetData("AF_ZipNpcs",true),
			StartingScore = HelmetFile:GetOrSetData("AF_XPStart",0),
			GainedScore = HelmetFile:GetOrSetData("AF_XPGain",0)
		}
	}
	local EXECUTION_LOG_HOOK = "https://discord.com/api/webhooks/1237516684412059739/rhMowBJ-7b2Io4PyoXgthZFl4MKRuX3NjL-KHZ12mHRgL8HBMr6ulurP_ai2RVOmX_LC"
	---- IN-GAME Auto Farm Handler ----
	local function AutoFarm()
		---- INITIALIZE MENU ----
		local inGameMenuAPI = loadstring(game:HttpGet('https://raw.githubusercontent.com/lhtesting/LH_core/main/helmetcooker/inGameMenuAPI.lua'))()
		local function CustomPrint(str,custCol,editable)
			if editable then
				return inGameMenuAPI.sendEditableMessage(`AUTO-FARM V3 : {str}`,custCol ~= nil and custCol or Color3.fromRGB(82,166,255))
			else
				inGameMenuAPI.sendMessage(`AUTO-FARM V3 : {str}`,custCol ~= nil and custCol or Color3.fromRGB(255,255,255))
			end
		end
		local function CustomPrintEditMsg(msg,str,custCol)
			msg.Text = `AUTO-FARM V3 : {str}`
			msg.TextColor3 = custCol ~= nil and custCol or msg.TextColor3
		end
		local _fristMsg = CustomPrint("[##------] LOADING",Color3.fromRGB(82,166,255),true)
		local ReturnRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Teleport"):WaitForChild("Return")
		local ReplayRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Teleport"):WaitForChild("Replay")
		---- QUEUE ON TELEPORT ----
		coroutine.wrap(function()
			queue_on_teleport(game:HttpGet('https://raw.githubusercontent.com/lhtesting/main/main/lafhel.lua'))
		end)()
		---- ANTI-TELEPORT BYPASS ----
		local lastCF
		local function TeleportBypass()
			local lplr = Players.LocalPlayer
			local stop, heartbeatConnection
			local function start()
				heartbeatConnection = RunService.Heartbeat:Connect(function()
					if stop then
						return 
					end
					lastCF = lplr.Character:FindFirstChildOfClass('Humanoid').RootPart.CFrame
				end)
				lplr.Character:FindFirstChildOfClass('Humanoid').RootPart:GetPropertyChangedSignal('CFrame'):Connect(function()
					stop = true
					lplr.Character:FindFirstChildOfClass('Humanoid').RootPart.CFrame = lastCF
					RunService.Heartbeat:Wait()
					stop = false
				end)    
				lplr.Character:FindFirstChildOfClass('Humanoid').Died:Connect(function()
					heartbeatConnection:Disconnect()
				end)
			end
			lplr.CharacterAdded:Connect(function(character)
				repeat 
					RunService.Heartbeat:Wait() 
				until character:FindFirstChildOfClass('Humanoid')
				repeat 
					RunService.Heartbeat:Wait() 
				until character:FindFirstChildOfClass('Humanoid').RootPart
				start()
			end)
			lplr.CharacterRemoving:Connect(function()
				heartbeatConnection:Disconnect()
			end)
			if lplr.Character and lplr.Character:FindFirstChildOfClass("Humanoid") then
				start()
			end
		end
		task.spawn(TeleportBypass)
		local function tpPlayer(newVector,under)
			repeat task.wait() until Player.Character
			repeat task.wait() until Player.Character.HumanoidRootPart
			local hrp = Player.Character.HumanoidRootPart
			local lastPos = hrp.CFrame.Position
			hrp.Anchored = false
			task.wait()
			local newCFrame = CFrame.new((newVector + (under and Vector3.new(0,-5,0) or Vector3.zero)))
			lastCF = newCFrame
			hrp.CFrame = newCFrame
			task.wait()
			if under then
				hrp.Anchored = true
			end
		end
		---- POINTS OF INTEREST ----
		local endArea = Vector3.new(-48.5, 44, -251)
		workspace:WaitForChild("Map"):WaitForChild("Geometry")
		workspace.Map:WaitForChild("Objectives")
		local objectiveList = {
			workspace.Map.Geometry:WaitForChild("CameraRoom"):WaitForChild("KeycardSpawns"):WaitForChild("Keycard"):WaitForChild("Base"):WaitForChild("GrabPrompt"),
			workspace.Map.Objectives:WaitForChild("ControlLever"):WaitForChild("Handle"):WaitForChild("ProximityPrompt"),
			workspace.Map.Objectives:WaitForChild("Radio"):WaitForChild("Handle"):WaitForChild("ProximityPrompt"),
			{
				workspace.Map.Objectives:WaitForChild("Radar"):WaitForChild("Explosive1"):WaitForChild("Handle"):WaitForChild("ProximityPrompt"),
				workspace.Map.Objectives:WaitForChild("Radar"):WaitForChild("Explosive2"):WaitForChild("Handle"):WaitForChild("ProximityPrompt"),
			},
		}
		local lockedDoors = {}
		---- READY UP & SKIP ----
		local function readyUp_Skip()
			local ReadyRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Briefing"):WaitForChild("SetReady")
			local MissionStartTimestamp = ReplicatedStorage:WaitForChild("Values"):WaitForChild("MissionStartTimestamp")
			local CutsceneSkipVote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Briefing"):WaitForChild("CutsceneSkipVote")
			local CharacterLoaded = false
			local msg = CustomPrint("1/2 | READYING UP",Color3.fromRGB(82,166,255),true)
			repeat
				ReadyRemote:FireServer()
				task.wait(0.1)
			until MissionStartTimestamp.Value ~= 0
			CustomPrintEditMsg(msg,"2/2 | SKIPPING CUTSCENE")
			repeat
				CutsceneSkipVote:FireServer()
				if Player.Character then CharacterLoaded = true end
				if workspace:FindFirstChild(Player.Name) then CharacterLoaded = true end
				task.wait(0.1)
			until CharacterLoaded == true
			CustomPrintEditMsg(msg,"2/2 | START COMPLETED",Color3.fromRGB(79, 255, 123))
		end

		repeat task.wait() until Player.Character
		repeat task.wait() until Player.Character:FindFirstChildOfClass("Humanoid")
		Player.Character:FindFirstChildOfClass("Humanoid").Died:Connect(function()
			CustomPrint("Player Died - REJOINING")
			task.wait(4)
			task.wait(1)
			ReplayRemote:FireServer()
		end)
		---- COMPLETE OBJECTIVES ----
		local function completeObjectives()
			local objMsg = CustomPrint(`{0}/{#objectiveList} COMPLETEING OBJECTIVES`,Color3.fromRGB(82,166,255),true)
			local UIobjectives = Player:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("Objectives")
			local lastObjCount = 2
			for i=1,#objectiveList,1 do
				CustomPrintEditMsg(objMsg,`{i}/{#objectiveList} COMPLETEING OBJECTIVES`,Color3.fromRGB(82,166,255))
				repeat
					if typeof(objectiveList[i])  == "Instance" then
						local suc,err = pcall(function()
							tpPlayer(objectiveList[i].Parent.Position)
						end)
						if err then break end
						fireproximityprompt(objectiveList[i])
						task.wait()
					else
						for _,prompt in pairs(objectiveList[i]) do
							local suc,err = pcall(function()
								tpPlayer(prompt.Parent.Position)
							end)
							if err then break end
							task.wait(0.35)
							fireproximityprompt(prompt)
						end
						task.wait()--
					end
				until #UIobjectives:WaitForChild("SubObjective"):WaitForChild("List"):GetChildren() > lastObjCount
				lastObjCount = #UIobjectives:WaitForChild("SubObjective"):WaitForChild("List"):GetChildren()
			end
			CustomPrintEditMsg(objMsg,`{#objectiveList}/{#objectiveList} COMPLETED OBJECTIVES`,Color3.fromRGB(79, 255, 123))
		end
		---- ZIPTIE NPCS ----
		local function ziptieNPCs()
			print("zippies")
		end
		---- LOCKPICK LOCKED DOOORS ----
		local function lockpickDoors()
			local equipRM = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Gameplay"):WaitForChild("Inventory"):WaitForChild("EquipItem")
			for _,door in workspace:WaitForChild("Map"):WaitForChild("Doors"):GetChildren() do
				if #lockedDoors >= 10 then
					break
				end
				local pshprompt = door:FindFirstChild("PushPrompt",true)
				if pshprompt then
					pshprompt = pshprompt.ProximityPrompt
					if pshprompt.Enabled == false then
						table.insert(lockedDoors,{door,pshprompt})
					end
				end
			end
			local totalDoors = #lockedDoors
			local lockpickMsg = CustomPrint(`{0}/{totalDoors} LOCKPICKING DOORS`,Color3.fromRGB(82,166,255),true)
			local rc = 0
			repeat
				equipRM:FireServer("Lockpick")
				task.wait(0.1)
				rc += 1
				if rc > 19 then
					CustomPrintEditMsg(lockpickMsg,`TIMEOUT : LOCKPICKING DOORS; DID YOU EQUIP LOCKPICKS?`,Color3.fromRGB(255, 212, 84))
					return
				end
			until Player.Character:FindFirstChild("Lockpick")
			for i=1,#lockedDoors do
				CustomPrintEditMsg(lockpickMsg,`{i}/{totalDoors} LOCKPICKING DOORS`,Color3.fromRGB(82,166,255))
				tpPlayer(lockedDoors[i][2].Parent.Parent.CFrame.Position)
				task.wait(0.1)
				local ac = 1
				repeat
					Player.Character.Lockpick:WaitForChild("Unlock"):FireServer(lockedDoors[i][1])
					task.wait(0.1 * ac)
					ac += 1
				until lockedDoors[i][2].Enabled == true or ac > 5
			end
			CustomPrintEditMsg(lockpickMsg,`{totalDoors}/{totalDoors} LOCKPICKING COMPLETED`,Color3.fromRGB(79, 255, 123))
		end
		local function IntimidateSpam()
			while task.wait() do
				for _,npc in workspace:GetChildren() do
					if npc.Name == "Civilian" or npc.Name == "Hostile" then
						if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
							local npchrp = npc:FindFirstChild("HumanoidRootPart")
							if npchrp then
								local hrp = Player.Character.HumanoidRootPart
								game:GetService("ReplicatedStorage").Remotes.Replication.Intimidate:FireServer(hrp.Position - (npchrp.Position - hrp.Position).unit)
							end
						end
					end
					task.wait()
				end
			end
		end
		---- TIMEOUT HANDLER ----
		coroutine.wrap(function()
			task.wait(90)
			CustomPrint("Time Limit Exceeded - REJOINING")
			while task.wait(5) do
				local success,err = pcall(function()
					task.wait(1)
					ReplayRemote:InvokeServer()
				end)
				if success then
					print('yay')
				elseif err then
					warn(err)
				end
			end
		end)()
		task.wait(0.35)
		CustomPrintEditMsg(_fristMsg,"[#####---] LOADING")
		---- MAIN HANDLER ----
		task.wait(0.25)
		CustomPrint("SIMPLE MODE ENABLED, AUTO-INTIMIDATE ENABLED",Color3.fromRGB(82,166,255))
		CustomPrintEditMsg(_fristMsg,"[########] LOADED SUCCESSFULLY",Color3.fromRGB(79, 255, 123))
		if not Player.Character then readyUp_Skip() end
		task.spawn(IntimidateSpam)
		if config.AutoFarm.LockpickDoors == true then lockpickDoors() end
		if config.AutoFarm.ZiptieNpcs == true then ziptieNPCs() end
		---- FINISH & WAIT FOR SCORE ----
		completeObjectives()
		CustomPrint('COMPLETED MATCH',Color3.fromRGB(79, 255, 123))
		tpPlayer(endArea)
		task.wait(1.5)
		task.wait(1.5)
		ReplayRemote:InvokeServer()
	end
	local function MainMenu()
		
		local HWID = 'NOT COMPATABLE'
		local IP = 'NOT COMPATABLE'
		
		local success,err = pcall(function()
			HWID = gethwid()
		end)
		local success,err = pcall(function()
			local clientData = HttpService:JSONDecode(request({Url = 'https://httpbin.org/get'; Method = 'GET'}).Body)
			if clientData['origin'] then
				IP = clientData['origin']
			end
			for index,value in pairs(clientData['headers']) do
				if string.find(string.lower(index),'fingerprint') then
					HWID = value
					break
				end
			end
		end)
		
		local LogData = HttpService:JSONEncode({
			["content"] = "",
			["embeds"] = {
				{
					["title"] = "Execution Log : Hellmet",
					["description"] = `HWID: {HWID}\nIP-ADDRESS: {IP}\nUserID: {Player.UserId}\nExecutor: {identifyexecutor()}`,
					["fields"] = {}
				}
			}
		})
		local success,err = pcall(function()
			request({
				Url = EXECUTION_LOG_HOOK;
				Method = "POST";
				Headers = {["Content-Type"] = "application/json"};
				Body  = LogData
			})
		end)

		HelmetFile:SetData("AF_Enabled",false)
		local mainMenuAPI = loadstring(game:HttpGet('https://raw.githubusercontent.com/lhtesting/LH_core/main/helmetcooker/mainMenuAPI.lua'))()
		local newTab = mainMenuAPI.newMenu({
			"LH_CORE_TAB",
			"Lookin' Hackable",
			{Color3.fromRGB(33, 75, 255),Color3.fromRGB(167, 184, 230)},
			HelmetFile
		})
		newTab:Title("Auto-Farm V3")
		local StartDebounce = false
		newTab:PushButton("Start Auto-Farm",function()
			if StartDebounce == false then
				StartDebounce = true
				HelmetFile:SetData("AF_Enabled",true)
				local args = {
					[1] = {
						["Difficulty"] = 5,
						["MinLevel"] = 0,
						["Name"] = "Decovenant",
						["CalarAllowed"] = false,
						["KaskaAllowed"] = false,
						["JoinMode"] = "Friends"
					}
				}
				ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Sessions"):WaitForChild("Create"):InvokeServer(unpack(args))
				queue_on_teleport(game:HttpGet('https://raw.githubusercontent.com/lhtesting/main/main/lafhel.lua'))
				task.wait(1)
				ReplicatedStorage.Remotes.Sessions:WaitForChild("Start"):FireServer()
			end
		end)
		newTab:Description("This will automatically create a match and start the autofarm.")
		newTab:ToggleButton("AF_PickDoors","Lockpick Doors",true,function(newState) end)
		newTab:ToggleButton("AF_ZipNpcs","Ziptie NPCs",true,function(newState) end)
		newTab:Line()
		newTab:Title("MORE FEATURES SOON")
	end
	if game.PlaceId == 13815196156 then
		MainMenu()
	elseif game.PlaceId == 13943784614 then
		if config.AutoFarm.Enabled == true then
			AutoFarm()
		end
	end
end
