-- Load the UI Library
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/VisualRoblox/Roblox/main/UI-Libraries/Visual%20Command%20UI%20Library/Source.lua', true))()

local Window = Library:CreateWindow({
    Name = 'Disorder',
    IntroText = 'A Light Appears',
    IntroIcon = 'rbxassetid://10618644218',
    IntroBlur = true,
    IntroBlurIntensity = 15,
    Theme = Library.Themes.dark,
    Position = 'bottom',
    Draggable = true,
    Prefix = ';'
})

local Tab = Window:AddTab('Disorder')
local CreditsTab = Window:AddTab('Credits')

local Username1, Username2 = '', ''
local remote = Instance.new("RemoteEvent", game.ReplicatedStorage)
remote.Name = "PlayAnimationEvent"

-- Safe execution wrapper
local function safeExecution(func, ...)
    local success, err = pcall(func, ...)
    if not success then
        warn('Error during execution: ' .. err)
        Library:Notify("Execution Error", err)
    end
end

-- Check if the game is Filtering Enabled
local function checkFE()
    return game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") ~= nil
end

-- Notify about FE status
local function notifyFEStatus()
    if checkFE() then
        Library:Notify("Game is FE Compliant", "This script will work properly in this game.")
        return true
    else
        Library:Notify("Game is Not FE Compliant", "This script will NOT work in this game.")
        return false
    end
end

-- Function to safely set animation
local function setAnimation(player)
    safeExecution(function()
        local character = player.Character or player.CharacterAdded:Wait()
        if character and character:FindFirstChild("Humanoid") then
            local anim = Instance.new('Animation')
            anim.AnimationId = 'rbxassetid://148840371'
            local animationTrack = character.Humanoid:LoadAnimation(anim)
            animationTrack:Play()
        else
            error("Humanoid not found or character does not exist.")
        end
    end)
end

-- Notify all players
local function broadcastMessage(message)
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player and player:FindFirstChild("PlayerGui") then
            player:SendNotification({
                Title = "Broadcast",
                Text = message,
                Duration = 5
            })
        end
    end
end

-- Wait for the game to fully load
local function waitForGameLoad()
    repeat wait() until game:IsLoaded()
end

-- Execute on script start
waitForGameLoad()
if not notifyFEStatus() then return end

-- Input fields for usernames
Tab:AddTextBox('Your Username', function(value)
    Username1 = value
end)

Tab:AddTextBox('Other Username', function(value)
    Username2 = value
end)

-- Button to play animation
Tab:AddButton('Play Animation', function()
    if Username1 == '' then
        Library:Notify("Error", "Please enter your username.")
        return
    end
    
    local player = game.Players:FindFirstChild(Username1)
    if player then
        remote:FireServer(player)
        broadcastMessage(Username1 .. " is playing an animation!")
    else
        Library:Notify("Error", 'Player not found: ' .. Username1)
    end
end)

-- Button to notify action
Tab:AddButton('Notify Action', function()
    if Username2 == '' then
        Library:Notify("Error", "Please enter the other username.")
        return
    end
    
    local player = game.Players:FindFirstChild(Username2)
    if player then
        broadcastMessage(Username2 .. " has been notified!")
    else
        Library:Notify("Error", 'Player not found: ' .. Username2)
    end
end)

-- Server-side event connection
remote.OnServerEvent:Connect(function(player)
    safeExecution(function()
        setAnimation(player)
    end)
end)

-- Add credits to the credits tab
CreditsTab:AddLabel("SCRIPT MADE BY AUTI4SM")
CreditsTab:AddLabel("DISCORD: AUTI4SM")

-- End of the script
