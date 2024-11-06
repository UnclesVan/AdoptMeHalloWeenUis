local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Reference the original amount label in BucksIndicatorApp
local originalAmountLabel = playerGui:WaitForChild("BucksIndicatorApp"):WaitForChild("CurrencyIndicator"):WaitForChild("Container"):WaitForChild("Amount")

-- Create the ScreenGui
local currencyUI = Instance.new("ScreenGui")
currencyUI.Name = "CurrencyUI"
currencyUI.Parent = playerGui

-- Create the Frame for the currency display
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.3, 0, 0.15, 0)
frame.Position = UDim2.new(0.5, -0.15, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = currencyUI

-- Add rounded corners to the frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.2, 0)
corner.Parent = frame

-- Create TextLabel for script owner
local ownerLabel = Instance.new("TextLabel")
ownerLabel.Size = UDim2.new(1, 0, 0.3, 0)
ownerLabel.Position = UDim2.new(0, 0, 0, 0)
ownerLabel.BackgroundTransparency = 1
ownerLabel.TextColor3 = Color3.new(0, 0, 0)
ownerLabel.TextScaled = true
ownerLabel.Font = Enum.Font.SourceSansBold
ownerLabel.TextStrokeTransparency = 0.5
ownerLabel.Text = "Private Script Owner: made by me"
ownerLabel.Parent = frame

-- Create the candy corn image
local candyCorn = Instance.new("ImageLabel", frame)
candyCorn.Size = UDim2.new(0.35, 0, 0.9, 0)
candyCorn.Position = UDim2.new(0.02, 0, 0.05, 0)
candyCorn.BackgroundTransparency = 1
candyCorn.Image = "rbxassetid://2576547983"  -- Updated asset ID
candyCorn.ScaleType = Enum.ScaleType.Fit

-- Create TextLabel for amount
local amountDisplay = Instance.new("TextLabel", frame)
amountDisplay.Size = UDim2.new(0.6, 0, 0.7, 0)
amountDisplay.Position = UDim2.new(0.3, 0, 0.2, 0)
amountDisplay.BackgroundTransparency = 1
amountDisplay.TextColor3 = Color3.new(0, 0, 0)
amountDisplay.TextScaled = true
amountDisplay.Font = Enum.Font.SourceSansBold
amountDisplay.TextStrokeTransparency = 0.5
amountDisplay.Text = originalAmountLabel.Text

-- Function to update the amount
local function updateCurrencyAmount()
    amountDisplay.Text = originalAmountLabel.Text
end

-- Connect to the changed event to update the display when the amount changes
originalAmountLabel.Changed:Connect(updateCurrencyAmount)

-- Initialize the amount display
updateCurrencyAmount()

-- Create the "Close" button (X)
local closeButtonContainer = Instance.new("Frame", frame)
closeButtonContainer.Size = UDim2.new(0.1, 0, 0.5, 0)
closeButtonContainer.Position = UDim2.new(0.9, 0, 0.25, 0)
closeButtonContainer.BackgroundColor3 = Color3.fromRGB(255, 200, 200)
closeButtonContainer.BorderSizePixel = 0
closeButtonContainer.BackgroundTransparency = 0.2

local closeButton = Instance.new("TextButton", closeButtonContainer)
closeButton.Size = UDim2.new(1, 0, 1, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 58, 58)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 36
closeButton.Text = "X"

-- Hover effect for close button
closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)  -- Darker red on hover
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 58, 58)  -- Original color
end)

-- Close button functionality with tween
closeButton.MouseButton1Click:Connect(function()
    local tweenService = game:GetService("TweenService")
    local closeTween = tweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, -0.15, 0.5, -0.1)
    })
    closeTween:Play()
    closeTween.Completed:Wait()  -- Wait for the animation to complete
    currencyUI:Destroy()  -- Close the UI
end)

-- Create the "Open" button
local openButtonContainer = Instance.new("Frame", frame)
openButtonContainer.Size = UDim2.new(0.1, 0, 0.5, 0)
openButtonContainer.Position = UDim2.new(1, -0.1, 0.25, 0)  -- Positioned right beside the close button
openButtonContainer.BackgroundColor3 = Color3.fromRGB(200, 255, 200)
openButtonContainer.BorderSizePixel = 0
openButtonContainer.BackgroundTransparency = 0.2

local openButton = Instance.new("TextButton", openButtonContainer)
openButton.Size = UDim2.new(1, 0, 1, 0)
openButton.BackgroundColor3 = Color3.fromRGB(58, 255, 58)
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.Font = Enum.Font.SourceSansBold
openButton.TextSize = 24
openButton.Text = "Open"

-- Hover effect for open button
openButton.MouseEnter:Connect(function()
    openButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
end)

openButton.MouseLeave:Connect(function()
    openButton.BackgroundColor3 = Color3.fromRGB(58, 255, 58)
end)

-- Open button functionality (opens the Fluent UI window or Fire Hub)
openButton.MouseButton1Click:Connect(function()
    -- Load the Fluent UI library and create the window
    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

    if Fluent then
        -- Create the window
        local Window = Fluent:CreateWindow({
            Title = "Fire Hub",  
            SubTitle = "Testing UI Functionality",
            TabWidth = 160,
            Size = UDim2.fromOffset(580, 460),
            Acrylic = false,
            Theme = "Dark",
        })

        -- Create the "Main" tab
        local Tabs = {}
        Tabs.Main = Window:AddTab({ Title = "Main", Icon = "" })
        
        -- Create the "Stamps Farm" tab
        Tabs.StampsFarm = Window:AddTab({ Title = "Stamps Farm", Icon = "" })

        -- Add the "Stamps Farm" button to the "Stamps Farm" tab
        local stampsButton = Tabs.StampsFarm:AddButton({
            Title = "Stamps Farm",
            TextColor = Color3.fromRGB(0, 255, 0),  -- You can adjust the color
            Font = Enum.Font.SourceSansBold,
            TextSize = 20,
            Callback = function()
                print("Stamps Farm Button Clicked!")
                -- You can add your functionality for Stamps Farm here
            end
        })

        -- Continuous claim feature for stamps
        local isClaiming = false
        local claimButton = Tabs.StampsFarm:AddButton({
            Title = "Claim Stamp",
            TextColor = Color3.fromRGB(255, 165, 0),
            Font = Enum.Font.SourceSansBold,
            TextSize = 20,
            Callback = function()
                isClaiming = not isClaiming
                if isClaiming then
                    claimButton.Text = "Stop Claiming"
                    -- Start continuous claiming loop
                    while isClaiming do
                        print("Claiming stamp...")
                        -- Add the function for claiming the stamp here
                        wait(1)  -- Adjust the speed of claiming (you can change the time here)
                    end
                else
                    claimButton.Text = "Claim Stamp"
                end
            end
        })

        -- Create the "Christmas" tab
        Tabs.Christmas = Window:AddTab({ Title = "Christmas", Icon = "" })

        -- Add the "Coming Soon" label and button to "Christmas" tab
        local christmasLabel = Instance.new("TextLabel")
        christmasLabel.Size = UDim2.new(1, 0, 0.3, 0)
        christmasLabel.Position = UDim2.new(0, 0, 0.3, 0)
        christmasLabel.BackgroundTransparency = 1
        christmasLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        christmasLabel.TextScaled = true
        christmasLabel.Font = Enum.Font.SourceSansBold
        christmasLabel.TextStrokeTransparency = 0.5
        christmasLabel.Text = "Coming Soon"
        christmasLabel.Parent = Tabs.Christmas

        -- "Collect Gingerbread" button
        local collectButton = Tabs.Christmas:AddButton({
            Title = "Collect Gingerbread",
            TextColor = Color3.fromRGB(255, 255, 0),
            Font = Enum.Font.SourceSansBold,
            TextSize = 20,
            Callback = function()
                print("Collect Gingerbread Button Clicked!")
                -- Functionality for collecting gingerbread can go here
            end
        })

        -- Create the "Pet Farm" tab
        Tabs.PetFarm = Window:AddTab({ Title = "Pet Farm", Icon = "" })

        -- "Coming Soon" label for Pet Farm
        local petFarmLabel = Instance.new("TextLabel")
        petFarmLabel.Size = UDim2.new(1, 0, 0.3, 0)
        petFarmLabel.Position = UDim2.new(0, 0, 0.3, 0)
        petFarmLabel.BackgroundTransparency = 1
        petFarmLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        petFarmLabel.TextScaled = true
        petFarmLabel.Font = Enum.Font.SourceSansBold
        petFarmLabel.TextStrokeTransparency = 0.5
        petFarmLabel.Text = "Coming Soon"
        petFarmLabel.Parent = Tabs.PetFarm

        -- Show the window
        Window.Visible = true
    end
end)

-- Function to pop in the UI
local function popInUI()
    frame.Position = UDim2.new(0.5, -0.15, 0.1, 0)
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.Visible = true

    local tweenService = game:GetService("TweenService")
    local popTween = tweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -0.15, 0.05, 0),
        Size = UDim2.new(0.3, 0, 0.15, 0)
    })
    popTween:Play()
end

-- Call the pop-in function to show the UI with animation
popInUI()

-- Draggable functionality
local dragging = false
local dragStart = nil
local startPos = nil
local userInputService = game:GetService("UserInputService")

local function updateInput(input)
    if dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Wait()
        dragging = false
    end
end)

userInputService.InputChanged:Connect(updateInput)

-- Hover effects for the frame
frame.MouseEnter:Connect(function()
    local tweenService = game:GetService("TweenService")
    tweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
        Size = UDim2.new(0.32, 0, 0.17, 0)
    }):Play()
end)

frame.MouseLeave:Connect(function()
    local tweenService = game:GetService("TweenService")
    tweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Size = UDim2.new(0.3, 0, 0.15, 0)
    }):Play()
end)
