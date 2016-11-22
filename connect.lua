--[[The Lua pattern that must be matched by string.find to be a valid IoT network AP.
    NOTE: Currently, using an escaped '-' dash character such as: riot\-waikato means that the
    phrase does not get matched.]]
local ssid_pattern = "riot"
local available = {}	-- list of our APs

--From https://learn.adafruit.com/adafruit-huzzah-esp8266-breakout/using-nodemcu-lua
--[[table format is BSSID : SSID, RSSI, auth mode, Channel]]
function listap(t)

    local matchingap = 0;	-- count the number of matching APs
    print("Available access points:")
    print("\n"..string.format("%32s","SSID").."\tBSSID\t\t\t\t  RSSI\t\tAUTHMODE\tCHANNEL")
    print("\n\t\t\tSSID\t\t\t\t\tBSSID\t\t\t  RSSI\t\tAUTHMODE\t\tCHANNEL")
    for bssid,v in pairs(t) do
        local ssid, rssi, authmode, channel = string.match(v, "([^,]+),([^,]+),([^,]+),([^,]*)")
        print(string.format("%32s",ssid).."\t"..bssid.."\t  "..rssi.."\t\t"..authmode.."\t\t\t"..channel)

        -- Store SSIDs that match the pattern of our IoT devices.
        if string.find(ssid, ssid_pattern) then
            available[bssid] = ssid
            matchingap = matchingap + 1
        end
    end

    --Print APs that match the ssid_pattern
    print("Found "..matchingap.." APs:")
    for bssid, ssid in pairs(available) do
        print(ssid, bssid)
    end
end	-- function listap

wifi.setmode(wifi.STATION)

-- Scan for Wifi APs. Use the newer format of AP table.
print("Scanning access points...")
wifi.sta.getap(1, listap)

--[[Connecting to an AP stops the Wifi scan and printing of the table from completing.]]
--wifi.sta.config("wific", "wifiwifi")
