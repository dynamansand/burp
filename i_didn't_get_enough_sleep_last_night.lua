local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Helper function to darken Color3 values for text outlines[cite: 2]
local function darkenColor(color, factor)
    factor = factor or 0.35
    return Color3.new(color.R * factor, color.G * factor, color.B * factor)
end

-- Shared Color Constants[cite: 2]
local COLOR_SONIC_BLUE = Color3.fromRGB(0, 70, 200)
local COLOR_KNUCKLES_RED = Color3.fromRGB(220, 20, 20)
local COLOR_TAILS_YELLOW = Color3.fromRGB(255, 255, 0) -- Added Tails color

-- Single Shared Overlay UI[cite: 2]
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MasterLMSLyricsOverlay"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 100000 
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui", 10) or CoreGui

-- Main Active Lyric Label[cite: 2]
local currentLabel = Instance.new("TextLabel")
currentLabel.Name = "CurrentLyric"
currentLabel.Size = UDim2.new(0.8, 0, 0.047, 0)
currentLabel.AnchorPoint = Vector2.new(0.5, 0.5)
currentLabel.Position = UDim2.new(0.5, 0, 0.732, 0) 
currentLabel.BackgroundTransparency = 1
currentLabel.TextScaled = true
currentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
currentLabel.Font = Enum.Font.Highway 
currentLabel.Text = ""
currentLabel.TextStrokeTransparency = 0
currentLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
currentLabel.Parent = screenGui

-- UIScale for BPM pulsation on the main lyric[cite: 2]
local lyricScale = Instance.new("UIScale")
lyricScale.Parent = currentLabel

-- Secondary Shadow/Previous Lyric Label[cite: 2]
local previousLabel = Instance.new("TextLabel")
previousLabel.Name = "PreviousLyric"
previousLabel.Size = UDim2.new(0.8, 0, 0.038, 0)
previousLabel.AnchorPoint = Vector2.new(0.5, 0.5)
previousLabel.Position = UDim2.new(0.5, 0, 0.777, 0) 
previousLabel.BackgroundTransparency = 1
previousLabel.TextScaled = true
previousLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
previousLabel.Font = Enum.Font.Highway 
previousLabel.Text = ""
previousLabel.TextTransparency = 0.55
previousLabel.TextStrokeTransparency = 0.75
previousLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
previousLabel.Parent = screenGui

-- Transparent Audio Visualizer Setup[cite: 2]
local visualizerFrame = Instance.new("Frame")
visualizerFrame.Name = "AudioVisualizer"
visualizerFrame.Size = UDim2.new(0.5, 0, 0.06, 0)
visualizerFrame.Position = UDim2.new(0.25, 0, 0.805, 0)
visualizerFrame.BackgroundTransparency = 1
visualizerFrame.Parent = screenGui

local NUM_BARS = 20
local visualizerBars = {}

for i = 1, NUM_BARS do
    local bar = Instance.new("Frame")
    bar.Name = "Bar_" .. i
    bar.AnchorPoint = Vector2.new(0.5, 1) 
    bar.Position = UDim2.new((i - 0.5) / NUM_BARS, 0, 1, 0)
    bar.Size = UDim2.new((1 / NUM_BARS) - 0.01, 0, 0, 0)
    bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    bar.BackgroundTransparency = 0.8
    bar.BorderSizePixel = 0
    bar.Parent = visualizerFrame
    visualizerBars[i] = bar
end

-- Configurations for each theme track (including BPM)[cite: 2]
local themeConfigs = {
    ["TailsSolo"] = {
        bpm = 95,
        color = COLOR_TAILS_YELLOW,
        timeline = {
            {time = 0.0, text = ""},
            {time = 32.1, text = "The heavy silence buried all the voices that I knew"},
            {time = 37.1, text = "I'm standing in the burning hell, but I still remember you."},
            {time = 42.1, text = "My hands are steady now, but I can't face this on my own"},
            {time = 47.2, text = "I am the only one left standing in the cold unknown..."},
			{time = 50.8, text = "THEY TOOK THE REST OF THEM"},
    		{time = 53.4, text = "BUT THEY CAN'T TAKE MY MIND"},
    		{time = 55.9, text = "AND EVERY PIECE WAS BUILT"},
    		{time = 58.4, text = "TO LEAVE THE FEAR BEHIND"},
    		{time = 61.3, text = "I"},
    		{time = 61.6, text = "I WAS"},
    		{time = 61.9, text = "I WAS MADE"},
    		{time = 62.35, text = "I WAS MADE TO"},
    		{time = 62.9, text = "I WAS MADE TO FALL"},
    		{time = 63.5, text = "BUT"},
    		{time = 63.8, text = "BUT TAUGHT"},
    		{time = 64.2, text = "BUT TAUGHT MY"},
    		{time = 64.4, text = "BUT TAUGHT MYSELF"},
    		{time = 64.9, text = "BUT TAUGHT MYSELF TO"},
    		{time = 65.3, text = "BUT TAUGHT MYSELF TO FLY"},
    		{time = 66.25, text = "AND I WON'T STOP NOW,"},
    		{time = 69.15, text = "I'LL MAKE IT RIGHT!"},
    		{time = 72.15, text = ""},
    		{time = 138.2, text = "The darkness doesn't scare me, and I don't need the light to see"},
    		{time = 143.25, text = "I'm moving through the shadows, and I know you're counting on me"},
    		{time = 148.25, text = "My legs are burning now, but I refuse to slow my pace"},
    		{time = 153.35, text = "I am the only spark still shining in this empty place!"},
    		{time = 156.95, text = "THEY TOOK THE REST OF THEM"},
    		{time = 159.55, text = "BUT THEY CAN'T TAKE MY MIND"},
    		{time = 162.05, text = "AND EVERY PIECE WAS BUILT"},
    		{time = 164.55, text = "TO LEAVE THE FEAR BEHIND"},
    		{time = 167.45, text = "I"},
    		{time = 167.75, text = "I WAS"},
    		{time = 168.05, text = "I WAS MADE"},
    		{time = 168.5, text = "I WAS MADE TO"},
    		{time = 169.05, text = "I WAS MADE TO FALL"},
    		{time = 169.65, text = "BUT"},
    		{time = 169.95, text = "BUT TAUGHT"},
    		{time = 170.35, text = "BUT TAUGHT MY"},
    		{time = 170.55, text = "BUT TAUGHT MYSELF"},
    		{time = 171.05, text = "BUT TAUGHT MYSELF TO"},
    		{time = 171.45, text = "BUT TAUGHT MYSELF TO FLY"},
    		{time = 172.4, text = "AND I WON'T STOP NOW,"},
    		{time = 175.3, text = "I'LL MAKE IT RIGHT!"},
    		{time = 178.3, text = ""}
			
        }
    },
    ["MetalSonicSolo"] = {
        bpm = 84,
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
        bpm = 87,
        color = COLOR_SONIC_BLUE,
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
            {time = 235.2, text = "I WON'T EVER"},
            {time = 236.9, text = "FALL DOWN"},
            {time = 238.3, text = "GIVE ME STRENGTH"},
            {time = 239.2, text = "SO I CAN"},
            {time = 239.7, text = "BREAK"},
            {time = 241.1, text = "FREE!"},
            {time = 243.1, text = ""},
        }
    },
    ["AmySolo"] = {
        bpm = 86,
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
    },
    ["KnucklesSolo"] = {
        bpm = 155,
        color = COLOR_KNUCKLES_RED,
        timeline = {
        	{time = 0.0, text = ""},
            {time = 10.8, text = "COME ON,", color = COLOR_KNUCKLES_RED},
            {time = 11.6, text = "BRING IT!", color = COLOR_KNUCKLES_RED},
            {time = 13.6, text = ""},
            {time = 37.3, text = "Let's go, it's toe to toe", color = COLOR_KNUCKLES_RED},
            {time = 38.5, text = "When you're on my land", color = COLOR_KNUCKLES_RED},
            {time = 39.3, text = "There's somethin' you must know", color = COLOR_KNUCKLES_RED},
            {time = 40.8, text = "Whether real, or faux", color = COLOR_KNUCKLES_RED},
            {time = 41.6, text = "I never choke,", color = COLOR_KNUCKLES_RED},
            {time = 42.4, text = "Because it's just", color = COLOR_KNUCKLES_RED},
            {time = 43.1, text = "my M.O", color = COLOR_KNUCKLES_RED},
            {time = 43.9, text = "I'm throwin' blows", color = COLOR_KNUCKLES_RED},	
            {time = 44.6, text = "while all you do is hesitate", color = COLOR_KNUCKLES_RED},
            {time = 46.3, text = "Defiant, no", color = COLOR_KNUCKLES_RED},
            {time = 47.0, text = "In my plateau", color = COLOR_KNUCKLES_RED},
            {time = 47.9, text = "I'm doin' what is necessary", color = COLOR_KNUCKLES_RED},
            {time = 49.8, text = "AND IF I'VE ENTERED A GAME,", color = COLOR_KNUCKLES_RED},
            {time = 51.5, text = "I AIN'T STAYIN'", color = COLOR_KNUCKLES_RED},
            {time = 52.2, text = "CAUSE I DON'T PLAY, OR JOKE OR CHUCKLE", color = COLOR_KNUCKLES_RED},
            {time = 54.1, text = "KEEP MY FISTS BLAZIN' WITH RAGE", color = COLOR_KNUCKLES_RED},
            {time = 55.9, text = "THROUGH EACH STAGE", color = COLOR_KNUCKLES_RED},
            {time = 56.9, text = "YOU REPHRASE THE FURY", color = COLOR_KNUCKLES_RED},
            {time = 58.4, text = "SO KNOCK KNOCK, IT'S KNUCKLES", color = COLOR_KNUCKLES_RED},
            {time = 59.9, text = "IN NO NEED TO HURRY OR BURN", color = COLOR_KNUCKLES_RED},
            {time = 61.9, text = "WHAT NOW?", color = COLOR_KNUCKLES_RED},
            {time = 62.7, text = "Guess I'm s'possed to", color = COLOR_KNUCKLES_RED},
            {time = 63.5, text = "BEAT DOWN", color = COLOR_KNUCKLES_RED},
            {time = 64.2, text = "Leave you in the", color = COLOR_KNUCKLES_RED},
            {time = 65.0, text = "STREETS, HOW", color = COLOR_KNUCKLES_RED},
            {time = 65.8, text = "Dare you let them", color = COLOR_KNUCKLES_RED},
            {time = 66.6, text = "BLEED, NOW", color = COLOR_KNUCKLES_RED},
            {time = 67.3, text = "SEE HOW", color = COLOR_KNUCKLES_RED},
            {time = 68.1, text = "I'm wiping the floor with ya,", color = COLOR_KNUCKLES_RED},
            {time = 69.9, text = "I'll put you", color = COLOR_KNUCKLES_RED},
            {time = 70.5, text = "STRAIGHT DOWN", color = COLOR_KNUCKLES_RED},
            {time = 71.1, text = "So tell me who's", color = COLOR_KNUCKLES_RED},
            {time = 71.8, text = "WEAK NOW", color = COLOR_KNUCKLES_RED},
            {time = 72.5, text = "Let's see who", color = COLOR_KNUCKLES_RED},
            {time = 73.1, text = "CONCEDES NOW", color = COLOR_KNUCKLES_RED},
            {time = 74.4, text = "WHATCHU THINK I'LL STRUGGLE AND BUCKLE UNDER YOUR ARMAGEDDON?", color = COLOR_KNUCKLES_RED},
            {time = 77.6, text = "I'M ONLY GETTIN' STARTED", color = COLOR_KNUCKLES_RED},
            {time = 78.9, text = "GUARDIN' ANGEL ISLAND", color = COLOR_KNUCKLES_RED},
            {time = 80.0, text = "DEFENDIN' MY HEAVEN", color = COLOR_KNUCKLES_RED},
            {time = 81.3, text = "CRANKED TO ELEVEN", color = COLOR_KNUCKLES_RED},
            {time = 82.2, text = "I'LL NEVER STEP DOWN", color = COLOR_KNUCKLES_RED},
            {time = 83.7, text = "I'LL MAKE SURE THIS WORLD", color = COLOR_KNUCKLES_RED},
            {time = 84.8, text = "KEEPS SPINNIN'", color = COLOR_KNUCKLES_RED},
            {time = 85.5, text = "AND GOES 'ROUND THE BEND", color = COLOR_KNUCKLES_RED},
            {time = 86.45, text = "EVERY NIGHT", color = COLOR_SONIC_BLUE},
            {time = 87.8, text = "WE STAND", color = COLOR_SONIC_BLUE},
            {time = 89.4, text = "HERE REPEATING", color = COLOR_SONIC_BLUE},
            {time = 90.4, text = "REPEATING EVERY MEMORY", color = COLOR_SONIC_BLUE},
            {time = 91.9, text = "WITH EVERY", color = COLOR_SONIC_BLUE},
            {time = 92.8, text = "SLIGHT OF HAND", color = COLOR_SONIC_BLUE},
            {time = 95.65, text = "ALWAYS SEEKING", color = COLOR_SONIC_BLUE},
            {time = 96.6, text = "AND SEARCHING", color = COLOR_SONIC_BLUE},
            {time = 97.2, text = "FOR A BRAND NEW POSSIBILITY", color = COLOR_SONIC_BLUE},
            {time = 99.0, text = "AND ISN'T IT TIRING TO HAVE OUR FIRE EXTINGUISHED AND REIGNITED?", color = COLOR_SONIC_BLUE},
            {time = 103.4, text = "IN THE MILLIONS OF TIMES", color = COLOR_SONIC_BLUE},
            {time = 104.9, text = "RIGHT WHERE WE STAND", color = COLOR_SONIC_BLUE},
            {time = 108.0, text = "ALWAYS HOPING", color = COLOR_SONIC_BLUE},
            {time = 109.0, text = "AND PRAYING", color = COLOR_SONIC_BLUE},
            {time = 109.6, text = "THAT WE'LL FINALLY FIND A WAY TO BE RELEASED", color = COLOR_SONIC_BLUE},
            {time = 111.6, text = ""},
            {time = 125.6, text = "And like I said, you're goin-", color = COLOR_KNUCKLES_RED},
            {time = 126.9, text = "LEFT RIGHT LEFT RIGHT LEFT RIGHT UP", color = COLOR_KNUCKLES_RED},
            {time = 128.5, text = "LEFT RIGHT LEFT RIGHT LEFT RIGHT-", color = COLOR_KNUCKLES_RED},
            {time = 129.6, text = "WHAT?", color = COLOR_KNUCKLES_RED},
            {time = 130.3, text = "You thought I'd put up the gloves,", color = COLOR_KNUCKLES_RED},
            {time = 131.8, text = "And feed your thirst?", color = COLOR_KNUCKLES_RED},
            {time = 132.8, text = "Nah,", color = COLOR_KNUCKLES_RED},
            {time = 132.1, text = "I'll fight for my life, I'll fight for the dead", color = COLOR_KNUCKLES_RED},
            {time = 134.6, text = "I'll give you the worst", color = COLOR_KNUCKLES_RED},
            {time = 135.4, text = "And do it again!", color = COLOR_KNUCKLES_RED},
            {time = 136.1, text = "I'll never stop going,", color = COLOR_KNUCKLES_RED},
            {time = 136.8, text = "That's just who I am", color = COLOR_KNUCKLES_RED},
            {time = 137.7, text = "If anybody got their doubts,", color = COLOR_KNUCKLES_RED},
            {time = 138.8, text = "Just know", color = COLOR_KNUCKLES_RED},
            {time = 139.1, text = "I", color = COLOR_KNUCKLES_RED},
            {time = 139.35, text = "CAN.", color = COLOR_KNUCKLES_RED},
            {time = 140.1, text = ""},
            {time = 140.9, text = "Pin me in a corner, and I'll die", color = COLOR_SONIC_BLUE},
            {time = 143.9, text = "Fighting, and trying", color = COLOR_SONIC_BLUE},
            {time = 145.4, text = "And still", color = COLOR_SONIC_BLUE},
            {time = 147.1, text = "Pit me with the horrors, and they'll cry", color = COLOR_SONIC_BLUE},
            {time = 150.1, text = "Vile and violently", color = COLOR_SONIC_BLUE},
            {time = 153.1, text = "We live inside this moment every night", color = COLOR_SONIC_BLUE},
            {time = 156.3, text = "Tired, and silently", color = COLOR_SONIC_BLUE},
            {time = 159.4, text = "Pleading for a moment of our lives", color = COLOR_SONIC_BLUE},
            {time = 162.55, text = "Back in the good times", color = COLOR_SONIC_BLUE},
            {time = 163.2, text = ""},
            {time = 163.85, text = "EVERY NIGHT", color = COLOR_SONIC_BLUE},
            {time = 165.2, text = "WE STAND", color = COLOR_SONIC_BLUE},
            {time = 166.8, text = "HERE REPEATING", color = COLOR_SONIC_BLUE},
            {time = 167.8, text = "REPEATING EVERY MEMORY", color = COLOR_SONIC_BLUE},
            {time = 169.3, text = "WITH EVERY", color = COLOR_SONIC_BLUE},
            {time = 170.2, text = "SLIGHT OF HAND", color = COLOR_SONIC_BLUE},
            {time = 173.05, text = "ALWAYS SEEKING", color = COLOR_SONIC_BLUE},
            {time = 174.0, text = "AND SEARCHING", color = COLOR_SONIC_BLUE},
            {time = 174.6, text = "FOR A BRAND NEW POSSIBILITY", color = COLOR_SONIC_BLUE},
            {time = 176.4, text = "AND ISN'T IT TIRING TO HAVE OUR FIRE EXTINGUISHED AND REIGNITED?", color = COLOR_SONIC_BLUE},
            {time = 180.8, text = "IN THE MILLIONS OF TIMES", color = COLOR_SONIC_BLUE},
            {time = 182.3, text = "RIGHT WHERE WE STAND", color = COLOR_SONIC_BLUE},
            {time = 185.4, text = "ALWAYS HOPING", color = COLOR_SONIC_BLUE},
            {time = 186.4, text = "AND PRAYING", color = COLOR_SONIC_BLUE},
            {time = 187.0, text = "THAT WE'LL FINALLY FIND A WAY TO BE RELEASED", color = COLOR_SONIC_BLUE},
            {time = 189.0, text = ""},
            {time = 217.95, text = "EVERY NIGHT", color = COLOR_SONIC_BLUE},
            {time = 219.4, text = "WE STAND", color = COLOR_SONIC_BLUE},
            {time = 221.0, text = "HERE REPEATING", color = COLOR_SONIC_BLUE},
            {time = 222.0, text = "REPEATING EVERY MEMORY", color = COLOR_SONIC_BLUE},
            {time = 223.5, text = "WITH EVERY", color = COLOR_SONIC_BLUE},
            {time = 224.4, text = "SLIGHT OF HAND", color = COLOR_SONIC_BLUE},
            {time = 227.25, text = "ALWAYS SEEKING", color = COLOR_SONIC_BLUE},
            {time = 228.2, text = "AND SEARCHING", color = COLOR_SONIC_BLUE},
            {time = 228.8, text = "FOR A BRAND NEW POSSIBILITY", color = COLOR_SONIC_BLUE},
            {time = 230.6, text = "AND ISN'T IT TIRING TO HAVE OUR FIRE EXTINGUISHED AND REIGNITED?", color = COLOR_SONIC_BLUE},
            {time = 235.0, text = "IN THE MILLIONS OF TIMES", color = COLOR_SONIC_BLUE},
            {time = 236.5, text = "RIGHT WHERE WE STAND", color = COLOR_SONIC_BLUE},
            {time = 239.6, text = "ALWAYS HOPING", color = COLOR_SONIC_BLUE},
            {time = 240.6, text = "AND PRAYING", color = COLOR_SONIC_BLUE},
            {time = 241.2, text = "THAT WE'LL FINALLY FIND A WAY TO BE RELEASED", color = COLOR_SONIC_BLUE},
            {time = 244.6, text = "OH!", color = COLOR_SONIC_BLUE},
            {time = 246.6, text = ""},
        }
    }
}

local SoloThemes = ReplicatedStorage:WaitForChild("ClientAssets"):WaitForChild("Sounds"):WaitForChild("mus"):WaitForChild("Game"):WaitForChild("Round"):WaitForChild("SoloTheme")
local currentLine = 0
local isFadingOut = false
local currentFadeTween = nil
local previousFadeTween = nil

local function cancelActiveTweens()
    if currentFadeTween then currentFadeTween:Cancel() currentFadeTween = nil end
    if previousFadeTween then previousFadeTween:Cancel() previousFadeTween = nil end
end

local function fadeOutLyrics()
    if isFadingOut or (currentLabel.Text == "" and previousLabel.Text == "") then return end
    isFadingOut = true
    cancelActiveTweens()
    
    local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    
    currentFadeTween = TweenService:Create(currentLabel, tweenInfo, {TextTransparency = 1, TextStrokeTransparency = 1})
    previousFadeTween = TweenService:Create(previousLabel, tweenInfo, {TextTransparency = 1, TextStrokeTransparency = 1})
    
    currentFadeTween:Play()
    previousFadeTween:Play()
    
    currentFadeTween.Completed:Connect(function(playbackState)
        if playbackState == Enum.PlaybackState.Completed and isFadingOut then
            currentLabel.Text = ""
            previousLabel.Text = ""
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
    local targetColor = config.color
    
    for i, lyricData in ipairs(config.timeline) do
        if currentTime >= lyricData.time then
            targetText = lyricData.text
            targetIndex = i
            if lyricData.color then
                targetColor = lyricData.color
            end
        else
            break
        end
    end
    
    -- 1. BPM Pulse calculation using exponential beat decay[cite: 2]
    local bpm = config.bpm or 100
    local beatInterval = 60 / bpm
    local beatProgress = (currentTime % beatInterval) / beatInterval
    local beatPulse = math.exp(-beatProgress * 7) * 0.15 
    lyricScale.Scale = 1 + beatPulse

    -- 2. Audio Visualizer update with frequency simulation and higher sensitivity[cite: 2]
    local loudness = soundTrack.PlaybackLoudness or 0
    local normalizedLoudness = math.clamp((loudness ^ 1.1) / 250, 0, 1.2)
    
    for i, bar in ipairs(visualizerBars) do
        local barNoise = math.noise(currentTime * 4, i * 0.25) + 0.5 
        local waveFactor = (math.sin(currentTime * 8 + i * 0.5) + 1) * 0.15
        
        local heightMultiplier = (barNoise * 0.85) + waveFactor
        local barHeight = math.clamp(normalizedLoudness * heightMultiplier, 0.02, 1)
        
        bar.Size = UDim2.new((1 / NUM_BARS) - 0.01, 0, barHeight, 0)
        bar.BackgroundColor3 = targetColor
        bar.BackgroundTransparency = math.clamp(0.85 - (barHeight * 0.4), 0.45, 0.85)
    end
    
    -- 3. Line transitions and fading[cite: 2]
    if targetIndex ~= currentLine then
        currentLine = targetIndex
        cancelActiveTweens()
        isFadingOut = false
        
        if targetText == "" then
            fadeOutLyrics()
        else
            -- Shuffle old text up
            if currentLabel.Text ~= "" then
                previousLabel.Text = currentLabel.Text
                previousLabel.TextColor3 = currentLabel.TextColor3
                previousLabel.TextStrokeColor3 = currentLabel.TextStrokeColor3
                previousLabel.TextTransparency = 0.55
                previousLabel.TextStrokeTransparency = 0.75
            else
                previousLabel.Text = ""
            end
            
            -- Set new text
            currentLabel.Text = targetText
            currentLabel.TextColor3 = targetColor
            currentLabel.TextStrokeColor3 = darkenColor(targetColor, 0.35)
            
            -- Prepare for fade in
            currentLabel.TextTransparency = 1
            currentLabel.TextStrokeTransparency = 1
            
            local fadeInInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            currentFadeTween = TweenService:Create(currentLabel, fadeInInfo, {
                TextTransparency = 0,
                TextStrokeTransparency = 0
            })
            currentFadeTween:Play()
        end
    end
end

-- Cleanup prior active connections[cite: 2]
_G.LyricsConnection = _G.LyricsConnection or nil
if _G.LyricsConnection then _G.LyricsConnection:Disconnect() end

_G.LyricsConnection = RunService.Heartbeat:Connect(function()
    local playingTheme, config = getActiveTheme()
    if playingTheme and playingTheme.IsPlaying then
        if playingTheme.TimePosition < 0.5 then
            isFadingOut = false
            currentLabel.Text = ""
            previousLabel.Text = ""
            currentLine = 0
        end
        updateLyrics(playingTheme, config)
    else
        fadeOutLyrics()
        lyricScale.Scale = 1
        for _, bar in ipairs(visualizerBars) do
            bar.Size = UDim2.new(bar.Size.X.Scale, 0, 0, 0)
        end
    end
end)

print("dude")
