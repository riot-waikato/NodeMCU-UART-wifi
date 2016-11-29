function pad(str, len, char)
    if char == nil then char = ' ' end
    return str .. string.rep(char, len - #str)
end

function list() dofile("list.lua") end
function globals() dofile("globals.lua") end

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

function printfile(str)
    if str ~= nil then fileToPrint = str end
    dofile("printfile.lua")
end

function connectWifi() dofile("wifiapconnect.lua") end

function initWifiMonitor()
    dofile("wifieventmon.lua")
    dofile("wifistatemon.lua")
end

function initUART()
    dofile("uart.lua")
end

print("Boot reason...")
print(node.bootreason())

--produce standard output
print("\n--> Files contained:")
list()
printfile()

print()

dofile("timesync.lua")

--wifi setup
wifi.setmode(wifi.STATION)
initWifiMonitor()
connectWifi()

initUART()
