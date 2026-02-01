-- Prospext Client Executor v1
-- Fully client-only, run with Arecus X

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "ProspextExecutor"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Floating Button
local floatBtn = Instance.new("TextButton", gui)
floatBtn.Size = UDim2.fromScale(0.12,0.08)
floatBtn.Position = UDim2.fromScale(0.02,0.8)
floatBtn.Text = "≡"
floatBtn.TextSize = 26
floatBtn.BackgroundColor3 = Color3.fromRGB(0,180,120)
floatBtn.TextColor3 = Color3.new(1,1,1)
floatBtn.Visible = false
floatBtn.Active = true
floatBtn.Draggable = true

-- Main Window
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.95,0.85)
main.Position = UDim2.fromScale(0.025,0.075)
main.BackgroundColor3 = Color3.fromRGB(15,15,20)
main.Active = true
main.Draggable = true

-- Minimize
local min = Instance.new("TextButton", main)
min.Size = UDim2.fromScale(0.08,0.06)
min.Position = UDim2.fromScale(0.9,0.02)
min.Text = "—"
min.TextSize = 20
min.BackgroundColor3 = Color3.fromRGB(180,60,60)
min.TextColor3 = Color3.new(1,1,1)

-- Tabs
local tabs = Instance.new("Frame", main)
tabs.Size = UDim2.fromScale(1,0.1)
tabs.Position = UDim2.fromScale(0,0.1)
tabs.BackgroundColor3 = Color3.fromRGB(20,20,30)

local execTab = Instance.new("TextButton", tabs)
execTab.Size = UDim2.fromScale(0.5,1)
execTab.Text = "EXECUTOR"
execTab.BackgroundTransparency = 1
execTab.TextColor3 = Color3.fromRGB(0,255,180)

local outTab = Instance.new("TextButton", tabs)
outTab.Size = UDim2.fromScale(0.5,1)
outTab.Position = UDim2.fromScale(0.5,0)
outTab.Text = "OUTPUT"
outTab.BackgroundTransparency = 1
outTab.TextColor3 = Color3.fromRGB(180,180,180)

-- Pages
local execPage = Instance.new("Frame", main)
execPage.Size = UDim2.fromScale(1,0.9)
execPage.Position = UDim2.fromScale(0,0.1)
execPage.BackgroundTransparency = 1

local outPage = execPage:Clone()
outPage.Visible = false
outPage.Parent = main

-- Script box
local box = Instance.new("TextBox", execPage)
box.Size = UDim2.fromScale(0.96,0.65)
box.Position = UDim2.fromScale(0.02,0.03)
box.MultiLine = true
box.ClearTextOnFocus = false
box.TextWrapped = true
box.TextXAlignment = Left
box.TextYAlignment = Top
box.TextSize = 16
box.BackgroundColor3 = Color3.fromRGB(25,25,35)
box.TextColor3 = Color3.fromRGB(0,255,180)
box.Text = 'print("prospext1700")'

-- Buttons
local function makeBtn(txt,x,y,parent)
	local b = Instance.new("TextButton", parent or execPage)
	b.Size = UDim2.fromScale(0.3,0.1)
	b.Position = UDim2.fromScale(x,y)
	b.Text = txt
	b.TextSize = 16
	b.BackgroundColor3 = Color3.fromRGB(0,180,120)
	b.TextColor3 = Color3.new(1,1,1)
	return b
end

local run = makeBtn("EXECUTE",0.35,0.72)
local clearScript = makeBtn("CLEAR SCRIPT",0.05,0.72)
local paste = makeBtn("PASTE",0.65,0.72)

-- Output box
local outBox = Instance.new("TextBox", outPage)
outBox.Size = UDim2.fromScale(0.96,0.8)
outBox.Position = UDim2.fromScale(0.02,0.05)
outBox.MultiLine = true
outBox.TextWrapped = true
outBox.ClearTextOnFocus = false
outBox.TextXAlignment = Left
outBox.TextYAlignment = Top
outBox.TextSize = 15
outBox.BackgroundColor3 = Color3.fromRGB(25,25,35)
outBox.TextColor3 = Color3.fromRGB(200,200,200)
outBox.Text = ""

local clearOut = makeBtn("CLEAR OUTPUT",0.3,0.87,outPage)
clearOut.Size = UDim2.fromScale(0.4,0.1)
clearOut.BackgroundColor3 = Color3.fromRGB(180,60,60)

-- ===== LOGIC =====
run.MouseButton1Click:Connect(function()
	outBox.Text = ""
	local fn, err = loadstring(box.Text)
	if not fn then
		outBox.Text = err
		return
	end
	local ok,res = pcall(fn)
	if not ok then
		outBox.Text = res
	end
end)

clearScript.MouseButton1Click:Connect(function()
	box.Text = ""
end)

paste.MouseButton1Click:Connect(function()
	box:CaptureFocus()
end)

clearOut.MouseButton1Click:Connect(function()
	outBox.Text = ""
end)

execTab.MouseButton1Click:Connect(function()
	execPage.Visible = true
	outPage.Visible = false
	execTab.TextColor3 = Color3.fromRGB(0,255,180)
	outTab.TextColor3 = Color3.fromRGB(180,180,180)
end)

outTab.MouseButton1Click:Connect(function()
	execPage.Visible = false
	outPage.Visible = true
	outTab.TextColor3 = Color3.fromRGB(0,255,180)
	execTab.TextColor3 = Color3.fromRGB(180,180,180)
end)

-- Minimize / Restore
min.MouseButton1Click:Connect(function()
	main.Visible = false
	floatBtn.Visible = true
end)

floatBtn.MouseButton1Click:Connect(function()
	main.Visible = true
	floatBtn.Visible = false
end)

-- ===== Idle Fade =====
local lastInput = tick()
local faded = false

local function fade(to)
	TweenService:Create(main, TweenInfo.new(0.4), {BackgroundTransparency = to}):Play()
end

gui.InputBegan:Connect(function()
	lastInput = tick()
	if faded then
		fade(0)
		faded = false
	end
end)

task.spawn(function()
	while true do
		task.wait(1)
		if main.Visible and not faded and tick() - lastInput > 6 then
			fade(0.4)
			faded = true
		end
	end
end)

print("✅ Prospext Client Executor loaded")
