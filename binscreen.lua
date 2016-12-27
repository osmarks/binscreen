local actuallyRun = true

local function netRequest(url)
	local web = require "internet"
	local request = web.request(url) --Download the feed data
	local data = ""
  
	for chunk in request do --OC's internet requests are for some reason done in chunks.
		data = data .. chunk
	end
	
	return data
end

local function stringToChars(str)
	chars = {}
	
	str:gsub(".", function(char)
		table.insert(chars, char) --Insert each char into an array
	end)
	
	return chars
end

local function runOnce(feed)
	local component = require "component"
	local term = require "term"
	--component and term are only necessary here, so require them here.
	
	component.gpu.setResolution(60, 30)
	--Set resolution. For a square screen, the second number must be half the first for some reason
	term.clear() --Wipe previous text off screen.

	local data = netRequest(feed)
	
	if data == "STOP" then
		actuallyRun = false --Stop, so that it's possible to modify configs on already-running screen setups.
	else
		local chars = stringToChars(data)
		
		for index, char in ipairs(chars) do
			term.write(char, true) --Print out char array
		end
	end
end

function start(feed)
	local hasRun = false

	while actuallyRun or not hasRun do
		runOnce(feed)
		hasRun = true
		os.sleep(60) --Wait before redownloading & redrawing everything	
	end
end

start("YOUR_ADDRESS_HERE") --Your URL here, even if using rc for some reason
