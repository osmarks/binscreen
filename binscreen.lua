local actuallyRun = true

function start(feed)
	local worldwideEHyperWeb = require "internet"
	local term = require "term"
	local component = require "component"  
	--Get necessary libraries.

	while actuallyRun do --To allow dry-runs of the system.
		component.gpu.setResolution(60, 30)
		--That sets the resolution. For a square screen, the second number must be half the first for some reason
		term.clear() --Wipe previous text off screen.
		local request = worldwideEHyperWeb.request(feed) --Download the feed data
		local data = ""
  
		for chunk in request do --OC's internet requests are for some reason done in chunks.
			data = data .. chunk
		end

		if data == "STOP" then
			actuallyRun = false --Stop, so that it's possible to modify configs on already-running screen setups.
		else
			term.write(data, true)
		end
		
		os.sleep(60) --Wait before redownloading everything
	end
end

--start("YOUR_ADDRESS_HERE") --If launching without using rc.d then uncomment & swap this out for your URL.
