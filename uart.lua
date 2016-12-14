--Configuration options
wifitimeout = 500 --length of time (ms)
interactive_mode = false

uarttmr = tmr.create() --checks if it is taking too long to send a packet over wifi

ledtmr = tmr.create()

local function turnledoff()
    gpio.write(1, gpio.LOW)
end

--[[If called, a packet could not be transmitted over wifi.]]
local function wifi_timeout()
    print("-")
    gpio.write(1, gpio.HIGH)

    -- turn LED on
    ledtmr:alarm(250, tmr.ALARM_SINGLE, turnledoff)
end

--[[If called, a packet was successfully transmitted over wifi.]]
local function wifi_onsent(socket)
    print("+")
    tmr.unregister(uarttmr)
    gpio.write(1, gpio.HIGH)

    -- turn LED on
    ledtmr:alarm(750, tmr.ALARM_SINGLE, turnledoff)
end

local function set_packet(_str) packet = _str:sub(1, -2).."\n" end

local function set_packet_lux(_str) 
  sec, usec = rtctime.get()
  packet = _str:sub(1, -2).."1"..sec.."\n" --packet structure for lux: 
end

--[[Runs when UART receives data.  Checks packet type and attempts to send data packets via wifi and
    run commands.]]
local function uart_ondata(data)

       print("Received via UART: "..data)
       gpio.write(1, gpio.HIGH)
       ledtmr:alarm(500, tmr.ALARM_SINGLE, turnledoff)

       --check packet type
       if data:sub(1, 3) == "lux" then
           print("Packet is data packet...")

           --packet is from light sensor
           set_packet_lux(data)
           if wifi.sta.status() == 5 and wifi.sta.getrssi() > -75 then

               if not synced then
                   print("WARNING: Time not synced.")
               end

               --start timer in case wifi times out
               if not uarttmr:alarm(wifitimeout, tmr.ALARM_SINGLE, wifi_timeout) then
                   print("Could not start UART timer...")
               end

               if not sendpacket(wifi_onsent) then
                   print("-")
               else
                   print("Sending packet: "..packet)
               end
               --print("+") --notify Arduino that packet was sent
           else
               print("-") --packet could not be sent
           end
       else
           print("Packet is command packet...")
           --packet is command (required to debug interactively)
           cmd = loadstring(data)
           if cmd then
               cmd()
           else
               print("Invalid command...")
           end
       end
       
       collectgarbage()
end


local function inituart() 
   --uncomment to use altarnate UART pins (gpio13/15)
   --uart.alt(1)

   --see if manually configuring uart params helps at all
    print("Initializing UART...")

    local baud_rate
    if interactive_mode then
        baud_rate = 115200 --baud rate that error messages are transmitted in
    else
        baud_rate = 9600 --baud rate that Arduino sensor uses
    end
    uart.setup(0, baud_rate, 8, uart.PARITY_NONE, uart.STOPBITS_1, 0)

    --using "\n" as the terminator is useful for interactive debugging but
    --the Arduino sensor uses a $
    local uart_term = "\n"

    --set callback function when data received
    uart.on("data", uart_term, uart_ondata, 0)

    collectgarbage()
end

inituart()
