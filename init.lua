local function pad(str, len, char)
    if char == nil then char = ' ' end
    return str .. string.rep(char, len - #str)
end

local function list() dofile("list.lua") end
local function globals() dofile("globals.lua") end

local function help()
   bak=fileToPrint
   fileToPrint='help.txt'
   printfile(fileToPrint)
   fileToPrint=bak
end

local function printfile(str)
    if str ~= nil then fileToPrint = str end
    dofile("printfile.lua")
end

local function connectWifi() dofile("wifiapconnect.lua") end

local function initWifiMonitor()
    dofile("wifieventmon.lua")
    dofile("wifistatemon.lua")
end

local function initUART()
    dofile("uart.lua")
end

print("Boot reason...")
print(node.bootreason())

--produce standard output
print("\n--> Files contained:")
list()
printfile()

print()

--dofile("timesync.lua")
--dofile("wifisend.lua")

--wifi setup
wifi.setmode(wifi.STATION)
initWifiMonitor()
connectWifi()

initUART()
