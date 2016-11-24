local hostport = 65051

packet="test 0x01 2442 1 2 3 4 5 6 5 4 3.14252142\n"
chk=0
ready=0

function on_sent(sent)
    print("Sent test packet...")
end

function sock_connected(sck, c)
    sck:send(packet, on_sent)
end

function sendman()
   get_ip()
   if hostip == nil then
      print("-chk")
      sendManagerFlag = nil
      --tmr.unregister(0)
      do return end
   else
      sendManagerFlag = 1
      if chk == 1 then
      print("+chk")
        --if ready == 1 then
	  sendtest()
	  --ready=0
	--end
      else
        sendpacket()
      end
   end
end

--[[Sends a packet containing the string in the 'packet' global variable.
]]
function sendpacket()
    print("Sending via Wifi: "..packet)
    if wifi.sta.status() == 5 then
        sock = net.createConnection(net.TCP, 0)
        sock:on("connection", function(sck, c)
            sck:send(packet, function(sent)
                print("Packet sent...")
            end)
        end)

	sock:connect(hostport, hostip)

        collectgarbage()
    else
        print("Packet could not be sent. Wifi not ready.")
    end
end
