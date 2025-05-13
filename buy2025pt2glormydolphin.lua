loadstring(game:HttpGet(('https://raw.githubusercontent.com/UnclesVan/AdoPtMe-/refs/heads/main/dehashwithslashinmiddle')))()

loadstring(game:HttpGet(('https://raw.githubusercontent.com/UnclesVan/AdoptMeHalloWeenUis/refs/heads/main/SocialStoneUIAdoPtMe!')))()

local args = {
    "pets",
    "moon_2025_glormy_dolphin",
    1
}

local event = game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("SocialStonesAPI/AttemptExchange")

while true do
    event:FireServer(unpack(args))
    wait(7) -- Wait for 7 seconds before the next iteration
end
