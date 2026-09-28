-- Orvyn Hub - Cleaned (no loggers, no S2 branding, no config exfiltration)
-- Rebranded from S2 Hub; all references changed to Phantom

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local player = Players.LocalPlayer

-- Master table
local M = {}

-- ------------------------------------------------------------
-- EARLY CONFIG LOAD (CherryConfig)
-- ------------------------------------------------------------
M.introSoundEnabled = true
M.introSongChoice = 3
M.introGUIEnabled = true
if isfile and isfile("CherryConfig.json") then
	local ok, data = pcall(function() return HS:JSONDecode(readfile("CherryConfig.json")) end)
	if ok and type(data) == "table" then
		if data.introSoundEnabled ~= nil then M.introSoundEnabled = data.introSoundEnabled end
		if data.introSongChoice then M.introSongChoice = data.introSongChoice end
		if data.introGUIEnabled ~= nil then M.introGUIEnabled = data.introGUIEnabled end
	end
end

-- Intro sound
local introSoundInstance = nil
local INTRO_SONGS = {
	[1] = { url = "https://files.catbox.moe/43iq8z.mp3", file = "movee_intro1.mp3" },
	[2] = { url = "https://files.catbox.moe/pg5ir9.mp3", file = "movee_intro2.mp3" },
	[3] = { url = "https://files.catbox.moe/hg5cr4.mp3", file = "movee_intro3.mp3" },
}
if M.introSoundEnabled then
	local song = INTRO_SONGS[M.introSongChoice] or INTRO_SONGS[3]
	local ok, data = pcall(function() return game:HttpGet(song.url) end)
	if ok and data then
		pcall(function() writefile(song.file, data) end)
	end
	introSoundInstance = Instance.new("Sound")
	pcall(function()
		introSoundInstance.SoundId = getcustomasset(song.file)
		introSoundInstance.Volume = 3
		introSoundInstance.Looped = false
		introSoundInstance.Parent = game:GetService("CoreGui")
		introSoundInstance:Play()
	end)
end

-- INTRO GUI
local function playIntroGUI()
	if not M.introGUIEnabled then return end
	local playerGui = player:WaitForChild("PlayerGui")
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "K7Intro"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	local function createText(text, size, yPos)
		local label = Instance.new("TextLabel")
		label.Text = text
		label.TextSize = size
		label.Font = Enum.Font.GothamBold
		label.TextColor3 = Color3.new(1, 1, 1)
		label.TextStrokeColor3 = Color3.new(0, 0, 0)
		label.TextStrokeTransparency = 0.5
		label.BackgroundTransparency = 1
		label.TextTransparency = 1
		label.Size = UDim2.new(0, 0, 0, size)
		label.Position = UDim2.new(0.5, 0, yPos, 0)
		label.AnchorPoint = Vector2.new(0.5, 0.5)
		label.AutomaticSize = Enum.AutomaticSize.XY
		label.Parent = screenGui
		return label
	end

	local title = createText("Phantom Hub", 40, 0.48)
	local line = Instance.new("Frame")
	line.Size = UDim2.new(0, 150, 0, 2)
	line.Position = UDim2.new(0.5, 0, 0.515, 0)
	line.AnchorPoint = Vector2.new(0.5, 0.5)
	line.BackgroundColor3 = Color3.new(1, 1, 1)
	line.BackgroundTransparency = 1
	line.BorderSizePixel = 0
	line.Parent = screenGui
	local subtitle = createText("", 14, 0.55)

	local function fadeIn(object, property)
		local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local goal = {[property] = 0}
		local tween = TweenService:Create(object, tweenInfo, goal)
		tween:Play()
		return tween
	end

	local function fadeOut(object, property)
		local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local goal = {[property] = 1}
		local tween = TweenService:Create(object, tweenInfo, goal)
		tween:Play()
		return tween
	end

	task.wait(0.5)
	fadeIn(title, "TextTransparency")
	task.wait(0.5)
	fadeIn(line, "BackgroundTransparency")
	task.wait(0.3)
	fadeIn(subtitle, "TextTransparency")
	task.wait(2)
	fadeOut(title, "TextTransparency")
	fadeOut(line, "BackgroundTransparency")
	fadeOut(subtitle, "TextTransparency")
	task.wait(0.8)
	screenGui:Destroy()
end

if M.introGUIEnabled then
	playIntroGUI()
end

repeat task.wait() until game:IsLoaded()

-- ============================================================
-- THEME COLORS (Blue Accent)
-- ============================================================
local BLUE = Color3.fromRGB(30, 144, 255)
local DARK_BLUE = Color3.fromRGB(0, 50, 150)
local CHERRY_ACCENT = BLUE

-- ============================================================
-- SKY THEME (unchanged)
-- ============================================================
M.CANDY_SKY_TAG = "MoveeSkyTheme"
M.currentSkyTheme = "Night"
M.CANDY_SKY_PRESETS = {
	["Off"]={kind="off"},
	["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
	["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
	["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
	["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
	["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
	["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
	["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
	["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
	["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
	["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
	["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
	["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
	["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.55,dens=0.55,color={200,150,255}}},
	["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
	["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
	["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
	["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
	["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
	["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
	["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
	["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
	["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
	["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}
M.SkyOrder = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}

local function candyColor(rgb) return Color3.fromRGB(rgb[1],rgb[2],rgb[3]) end
function M.CandyApplyCustomSky(mode)
	for _,child in ipairs(Lighting:GetChildren()) do if child:GetAttribute(M.CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end
	local terrain=workspace:FindFirstChildOfClass("Terrain")
	if terrain then for _,child in ipairs(terrain:GetChildren()) do if child:GetAttribute(M.CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end end
	local preset=M.CANDY_SKY_PRESETS[mode]
	if not preset or preset.kind=="off" then Lighting.ClockTime=14;Lighting.Brightness=2;Lighting.OutdoorAmbient=Color3.fromRGB(127,127,127);Lighting.Ambient=Color3.fromRGB(127,127,127);Lighting.FogEnd=100000;Lighting.GlobalShadows=true;return end
	Lighting.FogStart=0;Lighting.FogEnd=100000;Lighting.FogColor=Color3.fromRGB(200,200,200);Lighting.ColorShift_Top=Color3.fromRGB(0,0,0);Lighting.ColorShift_Bottom=Color3.fromRGB(0,0,0);Lighting.GlobalShadows=true
	Lighting.ClockTime=preset.clock or 14;Lighting.Brightness=preset.brightness or 2
	if preset.outAmb then Lighting.OutdoorAmbient=candyColor(preset.outAmb) end
	if preset.ambient then Lighting.Ambient=candyColor(preset.ambient) end
	if preset.sky then
		local skyInst=Instance.new("Sky");skyInst:SetAttribute(M.CANDY_SKY_TAG,true)
		if preset.sky.stars then skyInst.StarCount=preset.sky.stars end
		if preset.sky.moon then skyInst.MoonAngularSize=preset.sky.moon end
		if preset.sky.sun then skyInst.SunAngularSize=preset.sky.sun end
		if preset.sky.moonTex then skyInst.MoonTextureId="rbxasset://sky/moon.jpg" end
		skyInst.Parent=Lighting
	end
	if preset.atm then
		local atm=Instance.new("Atmosphere");atm:SetAttribute(M.CANDY_SKY_TAG,true)
		atm.Density=preset.atm.dens or 0.3;atm.Color=candyColor(preset.atm.color);atm.Decay=candyColor(preset.atm.decay);atm.Glare=preset.atm.glare or 1;atm.Haze=preset.atm.haze or 1;atm.Parent=Lighting
	end
	if preset.clouds and terrain then
		local clouds=Instance.new("Clouds");clouds:SetAttribute(M.CANDY_SKY_TAG,true)
		clouds.Cover=preset.clouds.cover or 0.5;clouds.Density=preset.clouds.dens or 0.5;clouds.Color=candyColor(preset.clouds.color);clouds.Parent=terrain
	end
end

-- ============================================================
-- ANIMATION PACKS
-- ============================================================
M.PACKS = {
	["Adidas Sports"] = {
		WalkAnim = 18537392113,
		RunAnim  = 18537384940,
		JumpAnim = 18537380791,
		FallAnim = 18537367238,
		SwimIdle = 18537387180,
		Swim     = 18537389531,
		Animation1 = 18537376492,
		Animation2 = 18537371272,
		ClimbAnim = 18537363391,
	},
	["Adidas Community"] = {
		WalkAnim = 122150855457006,
		RunAnim  = 82598234841035,
		JumpAnim = 75290611992385,
		FallAnim = 98600215928904,
		SwimIdle = 109346520324160,
		Swim     = 133308483266208,
		Animation1 = 122257458498464,
		Animation2 = 102357151005774,
		ClimbAnim = 88763136693023,
	},
	["Adidas Aura"] = {
		WalkAnim = 83842218823011,
		RunAnim  = 118320322718866,
		JumpAnim = 109996626521204,
		FallAnim = 95603166884636,
		SwimIdle = 94922130551805,
		Swim     = 134530128383903,
		Animation1 = 110211186840347,
		Animation2 = 114191137265065,
		ClimbAnim = 97824616490448,
	},
	["Wicked Popular"] = {
		WalkAnim = 92072849924640,
		RunAnim = 72301599441680,
		JumpAnim = 104325245285198,
		FallAnim = 121152442762481,
		Animation1 = 118832222982049,
		ClimbAnim = 131326830509784,
		SwimIdle = 113199415118199,
		Swim = 99384245425157,
		Animation2 = 76049494037641,
	},
	Elder = {
		WalkAnim = 10921111375,
		RunAnim  = 10921104374,
		JumpAnim = 10921107367,
		FallAnim = 10921105765,
		SwimIdle = 10921110146,
		Swim     = 10921108971,
		ClimbAnim = 10921100400,
		Animation1 = 10921101664,
		Animation2 = 10921102574,
	},
	Zombie = {
		WalkAnim = 10921355261,
		RunAnim  = 616163682,
		JumpAnim = 10921351278,
		FallAnim = 10921350320,
		SwimIdle = 10921353442,
		Swim     = 10921352344,
		Animation1 = 10921344533,
		Animation2 = 10921345304,
		ClimbAnim = 10921343576,
	},
	Mage = {
		WalkAnim = 10921152678,
		RunAnim  = 10921148209,
		JumpAnim = 10921149743,
		FallAnim = 10921148939,
		SwimIdle = 10921151661,
		Swim     = 10921150788,
		ClimbAnim = 10921143404,
		Animation1 = 10921144709,
		Animation2 = 10921145797,
	},
	["Catwalk Glam"] = {
		WalkAnim = 109168724482748,
		RunAnim  = 81024476153754,
		JumpAnim = 116936326516985,
		FallAnim = 92294537340807,
		SwimIdle = 98854111361360,
		Swim     = 134591743181628,
		ClimbAnim = 119377220967554,
		Animation1 = 133806214992291,
		Animation2 = 94970088341563,
	},
	Astronaut = {
		WalkAnim = 10921046031,
		RunAnim  = 10921039308,
		JumpAnim = 10921042494,
		FallAnim = 10921040576,
		SwimIdle = 10921045006,
		Swim     = 10921044000,
		ClimbAnim = 10921032124,
		Animation1 = 10921034824,
		Animation2 = 10921036806,
	},
	['Wicked "Dancing Through Life"'] = {
		WalkAnim = 73718308412641,
		RunAnim  = 135515454877967,
		JumpAnim = 78508480717326,
		FallAnim = 78147885297412,
		SwimIdle = 129183123083281,
		Swim     = 110657013921774,
		ClimbAnim = 129447497744818,
		Animation1 = 92849173543269,
		Animation2 = 132238900951109,
	},
	Werewolf = {
		WalkAnim = 10921342074,
		RunAnim  = 10921336997,
		JumpAnim = nil,
		FallAnim = 10921337907,
		SwimIdle = 10921341319,
		Swim     = 10921340419,
		ClimbAnim = 10921329322,
		Animation1 = 10921330408,
		Animation2 = 10921333667,
	},
	Superhero = {
		WalkAnim = 10921298616,
		RunAnim  = 10921291831,
		JumpAnim = 10921294559,
		FallAnim = 10921293373,
		SwimIdle = 10921297391,
		Swim     = 10921295495,
		ClimbAnim = 10921286911,
		Animation1 = 10921288909,
		Animation2 = 10921290167,
	},
	Toy = {
		WalkAnim = 10921312010,
		RunAnim  = 10921306285,
		JumpAnim = 10921308158,
		FallAnim = 10921307241,
		SwimIdle = 10921310341,
		Swim     = 10921309319,
		ClimbAnim = 10921300839,
		Animation1 = 10921301576,
		Animation2 = nil,
	},
	["No Boundaries"] = {
		WalkAnim = 18747074203,
		RunAnim  = 18747070484,
		JumpAnim = 18747069148,
		FallAnim = 18747062535,
		SwimIdle = 18747071682,
		Swim     = 18747073181,
		ClimbAnim = 18747060903,
		Animation1 = 18747067405,
		Animation2 = 18747063918,
	},
	NFL = {
		WalkAnim = 110358958299415,
		RunAnim  = 117333533048078,
		JumpAnim = 119846112151352,
		FallAnim = 129773241321032,
		SwimIdle = 79090109939093,
		Swim     = 132697394189921,
		ClimbAnim = 134630013742019,
		Animation1 = 92080889861410,
		Animation2 = 74451233229259,
	},
	["Amazon Unboxed"] = {
		WalkAnim = 90478085024465,
		RunAnim  = 134824450619865,
		JumpAnim = 121454505477205,
		FallAnim = 94788218468396,
		SwimIdle = 129126268464847,
		Swim     = 105962919001086,
		ClimbAnim = 121145883950231,
		Animation1 = 98281136301627,
		Animation2 = nil,
	},
	Vampire = {
		WalkAnim = 10921326949,
		RunAnim  = 10921320299,
		JumpAnim = 10921322186,
		FallAnim = 10921321317,
		SwimIdle = 10921325443,
		Swim     = 10921324408,
		ClimbAnim = 10921314188,
		Animation1 = 10921315373,
		Animation2 = nil,
	},
	Ninja = {
		Run=656118852, Walk=656121766, Jump=656117878, Fall=656115606,
		Swim=656119721, SwimIdle=656121397, Climb=656114359,
		Idle={656117400,656118341,886742569}
	},
	Robot = {
		Run=616091570, Walk=616095330, Jump=616090535, Fall=616087089,
		Swim=616092998, SwimIdle=616094091, Climb=616086039,
		Idle={616088211,616089559,885531463}
	},
	Levitation = {
		Run=616010382, Walk=616013216, Jump=616008936, Fall=616005863,
		Swim=616011509, SwimIdle=616012453, Climb=616003713,
		Idle={616006778,616008087,886862142}
	},
	Stylish = {
		Run=616140816, Walk=616146177, Jump=616139451, Fall=616134815,
		Swim=616143378, SwimIdle=616144772, Climb=616133594,
		Idle={616136790,616138447,886888594}
	},
	Bubbly = {
		Run=910025107, Walk=910034870, Jump=910016857, Fall=910001910,
		Swim=910028158, SwimIdle=910030921, Climb=909997997,
		Idle={910004836,910009958,1018536639}
	},
	Cartoon = {
		Run=742638842, Walk=742640026, Jump=742637942, Fall=742637151,
		Swim=742639220, SwimIdle=742639812, Climb=742636889,
		Idle={742637544,742638445,885477856}
	},
}
M.animPack = "Adidas Sports"
M.animPackEnabled = true
M.savedAnimate = nil

-- ============================================================
-- CHARTER FEATURES (Headless & Korblox)
-- ============================================================
M.headlessEnabled = false
M.korbloxEnabled = false

local HEADLESS_MESH_ID = "rbxassetid://1095708"
local KORBLOX_MESH_ID = "rbxassetid://1095708"