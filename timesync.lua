local timeserver_data
local timeout = 10000
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
    else
        timeserver_data = timeserver_data..data
    end

    if lastpacket then
        synced = true
        tmr.unregister(wifitmr) --we're done with the timer TODO:Doesn't work. Timer continues.

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

--[[Callback that runs when the connection to the time server is taking too long to establish or packets have
    not arrived in a reasonable period of time (defined in the timeout variable).  Closes the socket and attempts
    to re-establish a connection with the time server on the current host.]]
function timesync_timeout()
    print("Connection to time server timed out...")
    if not timesock == nil then
        timesock:close()
    else
        timesock = net.createConnection(net.TCP, 0)
    end

    connecttotimeserver(timesock)
end

--[[Starts the wifi timer to check if the time server is responding in a reasonable period of time.  If the timer is
    already running, it is reset.]]
function startwifitmr()
    --print("Starting wifi timer...")
    running, mode = tmr.state(wifitmr)
    if running then
        tmr.unregister(wifitmr)
    end
    if not tmr.alarm(wifitmr, timeout, tmr.ALARM_SINGLE, timesync_timeout) then print("Could not start wifi timer...") end
end

--[[Connects the given socket to the time server and registers callback functions when the socket connects or receives
    data.]]
function connecttotimeserver(socket)
    if wifi.sta.status() == 5 and synced == false then
        print("Connecting to time server...")
        timesock:on("receive", function(s, data)
        settime(data)
        startwifitmr()
        end)
        timesock:on("connection", function(s)
        print("Connected to time server...")
        startwifitmr()
        end)
        timesock:connect(65053, hostip)
        startwifitmr()
    else
        --will have to wait until connected
        print("Cannot connect to time server...")
    end
end

--[[Starts the time syncing process by creating the socket and starting connection to the time server.]]
function timesync()
    if not synced then
        print("Starting time sync...")
        timesock = net.createConnection(net.TCP, 0)
        connecttotimeserver(timesock)
        collectgarbage()
    end
end
