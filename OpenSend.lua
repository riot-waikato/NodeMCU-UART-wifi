get_ip()
sock = net.createConnection(net.TCP, 0)
--sock:on("recieve", function(sck, data) print("recieved: " .. data) end)
sock:on("connection", function(sck)
   --wait for connection before sending
   sock:send("test 0x00 4214 9 8 7 6 5 4 3 2 1.23456789\n")
end)

sock:connect(65051, hostip)