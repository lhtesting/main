----------------------------
----  LOOKIN' HACKABLE  ----
----------------------------
---------------------
----  VARIABLES  ----
---------------------

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Character
local Player = Players.LocalPlayer
local HumanoidRootPart

local MovementValue = Instance.new("CFrameValue")
local MovementActive = false
local MovementTimePerStud = 0.075

--------------------------
----  INITIALIZATION  ----
--------------------------

local inGameMenuAPI = loadstring(game:HttpGet('https://raw.githubusercontent.com/lhtesting/LH_core/main/helmetcooker/inGameMenuAPI.lua'))()
local function CustomPrint(str,custCol,editable)
	if editable then
		return inGameMenuAPI.sendEditableMessage(`AUTO-FARM V4 : {str}`,custCol ~= nil and custCol or Color3.fromRGB(82,166,255))
	else
		inGameMenuAPI.sendMessage(`AUTO-FARM V4 : {str}`,custCol ~= nil and custCol or Color3.fromRGB(255,255,255))
	end
end
local function CustomPrintEditMsg(msg,str,custCol)
	msg.Text = `AUTO-FARM V4 : {str}`
	msg.TextColor3 = custCol ~= nil and custCol or msg.TextColor3
end
local LoadingMsg = CustomPrint("[##------] LOADING",Color3.fromRGB(82,166,255),true)
local ReturnRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Teleport"):WaitForChild("Return")
local ReplayRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Teleport"):WaitForChild("Replay")

---------------------
----  FUNCTIONS  ----
---------------------

local function MovementSetup()
	workspace.Gravity = 0
	workspace.Changed:Connect(function()
		workspace.Gravity = 0
	end)
	for _,part in Character:GetDescendants() do
		if not part:IsA("BasePart") then continue end
		part.CanCollide = false
	end
	MovementValue.Value = HumanoidRootPart.CFrame
	HumanoidRootPart.Changed:Connect(function()
		if MovementActive == true then return end
		MovementValue.Value = HumanoidRootPart.CFrame
	end)
end

local function MovementMove(NewCFrame: CFrame)
	MovementActive = true
	MovementValue.Value = HumanoidRootPart.CFrame
	local Distance = math.abs((MovementValue.Value.Position - NewCFrame.Position).Magnitude)
	local TI = TweenInfo.new(Distance*MovementTimePerStud,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut)
	local MovementTween = TweenService:Create(MovementValue,TI,{Value = NewCFrame})
	local MovementConnection = MovementValue.Changed:Connect(function(_CFrame)
		HumanoidRootPart.CFrame = _CFrame
	end)
	MovementTween:Play()
	local tweenDone = false
	local LagbackTestConnection = HumanoidRootPart.Changed:Connect(function()
		local Diff = (MovementValue.Value.Position - HumanoidRootPart.CFrame.Position).Magnitude
		if math.abs(Diff) > 5 then
			CustomPrint("Lagback Detected, Attempting to Fix | "..Diff,Color3.fromRGB(255, 189, 82))
			MovementTween:Cancel()
			tweenDone = true
			MovementMove(NewCFrame)
		end
	end)
	local tweenCon = MovementTween.Completed:Connect(function()
		tweenDone = true
	end)
	repeat task.wait() until tweenDone == true
	tweenCon:Disconnect()
	MovementConnection:Disconnect()
	LagbackTestConnection:Disconnect()
	MovementActive = false
end

local function readyUp_Skip()
	local ReadyRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Briefing"):WaitForChild("SetReady")
	local MissionStartTimestamp = ReplicatedStorage:WaitForChild("Values"):WaitForChild("MissionStartTimestamp")
	local CutsceneSkipVote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Briefing"):WaitForChild("CutsceneSkipVote")
	local CharacterLoaded = false
	local msg = CustomPrint("1/3 | READYING UP",Color3.fromRGB(82,166,255),true)
	repeat
		ReadyRemote:FireServer()
		task.wait(0.1)
	until MissionStartTimestamp.Value ~= 0
	CustomPrintEditMsg(msg,"2/3 | SKIPPING CUTSCENE")
	repeat
		CutsceneSkipVote:FireServer()
		if Player.Character then CharacterLoaded = true end
		if workspace:FindFirstChild(Player.Name) then CharacterLoaded = true end
		task.wait()
	until CharacterLoaded == true
	CustomPrintEditMsg(msg,"3/3 | START COMPLETED",Color3.fromRGB(79, 255, 123))
end
local MainNodeTree = {}
local function CreateMovementNodes()
	local DownstairsRoomNodes = {
		[1] = {
			UP_CFrame = CFrame.new(Vector3.new(-36,-47.5,-171)),
			DOWN_CFrame = CFrame.new(Vector3.new(-36,-55,-171))
		},
		[2] = {
			UP_CFrame = CFrame.new(Vector3.new(-36,-47.5,-126)),
			DOWN_CFrame = CFrame.new(Vector3.new(-36,-55,-126))
		},
		[3] = {
			UP_CFrame = CFrame.new(Vector3.new(-36,-42.5,-84)),
			DOWN_CFrame = CFrame.new(Vector3.new(-36,-50,-84))
		},
		[4] = {
			UP_CFrame = CFrame.new(Vector3.new(-36,-42.5,-41)),
			DOWN_CFrame = CFrame.new(Vector3.new(-36,-50,-41))
		},
		[5] = {
			UP_CFrame = CFrame.new(Vector3.new(16,-42.5,-41)),
			DOWN_CFrame = CFrame.new(Vector3.new(16,-50,-41))
		},
		[6] = {
			UP_CFrame = CFrame.new(Vector3.new(16,-42.5,-84)),
			DOWN_CFrame = CFrame.new(Vector3.new(16,-50,-84))
		},
		[7] = {
			UP_CFrame = CFrame.new(Vector3.new(16,-47.5,-126)),
			DOWN_CFrame = CFrame.new(Vector3.new(16,-55,-126))
		},
		[8] = {
			UP_CFrame = CFrame.new(Vector3.new(16,-47.5,-171)),
			DOWN_CFrame = CFrame.new(Vector3.new(16,-55,-171))
		},
	}
	local KeycardNodes = {
		START_CFrame = CFrame.new(Vector3.new(-10,-66,-106)),
		KEYCARD = workspace.Map.Geometry.CameraRoom.KeycardSpawns.Keycard.Base
	}
	local Starcase1Node = {
		UP_CFrame = CFrame.new(Vector3.new(-9,0,-3)),
		DOWN_CFrame = CFrame.new(Vector3.new(-9,-50,-3))
	}
	local UpstairsRoomNodes = {
		[1] = {
			UP_CFrame = CFrame.new(Vector3.new(10.5,-5.5,-40.5)),
			DOWN_CFrame = CFrame.new(Vector3.new(10.5,-18.5,-40.5))
		},
		[2] = {
			UP_CFrame = CFrame.new(Vector3.new(10.5,-5.5,-70.5)),
			DOWN_CFrame = CFrame.new(Vector3.new(10.5,-18.5,-70.5))
		},
		[3] = {
			UP_CFrame = CFrame.new(Vector3.new(-30.5,-5.5,-40.5)),
			DOWN_CFrame = CFrame.new(Vector3.new(-30.5,-18.5,-40.5))
		},
		[4] = {
			UP_CFrame = CFrame.new(Vector3.new(-30.5,-5.5,-70.5)),
			DOWN_CFrame = CFrame.new(Vector3.new(-30.5,-18.5,-70.5))
		},
		[5] = {
			UP_CFrame = CFrame.new(Vector3.new(-83.5,-3.5,-49.5)),
			DOWN_CFrame = CFrame.new(Vector3.new(-83.5,-16.5,-49.5))
		},
		[6] = {
			UP_CFrame = CFrame.new(Vector3.new(-83.5,-3.5,-17.5)),
			DOWN_CFrame = CFrame.new(Vector3.new(-83.5,-16.5,-17.5))
		},
		[7] = {
			UP_CFrame = CFrame.new(Vector3.new(-44.5,-3.5,11.5)),
			DOWN_CFrame = CFrame.new(Vector3.new(-44.5,-16.5,11.5))
		},
	}
	local LeverNodes = {
		START_CFrame = CFrame.new(Vector3.new(-75.4,-2.5,-111.5)),
		LEVER = workspace.Map.Objectives.ControlLever.Handle
	}
	local BombNodes = {
		C4_1 = workspace.Map.Objectives.Radar.Explosive1.Handle,
		C4_2 = workspace.Map.Objectives.Radar.Explosive2.Handle
	}
	local WIN_CFrame = CFrame.new(Vector3.new(-49.5,45.5,-252))
	local START_CFrame = HumanoidRootPart.CFrame + Vector3.new(0,-6,0)
	for i=1,#DownstairsRoomNodes do
		table.insert(MainNodeTree,{
			_CFrame = DownstairsRoomNodes[i].UP_CFrame
		})
	end
	table.insert(MainNodeTree,{
		_CFrame = KeycardNodes.KEYCARD.CFrame,
		Prompt = KeycardNodes.KEYCARD:FindFirstChildOfClass("ProximityPrompt")
	})
	for i=1,#UpstairsRoomNodes do
		table.insert(MainNodeTree,{
			_CFrame = UpstairsRoomNodes[i].DOWN_CFrame
		})
	end
	table.insert(MainNodeTree,{
		_CFrame = LeverNodes.LEVER.CFrame,
		Prompt = LeverNodes.LEVER:FindFirstChildOfClass("ProximityPrompt")
	})
	table.insert(MainNodeTree,{
		_CFrame = workspace.Map.Objectives.Radio.Handle.CFrame,
		Prompt = workspace.Map.Objectives.Radio.Handle:FindFirstChildOfClass("ProximityPrompt")
	})
	table.insert(MainNodeTree,{
		_CFrame = BombNodes.C4_1.CFrame,
		Prompt = BombNodes.C4_1:FindFirstChildOfClass("ProximityPrompt")
	})
	table.insert(MainNodeTree,{
		_CFrame = BombNodes.C4_1.CFrame,
		Prompt = BombNodes.C4_1:FindFirstChildOfClass("ProximityPrompt")
	})
	table.insert(MainNodeTree,{
		_CFrame = BombNodes.C4_2.CFrame,
		Prompt = BombNodes.C4_2:FindFirstChildOfClass("ProximityPrompt")
	})
	table.insert(MainNodeTree,{
		_CFrame = WIN_CFrame
	})
end

local function IntimidateSpam()
	task.spawn(function()
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
	end)
end

local function AutoKiller()
	local equiprm = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Gameplay"):WaitForChild("Inventory"):WaitForChild("EquipWeapon")
	equiprm:FireServer(1)
	task.wait(1)
	task.spawn(function()
		local Weapon = Character:FindFirstChildOfClass("Tool")
		while task.wait() do
			if not Weapon or not Weapon:FindFirstChild("OnHit") then equiprm:FireServer(1) task.wait(1) continue end
			for _,NPC in workspace:GetChildren() do
				if not NPC:IsA("Model") or not table.find({"Hostile","Civilian"},NPC.Name) or not NPC:FindFirstChild("Humanoid") or NPC.Humanoid.Health < 1 then continue end
				local Hostile = NPC:GetAttribute("Hostile")
				if Hostile and Hostile == true then
					task.spawn(function()
						for i=1,5 do
							Weapon.OnHit:FireServer(NPC.Humanoid,NPC.Head.Position,NPC.Head)
						end
					end)
				end
				local Running = NPC:GetAttribute("Running")
				if Running and Running == true then
					task.spawn(function()
						for i=1,5 do
							Weapon.OnHit:FireServer(NPC.Humanoid,NPC.Head.Position,NPC.Head)
						end
					end)
				end
				local Tool = NPC:FindFirstChildOfClass("Tool")
				if Tool then
					task.spawn(function()
						for i=1,5 do
							Weapon.OnHit:FireServer(NPC.Humanoid,NPC.Head.Position,NPC.Head)
						end
					end)
				end
			end
		end
	end)
end

CustomPrintEditMsg(LoadingMsg,"[######--] LOADING",Color3.fromRGB(79, 255, 123))

------------------------
----  MAIN RUNTIME  ----
------------------------

task.wait()
CustomPrintEditMsg(LoadingMsg,"[########] LOADED")
if not Player.Character then readyUp_Skip() repeat task.wait() until Player.Character end
Character = Player.Character
HumanoidRootPart = Character:WaitForChild("HumanoidRootPart",5)
if not HumanoidRootPart then CustomPrint("Couldn't find HumanoidRootPart",Color3.new(1,0,0)) error("Couldn't find HumanoidRootPart")  end
local supmsg = CustomPrint("1/6 | INITIALIZING",Color3.fromRGB(82,166,255),true)
MovementSetup()
task.wait(0.1)
CustomPrintEditMsg(supmsg,"2/6 | CREATING NODES")
CreateMovementNodes()
task.wait(0.1)
CustomPrintEditMsg(supmsg,"3/6 | FIXING PROMPTS")
for _,prompt in workspace:GetDescendants() do
	if not prompt:IsA("ProximityPrompt") then continue end
	prompt.HoldDuration = 0
end
workspace.DescendantAdded:Connect(function(prompt)
	if not prompt:IsA("ProximityPrompt") then return end
	prompt.HoldDuration = 0
end)
RunService.RenderStepped:Connect(function()
	for _, child in Character:GetDescendants() do
		if child:IsA("BasePart") and child.CanCollide == true then
			child.CanCollide = false
		end
	end
end)
task.wait(0.1)
CustomPrintEditMsg(supmsg,"4/6 | INTIIDATE SPAM")
IntimidateSpam()
task.wait(0.1)
CustomPrintEditMsg(supmsg,"5/6 | AUTO-KILL")
AutoKiller()
task.wait(0.1)
CustomPrintEditMsg(supmsg,"6/6 | INITIALIZED",Color3.fromRGB(79, 255, 123))
task.wait(0.1)
local nodemsg = CustomPrint(`0/{#MainNodeTree+1} | COMPLETING PATH`,Color3.fromRGB(255, 196, 94),true)
task.wait(0.1)
for i=1,#MainNodeTree do
	task.wait(0.2)
	CustomPrintEditMsg(nodemsg,`{i}/{#MainNodeTree+1} | COMPLETING PATH`,Color3.fromRGB(82,166,255))
	MovementMove(MainNodeTree[i]._CFrame)
	if not MainNodeTree[i].Prompt then continue end
	fireproximityprompt(MainNodeTree[i].Prompt,0)
end
CustomPrintEditMsg(nodemsg,`{#MainNodeTree+1}/{#MainNodeTree+1} | PATH COMPLETED`,Color3.fromRGB(79, 255, 123))
local completeMsg = CustomPrintEditMsg("WAITING FOR COMPLETION",Color3.fromRGB(255, 196, 94),true)
Player.PlayerGui:WaitForChild("MissionComplete")
CustomPrintEditMsg(completeMsg,"WAITING FOR COMPLETION",Color3.fromRGB(79, 255, 123))
CustomPrint("RESTARTING MATCH",Color3.fromRGB(82,166,255))
task.wait(1)
queue_on_teleport(game:HttpGet("https://raw.githubusercontent.com/lhtesting/main/main/testafhel.lua"))
task.wait(1)
game:GetService("ReplicatedStorage").Remotes.Teleport.Replay:InvokeServer()
