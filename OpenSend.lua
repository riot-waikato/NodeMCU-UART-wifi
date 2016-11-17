function sendtest()
   if wifi.sta.status() == 5 then
--      print(node.heap())
      get_ip()
      if hostip ~= nil then
         sock = net.createConnection(net.TCP, 0)
         sock:on("connection", connect_send)
             --wait for connection before sending   	     	     
	 sock:connect(65051, hostip)
      	 sock = nil
      else
         print("ip address is null")
      end
--      print(node.heap())
      collectgarbage()
--      print(node.heap())
   else
      print("wifi not ready")
   end
end

function settime(data)
  rtctime.set(data, 0)
  print(success)
  print(rtctime.get())
  synced=1
end

synced=0

function timesync()
  if wifi.sta.status() == 5 and synced == 0 then
      get_ip()
      if hostip ~= nil and synced == 0 then
         timesock = net.createConnection(net.TCP, 0)
         timesock:on("receive", function(s, data) settime(data) end)
             --wait for connection before sending   	     	     
	 timesock:connect(65053, hostip)
      	 timesock = nil
      end
      collectgarbage()
   end
end