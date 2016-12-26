local actuallyRun = true

function start(feed)
  local worldwideEHyperWeb = require "internet"
  local term = require "term"
  local component = require "component"  

  while actuallyRun do
	component.gpu.setResolution(60, 30)
	--That sets the resolution. For a square screen, the second number must be half the first for some reason.
	  term.clear()
    local request = worldwideEHyperWeb.request(feed)
    local data = ""
    
    for chunk in request do
      data = data .. chunk
    end

    if data == "STOP" then
      actually_run = false
    else
      term.write(data, true)
    end
    
    os.sleep(60)
  end
end

--start("YOUR_ADDRESS_HERE") --If launching without using rc.d then uncomment & swap this out for your URL.
