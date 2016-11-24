function registeruart() 
   --uncomment to use altarnate UART pins (gpio13/15)
   --uart.alt(1)

   --see if manually configuring uart params helps at all
    print("Initializing UART...")
    uart.setup(0, 115200, 8, uart.PARITY_NONE, uart.STOPBITS_1, 0)

    uart_slave()
end

function set_packet(_str) packet = _str:sub(1, -2).."\n" end
function set_packet_lux(_str) 
  sec, usec = rtctime.get()
  packet = _str:sub(1, -2).."1"..sec.."\n" --packet structure for lux: 
end

function uart_slave()
   chk=1
   uart.on("data", "\n",
     function(data)
       print("Received via UART: "..data)
       cmd = loadstring(data)
       cmd()
       set_packet_lux(data)
       sendpacket()
       --check if wifi connected
       if synced == 0 then
            print("WARNING: Time not synced.")
       end

       
       collectgarbage()
   end, 0)
end

registeruart()
