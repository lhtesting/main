repeat task.wait() until game:IsLoaded()
task.wait(3)
local Button1 = workspace.MapFolder.Obby_FloodedCaves.Button1.TouchPart
local Button2 = workspace.MapFolder.Obby_FloodedCaves.Button2.TouchPart
local FCPP = workspace.MapFolder.Obby_FloodedCaves.PromptPart_FloodedCaves
local CCPP = workspace.MapFolder.Obby_CrystalCaves.PromptPart_CrystalCaves
local head = game.Players.LocalPlayer.Character.Head
local HRP = game.Players.LocalPlayer.Character.HumanoidRootPart
for _,prompt in workspace:GetDescendants() do
    if not prompt:IsA("ProximityPrompt") then continue end
    prompt.HoldDuration = 0
end
firetouchinterest(head,Button1,0)
task.wait()
firetouchinterest(head,Button1,1)
task.wait()
firetouchinterest(head,Button2,0)
task.wait()
firetouchinterest(head,Button2,1)
task.wait()
HRP.CFrame = FCPP.CFrame
task.wait(1)
fireproximityprompt(FCPP.ProximityPrompt,0)
task.wait(1)
queue_on_teleport(game:HttpGet("https://raw.githubusercontent.com/lhtesting/main/main/ah23tgds.lua"))
game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
