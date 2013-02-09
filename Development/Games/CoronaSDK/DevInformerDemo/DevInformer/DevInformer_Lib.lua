local DevInformerLib = {}
local DevInformerLib_mt = { __index = DevInformerLib }

function DevInformerLib.New()
	local devLib = {}
	
	devLib.devinfo = nil
	devLib.memCleaner = nil
	
	return setmetatable(devLib, DevInformerLib_mt)
end

function DevInformerLib:Destroy()
	self = nil
end

function DevInformerLib:GetDeviceInfo()
	print("DevInformerLib: Getting Device Info...")
	self.devinfo = {}
	local devinfo = self.devinfo
	
	-- iOS
	devinfo.isSimulator = false
	devinfo.isiDevice = false
	devinfo.isiPhone = false
	devinfo.isiPod = false
	devinfo.isiPhone5 = false
	devinfo.isiPad = false
	devinfo.isTall = false
	devinfo.genLevel = 0
	
	-- Android, Kindle, Nook
	devinfo.isAndroid = false
	devinfo.isGoogle = false
	devinfo.isKindleFire = false
	devinfo.isNook = false
	
	if(system.getInfo("environment") == "simulator")then
		devinfo.isSimulator = true
		-- Here you could simulate other device tweaks
		devinfo.genLevel = 5
	end
	
	-- Device Name or Computer name
	devinfo.name = system.getInfo("name")
	-- iPad, iPhone, iPod touch, etc
	devinfo.model = system.getInfo("model")
	-- "iPhone1,1" = iPhone 1G
	-- "iPhone1,2" = iPhone 3G
	-- "iPhone2,1" = iPhone 3GS
	-- "iPhone3,1" = iPhone 4
	-- "iPhone4,1" = iPhone 4S
	-- "iPhone5,1" = iPhone 5
	-- "iPod1,1" = iPod touch 1st Gen
	-- "iPod2,1" = iPod touch 2nd Gen
	-- "iPod3,1" = iPod touch 3rd Gen
	-- "iPad4,1" = iPod touch 4th Gen
	-- "iPod5,1" = iPod touch 5th Gen
	-- "iPad1,1" = iPad 1st Gen
	-- "iPad2,1" = iPad 2nd Gen
	-- "iPad3,1" = iPad 3rd Gen (HD)
	-- "iPad4,1" = iPad 4th Gen (Lightning)
	devinfo.description = system.getInfo("architectureInfo")
	
	if(not devinfo.isSimulator)then
		local ipod_check = string.sub(devinfo.description, 1, 5)
		local iphone_check = string.sub(devinfo.description, 1, 7)
		if(ipod_check == "iPod2" or ipod_check == "iPad2" or iphone_check == "iPhone2")then
			devinfo.genLevel = 2
		elseif(ipod_check == "iPod3" or ipod_check == "iPad3" or iphone_check == "iPhone3")then
			devinfo.genLevel = 3
		elseif(ipod_check == "iPod4" or ipod_check == "iPad4" or iphone_check == "iPhone4")then
			devinfo.genLevel = 4
		-- Going to go ahead and put the "New iPad" 3rd Gen, 2nd Gen, and iPhone 4S into this category for now
		elseif(ipod_check == "iPod5" or iphone_check == "iPhone5" or iphone_check == "iPhone4")then
			devinfo.genLevel = 5
		end
	end
	
	if (string.sub(devinfo.model, 1, 2) == "iP") then 
		devinfo.isiDevice = true
		if (string.sub(devinfo.model, 1, 4) == "iPad") then
			devinfo.isiPad = true
		else
			if(string.sub(devinfo.description, 1, 4) == "iPod")then
				devinfo.isiPod = true
			else
				devinfo.isiPhone = true
			end
		end 
	else
	   devinfo.isAndroid = true
	   devinfo.isGoogle = true
	 
	   -- The Kindles start with "K", but Corona builds before #976 returned
	   -- "WFJWI" instead of "KFJWI" (will handle both)
	   if (devinfo.model == "Kindle Fire" or devinfo.model == "WFJWI" or string.sub(devinfo.model, 1, 2) == "KF") then
		  devinfo.isKindleFire = true
		  devinfo.isGoogle = false
	   end
	 
	   if((string.sub(devinfo.model, 1 ,4) == "Nook") or (string.sub(devinfo.model, 1, 4) == "BNRV")) then
		  devinfo.isNook = true
		  devinfo.isGoogle = false 
	   end 
	end

	if ( (display.pixelHeight/display.pixelWidth) > 1.5 ) then
	   devinfo.isTall = true
	   if(devinfo.isiDevice)then
			devinfo.isiPhone5 = true
	   end
	end
	
	--if(devinfo.screenW < 961
	devinfo.platform = system.getInfo("platformName")
	devinfo.platformVersion = system.getInfo("platformVersion")
	devinfo.maxTextureSize = system.getInfo("maxTextureSize")
	
	devinfo.screenW = display.contentWidth
	devinfo.screenH = display.contentHeight
	devinfo.screenHW = display.contentWidth / 2
	devinfo.screenHH = display.contentHeight / 2
	devinfo.pixelWidth = display.pixelWidth
	devinfo.pixelHeight = display.pixelHeight
	devinfo.ratio = devinfo.pixelWidth / devinfo.pixelHeight
	devinfo.deviceWidth = (display.contentWidth - (display.screenOriginX * 2)) / display.contentScaleX
	devinfo.deviceHeight = (display.contentHeight - (display.screenOriginY * 2)) / display.contentScaleY
	devinfo.scaleFactor = math.floor(devinfo.deviceWidth / display.contentWidth)
	
	--Reports whats in config.lua
	devinfo.viewableContentWidth = display.viewableContentWidth
	devinfo.viewableContentHeight = display.viewableContentHeight

	--Landscape(4:3 or 0.75)
	devinfo.bgWidth = devinfo.screenW --960
	devinfo.bgHeight = devinfo.screenH --720
	
	devinfo.devLeft = display.screenOriginX
	devinfo.devRight = display.contentWidth - display.screenOriginX
	devinfo.devTop = display.screenOriginY
	devinfo.devBottom =  display.contentHeight - display.screenOriginY
	
	--Landscape(16:9 or 0.56..)
	if(devinfo.ratio < 0.70)then
		--devinfo.bgWidth = 1136
		devinfo.bgHeight = 852
	end
	
	-- Deduce Spec Level
	-- Could use a medium here...
	if((devinfo.isiPhone and devinfo.genLevel > 3) or (devinfo.isiPod and devinfo.genLevel > 3) or (devinfo.isiPad and devinfo.genLevel > 1))then
		devinfo.spec = "High"
	else
		devinfo.spec = "Low"
	end
	
	return self.devinfo
end

function DevInformerLib:PrintDeviceInfo()
	if(not self.devinfo)then
		self:GetDeviceInfo()
	end
	print("DEVICE INFO:")
	for k,v in pairs(self.devinfo) do
		print("  "..tostring(k) .. " : " ..tostring(v))
	end
end

function DevInformerLib:ShowBounds()
	print("DevInformerLib: Showing Bounds...")
	if(not self.devinfo)then
		self:GetDeviceInfo()
	end
	local devinfo = self.devinfo
	
	local UL = display.newCircle(devinfo.devLeft, devinfo.devTop, 4)
	local UR = display.newCircle(devinfo.devRight, devinfo.devTop, 4)
	local LL = display.newCircle(devinfo.devLeft, devinfo.devBottom, 4)
	local LR = display.newCircle(devinfo.devRight, devinfo.devBottom, 4)
	local CC = display.newCircle(devinfo.screenHW, devinfo.screenHH, 4)
end

function DevInformerLib:StartUpMemCleaner(cycleTime, isVerbose)
	print("DevInformerLib: Starting MemCleaner...")
	local gcVerbose = function()
		collectgarbage()
		print("Mem: "..tostring(collectgarbage("count")).."  Tex: "..system.getInfo("textureMemoryUsed") / 1000000)
	end
	
	local gc = function()
		collectgarbage()
	end
	
	if(isVerbose)then
		self.memCleaner = timer.performWithDelay(cycleTime, function() gcVerbose() end, 0)
	else
		self.memCleaner = timer.performWithDelay(cycleTime, function() gc() end, 0)
	end
end

function DevInformerLib:StopMemCleaner(cycleTime, isVerbose)
	print("DevInformerLib: Stopping MemCleaner...")
	if(self.memCleaner)then
		timer.cancel(self.memCleaner)
		self.memCleaner = nil
	end
end

return DevInformerLib