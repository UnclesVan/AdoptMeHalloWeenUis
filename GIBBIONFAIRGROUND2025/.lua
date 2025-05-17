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
	btn.Size = UDim2.new(0, 200, 0, 40) -- Slightly smaller buttons
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.Text = text
	btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3) -- Dark gray background
	btn.TextColor3 = Color3.new(1, 1, 1) -- White text
	btn.Font = Enum.Font.SourceSansBold -- More readable font
	btn.TextSize = 14 -- Adjusted text size
	return btn
end

local function createLabel(text, yPos)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0, 200, 0, 20)
	lbl.Position = UDim2.new(0, 10, 0, yPos)
	lbl.Text = text
	lbl.TextColor3 = Color3.new(1,1,1)
	lbl.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1) -- Darker background
	lbl.Font = Enum.Font.SourceSansSemibold
	lbl.TextSize = 12
	lbl.TextXAlignment = Enum.TextXAlignment.Left -- Align text to the left
	return lbl
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LayoutUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false -- Keep UI when player respawns

-- Move the whole UI to the right
local uiOffsetX = 200 -- Adjust this value to move it further right
local uiOffsetY = 50  -- Optional: Adjust vertical offset

local buttons = {}
local toggleFlags = {false, false, false, false, false} -- Added one more for the new toggle
local autoOpenCoroutine = nil
local attemptClaimCoroutine = nil
local autoBuyPetsCoroutine = nil -- Renamed the original auto buy
local autoBuyBoxesCoroutine = nil -- New auto buy for boxes
local autoCloseCoroutine = nil

local labels = {
	"Auto Open",
	"Claim Gibbion",
	"Auto Buy Pets",
	"Auto Close Reward",
	"Auto Buy Boxes" -- New label
}

-- Create the 5 toggle buttons
for i, label in ipairs(labels) do
	local btn = createButton(label, uiOffsetY + 10 + (i-1)*50) -- Adjusted spacing and offset
	btn.Position = UDim2.new(0, uiOffsetX + 10, 0, uiOffsetY + 10 + (i-1)*50) -- Apply horizontal offset
	btn.Name = label .. "Button"
	buttons[i] = btn
	btn.Parent = screenGui
end

-- Position for the "Close" button
local closeButtonY = uiOffsetY + 10 + 5*50 + 15 -- Adjusted position

-- Create the "Close" button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 200, 0, 40)
closeBtn.Position = UDim2.new(0, uiOffsetX + 10, 0, closeButtonY)
closeBtn.Text = "Close"
closeBtn.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 14
closeBtn.Parent = screenGui

-- Position for the "Buy Amount:" label (for pets)
local buyPetsLabelY = closeButtonY + 40 + 10
local buyPetsLabel = createLabel("Buy Pet Amount:", buyPetsLabelY)
buyPetsLabel.Position = UDim2.new(0, uiOffsetX + 10, 0, buyPetsLabelY)
buyPetsLabel.Parent = screenGui

-- Create the TextBox for pet buy amount
local buyPetsAmountBoxY = buyPetsLabelY + 20 + 5
local buyPetsAmountBox = Instance.new("TextBox")
buyPetsAmountBox.Size = UDim2.new(0, 200, 0, 30)
buyPetsAmountBox.Position = UDim2.new(0, uiOffsetX + 10, 0, buyPetsAmountBoxY)
buyPetsAmountBox.Text = "1"
buyPetsAmountBox.PlaceholderText = "Enter pet amount"
buyPetsAmountBox.BackgroundColor3 = Color3.new(1,1,1)
buyPetsAmountBox.TextColor3 = Color3.new(0,0,0)
buyPetsAmountBox.Font = Enum.Font.SourceSansSemibold
buyPetsAmountBox.TextSize = 12
buyPetsAmountBox.Parent = screenGui

-- Position for the "Buy Box Amount:" label
local buyBoxesLabelY = buyPetsAmountBoxY + 30 + 10
local buyBoxesLabel = createLabel("Buy Box Amount:", buyBoxesLabelY)
buyBoxesLabel.Position = UDim2.new(0, uiOffsetX + 10, 0, buyBoxesLabelY)
buyBoxesLabel.Parent = screenGui

-- Create the TextBox for box buy amount
local buyBoxesAmountBoxY = buyBoxesLabelY + 20 + 5
local buyBoxesAmountBox = Instance.new("TextBox")
buyBoxesAmountBox.Size = UDim2.new(0, 200, 0, 30)
buyBoxesAmountBox.Position = UDim2.new(0, uiOffsetX + 10, 0, buyBoxesAmountBoxY)
buyBoxesAmountBox.Text = "2"
buyBoxesAmountBox.PlaceholderText = "Enter box amount"
buyBoxesAmountBox.BackgroundColor3 = Color3.new(1,1,1)
buyBoxesAmountBox.TextColor3 = Color3.new(0,0,0)
buyBoxesAmountBox.Font = Enum.Font.SourceSansSemibold
buyBoxesAmountBox.TextSize = 12
buyBoxesAmountBox.Parent = screenGui

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

-- Original "Auto Open Box" loop - NOW ONLY OPENS FROM HOTBAR
local function autoOpenLoop()
	while toggleFlags[1] do
		local success, err = pcall(function()
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

-- Auto Buy Pets loop - NOW USES TEXTBOX AMOUNT
local function autoBuyPetsLoop()
	while toggleFlags[3] do
		local success, err = pcall(function()
			local buyAmount = tonumber(buyPetsAmountBox.Text)
			if not buyAmount or buyAmount < 1 then
				buyAmount = 1 -- Default to 1 if the input is invalid
			end

			local args = {
				"pets", -- Buying the PET
				"gibbon_2025_gibbon",
				{
					buy_count = buyAmount
				}
			}
			game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ShopAPI/BuyItem"):InvokeServer(unpack(args))
			wait(1) -- Small delay between buy attempts
		end)
		if not success then warn("AutoBuy Pets error:", err) end
		wait(0.5) -- General delay for the loop
		if not toggleFlags[3] then
			break
		end
	end
	autoBuyPetsCoroutine = nil
end

-- Auto Buy Gibbion Boxes loop
local function autoBuyBoxesLoop()
	while toggleFlags[5] do
		local success, err = pcall(function()
			local buyAmount = tonumber(buyBoxesAmountBox.Text)
			if not buyAmount or buyAmount < 1 then
				buyAmount = 1 -- Default to 1 if the input is invalid
			end

			local args = {
				"gifts", -- Buying the GIFT BOX
				"gibbon_2025_standard_box",
				{
					buy_count = buyAmount
				}
			}
			game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ShopAPI/BuyItem"):InvokeServer(unpack(args))
			wait(1) -- Small delay between buy attempts
		end)
		if not success then warn("AutoBuy Boxes error:", err) end
		wait(0.5) -- General delay for the loop
		if not toggleFlags[5] then
			break
		end
	end
	autoBuyBoxesCoroutine = nil
end

-- Auto Close loop - now controlled solely by its toggle
local function autoCloseLoop()
	while toggleFlags[4] do
		local success, err = pcall(function()
			local rewardGui = playerGui:FindFirstChild("JackboxRewardApp")
			if rewardGui then
				local closeButton = rewardGui:FindFirstChild("Body")
					and rewardGui.Body:FindFirstChild("CloseButton") -- Assuming there's a "CloseButton"
				if closeButton then
					simulateClick(closeButton)
				else
					local claimButton = rewardGui:FindFirstChild("Body")
						and rewardGui.Body:FindFirstChild("ClaimButton") -- Fallback to Claim if no Close
					if claimButton then
						simulateClick(claimButton)
					end
				end
			end
		end)
		if not success then warn("AutoClose error:", err) end
		wait(5)
	end
	autoCloseCoroutine = nil
end

-- Toggle handlers
-- 1. Auto Open Box - NOW ONLY OPENS HOTBAR ITEMS
buttons[1].MouseButton1Click:Connect(function()
	toggleFlags[1] = not toggleFlags[1]
	local btn = buttons[1]
	if toggleFlags[1] then
		btn.Text = "Auto Open: ON" -- Shorter text
		btn.BackgroundColor3 = Color3.new(0, 0.5, 0) -- Darker green
		autoOpenCoroutine = coroutine.create(autoOpenLoop)
		coroutine.resume(autoOpenCoroutine)
	else
		btn.Text = "Auto Open: OFF"
		btn.BackgroundColor3 = Color3.new(0.5, 0, 0) -- Darker red
		autoOpenCoroutine = nil
	end
end)

-- 2. AttemptClaimRingmasterGibbion
buttons[2].MouseButton1Click:Connect(function()
	toggleFlags[2] = not toggleFlags[2]
	local btn = buttons[2]
	if toggleFlags[2] then
		btn.Text = "Claim Gibbion: ON" -- Shorter text
		btn.BackgroundColor3 = Color3.new(0, 0.5, 0) -- Darker green
		attemptClaimCoroutine = coroutine.create(attemptClaimLoop)
		coroutine.resume(attemptClaimCoroutine)
	else
		btn.Text = "Claim Gibbion: OFF"
		btn.BackgroundColor3 = Color3.new(0.5, 0, 0) -- Darker red
		-- The attemptClaimLoop will now break when toggleFlags[2] is false
	end
end)

-- 3. AutoBuy Pets + textbox for amount
buttons[3].MouseButton1Click:Connect(function()
	toggleFlags[3] = not toggleFlags[3]
	local btn = buttons[3]
	if toggleFlags[3] then
		btn.Text = "Auto Buy Pets: ON" -- Shorter text
		btn.BackgroundColor3 = Color3.new(0, 0.5, 0) -- Darker green
		autoBuyPetsCoroutine = coroutine.create(autoBuyPetsLoop)
		coroutine.resume(autoBuyPetsCoroutine)
	else
		btn.Text = "Auto Buy Pets: OFF"
		btn.BackgroundColor3 = Color3.new(0.5, 0, 0) -- Darker red
		if autoBuyPetsCoroutine and coroutine.status(autoBuyPetsCoroutine) == "running" then
			toggleFlags[3] = false -- Ensure the loop in autoBuyPetsLoop stops
		end
	end
end)

-- 4. Auto Close JackBox Reward - Controls its own loop
buttons[4].MouseButton1Click:Connect(function()
	toggleFlags[4] = not toggleFlags[4]
	local btn = buttons[4]
	if toggleFlags[4] then
		btn.Text = "Auto Close Reward: ON" -- Shorter text
		btn.BackgroundColor3 = Color3.new(0, 0.5, 0) -- Darker green
		autoCloseCoroutine = coroutine.create(autoCloseLoop)
		coroutine.resume(autoCloseCoroutine)
	else
		btn.Text = "Auto Close Reward: OFF"
		btn.BackgroundColor3 = Color3.new(0.5, 0, 0) -- Darker red
		if autoCloseCoroutine and coroutine.status(autoCloseCoroutine) == "running" then
			toggleFlags[4] = false -- Ensure the loop in autoCloseLoop stops
		end
	end
end)

-- 5. AutoBuy Gibbion Boxes + textbox for amount
buttons[5].MouseButton1Click:Connect(function()
	toggleFlags[5] = not toggleFlags[5]
	local btn = buttons[5]
	if toggleFlags[5] then
		btn.Text = "Auto Buy Boxes: ON" -- Shorter text
		btn.BackgroundColor3 = Color3.new(0, 0.5, 0) -- Darker green
		autoBuyBoxesCoroutine = coroutine.create(autoBuyBoxesLoop)
		coroutine.resume(autoBuyBoxesCoroutine)
	else
		btn.Text = "Auto Buy Boxes: OFF"
		btn.BackgroundColor3 = Color3.new(0.5, 0, 0) -- Darker red
		if autoBuyBoxesCoroutine and coroutine.status(autoBuyBoxesCoroutine) == "running" then
			toggleFlags[5] = false -- Ensure the loop in autoBuyBoxesLoop stops
		end
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	toggleFlags[1] = false
	toggleFlags[2] = false
	toggleFlags[3] = false
	toggleFlags[4] = false
	toggleFlags[5] = false
	screenGui:Destroy()
end)
