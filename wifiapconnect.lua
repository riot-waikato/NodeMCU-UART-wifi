--Configuration Options
--[[The Lua pattern that must be matched by string.find to be a valid IoT network AP.]]
ssid_pattern = "riot%-waikato"
password = "riotwaikato"
minrssi = -70	-- minimum signal strength considered acceptable
local retryinterval = 5000 -- interval between scans for APs when no AP was found

available = {} -- list of our APs, needed in other wifi files
apscantimer = tmr.create()
wifiretries = 0

--[[Prints a nicely formatted list of the table provided by getap().  This handles the new
    version of the table.
    ]]
local function printaps(t)
    print("Available access points:")
    print("\n\t\t\tSSID\t\t\t\t\tBSSID\t\t\t  RSSI\t\tAUTHMODE\t\tCHANNEL")
    for bssid,v in pairs(t) do
        local ssid, rssi, authmode, channel = string.match(v, "([^,]+),([^,]+),([^,]+),([^,]*)")
        print(string.format("%32s",ssid).."\t"..bssid.."\t  "..rssi.."\t\t"..authmode.."\t\t\t"..channel)
    end
end


--[[Counts the number of BSSID/SSID pairs held in the available global variable.
]]
local function countmatchingaps()
    local count = 0;
    for x, y in pairs(available) do
        count = count + 1
    end
    return count
end


--[[Prints a status message with the number of APs held in the available global variable
    then prints them.
    ]]
local function printmatchingaps()
    print("Found "..countmatchingaps().." matching APs...")
    for bssid, ssid in pairs(available) do
        print(ssid, bssid)
    end
end


--[[The callback function for when a Wifi scan completes.  Each AP's SSID is checked against
    the pattern provided in 'ssid_pattern'.  Matching SSIDs are considered part of the RIOT
    network and the BSSID and SSID are saved to 'available'.

    The table t is in the form:
    BSSID: SSID, RSSI, auth mode, Channel

    The format argument provided to wifi.sta.ap() must be 1 so that it provides the new format
    table.  The new format table allows duplicate SSIDs and uses BSSIDs to distinguish between
    access points.
    ]]
local function do_onscancomplete(t)

    print("Scanning complete...")

    --printing the APs at a lower baud rate sets of the watchdog reset
    if interactive_mode then
        printaps(t)
    end

    available = {}
    for bssid,v in pairs(t) do
        local ssid, rssi, authmode, channel = string.match(v, "([^,]+),([^,]+),([^,]+),([^,]*)")

        -- Store SSIDs that match the pattern of our IoT devices.
        if string.find(ssid, ssid_pattern) then

            if tonumber(rssi) > minrssi then
		available[bssid] = {}
                available[bssid].ssid = ssid
		available[bssid].rssi = tonumber(rssi)
            else
                print("Signal strength of "..ssid.. " too poor to connect...")
            end
        end
    end
    
    --printing the APs at a lower baud rate sets off the watchdog reset
    if interactive_mode then
        printmatchingaps()
    end
    dofile("wifiapselection.lua")
end	-- function do_onscancomplete


--[[Chooses an available AP to connect this device to.  Current algorithm chooses a
    random AP out of those available.
    ]]
local function chooseavailableap()
    local apset = {}
    local count = 0

    --count available APs
    for bssid, ssid in pairs(available) do
        count = count + 1
        apset[count] = bssid
    end

    if count > 1 then
        select = math.random(1, count)
    elseif count > 0 then
        select = 1
    elseif count == 0 then
        print("No RIOT access points found...")

        --start retry timer
        tmr.alarm(apscantimer, retryinterval, tmr.ALARM_SINGLE, function() wifiscan() end)
        wifiretries = wifiretries + 1
        return
    end

    print("Connecting to access point: "..available[apset[select]])
    print(wifi.sta.getconfig())

    --Connect if there is a valid AP available
    if select ~= nil then
        wifi.sta.config(available[apset[select]], password, 0, apset[select])
        wifi.sta.connect()
    end

    collectgarbage()
end



--[[Get ip, netmask and gateway address.
    ]]
local function get_ip() ip, nm, hostip = wifi.sta.getip() end

local function wifiscan()
    if wifiretries > 0 then
        print("Attempt "..wifiretries)
    end
    print("Scanning for Wifi APs...")
    wifi.sta.getap(1, do_onscancomplete)
end

wifi.setmode(wifi.STATION)

-- Scan for Wifi APs. Use the newer format of AP table.
wifiscan()
