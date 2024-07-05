if game.GameId == 5849979605 then
	repeat task.wait() until game:IsLoaded()
	repeat task.wait() until game:GetService("Players").LocalPlayer:GetMouse()
	local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/obeseinsect/roblox/main/Ui%20Libraries/Elerium.lua"))()

	local Window = Library:AddWindow('LH_DEV // DARKDIVERS',{
		main_color = Color3.fromRGB(41, 74, 122),
		min_size = Vector2.new(400, 600),
		toggle_key = Enum.KeyCode.RightShift,
		can_resize = true,
	})
	local Tab = Window:AddTab('LH_DEV')

	Tab:Show()
	Tab:AddLabel("WARNING!")
	Tab:AddLabel("This is a Developer Preview of a Script for DARKDIVERS")
	Tab:AddLabel("Lookin' Hackable // DO NOT REDISTRIBUTE")
	Tab:AddLabel(' ')

	Tab:AddLabel('MATCH STATISTICS')
	local Statistic_M = Tab:AddLabel("Current Map: LOADING...")
	local Statistic_TES = Tab:AddLabel("Total Enemies Spawned: LOADING...")
	local Statistic_TEK = Tab:AddLabel("Total Enemies Killed: LOADING...")
	local Statistic_ECS = Tab:AddLabel("Enemies Currently Spawned: LOADING...")
	local Statistic_DD = Tab:AddLabel("Damage Dealt: LOADING...")
	local Statistic_GT = Tab:AddLabel("Game Time: LOADING...")

	local CurrentMap
	if game.PlaceId == 17065532662 then
		CurrentMap = "LOBBY"
	elseif game.PlaceId == 17178716511 then
		CurrentMap = "ARRADISE"
	elseif game.PlaceId == 17816087597 then
		CurrentMap = "AMUN"
	elseif game.PlaceId == 17097972614 then
		CurrentMap = "DARK MOON"
	elseif game.PlaceId == 17509071580 then
		CurrentMap = "CYBEROX"
	else
		CurrentMap = "UNKNOWN"
	end
	Statistic_M.Text = "Current Map: "..CurrentMap

	Statistic_DD.Text = "Damage Dealt: "..tostring(Players.LocalPlayer:WaitForChild("leaderstats"):WaitForChild("Damage").Value)
	Players.LocalPlayer.leaderstats.Damage.Changed:Connect(function(newValue)
		Statistic_DD.Text = "Damage Dealt: "..tostring(newValue)
	end)

	task.spawn(function()
		local Current = 1
		Statistic_GT.Text = "Game Time: 1"
		while task.wait(1) do
			Current += 1
			Statistic_GT.Text = "Game Time: "..tostring(Current)
		end
	end)
	Tab:AddLabel(' ')

	local KillAll,KillPlayers = false,false
	local GunList = {"AR14_Brainwasher","SG19_Punisher","SG16_Judgment","RL-4_Gifter","MR-1_Messiah","MG99_Liberator","BW84_Endragon","AR26_Unslave","AR14_Brainwasher"}
	if CurrentMap ~= "LOBBY" then
		workspace:WaitForChild("Enemies")
		Statistic_TEK.Text = "Total Enemies Killed: ERR"
		local TotalEnemiesSpawned,CurrentSpawned,Killed = 0,0,0
		for _,enemy in workspace.Enemies:GetChildren() do
			TotalEnemiesSpawned += 1
			CurrentSpawned += 1
			Statistic_TES.Text = "Total Enemies Spawned: "..tostring(TotalEnemiesSpawned)
			Statistic_ECS.Text = "Enemies Currently Spawned: "..tostring(CurrentSpawned)
		end
		workspace.Enemies.ChildAdded:Connect(function()
			TotalEnemiesSpawned += 1
			CurrentSpawned += 1
			Statistic_TES.Text = "Total Enemies Spawned: "..tostring(TotalEnemiesSpawned)
			Statistic_ECS.Text = "Enemies Currently Spawned: "..tostring(CurrentSpawned)
		end)

		workspace.Enemies.ChildRemoved:Connect(function()
			CurrentSpawned -= 1
			Statistic_ECS.Text = "Enemies Currently Spawned: "..tostring(CurrentSpawned)
		end)
		local EquipedGun = nil
		for i=1,10 do
			for _,Tool in Players.LocalPlayer.Backpack:GetChildren() do
				if not table.find(GunList,Tool.Name) then continue end
				EquipedGun = Tool.Name
				break
			end
			if Players.LocalPlayer.Character then
				for _,Tool in Players.LocalPlayer.Character:GetChildren() do
					if not table.find(GunList,Tool.Name) then continue end
					EquipedGun = Tool.Name
					break
				end
			end
			if EquipedGun ~= nil then break end
			task.wait(1)
		end
		if EquipedGun ~= nil then
			local function KillAllEnemies()
				for _,Enemy in workspace.Enemies:GetChildren() do
					local Humanoid = Enemy:FindFirstChildOfClass("Humanoid")
					if not Humanoid or Humanoid.Health < 1 then continue end
					ReplicatedStorage.Remotes.HitTarget:InvokeServer(Humanoid,nil,Enemy,"P15_Freedom_One",10000000)
					if Humanoid.Health < 1 then
						Killed += 1
						Statistic_TEK.Text = "Total Enemies Killed: "..tostring(Killed)
					end
				end
			end
			local function DamagePlayers()
				for _,Player in Players:GetPlayers() do
					if not Player.Character then continue end
					local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
					if not Humanoid or Humanoid.Health < 1 then continue end
					ReplicatedStorage.Remotes.HitTarget:InvokeServer(Humanoid,nil,Player.Character,"P15_Freedom_One",10000000)
				end
			end
			Tab:AddLabel('EXPLOITS')
			Tab:AddButton("Beat Match // NOT WORKING",function()
				warn(" ")
				warn("The 'Beat Match' Feature is still a WORK IN PROGRESS, please wait for future updates!")
				warn(" ")
			end)
			Tab:AddSwitch("Auto Kill All Enemies",function(bool)
				KillAll = bool
			end)
			Tab:AddSwitch("Kill All Players",function(bool)
				KillPlayers = bool
			end)
			task.spawn(function()
				while task.wait() do
					if KillAll == false then task.wait() continue end
					KillAllEnemies()
				end
			end)
			task.spawn(function()
				while task.wait() do
					if KillPlayers == false then task.wait() continue end
					for i=1,100 do
						for i=1,100 do
							DamagePlayers()
						end
					end
				end
			end)
		else
			Tab:AddLabel("WE COULDN'T DETECT THE FIREARM YOU ARE USING, PLEASE SWITCH TO A DIFFERENT PRIMARY")
		end
	else
		Tab:AddLabel("PLEASE READ")
		Tab:AddLabel("EQUIP THE: P15 Freedom One")
		Tab:AddLabel(" ")
		Tab:AddLabel("JOIN A MATCH TO USE EXPLOITS")
	end
	Tab:AddLabel(' ')
	queue_on_teleport(game:HttpGet("https://raw.githubusercontent.com/lhtesting/main/main/ddlhdp.lua"))
end
