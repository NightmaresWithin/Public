display.setStatusBar( display.HiddenStatusBar )

local function Main()
	local HUDson_Lib = require("HUDson.HUDson_Lib")
	local HUDson = HUDson_Lib.New()
	local DevInformer_Lib = require("DevInformer.DevInformer_Lib")
	local DevInformer = DevInformer_Lib.New()
	
	local deviceInfo = DevInformer:GetDeviceInfo()
	
	local livesIndicators = {}
	local levelIndicators = {}
	local scoreBoards = {}
	local powerMeters = {}
	local healthMeters = {}
	
	local hudGroup = display.newGroup()
	
	local function CreateHUD()
		local gradBorderColor = graphics.newGradient({5,190,160},{3,32,195})
		local borderColor = {70,130,250,255}
			
		-- ScoreBoard (No Image, No Border)
		local scoreBoardProps = {
			backgroundImage = nil,
			backgroundBorder = nill,
			numberSet = 2,
			width = 180,
			height = 40,
			x = (deviceInfo.devRight * .5) - 90,
			y = deviceInfo.devTop + 5,
			useComma = false,
			numWidth = 22,
			numHeight = 32,
			borderIsGradient = false,
			borderColor1 = nil, --gradBorderColor
			borderSize = 4,
			fillColor1 = {0,0,0,255},
			initialValue = 0,
			pad = true,
			padlen = 8
		}
		scoreBoards[#scoreBoards + 1] = HUDson:NewScoreBoard(hudGroup, scoreBoardProps)

		-- ScoreBoard (Image Background)
		local scoreBoardProps = {
			backgroundImage = "scorebg.png",
			backgroundBorder = 17,
			numberSet = 1,
			width = 200,
			height = 50,
			x = (deviceInfo.devRight * .5) - 100,
			y = deviceInfo.devTop + 55,
			useComma = true,
			numWidth = 22,
			numHeight = 32,
			borderIsGradient = false,
			borderColor1 = nil, --gradBorderColor
			borderSize = nil,
			fillColor1 = {0,0,0,255},
			initialValue = 12438,
			pad = false,
			padlen = nil
		}
		scoreBoards[#scoreBoards + 1] = HUDson:NewScoreBoard(hudGroup, scoreBoardProps)
		
		-- ScoreBoard (Gradient Border)
		local scoreBoardProps = {
			backgroundImage = nil,
			backgroundBorder = 14,
			numberSet = 2,
			width = 190,
			height = 40,
			x = (deviceInfo.devRight * .5) - 95,
			y = deviceInfo.devTop + 125,
			useComma = false,
			numWidth = 22,
			numHeight = 32,
			borderIsGradient = true,
			borderColor1 = gradBorderColor,
			borderSize = 4,
			fillColor1 = {0,0,50,255},
			initialValue = 99,
			suffix = "%",
			pad = false,
			padlen = nil
		}
		scoreBoards[#scoreBoards + 1] = HUDson:NewScoreBoard(hudGroup, scoreBoardProps)
		
		-- Lives Indicator
		local livProps = {
			imagename = "InvaderPlayer1HD.png",
			x = deviceInfo.devLeft + 30,
			y = deviceInfo.devTop + 25,
			width = 31,
			height = 18,
			seperation = 18,
			lives = 6
		}
		livesIndicators[#livesIndicators + 1] = HUDson:NewLivesIndicator(hudGroup, livProps)
		
		-- Level Indicator (Image Version)
		local lvlProps = {
			levelImage = "Level_1.png",
			levelPrefix = "",
			width = 100,
			height = 20,
			x = deviceInfo.devRight - 170,
			y = deviceInfo.devTop + 25,
			level = 6,
			fontname = native.systemFontBold,
			fontcolor = {3,169,32,255},
			fontsize = 30
		}
		levelIndicators[#levelIndicators + 1] = HUDson:NewLevelIndicator(hudGroup, lvlProps)
		
		-- Level Indicator (System Font Version)
		local lvlProps = {
			levelPrefix = "Level: ",
			x = deviceInfo.devRight - 170,
			y = deviceInfo.devTop + 75,
			level = 6,
			fontname = native.systemFontBold,
			fontcolor = {255,255,255,255},
			fontsize = 30
		}
		levelIndicators[#levelIndicators + 1] = HUDson:NewLevelIndicator(hudGroup, lvlProps)
		
		-- Power Meter (Horizontal)
		local powerMeterProps = {
			x = 20,
			y = 60,
			width = 220,
			height = 20,
			orientation = "horizontal",
			totalPower = 200,
			regainSpeed = 500,
			regainAmount = 10,
			casingOuterIsGradient = true,
			casingOuterColor = gradBorderColor,
			casingOuterFlashColor = {255,0,0,255},
			casingInnerIsGradient = false,
			casingInnerColor = {0,0,0,255},
			barColor = {0,230,20,255}
		}
		powerMeters[#powerMeters + 1] = HUDson:NewPowerMeter(hudGroup, powerMeterProps)	
		
		-- Power Meter (Vertical)
		local powerMeterProps = {
			x = deviceInfo.devRight - 220,
			y = 20,
			width = 20,
			height = 140,
			orientation = "vertical",
			totalPower = 200,
			regainSpeed = 300,
			regainAmount = 10,
			casingOuterIsGradient = true,
			casingOuterColor = gradBorderColor,
			casingOuterFlashColor = {0,255,0,255},
			casingInnerIsGradient = false,
			casingInnerColor = {0,0,0,255},
			barColor = {92,0,202,255}
		}
		powerMeters[#powerMeters + 1] = HUDson:NewPowerMeter(hudGroup, powerMeterProps)
		
		-- Health Meter (Horizontal)
		local healthMeterProps = {
			x = 20,
			y = 130,
			width = 220,
			height = 20,
			orientation = "horizontal",
			totalPower = 200,
			regainSpeed = 500,
			regainAmount = 10,
			casingOuterIsGradient = true,
			casingOuterColor = gradBorderColor,
			casingOuterFlashColor = {255,0,0,150},
			casingInnerIsGradient = false,
			casingInnerColor = {0,0,0,255},
			barColor = {190,0,50,255}
		}
		healthMeters[#healthMeters + 1] = HUDson:NewPowerMeter(hudGroup, healthMeterProps)
		
		-- Health Meter (Vertical)
		local healthMeterProps = {
			x = deviceInfo.devRight - 260,
			y = 20,
			width = 20,
			height = 140,
			orientation = "vertical",
			totalPower = 200,
			regainSpeed = 700,
			regainAmount = 10,
			casingOuterIsGradient = true,
			casingOuterColor = gradBorderColor,
			casingOuterFlashColor = {90,5,210,150},
			casingInnerIsGradient = false,
			casingInnerColor = {0,0,0,255},
			barColor = {10,190,255,255}
		}
		healthMeters[#healthMeters + 1] = HUDson:NewPowerMeter(hudGroup, healthMeterProps)
	end
	
	CreateHUD()	
	
	-- ScoreBoard Flasher
	timer.performWithDelay(1200, function()
		scoreBoards[3]:Flash()
	end, 0)
	
	-- ScoreBoard Adder
	timer.performWithDelay(200, function()
		for i=1,2 do
			scoreBoards[i]:AddScore(1)
		end
	end, 0)
	
	-- Level Advancement
	timer.performWithDelay(2000, function()
		for i=1,#levelIndicators do
			levelIndicators[i]:AdvanceLevel()
		end
	end, 0)
	
	-- Life Killer
	timer.performWithDelay(3000, function()
		for i=1,#livesIndicators do
			if(livesIndicators[i].lives > 0)then
				local livesLeft = livesIndicators[i]:RemoveLife()			
			else
				livesIndicators[i].lives = 6
				livesIndicators[i]:Draw()
			end
		end
	end, 0)
	
	-- Power Meter (Horizontal)
	for i=1,#powerMeters do
		powerMeters[i].power = 0
		timer.performWithDelay(powerMeters[i].regainSpeed, function()
			if(powerMeters[i].power == powerMeters[i].totalPower)then
				powerMeters[i]:Pulse()
				powerMeters[i]:SubtractMeter(powerMeters[i].totalPower)
			end
			powerMeters[i]:AddMeter(powerMeters[i].regainAmount)
		end, 0)
	end
	
	-- Health Meter (Horizontal)
	for i=1,#healthMeters do
		healthMeters[i].power = 0
		timer.performWithDelay(healthMeters[i].regainSpeed, function()
			if(healthMeters[i].power == 0)then
				healthMeters[i]:AddMeter(healthMeters[i].totalPower)
			end
			healthMeters[i]:Pulse()
			healthMeters[i]:SubtractMeter(healthMeters[i].regainAmount)
		end, 0)
	end
	
end
Main()
