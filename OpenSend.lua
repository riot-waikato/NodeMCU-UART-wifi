

--[[Callback function to run when timestamp data is received.]]
function settime(data)
    print("Syncing time...")
    rtctime.set(data, 0)
    sec, usec = rtctime.get()
    print(sec.."."..usec)
    synced=1
    tm = rtctime.epoch2cal(rtctime.get())
    print(string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))
end

synced=0

--[[Create a socket to accept timestamp data]]
function timesync()
    get_ip()
    if hostip ~= nil and synced == 0 then
         print("Getting time...")
         timesock = net.createConnection(net.TCP, 0)
         timesock:on("receive", function(s, data) settime(data) end)
             --wait for connection before sending   	     	     
	 timesock:connect(65053, hostip)
      	 timesock = nil
    end
    collectgarbage()
end
