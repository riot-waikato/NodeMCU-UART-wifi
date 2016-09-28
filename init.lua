--set up all functions
function pad(str, len, char)
    if char == nil then char = ' ' end
    return str .. string.rep(char, len - #str)
end

function list() dofile("list.lua") end
--function startnet() dofile("startWifi.lua") end
--function relay() dofile("relay.lua") end
function globals() dofile("globals.lua") end

function get_ip() hostip = '172.24.42.1' end
function help()
   bak=fileToPrint
   fileToPrint='help.txt'
   printfile(fileToPrint)
   fileToPrint=bak
end

function printfile(str)
    if str ~= nil then fileToPrint = str end
    dofile("printfile.lua")
end

wific='wific'
wifiwifi='wifiwifi'
function connectWifi() dofile("connect.lua") end
function sendtest() dofile("OpenSend.lua") end

--produce standard output
print("\n--> Files contained:")
list()
printfile()
--print("\n--> Starting wifi...")
--startnet()
--print("\n--> Starting server...")
--relay()

print()