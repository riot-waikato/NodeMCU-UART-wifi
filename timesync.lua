local timeserver_data
synced=false

--[[Callback function to run when timestamp data is received.  Experience shows that the timestamp may be split into multiple
    packets so this concatenates received data in the timeserver_data variable.  The final packet is terminated with a new-line
    character.]]
function settime(data)

    local dataend = -1	--index that data ends (just for printing)
    local lastpacket = false

    if data:sub(-1) == "\n" then
        dataend = -2
        lastpacket = true
    end
    print("Time server sent: "..data:sub(1, dataend))

    if timeserver_data == nil then
        timeserver_data = data
    -- concatenate data in case this is not the first packet received
    else timeserver_data = timeserver_data..data end

    if lastpacket then
        synced = true

        --set time and print
        rtctime.set(timeserver_data, 0)
        sec, usec = rtctime.get()
        tm = rtctime.epoch2cal(rtctime.get())
        print(string.format("Time synced: %04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))

        --close socket
        print("Closing connection to time server...")
        timesock:close()
        timesock = nil
    end
end

--[[Create a socket to accept timestamp data]]
function timesync()
    if hostip ~= nil and synced == 0 then
         print("Connecting to time server...")
         timesock = net.createConnection(net.TCP, 0)
         timesock:on("receive", function(s, data) settime(data) end)
	 timesock:connect(65053, hostip)
    end
    collectgarbage()
end

