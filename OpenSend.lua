function sendtest()
   if wifi.sta.status() == 5 then
      print(node.heap())
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
      print(node.heap())
      collectgarbage()
      print(node.heap())
   else
      print("wifi not ready")
   end
end