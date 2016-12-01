--Configuration Options
local hostport = 65051

packet="test 0x01 2442 1 2 3 4 5 6 5 4 3.14252142\n"
packetsent=false

local socket
local connected = false

chk=0
ready=0

function on_sent(sent)
    print("Sent test packet...")
end

function sock_connected(sck, c)
    sck:send(packet, on_sent)
end


--[[Opens a socket and registers callback functions.  The argument is called when the current packet
    has been sent.]]
function initsocket(callback)
    if not socket then
        print("Opening socket...")

        socket = net.createConnection(net.TCP, 0)
        if not socket then
            print("Could not open socket...")
            return
        else

            --immediately send first packet when socket is connected
            socket:on("connection", function(sck, c)
                print("Socket connected...")
                connected = true
                sck:send(packet, function(sck, c)
                    packetsent = true
                    if callback then
                        callback()
                    end
                end)
            end)

            socket:on("reconnection", function(sck, c)
                connected = true
            end)

            socket:on("disconnection", function(sck, c)
                connected = false
            end)

            socket:on("receive", function(sck, c)
                print("Socket received: "..c)
            end)

            socket:connect(hostport, hostip)
        end
    end
end

--[[Sends a packet containing the string in the 'packet' global variable.  Takes a callback argument to
    notify of successful send of a packet.  Returns true if the packet was sent through the socket and
    false if there is an IO error.

    NOTE: Currently sets up the socket every time a packet is sent as this is
    required by the database receiver.
]]
function sendpacket(callback)

    if socket then
        socket:close()
    end
    socket = nil

    packetsent = false

    print("Sending via Wifi: "..packet)

    if not socket then
        initsocket(callback)

        --confirm socket open
        if socket then
            return true
        else
            return false
        end
    end

    --nothing below here runs because the socket is not persistent but this may
    --change in future
    if socket then
        socket:send(packet, function(sck, c)
            packetsent = true
            if callback then
                callback()
            end
        end)

        return true
    else
        print("Could not send packet...")
        return false
    end
end
