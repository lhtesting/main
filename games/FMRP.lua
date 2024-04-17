return function(rayfieldcore,rayfieldmainwindowcore)
	local LuaWebService = game:GetService("LuaWebService")
	local Players = game:GetService("Players")

	local srcLoad = false
	
	local MainWindow = rayfieldmainwindowcore

	rayfieldcore:Notify({
		Title = "Lookin' Hackable",
		Content = "Game Detected : FMRP",
		Duration = 3
	})

	local function setNameTagText(text : string)
		game:GetService("ReplicatedStorage"):WaitForChild("RoleplayNametag"):FireServer(text)
	end

	local previousChatMessage = ""
	local function NametagChatHandler(newMessage : string)
		local possibleLetters = {"&","@","#","$","%","A","B","C","D","E","F","G","H","I"}
		local lastMessageLength = string.len(previousChatMessage) or 1
		local newMessageLength = string.len(newMessage) or 1
		for i = lastMessageLength,newMessageLength,lastMessageLength > newMessageLength and -1 or 1 do
			local newText = ""
			for currentLetter = 1, i, 1 do
				newText = newText..possibleLetters[math.random(1,#possibleLetters)]
			end
			setNameTagText(newText)
			task.wait(0.04)
		end
		task.wait(0.02)
		setNameTagText(newMessage)
		previousChatMessage = newMessage
	end

	local function quickNotify(text)
		rayfieldcore:Notify({
			Title = "FMRP - HUB",
			Content = text,
			Duration = 3
		})
	end

	local function checkIfAnimatronic()
		local isAnimatronic = false
		if Players.LocalPlayer.Character:FindFirstChildOfClass("Model") and not Players.LocalPlayer.Character:FindFirstChild("human") then isAnimatronic = true end
		return isAnimatronic
	end

	local changingnametag = false

	local function createDevTab()
		local Tab = MainWindow:CreateTab("Dev Options")
		local TopLabel = Tab:CreateLabel("WARNING - These options may be buggy or in Development!")
		local DestroyButton = Tab:CreateButton({
			Name = "Destroy Exploit",
			Callback = function()
				rayfieldcore:Destroy()
			end,
		})

		local NametagInput = Tab:CreateInput({
			Name = "TESTING - Creepy Nametag/Chat Changer",
			PlaceholderText = "Put Message Here",
			RemoveTextAfterFocusLost = false,
			Callback = function(Text)
				if changingnametag == false then
					changingnametag = true
					NametagChatHandler(Text)
					task.wait()
					changingnametag = false
				end
			end,
		})
	end

	local function createMainTab()
		local Tab = MainWindow:CreateTab("Home")
		local Paragraph1 = Tab:CreateParagraph({Title = "Information",
			Content = "Hello User! FMRP exploits have came a long way, they have been developed over years. I have been the #1 FMRP exploit developer for the longest time. I was the first person to create a STABLE unlock all characters script, however, the developers of FMRP have unfortunately patched this. THEY DID NOT ADD AN ANTICHEAT. You will only get kicked for trying to choose any character you want by spoofing the remote, and while you can literally just disable the anit-cheat, it isn't worth it as you still can't choose characters anyways. PLEASE DO NOT ASK ME TO MAKE ANOTHER UNLOCK ALL. Thank you for all your support and enjoy the features we have here!"
		})
		local Paragraph2 = Tab:CreateParagraph({Title = "QUICK NOTE",
			Content = "If you are using a color-changing nametag OR a part transparency flasher, EXPECT LAG, you are overloading the remote queue, so expect delays in respawning, namechanging, or even animations."
		})
		local DevSection = Tab:CreateSection("Developer")
		local Label = Tab:CreateLabel("Access Early Features // May be Buggy!")
		local EDO_Button = Tab:CreateButton({
			Name = "Enable Developer Options",
			Callback = function()
				createDevTab()
				rayfieldcore:Notify({
					Title = "New Tab",
					Content = "The Developer Tab has been added to your Hub!",
					Duration = 5
				})
			end,
		})
	end

	local isEndo = false

	local isPlayingCurrently = false
	local function musicHandler(_ID)
		local ID = nil
		if _ID then
			ID = tostring(_ID)
		end
		if isPlayingCurrently == false and ID then
			game:GetService("ReplicatedStorage"):WaitForChild("MusicPlayer"):InvokeServer(ID)
			isPlayingCurrently = true
		elseif isPlayingCurrently == true and ID then
			for _,musicPlayer in game.Players.LocalPlayer.Character.HumanoidRootPart:GetChildren() do
				if musicPlayer.Name == "MusicPlayer_Sound" and musicPlayer:IsA("Sound") then
					game:GetService("ReplicatedStorage"):WaitForChild("MusicPlayer"):InvokeServer(musicPlayer)
				end
			end
			game:GetService("ReplicatedStorage"):WaitForChild("MusicPlayer"):InvokeServer(ID)
		else
			for _,musicPlayer in game.Players.LocalPlayer.Character.HumanoidRootPart:GetChildren() do
				if musicPlayer.Name == "MusicPlayer_Sound" and musicPlayer:IsA("Sound") then
					game:GetService("ReplicatedStorage"):WaitForChild("MusicPlayer"):InvokeServer(musicPlayer)
				end
			end
			isPlayingCurrently = false
		end
	end

	local isRGBNameOn = false
	local transchangedb = true
	local sizechangedb = true

	local function createCharacterTab()
		local Tab = MainWindow:CreateTab("Player & Animatronic")
		local Label = Tab:CreateLabel("Affect your Animatronic or Player!")
		local GeneralSection = Tab:CreateSection("General")
		local TransSlider = Tab:CreateSlider({
			Name = "Character Transparency",
			Range = {0, 1},
			Increment = 0.01,
			Suffix = "Transparency",
			CurrentValue = 0,
			Flag = "CharacterTransparencySlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(newValue)
				coroutine.wrap(function()
					local Value = newValue <= 0.02 and 0 or newValue >= 0.98 and 1 or newValue
					if srcLoad == true then
						repeat task.wait() until sizechangedb == false
					end
					if transchangedb == false then
						transchangedb = true
						if checkIfAnimatronic() == true then
							local visRM = game:GetService("ReplicatedStorage").VisParts
							for _,charmodel in Players.LocalPlayer.Character:GetChildren() do
								if charmodel:IsA("Model") and charmodel:FindFirstChild("HumanoidRootPart") then
									for _,part in charmodel:GetDescendants() do
										if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Name ~= "RootPart" and part.Name ~= "crawlPart" then
											if isEndo == true then
												if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and string.lower(part.Name) ~= "crawlpart" and not string.find(string.lower(part.Name),"endo") and not string.find(string.lower(part.Name),"wire") and not string.find(string.lower(part.Name),"eye") and not string.find(string.lower(part.Name),"neck") and not string.find(string.lower(part.Name),"ndo") and not string.find(string.lower(part.Name), "teeth") and not string.find(string.lower(part.Name), "screw") and part.Name ~= "Black" or string.find(string.lower(part.Name), "eyebrow") then
												else
													visRM:FireServer(part,(Value))
												end
											else
												visRM:FireServer(part,(Value))
											end
										end
									end
								end
							end
						else
							local visRM = game:GetService("ReplicatedStorage").VisParts
							for _,part in Players.LocalPlayer.Character:GetDescendants() do
								if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Name ~= "RootPart" then
									visRM:FireServer(part,(Value))
								end
							end
						end
						task.wait(0.2)
						transchangedb = false
					end
				end)()
			end,
		})
		local MusicInput = Tab:CreateInput({
			Name = "Music Player [ANY WORKING ID]",
			PlaceholderText = "MUSIC ID HERE",
			RemoveTextAfterFocusLost = false,
			Callback = function(Text)
				local inputNum = tonumber(Text)
				if inputNum then
					musicHandler(inputNum)
				else
					musicHandler()
				end
			end,
		})
		local AllBadgesButton = Tab:CreateButton({
			Name = "Get all Badges - Besides 3",
			Callback = function()
				local Players = game:GetService("Players")

				local function moveChar(cframe)
					local char = Players.LocalPlayer.Character
					if not char then repeat task.wait() until char end
					local hrp = char:FindFirstChild("HumanoidRootPart")
					if not hrp then repeat task.wait() until char:FindFirstChild("HumanoidRootPart") end
					hrp.CFrame = cframe
				end

				local function promptInArea(area)
					if area:FindFirstChildOfClass("ProximityPrompt") then
						fireproximityprompt(area:FindFirstChildOfClass("ProximityPrompt"))
					elseif area:FindFirstChildOfClass("RemoteEvent") then
						area:FindFirstChildOfClass("RemoteEvent"):FireServer()
					end
				end

				local function giveBadgeInArea(area)
					if area:IsA("BasePart") then
						moveChar(area.CFrame)
					end
					task.wait(0.25)
					promptInArea(area)
				end

				local function scanArea(mapArea)
					for _,folder:Instance in mapArea:GetChildren() do
						if folder.Name == "ShadowBon" then continue end
						for _,Script in folder:GetDescendants() do
							if Script:IsA("Script") and Script.Name ~= "OnHasBadge" and string.find(string.lower(Script.Name),"badge") then
								giveBadgeInArea(Script.Parent)
								task.wait(0.25)
							end
						end
					end
				end

				scanArea(workspace.MAP.Rewards)
				task.wait(1)
				scanArea(workspace.HOUSE.Rewards)
				task.wait(1)
				giveBadgeInArea(workspace.MAP.Rewards.ShadowBon.ShadowBon2.box)
				task.wait(1)
				giveBadgeInArea(workspace.MAP.Rewards.ShadowBon.ShadowBon)
			end,
		})
		local AllJSButton = Tab:CreateButton({
			Name = "Play all JumpScare Sounds",
			Callback = function()
				local args = {
					[1] = game:GetService("Players").LocalPlayer.Character.LowerTorso,
					[2] = game.Players.LocalPlayer.Character
				}

				for _,remote in game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("CharacterFunctions"):WaitForChild("Jumpscares"):GetDescendants() do
					if remote:IsA("RemoteEvent") then
						remote:FireServer(unpack(args))
					end
				end
			end,
		})
		local BecomeBallButton = Tab:CreateButton({
			Name = "Become Ball (Roll Mode)",
			Callback = function()
				local UserInputService = game:GetService("UserInputService")
				local RunService = game:GetService("RunService")
				local Camera = workspace.CurrentCamera
				local SPEED_MULTIPLIER = 30
				local JUMP_POWER = 60
				local JUMP_GAP = 0.3
				local character = game.Players.LocalPlayer.Character
				for i,v in ipairs(character:GetDescendants()) do
					if v:IsA("BasePart") then
						v.CanCollide = false
					end
				end
				local ball = character.HumanoidRootPart
				ball.Shape = Enum.PartType.Ball
				ball.Size = Vector3.new(10,10,10)
				local humanoid = character:WaitForChild("Humanoid")
				local params = RaycastParams.new()
				params.FilterType = Enum.RaycastFilterType.Blacklist
				params.FilterDescendantsInstances = {character}
				local tc = RunService.RenderStepped:Connect(function(delta)
					ball.CanCollide = true
					humanoid.PlatformStand = true
					if UserInputService:GetFocusedTextBox() then return end
					if UserInputService:IsKeyDown("W") then
						ball.RotVelocity -= Camera.CFrame.RightVector * delta * SPEED_MULTIPLIER
					end
					if UserInputService:IsKeyDown("A") then
						ball.RotVelocity -= Camera.CFrame.LookVector * delta * SPEED_MULTIPLIER
					end
					if UserInputService:IsKeyDown("S") then
						ball.RotVelocity += Camera.CFrame.RightVector * delta * SPEED_MULTIPLIER
					end
					if UserInputService:IsKeyDown("D") then
						ball.RotVelocity += Camera.CFrame.LookVector * delta * SPEED_MULTIPLIER
					end
					--ball.RotVelocity = ball.RotVelocity - Vector3.new(0,ball.RotVelocity.Y/50,0)
				end)
				UserInputService.JumpRequest:Connect(function()
					local result = workspace:Raycast(
						ball.Position,
						Vector3.new(
							0,
							-((ball.Size.Y/2)+JUMP_GAP),
							0
						),
						params
					)
					if result then
						ball.Velocity = ball.Velocity + Vector3.new(0,JUMP_POWER,0)
					end
				end)
				Camera.CameraSubject = ball
				humanoid.Died:Connect(function() tc:Disconnect() end)
			end,
		})
		local RainbowToggle = Tab:CreateToggle({
			Name = "Rainbow Nametag",
			CurrentValue = false,
			Flag = "RainbowNameTagToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				isRGBNameOn = Value
				if isRGBNameOn == true then
					coroutine.wrap(function()
						local NametagRemote = game:GetService("ReplicatedStorage"):WaitForChild("RoleplayNametag")
						local TweenService = game:GetService("TweenService")
						local tweenInfo = TweenInfo.new(2.5,Enum.EasingStyle.Linear)
						local colorVal = Instance.new("Color3Value")
						colorVal.Value = Color3.new(1,0,0)
						colorVal.Changed:Connect(function(newColor)
							NametagRemote:FireServer(colorVal.Value)
						end)
						NametagRemote:FireServer(colorVal.Value)
						local step = 1
						while isRGBNameOn == true do
							local rainbowSteps = {
								[1] = Color3.fromRGB(255,0,0),
								[2] = Color3.fromRGB(255,255,0),
								[3] = Color3.fromRGB(0,255,0),
								[4] = Color3.fromRGB(0,255,255),
								[5] = Color3.fromRGB(0,0,255),
								[6] = Color3.fromRGB(255,0,255)
							}
							local tween = TweenService:Create(colorVal, tweenInfo, {Value = rainbowSteps[step]})
							tween:Play()
							tween.Completed:Wait()
							step += 1
							if step > #rainbowSteps then
								step = 1
							end
						end
						colorVal:Destroy()
					end)()
				end
			end,
		})
		local AnimatronicSection = Tab:CreateSection("Animatronic")
		local EndoButton = Tab:CreateButton({
			Name = "Become Endo-Skeleton",
			Callback = function()
				isEndo = true
				local Players = game:GetService("Players")
				local visRM = game:GetService("ReplicatedStorage").VisParts

				for _,charmodel in Players.LocalPlayer.Character:GetChildren() do
					if charmodel:IsA("Model") and charmodel:FindFirstChild("HumanoidRootPart") then
						for _,part in charmodel:GetDescendants() do
							if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and string.lower(part.Name) ~= "crawlpart" and not string.find(string.lower(part.Name),"endo") and not string.find(string.lower(part.Name),"wire") and not string.find(string.lower(part.Name),"eye") and not string.find(string.lower(part.Name),"neck") and not string.find(string.lower(part.Name),"ndo") and not string.find(string.lower(part.Name), "teeth") and not string.find(string.lower(part.Name), "screw") and part.Name ~= "Black" or string.find(string.lower(part.Name), "eyebrow") then
								visRM:FireServer(part,1)
							end
						end
					end
				end
			end,
		})
		----
		local PlayerSection = Tab:CreateSection("Player")
		local SizeSlider = Tab:CreateSlider({
			Name = "Character Size - R6/R15 ONLY",
			Range = {0.5, 1.5},
			Increment = 0.1,
			Suffix = "Size",
			CurrentValue = 1,
			Flag = "SizeSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
			Callback = function(Value)
				coroutine.wrap(function()
					if srcLoad == true then
						repeat task.wait() until sizechangedb == false
					end
					if sizechangedb == false then
						sizechangedb = true
						local minSize = 0.500000001
						local maxSize = 1.499999999
						local inputNum = tonumber(Value)
						if inputNum then
							local newInput = inputNum >= 1.5 and maxSize or inputNum <= 0.5 and minSize or inputNum
							local Remote = game:GetService("ReplicatedStorage"):WaitForChild("Size"):FireServer(newInput)
						end
						task.wait(0.2)
						sizechangedb = false
					end
				end)()
			end,
		})
		local ToolsButton = Tab:CreateButton({
			Name = "Give All Tools",
			Callback = function()
				local args = {
					[1] = workspace:WaitForChild(game.Players.LocalPlayer.Name),
					[2] = "Flashlight",
					[3] = "normalMask",
					[4] = "Axe",
					[5] = "Knife",
					[6] = "Wrench",
					[7] = "gamepass1Mask",
					[8] = "FreddyPlush",
					[9] = "GoldenFreddyPlush",
					[10] = "PhotoCamera"
				}
				game:GetService("ReplicatedStorage"):WaitForChild("Give_HumanAssets"):FireServer(unpack(args))
			end,
		})
	end

	game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("CharacterFunctions"):WaitForChild("Footstep"):Destroy()
	local newrm = Instance.new("RemoteEvent")
	newrm.Name = "Footstep"
	newrm.Parent = game:GetService("ReplicatedStorage").RemoteEvents.CharacterFunctions

	createMainTab()
	createCharacterTab()

	task.wait(2)

	transchangedb = false
	sizechangedb = false

	srcLoad = true
	game.Players.LocalPlayer.ChildAdded:Connect(function()
		isEndo = false
	end)

	game.Players.LocalPlayer.ChildRemoved:Connect(function()
		isEndo = false
	end)

end
