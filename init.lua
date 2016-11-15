function pad(str, len, char)
    if char == nil then char = ' ' end
    return str .. string.rep(char, len - #str)
end

dofile("OpenSend.lua")
function list() dofile("list.lua") end
function globals() dofile("globals.lua") end

function registerwifi() dofile("connectman.lua") end
function registeruart() 
   --uncomment to use altarnate UART pins (gpio13/15)
   --uart.alt(1)

   --see if manually configuring uart params helps at all
   uart.setup(0, 9600, 8, uart.PARITY_NONE, uart.STOPBITS_1, 0)

   registerwifi()
   uart_slave()
end
function deregisterwifi() 
   tmr.stop(1)
   tmr.stop(0)
end

function set_packet(_str) packet = _str:sub(1, -2).."\n" end
packet="test 0x01 2442 1 2 3 4 5 6 5 4 3.14252142\n"
function connect_send(sck) sck:send(packet) end 
chk=0
ready=1
function get_ip() ip, nm, hostip = wifi.sta.getip() end --'172.24.42.1' end --dofile("get_ip.lua") end

function help()
   bak=fileToPrint
   fileToPrint='help.txt'
   printfile(fileToPrint)
   fileToPrint=bak
end

function uart_slave()
   chk=1
   uart.on("data", "$",
     function(data)       
       set_packet(data)
       --check if wifi connected
       if wifi.sta.status() == 5 then --have ip, connected
         print("+")
       else
	 print("-")
       end
       ready=1
       collectgarbage()  
   end, 0)
end

function timerman()
  tmr.register(0, 500, 1, sendman)
  tmr.start(0)
end

function sendman()
   get_ip()
   if hostip == nil then
      --print("-chk")
      sendManagerFlag = nil
      tmr.unregister(0)
      do return end
   else
      sendManagerFlag = 1
      if chk == 1 then
      --print("+chk")
        if ready == 1 then
	  sendtest()
	  ready=0
	end
      else
        sendtest()
      end
   end
end

function printfile(str)
    if str ~= nil then fileToPrint = str end
    dofile("printfile.lua")
end

wific='wific'
wifiwifi='wifiwifi'
function connectWifi() dofile("connect.lua") end

--produce standard output
print("\n--> Files contained:")
list()
printfile()

print()

connectWifi()
registeruart()