-- after
while wait () do
-- Get the PlayerGui for the local player
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui") -- Use WaitForChild as PlayerGui might not be instantly available

-- Get the DialogApp ScreenGui
local dialogApp = playerGui:WaitForChild("DialogApp") -- WaitForChild is good practice here too

-- Check if the DialogApp was found and is a ScreenGui (optional but recommended)
if dialogApp and dialogApp:IsA("ScreenGui") then
    -- Disable the DialogApp ScreenGui
    dialogApp.Enabled = false

    print("DialogApp ScreenGui disabled.")
else
    warn("DialogApp ScreenGui not found or is not a ScreenGui.")
end

end
