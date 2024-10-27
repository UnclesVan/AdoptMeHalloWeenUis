-- LocalScript in StarterPlayerScripts

-- Function to enable the GUI
local function enableAltCurrencyIndicatorApp()
    local player = game.Players.LocalPlayer
    if player then
        -- Wait for PlayerGui to be available
        local playerGui = player:WaitForChild("PlayerGui")
        
        -- Find the AltCurrencyIndicatorApp GUI
        local altCurrencyGui = playerGui:FindFirstChild("AltCurrencyIndicatorApp")
        if altCurrencyGui then
            -- Enable the GUI
            altCurrencyGui.Enabled = true
            print("AltCurrencyIndicatorApp GUI is now enabled.")
        else
            warn("AltCurrencyIndicatorApp not found in PlayerGui.")
        end
    else
        warn("LocalPlayer is not available.")
    end
end

--LocalScript in StarterPlayerScripts

-- Function to enable the GUI
local function enableAltCurrencyIndicatorApp()
    local player = game.Players.LocalPlayer
    if player then
        -- Wait for PlayerGui to be available
        local playerGui = player:WaitForChild("PlayerGui")
        
        -- Find the AltCurrencyIndicatorApp GUI
        local altCurrencyGui = playerGui:FindFirstChild("AltCurrencyIndicatorApp")
        if altCurrencyGui then
            -- Enable the GUI
            altCurrencyGui.Enabled = true
            print("AltCurrencyIndicatorApp GUI is now enabled.")
        else
            warn("AltCurrencyIndicatorApp not found in PlayerGui.")
        end
    else
        warn("LocalPlayer is not available.")
    end
end


-- Repeatedly enable the GUI
while true do
    enableAltCurrencyIndicatorApp()
    wait(1)  -- Wait for 1 second before the next check
end
