local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Helper function to darken Color3 values for text outlines
local function darkenColor(color, factor)
    factor = factor or 0.4 -- Lower values make it darker (0.4 = 40% original brightness)
    return Color3.new(color.R * factor, color.G * factor, color.B * factor)
end

-- Single Shared Overlay UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MasterLMSLyricsOverlay"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 100000 
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui", 10) or CoreGui

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(0.8, 0, 0.047, 0)
-- Shifted 3x label height (0.047 * 3 = 0.141) upwards: 0.85 - 0.141 = 0.709
textLabel.Position = UDim2.new(0.1, 0, 0.709, 0) 
textLabel.BackgroundTransparency = 1
textLabel.TextScaled = true
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.Font = Enum.Font.Highway 
textLabel.Text = ""

-- Text Outline Configuration
textLabel.TextStrokeTransparency = 0 -- Fully visible outline
textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

textLabel.Parent = screenGui

-- Configurations for each theme track
local themeConfigs = {
    ["MetalSonicSolo"] = {
        color = Color3.fromRGB(0, 35, 130),
        timeline = {
            {time = 0.0, text = ""},
            {time = 78.7, text = "3"},
            {time = 79.3, text = "2"},
            {time = 79.9, text = "1"},
            {time = 80.2, text = "sonic dead he watching me"},
            {time = 81.7, text = "every day he clockin' me"},
            {time = 82.8, text = "red alert, armed and dangerous,"},
            {time = 84.7, text = "i keep that blast on me"},
            {time = 85.8, text = "and i ain't lookin for no trouble"},
            {time = 87.4, text = "i'm just lookin out for me"},
            {time = 88.7, text = "cause i done did stuff"},
            {time = 89.7, text = "them badniks ain't talkin' bout rappin' beef"},
            {time = 91.7, text = "boy, i'm talkin tragedies"},
            {time = 93.0, text = "massacres"},
            {time = 93.8, text = "casualties"},
            {time = 94.6, text = "stuff that i can't even remember"},
            {time = 96.1, text = "bet they remember me"},
            {time = 97.2, text = "stuff that happened late in december, i bring that winter heat"},
            {time = 100.2, text = "badniks poppin' the whole october, the real halloween"},
            {time = 103.2, text = ""},
        }
    },
    ["SonicSolo"] = {
        color = Color3.fromRGB(0, 70, 200),
        timeline = {
            {time = 0.0, text = ""},
            {time = 1.8, text = "Standing alone..."},
            {time = 4.8, text = "Standing just out of reach!"},
            {time = 7.1, text = "Foot on the brakes..."},
            {time = 10.2, text = "But I need to go on."},
            {time = 13.4, text = "Day after day, as I fall behind"},
            {time = 15.8, text = "You keep me away from being who I am!"},
            {time = 21.2, text = "No more chains..."},
            {time = 23.0, text = "on..."},
            {time = 24.4, text = "ME!"},
            {time = 26.4, text = ""},
            {time = 54.5, text = "Run around, feet planted on the ground"},	
            {time = 56.8, text = "Yeah baby, feel that rhythm"},
            {time = 58.4, text = "Make it speed of sound"},
            {time = 59.5, text = "So keep it rollin'!"},
            {time = 60.9, text = "Yeah, never slow it down"},
            {time = 62.2, text = "Just keep it real!"},
            {time = 64.2, text = ""},
            {time = 65.5, text = "Upside down"},
            {time = 66.5, text = "These limits are unbound"},
            {time = 67.8, text = "Yeah baby, faker than fake"},
            {time = 69.3, text = "You're for the background"},
            {time = 70.5, text = "So keep it rollin'!"},
            {time = 71.9, text = "You'll never slow me down"},
            {time = 73.3, text = "I am what's real!"},
            {time = 75.3, text = ""},
            {time = 76.5, text = "Hills of fading green..."},
            {time = 80.3, text = "Unravel at the seam!"},
            {time = 84.7, text = "Break..."},
            {time = 86.1, text = "me..."},
            {time = 87.5, text = "FREE!"},
            {time = 89.5, text = ""},
            {time = 90.2, text = "FLY TILL THE END"},
            {time = 91.4, text = "TURN THIS WORLD AROUND"},
            {time = 92.7, text = "I'M RISKING MY LIFE"},
            {time = 94.1, text = "FOR THESE FRIENDS I'VE FOUND"},
            {time = 95.5, text = "HEAR THESE VOICES"},
            {time = 97.1, text = "THAT CALL TO ME"},
            {time = 98.4, text = "TO BREAK AWAY"},
            {time = 99.4, text = "AND TRY TO"},
            {time = 99.8, text = "FIND"},
            {time = 100.3, text = "MY"},
            {time = 100.8, text = "WAY"},
            {time = 101.2, text = "BACK!"},
            {time = 101.7, text = "TO THE HOME THAT YOU TOOK FROM ME"},
            {time = 103.6, text = "I'M EVERYTHING YOU WANT"},
            {time = 105.3, text = "ALL YOU WANT TO BE"},
            {time = 106.4, text = "I WON'T EVER"},
            {time = 108.0, text = "FALL DOWN"},
            {time = 109.5, text = "GIVE ME STRENGTH"},
            {time = 110.4, text = "SO I CAN"},
            {time = 110.9, text = "BREAK"},
            {time = 112.3, text = "FREE!"},
            {time = 114.3, text = ""},
            {time = 136.8, text = "Drag on"},
            {time = 137.9, text = "Keep it going till dawn"},
            {time = 139.1, text = "Escape the city"},
            {time = 140.5, text = "That just keeps me withdrawn"},
            {time = 141.7, text = "Yeah, don't you feel it?"},
            {time = 143.1, text = "Those sins moving through your spine?"},
            {time = 145.1, text = ""},
            {time = 147.8, text = "Hear that sound?"},
            {time = 149.5, text = "Yeah, who cares how many of me there are,"},
            {time = 151.5, text = "I'm the best one around"},
            {time = 152.7, text = "We keep it rollin'!"},
            {time = 154.1, text = "With this new strength I found"},
            {time = 155.6, text = "I am what's real!"},
            {time = 157.6, text = ""},
            {time = 158.8, text = "Hills of fading green..."},
            {time = 162.6, text = "Unravel at the seam!"},
            {time = 167.0, text = "Break..."},
            {time = 168.3, text = "me..."},
            {time = 169.6, text = "FREE!"},
            {time = 171.6, text = ""},
            {time = 172.5, text = "FLY TILL THE END"},
            {time = 173.7, text = "TURN THIS WORLD AROUND"},
            {time = 175.0, text = "I'M RISKING MY LIFE"},
            {time = 176.4, text = "FOR THESE FRIENDS I'VE FOUND"},
            {time = 177.6, text = "HEAR THESE VOICES"},
            {time = 179.4, text = "THAT CALL TO ME"},
            {time = 180.4, text = "TO BREAK AWAY"},
            {time = 181.7, text = "AND TRY TO"},
            {time = 182.1, text = "FIND"},
            {time = 182.6, text = "MY"},
            {time = 183.1, text = "WAY"},
            {time = 183.5, text = "BACK!"},
            {time = 184.0, text = "TO THE HOME THAT YOU TOOK FROM ME"},
            {time = 185.9, text = "I'M EVERYTHING YOU WANT"},
            {time = 187.5, text = "ALL YOU WANT TO BE"},
            {time = 188.5, text = "I WON'T EVER"},
            {time = 190.3, text = "FALL DOWN"},
            {time = 191.6, text = "GIVE ME STRENGTH"},
            {time = 192.5, text = "SO I CAN"},
            {time = 193.0, text = "BREAK"},
            {time = 194.4, text = "FREE!"},
            {time = 196.4, text = ""},
            {time = 219.1, text = "Fly till the end"}, 
            {time = 220.3, text = "Turn this world around"},
            {time = 221.5, text = "I'M RISKING MY LIFE"},
            {time = 223.1, text = "FOR THESE FRIENDS I'VE FOUND"},
            {time = 224.3, text = "HEAR THESE VOICES"},
            {time = 225.8, text = "THAT CALL TO ME"},
            {time = 227.4, text = "TO BREAK AWAY"},
            {time = 228.4, text = "AND TRY TO"},
            {time = 228.8, text = "FIND"},
            {time = 229.3, text = "MY"},
            {time = 229.8, text = "WAY"},
            {time = 230.2, text = "BACK!"},
            {time = 230.7, text = "TO THE HOME THAT YOU TOOK FROM ME"},
            {time = 232.5, text = "I'M EVERYTHING YOU WANT"},
            {time = 234.2, text = "ALL YOU WANT TO BE"},
            {time = 106.4, text = "I WON'T EVER"},
            {time = 108.0, text = "FALL DOWN"},
            {time = 109.5, text = "GIVE ME STRENGTH"},
            {time = 110.4, text = "SO I CAN"},
            {time = 110.9, text = "BREAK"},
            {time = 112.3, text = "FREE!"},
            {time = 114.3, text = ""},
        }
    },
    ["AmySolo"] = {
        color = Color3.fromRGB(255, 105, 180),
        timeline = {
            {time = 0.0, text = ""},
            {time = 5.6, text = "I"},
            {time = 6.8, text = "HEAR"},
            {time = 7.6, text = "YOUR"},
            {time = 8.4, text = "WHISPERS"},
            {time = 9.7, text = "THROUGH THE DARK"},
            {time = 15.2, text = "YOUR HEART OF"},
            {time = 16.6, text = "POI-SON."},
            {time = 18.6, text = ""},
            {time = 119.8, text = "All of these thoughts"},
            {time = 120.8, text = "runnin' through my head"},
            {time = 122.7, text = "Arm on fire,"},
            {time = 123.6, text = "veins burnin' red,"},
            {time = 125.4, text = "Frusturation"},
            {time = 127.1, text = "is gettin' BIGGER"},
            {time = 128.2, text = "BANG,"},
            {time = 128.8, text = "BANG, BANG,"},
            {time = 129.3, text = "BANG, BANG, BANG"},
            {time = 130.0, text = "Pull"},
            {time = 130.1, text = "Pull my"},
            {time = 130.3, text = "Pull my Devil"},
            {time = 130.5, text = "Pull my Devil Trigger"},
            {time = 131.1, text = "All of these voices"},
            {time = 132.0, text = "inside my head"},
            {time = 133.9, text = "Blinding my sight"},
            {time = 134.9, text = "in a courtain of red"},
            {time = 136.7, text = "Frusturation"},
            {time = 138.3, text = "is gettin' BIGGER"},
            {time = 139.5, text = "BANG,"},
            {time = 140.1, text = "BANG, BANG,"},
            {time = 140.6, text = "BANG, BANG, BANG"},
            {time = 141.3, text = "Pull"},
            {time = 141.5, text = "Pull my"},
            {time = 141.7, text = "Pull my Devil"},
            {time = 141.9, text = "Pull my Devil Trigger"},
            {time = 143.9, text = ""},
        }
    }
}

local SoloThemes = ReplicatedStorage:WaitForChild("ClientAssets"):WaitForChild("Sounds"):WaitForChild("mus"):WaitForChild("Game"):WaitForChild("Round"):WaitForChild("SoloTheme")
local currentLine = 0
local isFadingOut = false
local fadeTween = nil

local function fadeOutLyrics()
    if isFadingOut or textLabel.Text == "" then return end
    isFadingOut = true
    
    local tweenInfo = TweenInfo.new(2.0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    fadeTween = TweenService:Create(textLabel, tweenInfo, {TextTransparency = 1, TextStrokeTransparency = 1})
    fadeTween:Play()
    
    fadeTween.Completed:Connect(function()
        if isFadingOut then
            textLabel.Text = ""
            currentLine = 0
        end
    end)
end

local function getActiveTheme()
    local success, descendants = pcall(function() return SoloThemes:GetDescendants() end)
    if not success or not descendants then return nil end
    
    for _, item in ipairs(descendants) do
        if item:IsA("Sound") and item.IsPlaying and themeConfigs[item.Name] then
            return item, themeConfigs[item.Name]
        end
    end
    return nil, nil
end

local function updateLyrics(soundTrack, config)
    local currentTime = soundTrack.TimePosition
    local targetText = ""
    local targetIndex = 0
    
    textLabel.TextColor3 = config.color
    textLabel.TextStrokeColor3 = darkenColor(config.color, 0.35)
    
    for i, lyricData in ipairs(config.timeline) do
        if currentTime >= lyricData.time then
            targetText = lyricData.text
            targetIndex = i
        else
            break
        end
    end
    
    if isFadingOut and targetText ~= "" then
        if fadeTween then fadeTween:Cancel() end
        isFadingOut = false
        textLabel.TextTransparency = 0
        textLabel.TextStrokeTransparency = 0
    end
    
    if isFadingOut then return end
    
    if targetIndex ~= currentLine then
        currentLine = targetIndex
        
        if fadeTween then fadeTween:Cancel() end
        textLabel.TextTransparency = 0
        textLabel.TextStrokeTransparency = 0
        
        if targetText == "" then
            fadeOutLyrics()
        else
            textLabel.Text = targetText
        end
    end
end

-- Cleanup prior active connections
_G.LyricsConnection = _G.LyricsConnection or nil
if _G.LyricsConnection then _G.LyricsConnection:Disconnect() end

_G.LyricsConnection = RunService.Heartbeat:Connect(function()
    local playingTheme, config = getActiveTheme()
    if playingTheme and playingTheme.IsPlaying then
        if playingTheme.TimePosition < 0.5 then
            isFadingOut = false
            textLabel.TextTransparency = 0
            textLabel.TextStrokeTransparency = 0
        end
        updateLyrics(playingTheme, config)
    else
        fadeOutLyrics()
    end
end)
