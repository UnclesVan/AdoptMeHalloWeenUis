-- dehash
loadstring(game:HttpGet(('https://raw.githubusercontent.com/UnclesVan/AdoPtMe-/refs/heads/main/dehashwithslashinmiddle')))()



-- Remove existing item and set new item on the hotbar
local argsClear = {1}
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/SetSlotProperties"):InvokeServer(unpack(argsClear))
local argsSetItem = {
	1,
	{
		category = "gifts",
		kind = "gibbon_2025_standard_box"
	}
}
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/SetSlotProperties"):InvokeServer(unpack(argsSetItem))

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local function createButton(text, yPos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 220, 0, 50)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.Text = text
	btn.BackgroundColor3 = Color3.new(0, 1, 0)
	btn.TextColor3 = Color3.new(1, 1, 1)
	return btn
end

local function createLabel(text, yPos)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0, 220, 0, 20)
	lbl.Position = UDim2.new(0, 10, 0, yPos)
	lbl.Text = text
	lbl.TextColor3 = Color3.new(1,1,1)
	lbl.BackgroundColor3 = Color3.new(0,0,0)
	return lbl
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LayoutUI"
screenGui.Parent = playerGui

local buttons = {}
local toggleFlags = {false, false, false, false}
local autoOpenCoroutine = nil
local attemptClaimCoroutine = nil
local autoBuyCoroutine = nil -- New coroutine for auto-buying
local autoCloseCoroutine = nil

local labels = {
	"Auto Open Box",
	"AttemptClaimRingmasterGibbion",
	"AutoBuyGibbion",
	"Auto Close JackBox Reward"
}

-- Create the 4 toggle buttons
for i, label in ipairs(labels) do
	local btn = createButton(label, 10 + (i-1)*60)
	btn.Parent = screenGui
	buttons[i] = btn
end

-- Position for the "Close" button
local closeButtonY = 10 + 4*60 + 20

-- Create the "Close" button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 220, 0, 50)
closeBtn.Position = UDim2.new(0, 10, 0, closeButtonY)
closeBtn.Text = "Close"
closeBtn.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = screenGui

-- Create "Buy Amount:" label **above** the "Close" button
local buyLabelY = closeButtonY + 50 + 10 -- Position it below the close button
local buyLabel = createLabel("Buy Amount:", buyLabelY)
buyLabel.Parent = screenGui

-- Create the TextBox **below** the label
local buyAmountBoxY = buyLabelY + 20 + 10 -- some space below label
local buyAmountBox = Instance.new("TextBox")
buyAmountBox.Size = UDim2.new(0, 220, 0, 30)
buyAmountBox.Position = UDim2.new(0, 10, 0, buyAmountBoxY)
buyAmountBox.Text = "1"
buyAmountBox.PlaceholderText = "Enter amount" -- Added a placeholder text
buyAmountBox.BackgroundColor3 = Color3.new(1,1,1)
buyAmountBox.TextColor3 = Color3.new(0,0,0)
buyAmountBox.Parent = screenGui

-- Helper for clicking
local function fireConnections(event)
	for _, connection in pairs(getconnections(event)) do
		connection:Fire()
	end
end

local function simulateClick(btn)
	if btn then
		fireConnections(btn.MouseButton1Down)
		wait(0.05)
		fireConnections(btn.MouseButton1Click)
		wait(0.05)
		fireConnections(btn.MouseButton1Up)
	end
end

-- Original "Auto Open Box" loop
local function autoOpenLoop()
	while toggleFlags[1] do
		local success, err = pcall(function()
			local claimBtn = playerGui:WaitForChild("JackboxRewardApp", 5)
				:WaitForChild("Body")
				:WaitForChild("ClaimButton")
			if claimBtn then
				simulateClick(claimBtn)
			end

			local toolContainer = playerGui:WaitForChild("ToolApp", 5)
				:WaitForChild("Frame")
				:WaitForChild("Hotbar")
				:WaitForChild("ToolContainer")
			if toolContainer then
				for _, child in ipairs(toolContainer:GetChildren()) do
					if child:IsA("GuiObject") then
						simulateClick(child)
					end
				end
			end
		end)
		if not success then warn("AutoOpen error:", err) end
		wait(2)
	end
end

-- Attempt Claim Ringmaster Gibbion loop
local function attemptClaimLoop()
	while toggleFlags[2] do
		local success, err = pcall(function()
			game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("GibbonAPI/AttemptClaimRingmaster"):FireServer()
		end)
		if not success then warn("AttemptClaim error:", err) end
		wait(1) -- Adjust wait time as needed
		if not toggleFlags[2] then -- Check if the toggle has been turned off
			break -- Exit the loop
		end
	end
	attemptClaimCoroutine = nil -- Clean up the coroutine variable
end

-- Auto Buy Gibbion loop (only buys if stack count is "x0")
local function autoBuyLoop()
	while toggleFlags[3] do
		local success, err = pcall(function()
			local stackCountLabel = player.PlayerGui:WaitForChild("ToolApp", 5)
				:WaitForChild("Frame")
				:WaitForChild("Hotbar")
				:WaitForChild("ToolContainer")
				:WaitForChild("StackCount")
				:WaitForChild("TextLabel")

			if stackCountLabel and stackCountLabel.Text == "x0" then
				local args = {
					"gifts",
					"gibbon_2025_standard_box",
					{
						buy_count = 10
					}
				}
				game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ShopAPI/BuyItem"):InvokeServer(unpack(args))
				wait(1) -- Small delay between buy attempts
			else
				wait(5) -- Wait longer if the stack is not "x0"
			end
		end)
		if not success then warn("AutoBuy error:", err) end
		wait(0.5) -- General delay for the loop
	end
	autoBuyCoroutine = nil
end

-- Auto Close loop
local function autoCloseLoop()
	while toggleFlags[4] do
		local success, err = pcall(function()
			local rewardGui = playerGui:FindFirstChild("JackboxRewardApp")
			if rewardGui then
				local claimBtn = rewardGui:FindFirstChild("Body")
					and rewardGui.Body:FindFirstChild("ClaimButton")
				if claimBtn then
					simulateClick(claimBtn)
				end
			end
		end)
		if not success then warn("AutoClose error:", err) end
		wait(5)
	end
end

-- Toggle handlers
-- 1. Auto Open Box
buttons[1].MouseButton1Click:Connect(function()
	toggleFlags[1] = not toggleFlags[1]
	local btn = buttons[1]
	if toggleFlags[1] then
		btn.Text = "Auto Open Box: ON"
		btn.BackgroundColor3 = Color3.new(0, 1, 0)
		autoOpenCoroutine = coroutine.create(autoOpenLoop)
		coroutine.resume(autoOpenCoroutine)
	else
		btn.Text = "Auto Open Box: OFF"
		btn.BackgroundColor3 = Color3.new(1, 0, 0)
		autoOpenCoroutine = nil
	end
end)

-- 2. AttemptClaimRingmasterGibbion
buttons[2].MouseButton1Click:Connect(function()
	toggleFlags[2] = not toggleFlags[2]
	local btn = buttons[2]
	if toggleFlags[2] then
		btn.Text = "AttemptClaimRingmasterGibbion: ON"
		btn.BackgroundColor3 = Color3.new(0, 1, 0)
		attemptClaimCoroutine = coroutine.create(attemptClaimLoop)
		coroutine.resume(attemptClaimCoroutine)
	else
		btn.Text = "AttemptClaimRingmasterGibbion: OFF"
		btn.BackgroundColor3 = Color3.new(1, 0, 0)
		-- The attemptClaimLoop will now break when toggleFlags[2] is false
	end
end)

-- 3. AutoBuyGibbion + textbox with stack count check for continuous buying
buttons[3].MouseButton1Click:Connect(function()
	toggleFlags[3] = not toggleFlags[3]
	local btn = buttons[3]
	if toggleFlags[3] then
		btn.Text = "AutoBuyGibbion: ON"
		btn.BackgroundColor3 = Color3.new(0, 1, 0)
		autoBuyCoroutine = coroutine.create(autoBuyLoop)
		coroutine.resume(autoBuyCoroutine)
	else
		btn.Text = "AutoBuyGibbion: OFF"
		btn.BackgroundColor3 = Color3.new(1, 0, 0)
		if autoBuyCoroutine and coroutine.status(autoBuyCoroutine) == "running" then
			toggleFlags[3] = false -- Ensure the loop in autoBuyLoop stops
		end
	end
end)

-- 4. Auto Close JackBox Reward
buttons[4].MouseButton1Click:Connect(function()
	toggleFlags[4] = not toggleFlags[4]
	local btn = buttons[4]
	if toggleFlags[4] then
		btn.Text = "Auto Close JackBox Reward: ON"
		btn.BackgroundColor3 = Color3.new(0, 1, 0)
		autoCloseCoroutine = coroutine.create(autoCloseLoop)
		coroutine.resume(autoCloseCoroutine)
	else
		btn.Text = "Auto Close JackBox Reward"
		btn.BackgroundColor3 = Color3.new(1, 0, 0)
		autoCloseCoroutine = nil
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	toggleFlags[1] = false
	toggleFlags[2] = false
	toggleFlags[3] = false -- Stop auto-buy on close
	toggleFlags[4] = false
	screenGui:Destroy()
end)
