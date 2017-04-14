local DATA_URL = "http://your.url/here"
local RESOLUTION_HORIZONTAL, RESOLUTION_VERTICAL = 60, 30
local REFRESH_TIME = 60
local continueRunning = true -- Turn off for a test run (will exit after one load)

local function netRequest(url)
	local web = require "internet"
	local request = web.request(url) -- Download the feed data
	local data = ""
  
	for chunk in request do -- OC's internet requests are for some reason done in chunks.
		data = data .. chunk
	end
	
	return data:gsub("\r", "") -- Strip out \r
end

local function stringToChars(str)
	chars = {}
	
	str:gsub(".", function(char)
		table.insert(chars, char)
	end)
	
	return chars
end

local function runOnce(feed)
	local component = require "component"
	local term = require "term"
	
	component.gpu.setResolution(RESOLUTION_HORIZONTAL, RESOLUTION_VERTICAL)
	-- Set resolution. For a square screen, the second number must be half the first for some reason
	term.clear() -- Wipe previous text off screen.

	local data = netRequest(feed)
	
	if data == "STOP" then
		continueRunning = false -- Stop on certain message to allow config modifications on running screen setups.
	else
		local chars = stringToChars(data)
		
		for index, char in ipairs(chars) do
			term.write(char, true) -- Print out char array & wrap.
		end
	end
end

function start(feed)
	local runs = 0

	while continueRunning or runs < 1 do -- Program should run at least once.
		runOnce(feed)
		runs = runs + 1
		os.sleep(REFRESH_TIME) -- Wait before redownloading & redrawing everything	
	end
end

start(DATA_URL)
