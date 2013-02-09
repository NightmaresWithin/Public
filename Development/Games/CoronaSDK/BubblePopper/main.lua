-- 2013 Nightmares Within
-- http://www.nightmareswithin.com
-- @NightmaresWithn
-- http://www.facebook.com/NightmaresWithin
-- You are free to Distribute, just keep my header :)
-- ==================================================
display.setStatusBar( display.HiddenStatusBar )

physics = require("physics")

local function BubblePopper()
	physics.start()
	physics.setGravity(0, 1)
	
	local screenW = display.contentWidth
	local screenH = display.contentHeight
	local screenHW = screenW *.5
	local screenHH = screenH *.5
	local Random = math.random

	-- Require our Bubble Maker
	local bubbleMaker_Lib = require("BubbleMaker_Lib")
	bubbleMaker = nil
	
	-- Make some groups
	local levelGroup = display.newGroup()
	local backgroundGroup = display.newGroup()
	local hudGroup = display.newGroup()
	local groundGroup = display.newGroup()
	local bubbleGroup = display.newGroup()
	levelGroup:insert(backgroundGroup)
	levelGroup:insert(hudGroup)
	levelGroup:insert(groundGroup)
	levelGroup:insert(bubbleGroup)
	
	local popCounter = 0
	local blowerSpeed = 80
	local blowerPauseTime = 6000
	local blowerBubbleCount = 15
	local gameOverText = nil
	local StartGame = nil
	
	-- Make a background gradient
	local function MakeBackground()
		local grad = graphics.newGradient({ 10, 180, 180 },{ 10, 140, 150 }, "down" )
		local background = display.newRect(hudGroup, 0, 0, screenW, screenH)
		background:setFillColor(grad)
	end
	MakeBackground()
	
	-- A quick pop counter
	local bubbleCounter = display.newText(hudGroup, popCounter, 20, 20, native.systemFont, 30)
	
	local function AdvancePopCounter()
		popCounter = popCounter + 1
		bubbleCounter.text = popCounter
	end
	
	local function RestartHandler(event)
		if(event.phase == "began")then
			gameOverText:removeEventListener("touch", gameOverText)
			display.remove(gameOverText)
			gameOverText = nil
			popCounter = 0
			bubbleCounter.text = popCounter
			StartGame()
		end	
		return true
	end
	
	local function GameOver()
		bubbleMaker:StopBlower()
		
		gameOverText = display.newText(hudGroup, "Game Over", 0, 0, native.systemFontBold, 40)
		gameOverText:setReferencePoint(display.CenterReferencePoint)
		gameOverText.x = screenHW
		gameOverText.y = screenHH
		gameOverText:addEventListener("touch", RestartHandler)
		
	end
	
	--Simple, re-usable function to create physics boundaries on your device
	local function MakeCollisionBounds()
		local tRectTop = display.newRect(groundGroup, 0, 0, screenW, 10)
		physics.addBody(tRectTop, "static", {density = 1.0, friction = 1.0})
		local tRectBottom = display.newRect(groundGroup, 0, screenH - 10, screenW, 10)
		physics.addBody(tRectBottom,  "static", {density = 1.0, friction = 1.0})
		tRectBottom.name = "ground"
		local tRectLeft = display.newRect(groundGroup, 0, 0, 10, screenH)
		physics.addBody(tRectLeft, "static", {density = 1.0, friction = 1.0})
		local tRectRight = display.newRect(groundGroup, screenW - 10, 0, 10, screenH)
		physics.addBody(tRectRight, "static", {density = 1.0, friction = 1.0})
		tRectTop.alpha = 0
		tRectTop.isHitTestable = true
		tRectBottom.alpha = 0
		tRectBottom.isHitTestable = true
		tRectLeft.alpha = 0
		tRectLeft.isHitTestable = true
		tRectRight.alpha = 0
		tRectRight.isHitTestable = true		
	end
	MakeCollisionBounds()
	
	local function MakeGrass()
		local grass = display.newImageRect(groundGroup, "Grass.png", screenW, 80)
		physics.addBody(grass, "static", {density = 1.0, friction = 1.0})
		grass:setReferencePoint(display.BottomLeftReferencePoint)
		grass.x = 0
		grass.y = screenH
		grass.name = "grass"
	end
	MakeGrass()
	
	StartGame = function()
		bubbleMaker = bubbleMaker_Lib.New(bubbleGroup, AdvancePopCounter, GameOver)
		bubbleMaker:MakeBlower(screenHW, 100, blowerBubbleCount, blowerSpeed, blowerPauseTime)
		bubbleMaker:StartBlower()
	end
	StartGame()
	
end

BubblePopper()