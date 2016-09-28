--set up all functions
function pad(str, len, char)
    if char == nil then char = ' ' end
    return str .. string.rep(char, len - #str)
end

dofile("OpenSend.lua")
function list() dofile("list.lua") end
function globals() dofile("globals.lua") end

function registerwifi() dofile("connectman.lua") end

function deregisterwifi() 
   tmr.stop(1)
   tmr.stop(0)
end

function connect_send(sck) sck:send("test 0x00 4214 9 8 7 6 5 4 3 2 1.23456789\n") end 

function get_ip() ip, nm, hostip = wifi.sta.getip() end --'172.24.42.1' end --dofile("get_ip.lua") end
function help()
   bak=fileToPrint
   fileToPrint='help.txt'
   printfile(fileToPrint)
   fileToPrint=bak
end

function timerman()
  tmr.register(0, 500, 1, sendman)
  tmr.start(0)
end

function sendman()
   get_ip()
   if hostip == nil then
      print("test")
      sendManagerFlag = nil
      tmr.unregister(0)
      do return end
   else
      sendManagerFlag = 1
      sendtest()
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