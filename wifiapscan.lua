--[[The Lua pattern that must be matched by string.find to be a valid IoT network AP.
    NOTE: Currently, using an escaped '-' dash character such as: riot\-waikato means that the
    phrase does not get matched.]]
local ssid_pattern = "riot"
local available	-- list of our APs
local password = "riotwaikato"


--[[Prints a nicely formatted list of the table provided by getap().  This handles the new
    version of the table.
    ]]
function printaps(t)
    print("Available access points:")
    print("\n"..string.format("%32s","SSID").."\tBSSID\t\t\t\t  RSSI\t\tAUTHMODE\tCHANNEL")
    print("\n\t\t\tSSID\t\t\t\t\tBSSID\t\t\t  RSSI\t\tAUTHMODE\t\tCHANNEL")
    for bssid,v in pairs(t) do
        local ssid, rssi, authmode, channel = string.match(v, "([^,]+),([^,]+),([^,]+),([^,]*)")
        print(string.format("%32s",ssid).."\t"..bssid.."\t  "..rssi.."\t\t"..authmode.."\t\t\t"..channel)
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
    printaps(t)

    available = {}
    for bssid,v in pairs(t) do
        local ssid, rssi, authmode, channel = string.match(v, "([^,]+),([^,]+),([^,]+),([^,]*)")

        -- Store SSIDs that match the pattern of our IoT devices.
        if string.find(ssid, ssid_pattern) then
            available[bssid] = ssid
        end
    end
    
    printmatchingaps()
    return chooseavailableap()
end	-- function do_onscancomplete



--[[Counts the number of BSSID/SSID pairs held in the available global variable.
]]
function countmatchingaps()
    local count = 0;
    for x, y in pairs(available) do
        count = count + 1
    end
    return count
end



--[[Prints a status message with the number of APs held in the available global variable
    then prints them.
    ]]
function printmatchingaps()
    print("Found "..countmatchingaps().." matching APs...")
    for bssid, ssid in pairs(available) do
        print(ssid, bssid)
    end
end



--[[Chooses an available AP to connect this device to.  Current algorithm chooses a
    random AP out of those available.
    ]]
function chooseavailableap()
    print("Starting function")
    local apset = {}
    local count = 0
    for bssid, ssid in pairs(available) do
        count = count + 1
        apset[count] = bssid
    end

    if count > 1 then
        select = math.random(1, count)
    elseif count > 0 then
        select = 1
    end

    print("Connecting to access point: "..available[apset[select]])
    print(wifi.sta.getconfig())

    --Connect if there is a valid AP available
    if select ~= nil then
        wifi.sta.config(available[apset[select]], password, 0, apset[select])
        wifi.sta.connect()
    end
end

wifi.setmode(wifi.STATION)

-- Scan for Wifi APs. Use the newer format of AP table.
print("Scanning access points...")
wifi.sta.getap(1, do_onscancomplete)
