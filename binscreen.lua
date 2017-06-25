local DATA_URL = "http://your.url/here"
local CFG_URL = "http://your.other/url/here"
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

local function runOnce(dataURL, cfgURL)
	local component = require "component"
	local term = require "term"
	local serialization = require "serialization"
	
	component.gpu.setResolution(RESOLUTION_HORIZONTAL, RESOLUTION_VERTICAL)
	-- Set resolution. For a square screen, the second number must be half the first for some reason
	term.clear() -- Wipe previous text off screen.

	local data = netRequest(dataURL)
	local cfg = serialization.unserialize(cfgURL)
	
	if data == "STOP" then
		continueRunning = false -- Stop on certain message to allow config modifications on running screen setups.
	else
		print(data)
	end
end

function start(data, cfg)
	local runs = 0

	while continueRunning or runs < 1 do -- Program should run at least once.
		runOnce(feed)
		runs = runs + 1
		os.sleep(REFRESH_TIME) -- Wait before redownloading & redrawing everything	
	end
end

start(DATA_URL, CFG_URL)
