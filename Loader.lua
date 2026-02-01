-- Prospect Executor Loader
-- Run from SERVER dev console

if not game:GetService("RunService"):IsServer() then
	error("Run this from the SERVER console")
end

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

-- REMOTE
local remote = ReplicatedStorage:FindFirstChild("ProspectExecute")
if not remote then
	remote = Instance.new("RemoteEvent")
	remote.Name = "ProspectExecute"
	remote.Parent = ReplicatedStorage
end

-- ADMIN LIST
local ADMINS = {
	["YourUsernameHere"] = true
}

-- SERVER EXECUTOR
local serverScript = Instance.new("Script")
serverScript.Name = "ProspectServerExecutor"
serverScript.Source = [[
local Remote = game.ReplicatedStorage.ProspectExecute

local ADMINS = {
	["YourUsernameHere"] = true
}

Remote.OnServerEvent:Connect(function(player, code)
	if not ADMINS[player.Name] then
		warn("Blocked:", player.Name)
		return
	end
	
	if typeof(code) ~= "string" then return end
	if #code > 8000 then return end

	local func, err = loadstring(code)
	if not func then
		warn("Compile error:", err)
		return
	end

	local ok, result = pcall(func)
	if not ok then
		warn("Runtime error:", result)
	end
end)
]]
serverScript.Parent = game.ServerScriptService

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ProspectExecutor"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.5, 0.6)
frame.Position = UDim2.fromScale(0.25, 0.2)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local box = Instance.new("TextBox", frame)
box.Size = UDim2.fromScale(0.95, 0.8)
box.Position = UDim2.fromScale(0.025, 0.05)
box.ClearTextOnFocus = false
box.TextXAlignment = Left
box.TextYAlignment = Top
box.TextWrapped = true
box.MultiLine = true
box.Text = "-- Prospect Executor\nprint('Hello world')"
box.BackgroundColor3 = Color3.fromRGB(30,30,30)
box.TextColor3 = Color3.fromRGB(0,255,140)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.fromScale(0.4, 0.1)
btn.Position = UDim2.fromScale(0.3, 0.88)
btn.Text = "EXECUTE"
btn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
btn.TextColor3 = Color3.new(1,1,1)

-- LOCAL SCRIPT
local localScript = Instance.new("LocalScript", gui)
localScript.Source = [[
local Remote = game.ReplicatedStorage:WaitForChild("ProspectExecute")
local gui = script.Parent
local frame = gui.Frame
local box = frame.TextBox
local btn = frame.TextButton

btn.MouseButton1Click:Connect(function()
	Remote:FireServer(box.Text)
end)
]]

-- GIVE GUI TO ADMINS
Players.PlayerAdded:Connect(function(plr)
	if ADMINS[plr.Name] then
		gui:Clone().Parent = plr:WaitForChild("PlayerGui")
	end
end)

print("✅ Prospect Executor loaded")
